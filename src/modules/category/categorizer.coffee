Promise = require("bluebird")
inquirer = require("inquirer");

require("util/string")
require("util/array")
PromiseUtil = require("util/promise")
ConsoleUtil = require("util/console")

Mutation = require('data/mutation')
repository = require('data/repository')

autocategorizer = require('category/auto-categorizer')
categories = require('category/categories')


# Goes through each mutation in the repository that needs categorizeing and sequentially categorizes data
categorizeAll = ->

  # First populate the list of mutations that need categorizing
  mutations = repository.notCategorized()
  
  # Save length
  totalNotCategorized = mutations.length
  
  # Add categories to mutations previously asked to autocomplete
  autocategorizer.completeList(mutations)
  
  # Filter out the completed mutations, leaving the mutations that we need to ask user for information
  mutations = (mutation for mutation in mutations when mutation.notCategorized() or mutation.notInvoiced())
    
  # Prepare sequential functions that return promises for categorization
  functions = []
  count = {asked: 0, total: mutations.length, autocompleted: totalNotCategorized - mutations.length, continue: true}
  mutations.forEach((mutation) ->
    functions.push((-> categorize(mutation, count)))
  )
  
  # Execute the chain
  PromiseUtil.sequence(functions).then(->
    console.log(totalNotCategorized + ' uncategorized mutations(s) found, ' + count.autocompleted + ' autocompleted, ' + count.asked + ' asked')
  )  

  
proceed = (answers) ->
  answers['mainCategory'] isnt '[STOP]'
  
  
printMutation = (mutation, asked, total, similar) ->
  ConsoleUtil.reset()
  console.log('\nMutation ' + (asked + 1) + ' of ' + total + ' ' + mutation.quarter())
  console.log(similar + ' mutations are similar')

  mutation.printBasic()

  
categorize = (mutation, count) ->
  defer = Promise.defer()
  
  # Stop
  if not count.continue
    defer.resolve()
    return defer.promise
  
  # Find similar mutations
  similar = repository.similar(mutation)

  # Print
  printMutation(mutation, count.asked, count.total, similar.length)
  
  questions = [
    {
      type: "rawlist"
      name: "mainCategory"
      message: "What is the main category?"
      
      choices: -> categories.mainCategories().add('[STOP]')
      when: -> mutation.notCategorized() 
    }
    {
      type: "rawlist" 
      name: "subCategory"
      message: "What is the sub category?"

      choices: (answers) -> categories.subCategories(answers['mainCategory'])
      when: (answers) -> 
        proceed(answers) and mutation.notCategorized()
    }
    {
      type: "confirm"
      name: "invoiceDateAsPaymentDate"
      message: "Is the invoice date also the payment date?",
      default: true

      when: (answers) ->
        proceed(answers) and 
          mutation.notInvoiced() and
            categories.needsInvoiceDate(mutation, answers['mainCategory'], answers['subCategory']) and
               not autocategorizer.askForInvoiceDate(mutation)
    }
    {
      type: "input",
      name: "invoiceDate",
      message: "What is the invoice date?"
      default: mutation.date
      filter: String

      when: (answers) ->
        proceed(answers) and
          mutation.notInvoiced() and
            categories.needsInvoiceDate(mutation, answers['mainCategory'], answers['subCategory']) and
              not answers['invoiceDateAsPaymentDate'] and
                  (not answers['invoiceDateAsPaymentDate']? or answers['invoiceDateAsPaymentDate']?)
     
      validate: (value) -> value.isDate() || "Please enter a date in the form of DD/MM/YY"
    }
    {
      type: "input"
      name: "VAT"
      message: "What is the VAT percentage"
      default: '21'
      filter: Number

      when: (answers) ->
        proceed(answers) and 
          mutation.noVAT() and
            categories.needsVAT(mutation, answers['mainCategory'], answers['subCategory'])
        
      validate: ( value ) -> value.isNumber() || "Please enter a number"
    }
    {
      type: "confirm"
      name: "autocomplete"
      message: "Auto-complete future mutations pointing to the same account name?"
      default: true
      
      when: (answers) -> 
        proceed(answers) and not autocategorizer.askedBefore(mutation) and mutation.fullToAccount() isnt ''
    }
  ]

  # Start prompt
  inquirer.prompt( questions, (answers) ->
    count.continue = proceed(answers)

    if count.continue    
      # Increment asked
      count.asked += 1
  
      if answers['mainCategory']?
        mutation.mainCategory = answers['mainCategory']
      
      if answers['subCategory']?
        mutation.subCategory  = answers['subCategory']
      
      if answers['VAT']?
        mutation.VAT = answers['VAT']
        
      if answers['invoiceDate']?
        mutation.invoiceDate = answers['invoiceDate']
      
      if answers['autocomplete']?
        if answers['autocomplete']
          autocategorizer.alwaysComplete(mutation, answers['invoiceDateAsPaymentDate'], answers['VAT'])
          
          # Complete future mutations
          autocategorizer.completeList(similar)
          
          # Update counts
          count.total -= similar.length
          count.autocompleted += similar.length
        else
          autocategorizer.neverComplete(mutation)
          
    defer.resolve()
  )

  defer.promise


module.exports = ->
  autocategorizer.load().then(-> categorizeAll())
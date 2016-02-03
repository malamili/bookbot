require('util/string')

fs = require('fs');
path = require('path');
Promise = require("bluebird")
PromiseUtil = require("util/promise")

Mutation = require('data/mutation')
repository = require('data/repository')
descriptions = require('import/descriptions')

inquirer = require("inquirer");

  
  
processAll = -> 
  functions = []
  ([file, data] for file, data of readFiles()).forEach((item) ->
    functions.push((-> process(item[0], item[1])))
  )
  
  PromiseUtil.sequence(functions)  

getFiles = ->
  fs.readdirSync('../data/import')
    
readFile = (file) ->
  fs.readFileSync('../data/import/' + file, 'utf-8')
  
fileIsValid = (file) ->
  path.extname(file).toLowerCase() is '.tab'
  
readFiles = ->
  content = {}
  content[file] = readFile(file) for file in getFiles() when fileIsValid(file)

  console.log(Object.keys(content).length + ' file(s) found')
  return content

  
process = (file, data) ->
  console.log('\n' + file)
  
  records = data.split('\n')

  count = {added: 0}

  # Nifty way to waterfall promises maintaining order!
  functions = []
  records.forEach((record) ->
    functions.push((-> processRecord(record, count)))
  )
  
  PromiseUtil.sequence(functions).then(->
    console.log(records.length + ' record(s) found, ' + count.added + ' added, ' + (records.length - count.added) + ' skipped')
  )
  
  
processRecord = (record, count) ->
  return Promise.resolve() if record is ''
  
  items = record.split('\t')

  mutation = new Mutation()
  
  # This is always the same for every record
  mutation.fromAccount = items[0]
  mutation.currency    = items[1]
  
  # Convert 20131102 to 02/11/13
  mutation.date        = items[2].slice(6) +'/'+ items[2].slice(4,6) +'/'+ items[2].slice(2,4)
  mutation.amount      = items[6]

  processRecordDescription(mutation, items[7]).then(->
    if not repository.hasMutation(mutation)
      repository.addMutation(mutation)
      count.added += 1
    else
      console.log('Skipped:')
      console.log(mutation)
      console.log('')
  )
    


# There are many cases of transaction, each will have it's description
# build up differently. We need to asses the type and forward to the right function
processRecordDescription = (mutation, description) ->
  # Error if no description
  if not description?
    console.log("Error, no description found for mutation:")
    console.log(mutation)
    return

  # Find the right function to parse the description
  for transactionType, func of descriptions.all()
    if description.startsWith(transactionType)
      func.bind(descriptions)(mutation, description)    # Bind descriptions so that 'this' is properly wired in func
      return Promise.resolve()
      
  # No transactionType found, so we inquire the details
  return inquireRecordInformation(mutation, description)
  
# Asks for missing information
inquireRecordInformation = (mutation, description) ->
  defer = Promise.defer()

  console.log("\nCould not parse:\n")
  console.log("Description: \t" + description.trim())
  console.log("Amount: \t" + mutation.currency + ' ' +mutation.amount)
  console.log("Date: \t\t" + mutation.date + "\n")
  
  questions = [
    {
      type: "list",
      name: "type",
      message: "What is the mutation type",
      choices: [ "Overboeking", "Acceptgiro", "Incasso", "iDeal", "Giro" ],
      filter: ( val ) -> return val.toUpperCase()
    }
    {
      type: "input",
      name: "toAccount",
      message: "What is the account number?"
    },
    {
      type: "input",
      name: "toAccountName",
      message: "What is the account name?"
    },
    {
      type: "input",
      name: "description",
      message: "Can you provide any description"
    },
  ]

  inquirer.prompt( questions, ( answers ) ->
    mutation.type = answers.type
    mutation.toAccount = answers.toAccount
    mutation.toAccountName = answers.toAccountName
    mutation.description = answers.description    
    defer.resolve()
  )

  defer.promise



module.exports = processAll
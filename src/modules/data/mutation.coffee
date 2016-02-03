# Mutation types: 
# OVERBOEKING, BANKKOSTEN, RENTE, ACCEPTGIRO, INCASSO, PERIODIEK, IDEAL, GIRO, PIN

# Mutation categories:


# Every mutation will at least have:
# - fromAccount
# - currency
# - date
# - amount
#
# From the (sometimes fuzzy) description of the transaction file, the following fields may be accumulated:
# - type
# - toAccount
# - toAccountName
# - description
#
# The mutation then needs to be categorized for the analysis.
# Lastly, we need to know the invoice date as opposed to the mutation date. We therefore need to match every mutation 
# to either the invoice. If no invoice match is available, we default to the mutation date for analysis.

require('util/string')
moment = require('moment');


# Printable version that returns '' if undefined
p = (field) ->
  if field then field else ''


class Mutation
  constructor: (@date, @type, @fromAccount, @toAccount, @toAccountName, @currency, @amount, @description, @mainCategory,
                @subCategory, @project, @detail, @invoiceFileId, @invoiceNumber, @invoiceDate, @VAT) ->

# s is the separator in serialization
  serialize: (s) ->
    p(@date) + s + p(@type) + s + p(@fromAccount) + s + p(@toAccount) + s + p(@toAccountName) + s +
    p(@currency) + s + p(@amount) + s + p(@description) + s + p(@mainCategory) + s + p(@subCategory) + s +
    p(@project) + s + p(@detail) + s + p(@invoiceFileId) + s + p(@invoiceNumber) + s + p(@invoiceDate) + s + p(@VAT)
    
    
  # Static method constructing a mutation based on a tsv record  
  @deserialize: (record) ->
    new Mutation(record.split('\t')...)

  getDate: ->
    moment(@date, "DD/MM/YY")
    
  fullToAccount: ->
    (@toAccount + @toAccountName)

  notCategorized: ->
    not @mainCategory? or @mainCategory is ''

  notInvoiced: ->
    not @invoiceDate? or @invoiceDate is ''

  noVAT: ->
    not @VAT? or @VAT is ''
    
  quarter: ->
    date = @getDate()
    '(' + date.year() + '-Q' + date.quarter() + ')'
    
  hash: ->
    @serialize('##').replace(/\s+/g, '').hash()
  
  printBasic: ->
    console.log("\nTo: \t\t" + @toAccountName.green)
    console.log("Account nr: \t" + @toAccount.green)
    console.log("Amount: \t" + ("€"  + @amount).magenta)
    console.log("Date: \t\t" + @date.yellow)
    console.log("Description: \t" + @description.yellow + "\n")
    
    if @mainCategory? and @mainCategory isnt ''
      console.log("Main Category: \t" + @mainCategory.cyan)

    if @subCategory? and @subCategory isnt ''
      console.log("Sub Category: \t" + @subCategory.cyan + "\n")
    

module.exports = Mutation
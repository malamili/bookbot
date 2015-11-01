fs = require('fs');
path = require('path');
Mutation = require('mutation')
repository = require('repository')

module.exports = ->
  console.log('\nProcessing...')
  process(file, data) for file, data of readFiles()

getFiles = ->
  fs.readdirSync('../data')
    
readFile = (file) ->
  fs.readFileSync('../data/' + file, 'utf-8')
  
fileIsValid = (file) ->
  path.extname(file) is '.tab'
  
readFiles = ->
  content = {}
  content[file] = readFile(file) for file in getFiles() when fileIsValid(file)

  console.log('Found ' + Object.keys(content).length + ' file(s)\n')
  return content

  
process = (file, data) ->
  console.log('Processing ' + file)
  
  records = data.split('\n')
  console.log('Found ' + records.length + ' records\n')

  processRecord(record) for record in records
  
  console.log('Done\n')
  
  
processRecord = (record) ->
  return if record is ''
  
  items = record.split('\t')

  mutation = new Mutation()
  
  # This is always the same for every record
  mutation.fromAccount = items[0]
  mutation.currency    = items[1]
  mutation.date        = items[2]
  mutation.amount      = items[6]

  processRecordDescription(mutation, items[7])
  
  repository.addMutation(mutation)
    
  
processRecordDescription = (mutation, description) ->
  
  # There are many cases of transaction, each will have it's description
  # build up differently. We need to asses the type and forward to the right function
  
  
  if description?
    description = require('replacer')(description)
    items = description.split('---')
    
    # Type
    if items[0] is 'SEPA Overboeking'
      mutation.type = 'OVERBOEKING'
      
    else if items[0] is 'SEPA iDeal'
      mutation.type = 'IDEAL' 
      
    else if items[0] is 'SEPA Acceptgirobetaling'
      mutation.type = 'ACCEPTGIRO'
      
    else if items[0] is 'SEPA Incasso algemeen doorlopend'
      mutation.type = 'INCASSO'   
      
    else if items[0] is 'SEPA Periodieke overb.'
      mutation.type = 'PERIODIEK'

    else if items[0] is 'ABN AMRO Bank N.V.'
      mutation.type = 'BANK'
      mutation.toAccount = 'ABN AMRO'
      mutation.toAccountName = 'ABN AMRO'
      mutation.description = 'Bankkosten'
      return
      
    else if items[0] is 'GIRO'
      mutation.type = 'GIRO'
      mutation.toAccount     = items[1].substring(0, items[1].indexOf(' '))
      mutation.toAccountName = items[1].substring(items[1].indexOf(' ') + 1)
      mutation.description = items[2]
      return
      
    else 
      mutation.type = 'OVERBOEKING'
      
      # Shuffle forward (its getting hacky)
      items[4] = items[2]
      items[3] = items[1]
      items[1] = items[0]
      
    
    # To Account
    if items[1]?
      # Remove IBAN: 
      items[1] = items[1].replace('IBAN: ', '')
      
      mutation.toAccount = items[1]
    
    # To Account Name
    if items[3]?
      
      # Remove Naam: 
      items[3] = items[3].replace('Naam: ', '')
      mutation.toAccountName = items[3]
  
    # Description
    if items[4]?
      
      # Remove omschrijving
      items[4] = items[4].replace('Omschrijving: ', '')
      mutation.description = items[4]
    
      
bankRecord = (mutation) ->
  
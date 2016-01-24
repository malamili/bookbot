repository = require('data/repository')
fs = require('fs')

module.exports = ->
  console.log('\nWriting...')
  
  # Separator
  s = '\t'
  
  data = 'Date' + s + 'Type' + s + 'From Account' + s + 'To Account' + s + 'To Name' + s + 'Currency' + s + 
    'Amount' + s + 'Description' + s + 'Category' + s + 'Invoice File' + s + 'Invoice Number' + s + 
    'Invoice Date' + s + 'VAT\n'  
  
  data += mutation.serialize(s) + '\n' for mutation in repository.all()
  
  # Remove last break
  data = data.slice(0, -2)
    
  fs.writeFileSync('../data/mutations.tsv', data, 'utf8')
  
  console.log('Done\n')
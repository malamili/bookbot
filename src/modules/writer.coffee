repository = require('repository')
fs = require('fs');

module.exports = ->
  console.log('\nWriting...')
  
  data = 'Date;Type;From Account;To Account;To Name;Currency;Amount;Description\n'  
  data += mutation.serialize() + '\n' for mutation in repository.mutations
  
  fs.writeFileSync('../data/output.csv', data, 'utf8')
  
  console.log('Done\n')
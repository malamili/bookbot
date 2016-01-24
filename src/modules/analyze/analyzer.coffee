require("util/number")

repository = require('data/repository')
inquirer = require("inquirer");
Promise = require("bluebird")


module.exports = ->
  console.log('\nAnalyzing...')
  
  accounts = {}
  
  for mutation in repository.all()
    
    # Init
    if not accounts[mutation.fromAccount]?
      accounts[mutation.fromAccount] = 0
      
    # Count
    accounts[mutation.fromAccount] += parseFloat(mutation.amount.replace(',','.'))

    
  for account, saldo of accounts
    console.log(account + ': ' + saldo.toEuro())
  
  # Return
  defer = Promise.defer()
  defer.resolve()  
  defer.promise
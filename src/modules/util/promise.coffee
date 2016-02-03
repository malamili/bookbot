Promise = require("bluebird")

module.exports = 
  
  # Runs functions returning promises in sequence, then resolves when all are done
  sequence: (functions) ->
    defer = Promise.defer()
    
    execute = (index) ->
      if index >= functions.length
        defer.resolve()
      else        
        functions[index].call().then(-> execute(index + 1))

    # Start with first
    execute(0)
    
    defer.promise
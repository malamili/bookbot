class Repository
  constructor: (@mutations) ->
    
  addMutation: (mutation) ->
    @mutations.push(mutation)
    
module.exports = new Repository([])

sortByDate = (mutations) ->
  mutations.sort((a, b) -> b.getDate().diff(a.getDate()))

class Repository
  constructor: ->
    @mutations = {}
    
  clear: ->
    @mutations = {}
    
  addMutation: (mutation) ->
    @mutations[mutation.hash()] = mutation
    
  hasMutation: (mutation) ->
    @mutations[mutation.hash()]?
    
  similar: (mutation) ->
    similar = []
    for hash, m of @mutations
      if m isnt mutation 
        if mutation.toAccount isnt '' or mutation.toAccountName isnt ''
          if m.toAccount is mutation.toAccount and m.toAccountName is mutation.toAccountName
            similar.push(m)
        
    sortByDate(similar)
    
  # Sort on date, newest first
  all: ->
    sortByDate((mutation for hash, mutation of @mutations))

  categorized: ->
    sortByDate((mutation for hash, mutation of @mutations when not mutation.notCategorized()))

  notCategorized: ->
    sortByDate((mutation for hash, mutation of @mutations when mutation.notCategorized()))
    
module.exports = new Repository([])
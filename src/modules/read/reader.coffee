fs = require('fs');
path = require('path');
Mutation = require('data/mutation')
repository = require('data/repository')

module.exports = ->
  repository.clear()
  
  mutations = readMutations()
  
  for mutation in mutations
    repository.addMutation(Mutation.deserialize(mutation))


readMutations = ->
  try
    file = 'mutations.tsv'
    
    # Split on breaks and remove the first row (headers)
    fs.readFileSync('../data/' + file, 'utf-8').split('\n').slice(1)
  catch error
    console.log(error)
    []
  
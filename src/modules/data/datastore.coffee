Promise = require('bluebird')
Nedb = require('nedb')

class Datastore
  constructor: ->
    @db = new Nedb({ filename: '../data/db/' + @name() + '.db', autoload: true });
    @entries = {}
  
  name: ->
    console.log('Error: Should be overridden')
  
  entryKey: ->
    console.log('Error: Should be overridden')

  # Loads data in memory
  load: ->
    defer = Promise.defer()
    self = @
    @db.find({}, (err, entries) ->
      self.entries[entry[self.entryKey()]] = entry for entry in entries
      defer.resolve()
    )
    defer.promise

module.exports = Datastore
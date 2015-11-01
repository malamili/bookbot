# Mutation types: OVERBOEKING, BANK, ACCEPTGIRO, INCASSO, PERIODIEK, IDEAL, GIRO

class Mutation
  constructor: (@fromAccount, @toAccount, @toAccountName, @currency, @date, @amount, @type, @description) ->

  serialize: ->
    @date + ';' + @type + ';' + @fromAccount + ';' + @toAccount + ';' + @toAccountName + ';' +
      @currency + ';' + @amount + ';' +@description

  getHash: ->
    return @amount

    
module.exports = Mutation


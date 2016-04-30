
# Path resolving making it non-relative accessible from any location.
require('app-module-path').addPath('./modules')

# Usage: "hello".green or 'world'.red
colors = require('colors')

# Run module returning a promise
run = (module, callback) ->
  require(module)().bind(@).then(-> callback())

# Shortcuts
#require('read/reader')()
#run('import/importer', ->)
#require('category/categorizer')()

#return

# CLI interface
vorpal = require('vorpal')();

# Hide default help and exit commands from automated menu's
vorpal.find("help").hidden()
vorpal.find("exit").hidden()


## COMMANDS
vorpal
  .command('status')
  .alias('st')
  .description('(st) Show current status')
  .action((args, callback) ->
  )

vorpal
  .command('read')
  .alias('re')
  .description('(re) Read mutations from database')
  .action((args, callback) ->
    require('read/reader')()
    console.log('Reading done')
    callback()
  )

vorpal
  .command('import')
  .alias('im')
  .description('(im) Import mutations from supported files')
  .action((args, callback) -> run('import/importer', callback))
  
vorpal
  .command('categorize')
  .alias('ca')
  .description('(ca) Categorize mutations')
  .action((args, callback) ->
      require('category/categorizer')().bind(@).then(-> callback())
  )
  
vorpal
  .command('write')
  .alias('wr')
  .description('(wr) Write to database')
  .action((args, callback) ->
      require('write/writer')()
      callback()
  )

vorpal
  .command('analyze')
  .alias('an')
  .description('(an) Analyze mutations to financial statement')
  .action((args, callback) ->
    require('analyze/analyzer')().bind(@).then(-> callback())
  )

vorpal
  .command('export')
  .alias('ex')
  .description('(ex) Export financial statement')
  .action((args, callback) ->
    callback()
  )

## END COMMANDS

# Welcome
console.log('\nBookbot here! What can I do for you?'.green)

# Show help
vorpal.exec("help")

# Start CLI
vorpal.delimiter('Bookbot$'.green).show()
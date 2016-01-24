# Path resolving making it non-relative accessible from any location.
require('app-module-path').addPath('./modules')

# Usage: "hello".green or 'world'.red
colors = require('colors')

# CLI interface
vorpal = require('vorpal')();

# Hide default help and exit commands from automated menu's
vorpal.find("help").hidden()
vorpal.find("exit").hidden()


# Command: Import
vorpal
.command('read')
.alias('r')
.action((args, callback) ->
  require('read/reader')()
  console.log('Reading done')
  callback()
)
.hidden()

# Command: Import
vorpal
  .command('import')
  .alias('i')
  .description('Import mutations from supported files')
  .action((args, callback) ->
      require('import/importer')().bind(@).then(-> callback())
  )
  
# Command: Append
vorpal
  .command('supplement')
  .alias('s')
  .description('Supplement mutations with category, invoice date and VAT')
  .action((args, callback) ->
      callback()
  )

# Command: Write
vorpal
  .command('write')
  .alias('w')
  .description('Write to database')
  .action((args, callback) ->
      require('write/writer')()
      callback()
  )

# Command: Analyze
vorpal
  .command('analyze')
  .alias('a')
  .description('Analyze mutations to financial statement')
  .action((args, callback) ->
    require('analyze/analyzer')().bind(@).then(-> callback())
  )

# Command: Export
vorpal
.command('export')
.alias('e')
.description('Export financial statement')
.action((args, callback) ->
  callback()
)


# Read database
require('read/reader')()

# Welcome
console.log('\nBookbot here! What can I do for you?'.green)

# Show help
vorpal.exec("help")

# Start CLI
vorpal.delimiter('Bookbot$'.green).show()
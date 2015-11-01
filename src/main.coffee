# Path resolving making it non-relative accessible from any location.
require('app-module-path').addPath('./modules')

# Usage: "hello".green or 'world'.red
colors = require('colors')

# CLI interface
cli = require('vorpal')();

# Command: Process
cli
  .command('process')
  .alias('p')
  .description('Reads and processes all supported files in ../data directory')
  .action((args, callback) ->
      require('processor')()
      callback()
  )

# Command: Read
cli
  .command('read')
  .alias('r')
  .description('Reads all Bookbot csv files currently used as backup')
  .action((args, callback) ->
      callback()
  )

# Command: Write
cli
  .command('write')
  .alias('w')
  .description('Dumps the Bookbot data in a csv file')
  .action((args, callback) ->
      callback()
  )

# Command: Analyze
cli
  .command('analyze')
  .alias('a')
  .description('Analyze accountancy information')
  .action((args, callback) ->
    require('analyzer')()
    callback()
  )

# Test
require('processor')()
require('writer')()

# Start
cli.delimiter('bookbot$').show()
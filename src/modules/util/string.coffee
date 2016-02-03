# Test is string starts with s
String::startsWith ?= (s) -> @slice(0, s.length) == s

# Extracts a substring given located between a start and end string
String::extract = (start, end) ->   
  return '' if @indexOf(start) is -1
  
  from = @indexOf(start) + start.length
  
  if end?
    to  =  @indexOf(end, from)
    @slice(from, to)
  else
    @slice(from)

  
# Trims also the spaces in between
String::trimDeep = ->
  @trim().replace(/\s{2,}/g, ' ');

  
# Splits a string by multiple spaces into an array
String::items = -> 
  @replace(/\s{2,}/g, '---').split('---')


# Computes hashcode of string
String::hash = ->
  return 0 if @length is 0

  hash = 0
  for character in @split('')
    hash  = ((hash << 5) - hash) + character.charCodeAt(0)
    hash |= 0 # Convert to 32bit integer

  hash

# Test whether string is a number
String::isNumber = ->
  !isNaN(parseFloat(@))
  
String::removeDots = ->
  @replace('.','')

String::removeSpaces = ->
  @replace(' ','')
  
# Test whether string is in DD/MM/YY format
String::isDate = ->
  return false if @length isnt 8
  
  days    = @slice(0,2)
  months  = @slice(3,5)
  years   = @slice(-2)
  slashes = @charAt(2) + @charAt(5)
  
  return days.isNumber() and months.isNumber() and years.isNumber() and slashes is '//'
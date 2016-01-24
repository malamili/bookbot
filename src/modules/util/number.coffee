round = (num) ->
  Math.round(num * 100) / 100

numberWithCommas = (x) ->
  x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")


reverse = (x) ->
  x.replace('.','#').replace(',','$').replace('#',',').replace('$','.')


Number::toEuro =  ->
  '€ ' + reverse(numberWithCommas(round(@)))
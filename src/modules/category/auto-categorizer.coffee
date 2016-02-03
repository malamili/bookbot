class AutoCategorizer extends require('data/datastore')
  name: ->
    'categories'
    
  entryKey: ->
    'fullToAccount'
    
  askedBefore: (mutation) ->
    @entries[mutation.fullToAccount()]?
    
  shouldComplete: (mutation) ->
    @entries[mutation.fullToAccount()].complete

  neverComplete: (mutation) ->
    entry =
      'fullToAccount' : mutation.fullToAccount()
      'complete' : false

    @entries[entry.fullToAccount] = entry
    @db.insert(entry, (error) ->
      console.log(error) if error?        
    )
    
  alwaysComplete: (mutation, invoiceDateAsPaymentDate, VAT) ->
    entry = 
      'fullToAccount' : mutation.fullToAccount()
      'complete' : true
      'mainCategory': mutation.mainCategory
      'subCategory': mutation.subCategory

    if invoiceDateAsPaymentDate?
      entry['invoiceDateAsPaymentDate'] = invoiceDateAsPaymentDate
    
    if VAT?
      entry['VAT'] = VAT

    @entries[entry.fullToAccount] = entry
    @db.insert(entry, (error) ->
      console.log(error) if error?
    )
    
  askForInvoiceDate: (mutation) ->
    entry = @entries[mutation.fullToAccount()]
    
    return entry? and entry.invoiceDateAsPaymentDate? and not entry.invoiceDateAsPaymentDate
    
  completeMutation: (mutation) ->
    entry = @entries[mutation.fullToAccount()]
    mutation.mainCategory = entry.mainCategory
    mutation.subCategory  = entry.subCategory
    
    if entry.invoiceDateAsPaymentDate? and entry.invoiceDateAsPaymentDate
      mutation.invoiceDate = mutation.date
        
    if entry.VAT?
      mutation.VAT = entry.VAT
    
  completeList: (mutations) ->
    @completeMutation(mutation) for mutation in mutations when @askedBefore(mutation) and @shouldComplete(mutation)


module.exports = new AutoCategorizer()
require('util/string')

class Categories
  
  office: {
    name: 'Office'
    hasInvoice: true
    subcategories: [
      {
        name: 'Supplies'
        VAT: '21'
        autoVAT: false
        autoInvoiceDate: false
      }
      {
        name: 'Food'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: true
      }
      {
        name: 'Furniture'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }
      {
        name: 'Printing'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: true
      }
      {
        name: 'Postal'
        VAT: '0'
        autoVAT: true
        autoInvoiceDate: true
      }
      {
        name: 'Internet'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }
      {
        name: 'Rent'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }
      {
        name: 'Phone cost'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }
    ]
  }
  
  material: {
    name: 'Material'
    hasInvoice: true
    subcategories: [
      {
        name: 'Electronic devices'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }      
      {
        name: 'Electronic components'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }
      {
        name: 'Computer hardware'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }
      {
        name: 'Software subscription'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }
      {
        name: 'Software license'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }
      {
        name: 'Software hosting'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }
      {
        name: 'Banking'
        VAT: '0'
        autoVAT: true
        autoInvoiceDate: true
      }
    ]
  }

  labor: {
    name: 'Labor'
    hasInvoice: false
    subcategories: [
      { name: 'Salary' }
      { name: 'Internship' }
      { name: 'Education' }
      { name: 'Recruitment' }
    ]
  }

  consulting: {
    name: 'Consulting'
    hasInvoice: true
    subcategories: [
      {
        name: 'Administration'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }     
      {
        name: 'Developers / Designers'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }      
      {
        name: 'Business Related'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }
    ]
  }

  acquisition: {
    name: 'Acquisition'
    hasInvoice: true
    subcategories: [
      {
        name: 'Advertising'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }
      {
        name: 'Gifts'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }
      {
        name: 'Conference'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }      
      {
        name: 'Dinner'
        VAT: '0'
        autoVAT: true
        autoInvoiceDate: true
      }
    ]
  }

  travel: {
    name: 'Travel'
    hasInvoice: true
    subcategories: [
      {
        name: 'Driving'
        VAT: '0'
        autoVAT: true
        autoInvoiceDate: false
        hasInvoice: false
      }
      {
        name: 'Parking'
        VAT: '0'
        autoVAT: true
        autoInvoiceDate: false
        hasInvoice: false
      }
      {
        name: 'Hotel'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }      
      {
        name: 'Flying'
        VAT: '0'
        autoVAT: true
        autoInvoiceDate: true
      }
    ]
  }



  revenue: {
    name: 'Revenue'
    hasInvoice: true
    subcategories: [
      {
        name: 'Project'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }
      {
        name: 'Product'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }
      {
        name: 'Maintenance'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }      
      {
        name: 'Support'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: true
      }      
      {
        name: 'Change'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: true
      }          
      {
        name: 'Hosting'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: true
      }         
      {
        name: 'Resell'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: true
      }
    ]
  }
  
  legal: {
    name: 'Legal'
    hasInvoice: true
    subcategories: [
      {
        name: 'Notary'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }
      {
        name: 'Lawyer'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }
      {
        name: 'Insurance'
        VAT: '21'
        autoVAT: true
        autoInvoiceDate: false
      }      
    ]
  }

  taxes: {
    name: 'Taxes'
    hasInvoice: false
    subcategories: [
      { name: 'Turnover' }
      { name: 'Wage' }
      { name: 'Profit' }
      { name: 'Correction' }
      { name: 'Subsidy' }
      { name: 'Penalty' }
    ]
  }

  account: {
    name: 'Account'
    hasInvoice: false
    subcategories: [
      { name: 'Creditcard' }
      { name: 'Paypal' }
      { name: 'Interchange' }
      { name: 'Withdrawal' }
      { name: 'Deposit' }
      { name: 'Interest' }
      { name: 'Loan' }
    ]
  }

  constructor: ->
    all = [
      @office
      @material
      @labor
      @consulting
      @acquisition
      @travel
      @revenue
      @taxes
      @account
      @legal
    ]

    @categories = {}
    @categories[category['name']] = category for category in all
    
    @subcategories = {}
    for category in all
      for subcategory in category.subcategories
        @subcategories[subcategory['name']] = subcategory
    
  
  
  mainCategories: ->
    (name for name, category of @categories)

  subCategories: (mainCategory) ->
    (category['name'] for category in @categories[mainCategory].subcategories)

  needsInvoiceDate: (mutation, mainCategory, subCategory) ->
    main = @categories[mainCategory]
    return main.hasInvoice

  needsVAT: (mutation, mainCategory, subCategory) ->
    @needsInvoiceDate(mutation, mainCategory, subCategory)






module.exports = new Categories()
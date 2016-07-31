require('util/string')

class Descriptions
  # SEPA Overboeking
  # IBAN: NL94INGB0004476042
  # BIC: INGBNL2A
  # Naam: B Bijl
  # Omschrijving: Vakantiegeld 2014  Sysunite B.V.
  SEPA_OVERBOEKING: (mutation, description) ->
    mutation.type = 'OVERBOEKING'
  
    mutation.toAccount     = description.extract('IBAN: ', ' ')
    mutation.toAccountName = description.extract('Naam: ', 'Omschrijving').trimDeep()
    mutation.description   = description.extract('Omschrijving: ').trimDeep()
  
  
  # SEPA Periodieke overb.
  # IBAN: NL94INGB0004476042
  # BIC: INGBNL2A
  # Naam: B Bijl
  # Omschrijving: Salaris 2014 Sysun ite B.V.
  SEPA_PERIODIEKE_OVERB: (mutation, description) ->
    @SEPA_OVERBOEKING(mutation, description)
    mutation.type = 'PERIODIEK'
  
  
  # SEPA Incasso algemeen doorlopend Incassant: NL96ZZZ273620000000
  # Naam: POSTNL MARKETING   SALES B V DEBITEURENBEHEER
  # Machtiging: NL01740010409676001  Omschrijving: Factuurnr. 5085921 52
  # IBAN: NL20INGB0000004025
  # Kenmerk: 901008179635
  SEPA_INCASSO_ALGEMEEN_DOORLOPEND: (mutation, description) ->
    mutation.type = 'INCASSO'
    
    mutation.toAccount      = description.extract('IBAN: ', ' ')
    mutation.toAccountName  = description.extract('Naam: ', 'Machtiging').trimDeep()
    mutation.description    = description.extract('Omschrijving: ', 'IBAN').trimDeep()
  
  
  # SEPA iDEAL  
  # IBAN: NL92RABO0139441719
  # BIC: RABONL2U
  # Naam: Stichting Derdengelden Sis ow               
  # Omschrijving: 21863 002000082648 7901 Order 21863 AMMS Electronic s B.V.
  # Kenmerk: 29-09-2014 09:16 002000
  SEPA_IDEAL: (mutation, description) ->
    @SEPA_OVERBOEKING(mutation, description)
    mutation.type = 'IDEAL'
    
  
  # SEPA Acceptgirobetaling
  # IBAN: NL86INGB0002445588
  # BIC: INGBNL2A
  # Naam: Belastingdienst Apeldoorn
  # Betalingskenm.: 9852983426401080
  SEPA_ACCEPTGIROBETALING: (mutation, description) ->
    mutation.type = 'ACCEPTGIRO'
  
    mutation.toAccount     = description.extract('IBAN: ', ' ')
    mutation.toAccountName = description.extract('Naam: ', 'Betalingskenm').trimDeep()
    mutation.description   = 'Kenmerk ' + description.extract('Betalingskenm.: ').trimDeep()
    
  # KOSTEN
  # EM2910003100665I TRANSFERPROV.    EUR        5,50
  KOSTEN_INTERNATIONALE_BOEKING: (mutation, description) ->
    mutation.type = 'BANKKOSTEN'
    
    mutation.toAccount = 'ABN AMRO'
    mutation.toAccountName = 'ABN AMRO'
    mutation.description = 'Internationale overboeking'
  
    
  # GIRO    
  # 4476042 B Bijl           
  # Salaris September 2013           
  # Sysunite B.V.
  GIRO: (mutation, description) ->
    mutation.type = 'GIRO'
  
    items = description.items()
  
    mutation.toAccount     = items[1].extract('', ' ')
    mutation.toAccountName = items[1].extract(' ')
    mutation.description   = items[2].trimDeep()
  
    
  # AFSLUITING RENTE EN/OF KOSTEN    
  # CREDITRENTE 763,13C CREDITRENTEOVERZICHT:            ONDERNEMERSDEPOSITO              VAN 30.06.2014 TOT 30.09.2014:   TOP 0,80% BASIS 0,60%            RENTE EFFECTIEF OP JAARBASIS
  AFSLUITING_RENTE: (mutation, description) ->
    mutation.type = 'RENTE'
    mutation.description = 'Ontvangen of te betalen rente'
  
  
  # ABN AMRO Bank N.V.               
  # Heeft u internetbankieren dan is uw nota beschikbaar onder Tools, Downloaden, Afschriften          of u ontvangt deze per post.                                     
  BANK_KOSTEN: (mutation, description) ->
    mutation.type = 'BANKKOSTEN'
    mutation.toAccount = 'ABN AMRO'
    mutation.toAccountName = 'ABN AMRO'
    mutation.description = 'Bankieren en rekeningen'
  
    
  # /TRTP/SEPA OVERBOEKING/IBAN/NL76ABNA0526197420/BIC/ABNANL2A/NAME/ J DE SWART/REMI/Salaris Oktober 2014 Sysunite B.V./EREF/NOTPROVID ED                                                             
  TRTP_SEPA: (mutation, description) ->
    mutation.type = 'OVERBOEKING'
  
    mutation.toAccount      = description.extract('IBAN/', '/')
    mutation.toAccountName  = description.extract('NAME/', '/').trimDeep()
    mutation.description    = description.extract('REMI/', '/').trimDeep()
    
    
  # /TRTP/SEPA Incasso algemeen doorlopend/CSID/NL13ZZZ332005960000 /NAME/INT CARD SERVICES/MARF/T300000013464001/REMI/7200 800001208 74 2014-11-12 INCASSO ABN AMRO BUSINESS CARD/IBAN/NL80ABNA0550288 171/BIC/ABNANL2A/EREF/7200800001208742014-11-12                
  TRTP_INCASSO: (mutation, description) ->
    @TRTP_SEPA(mutation, description)
    mutation.type = 'INCASSO'
  
    
  # /TRTP/iDEAL/IBAN/NL75ABNA0419777865/BIC/ABNANL2A/NAME/DRUKWERKDEA L NL BV/REMI/1244405957 0030000987708516 ODDB1159857_418003/EREF/ 18-11-2014 12:11 0030000987708516                              
  TRTP_IDEAL: (mutation, description) ->
    @TRTP_SEPA(mutation, description)
    mutation.type = 'IDEAL'
  
  
  # /TRTP/Acceptgirobetaling/IBAN/NL86INGB0002445588/BIC/INGBNL2A   /NAME/Belastingdienst Apeldoorn/REMI/ISSUER: CUR                   REF: 7852983426401110/EREF/NOTPROVIDED                        
  TRTP_ACCEPTGIRO: (mutation, description) ->
    @TRTP_SEPA(mutation, description)
    mutation.type = 'ACCEPTGIRO'
  
    
  # BEA   NR:6S71FQ   20.01.16/12.43 SO-PGU-Westraven UTRECHT,PAS301
  PIN: (mutation, description) ->
    mutation.type = 'PIN'

    mutation.toAccount      = ''
    mutation.toAccountName  = description.trimDeep().slice(29,-7)     # SO-PGU-Westraven UTRECHT
    mutation.description    = description.trim().slice(3).trimDeep().slice(0, 24) + ' ' + description.trim().slice(-6) # NR:6S71FQ 20.01.16/12.43 PAS301
  
    
  # Map description starting text to function
  all: ->
    'SEPA Periodieke overb.': @SEPA_PERIODIEKE_OVERB
    'SEPA Overboeking': @SEPA_OVERBOEKING
    'SEPA Opheffen rekening': @SEPA_OVERBOEKING
    'SEPA Incasso algemeen doorlopend': @SEPA_INCASSO_ALGEMEEN_DOORLOPEND
    'SEPA iDEAL': @SEPA_IDEAL
    'SEPA Acceptgirobetaling ': @SEPA_ACCEPTGIROBETALING
    'KOSTEN' : @KOSTEN_INTERNATIONALE_BOEKING
    'GIRO': @GIRO
    'AFSLUITING RENTE EN/OF KOSTEN': @AFSLUITING_RENTE
    'ABN AMRO Bank N.V.': @BANK_KOSTEN
    '/TRTP/SEPA OVERBOEKING/': @TRTP_SEPA
    '/TRTP/SEPA Incasso algemeen doorlopend': @TRTP_INCASSO
    '/TRTP/iDEAL/': @TRTP_IDEAL
    '/TRTP/Acceptgirobetaling/': @TRTP_ACCEPTGIRO
    'BEA': @PIN


module.exports = new Descriptions()
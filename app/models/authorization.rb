# il livello e' solo un numero definito da costanti
#
# TO_READ:    può solo leggere 
# TO_OPERATE: può caricare rifiuto a nome del produttore
# TO_DISPOSE: responsabile rifiuto
# TO_MANAGE:  può configurare l'UL
# TO_ADMIN:   amministratore
#
# il tipo di autorizzazione dipende dall'ip del client e dal login name (upn)
class Authorization
  include DmUniboCommon::Authorization

  configure_authlevels
end


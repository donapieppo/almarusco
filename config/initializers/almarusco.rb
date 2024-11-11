# upn di amministratori del programma (Array di upn)
NUTER = ["daria.prandstraller@unibo.it", "alberto.filetti2@unibo.it", "pietro.donatini@unibo.it"]

module Almarusco
  class Application < Rails::Application
    config.home_description = "
<p>Ogni rifiuto gestito attraverso l’applicazione è registrato separatamente in funzione della sua classificazione EER (Elenco Europeo dei Rifiuti), dello stato fisico, della eventuale pericolosità HP e ADR e dei quantitativi prodotti.</p>
<p>L'applicazione consente: al produttore del rifiuto di stampare le etichette dei contenitori e prenotare la consegna del rifiuto presso il Deposito Temporaneo prima della Raccolta, mentre ai Responsabili di Unità  Locale /Delegati alle Operazioni di tracciare puntualmente i rifiuti in Deposito, semplificandone e velocizzandone le operazioni di gestione, diminuendo al contempo il rischio di errore.</p>
<p>La puntuale tracciatura facilita inoltre la rendicontazione dei rifiuti prodotti, sia ai fini della gestione interna che a quelli legati agli obblighi di legge e alla rendicontazione ambientale.</p>".html_safe
  end
end

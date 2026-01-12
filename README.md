# almarusco
Prototipo di gestionale per i rifiuti speciali (su specifiche Unibo)


> Il vocabolo dialettale Róssc (immondizia, pattume), spesso italianizzato dai bolognesi in Rusco, deriva dal latino classico ruscus, che significa «pungitopo o arbusto cespuglioso», usato anticamente per fabbricare scope.
> https://lepri.blogautore.repubblica.it/2010/04/18/rusco-di-bologna/


## Demo locale con Docker Compose

Questa sezione descrive come provare l'applicativo via Docker Compose. 

Per preparare il db e configurare l'applicazione:

```bash
# build
docker compose -f compose_demo.yaml build
# start del database
docker compose -f compose_demo.yaml up -d db
# preparazione del database
docker compose -f compose_demo.yaml run --rm web bin/rails db:prepare
# aggiunta al database dati iniziali del demo
docker compose -f compose_demo.yaml run --rm web bin/rails db:setup_demo 
```

Per far partire il server:

```bash
docker compose -f compose_demo.yaml up web
```

Connettersi quindi a `(http://127.0.0.1:3000/home)[http://127.0.0.1:3000/home]` e 
loggarsi con utente `admin.user@example.com` (senza password)
per essere un amministratore della struttura di prova 1.

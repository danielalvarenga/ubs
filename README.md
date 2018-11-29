# UBS API
API to list health basic units of Brazil.


# Documentation
Heroku: [https://ubsapi.herokuapp.com](https://ubsapi.herokuapp.com)

Swagger docs: [https://app.swaggerhub.com/apis/danielalvarenga/ubs-api/1.0.0](https://app.swaggerhub.com/apis/danielalvarenga/ubs-api/1.0.0)

# Execution
To facilite execution with docker use script files.

## Rails tasks
Execute **db:seed** to import health basic units from [http://dados.gov.br/dataset/unidades-basicas-de-saude-ubs](http://dados.gov.br/dataset/unidades-basicas-de-saude-ubs).

    $ ./run.sh db:create db:migrate db:seed

## Start server

    $ ./up.sh
For supress logs:

    $ ./up.sh -d

## Stop all services

    $ ./down.sh

## Tests

    $ ./rspec.sh
For especific file/test:

    $ ./rspec.sh ./spec/exception/custom_exception_spec.rb:21
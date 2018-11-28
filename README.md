# UBS API
API to list health basic units of Brazil.


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
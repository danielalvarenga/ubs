#!/bin/bash

docker-compose down

docker-compose run web bundle exec rspec $*
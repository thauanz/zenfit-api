#!/bin/bash

# run the migrates or run the setup
bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:create db:setup

exec "$@"

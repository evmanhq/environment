#!/bin/bash

export PUMA_THREADS=${PUMA_THREADS:="0:16"}

if [ -n "$PUMA_WORKERS" ]; then 
  export PUMA_WORKERS="-w $PUMA_WORKERS"
fi

bundle exec rake db:migrate
bundle exec puma $PUMA_WORKERS -t $PUMA_THREADS -e $RAILS_ENV -b tcp://127.0.0.1:3000 --state=puma.state

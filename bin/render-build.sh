#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean

# Let the app deploy when Neon's free database allowance is exhausted, but
# keep failing the build for migration errors so they are not silently hidden.
if migrate_output="$(bundle exec rake db:migrate 2>&1)"; then
  printf '%s\n' "$migrate_output"
else
  migrate_status=$?
  printf '%s\n' "$migrate_output"

  if printf '%s\n' "$migrate_output" | grep -qiE "exceeded the quota|ConnectionNotEstablished|PG::ConnectionBad|could not connect"; then
    echo "WARNING: database unreachable, skipping migrations for this deploy."
  else
    exit "$migrate_status"
  fi
fi

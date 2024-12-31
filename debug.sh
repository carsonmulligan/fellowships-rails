#!/usr/bin/env bash
#
# Run this script from your project root:
#   chmod +x debug.sh
#   ./debug.sh
#
# It will gather debug data into a file named debug_output.txt.

{
  echo "===== (1) Listing Rails Rake tasks (development env) ====="
  bundle exec rake -P
  echo

  echo "===== (2) Listing Rails Rake tasks (production env) ====="
  RAILS_ENV=production bundle exec rake -P
  echo

  echo "===== (3) Checking Rails server startup (5-second test) ====="
  rails s &
  RAILS_PID=$!
  echo "Rails server started with PID $RAILS_PID... waiting 5 seconds."
  sleep 5
  echo "Killing rails server..."
  kill -INT "$RAILS_PID" || kill -9 "$RAILS_PID"
  echo

  echo "===== (4) Listing bin directory contents ====="
  ls -l bin
  echo

  echo "===== (5) Git commit & push to Heroku ====="
  git add .
  git commit -m "Test debug script"
  echo "Pushing to heroku main..."
  git push heroku main
  echo

  echo "===== (6) Fetching Heroku logs (last 200 lines) ====="
  heroku logs -n 200
  echo

  echo "===== (7) Running Heroku DB migrate ====="
  heroku run rake db:migrate
  echo

  echo "===== (8) Checking Heroku config ====="
  heroku config
  echo

  echo "===== (9) Checking local Ruby version ====="
  ruby -v
  echo

} 2>&1 | tee debug_output.txt

echo "All output saved to debug_output.txt"

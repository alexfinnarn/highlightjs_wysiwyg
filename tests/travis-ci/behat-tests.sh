#!/usr/bin/env bash

# Start server.
cd ${ROOT_DIR}/backdrop
$HOME/.composer/vendor/bin/drush backdrop-runserver 127.0.0.1:8057 > /dev/null 2>&1 &
nc -zvv 127.0.0.1 8057; out=$?; while [[ $out -ne 0 ]]; do echo "Retry hit port 8057..."; nc -zvv localhost 8057; out=$?; sleep 5; done
earlyexit

# Enable module.
cd $ROOT_DIR/backdrop
echo Enabling bundle module...
$HOME/.composer/vendor/bin/drush en ${MODULE_NAME} -y
earlyexit

# Enable any additional modules used during test runs.
echo Enabling additional testings modules...
git clone https://github.com/backdrop-contrib/${ADD_CONTRIB_MODULES}.git ${ROOT_DIR}/backdrop/modules/
$HOME/.composer/vendor/bin/drush en ${ADD_CONTRIB_MODULES} -y

$HOME/.composer/vendor/bin/drush en ${ADD_CUSTOM_MODULES} -y
$HOME/.composer/vendor/bin/drush cc all
earlyexit

# Run any database updates.
echo "Running pending database updates..."
$HOME/.composer/vendor/bin/drush updb -y
earlyexit

# Run headless tests.
echo "Running Behat headless tests..."
${ROOT_DIR}/backdrop/modules/${MODULE_NAME}/tests/behat/bin/behat --stop-on-failure --strict --config ${ROOT_DIR}/backdrop/modules/${MODULE_NAME}/tests/behat/behat.travis.yml --verbose --tags ${EXPRESS_HEADLESS_BEHAT_TAGS}
earlyexit

exit 0

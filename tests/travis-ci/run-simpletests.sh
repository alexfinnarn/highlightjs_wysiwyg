#!/usr/bin/env bash

cd ${ROOT_DIR}/backdrop

php ./core/scripts/run-tests.sh --url http://127.0.0.1:8057 --php ~/.phpenv/versions/$(phpenv version-name)/bin/php "${SIMPLETEST_CLASSES}"
earlyexit

exit 0

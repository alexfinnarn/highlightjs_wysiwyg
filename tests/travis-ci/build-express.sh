#!/usr/bin/env bash

# Install a site.
cd ${ROOT_DIR}/backdrop
$HOME/.composer/vendor/bin/drush si --db-url=mysql://backdrop:backdrop@127.0.0.1/backdrop -y

exit 0

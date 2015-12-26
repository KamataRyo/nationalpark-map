#!/usr/bin/env bash

set -e

if [[ "false" != "$TRAVIS_PULL_REQUEST" ]]; then
	echo "Not deploying pull requests."
	exit
fi

if [[ "master" != "$TRAVIS_BRANCH" ]]; then
	echo "Not on the 'master' branch."
	exit
fi

rm -rf .git
rm -r .gitignore

echo "bin
coffee
js/spec
node_modules
sketch
bower.json
config.rb
gulpfile.coffee
.bowerrc
.travis.yml
.gitignore
README.md
screenshot.png
package.json" > .gitignore

git init
git config user.name "kamataryo"
git config user.email "travis@example.com"
git add .
git commit --quiet -m "Deploy from travis"
git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:gh-pages > /dev/null 2>&1

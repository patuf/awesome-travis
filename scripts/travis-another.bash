#!/bin/bash

# Rerun another project's tests
# https://github.com/balupton/awesome-travis#rerun-another-projects-tests
# This should be easier but https://github.com/travis-ci/travis.rb/issues/315 is a thing. Also don't use --debug on `travis login` as that will output the github token.
if [ ! -z $GITHUB_TRAVIS_TOKEN ]; then
	echo "pinging $OTHER_REPO_SLUG..."
	rvm install 2.1 || exit -1
	gem install travis curb --no-rdoc --no-ri || exit -1
	travis login --skip-completion-check --org --github-token "$GITHUB_TRAVIS_TOKEN" || exit -1
	export TRAVIS_ACCESS_TOKEN=`cat ~/.travis/config.yml | grep access_token | sed 's/ *access_token: *//'` || exit -1
	travis restart --debug --skip-completion-check --org -r "$OTHER_REPO_SLUG" -t "$TRAVIS_ACCESS_TOKEN" || exit -1
	echo "pinged $OTHER_REPO_SLUG"
else
	echo "skipped ping $OTHER_REPO_SLUG"
fi
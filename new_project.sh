#!/bin/sh
PROJECT=$1
if [ -z $PROJECT ]; then
	PROJECT="landing"
fi

[ -e "$PROJECT" ] && echo "Can't create folder '$PROJECT' (Already exists)" && exit -1

git clone --depth=1 https://github.com/coffebar/landing_template.git "$PROJECT"

pushd "$PROJECT"

# remove this script and readme file
rm -f new_project.sh README.md
# change project name in index.html
sed -i "s|Landing|${PROJECT}|g" index.html
# remove template repo from 'remote' in git
# because don't want to push something into template's repo
git remote remove origin
# commit automatic changes
git commit -a -m "blank template"
# install gulp related stuff
# and open editor
pnpm install && [ -z $EDITOR ] && ./watch.sh || $EDITOR index.html

popd

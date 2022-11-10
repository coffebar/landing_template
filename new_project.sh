#!/bin/sh
PROJECT=$1
if [ -z $PROJECT ]; then
	PROJECT="landing"
fi
[ -e "$PROJECT" ] && exit -1
git clone --depth=1 https://github.com/coffebar/landing_template.git "$PROJECT"
pushd "$PROJECT"
rm -f new_project.sh
sed -i 's|Landing|${PROJECT}|g' index.html
npm install && ./watch.sh
popd

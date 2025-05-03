#!/bin/bash

flutter pub upgrade --major-versions --tighten

cd ./admin_app
flutter pub upgrade --major-versions --tighten
cd $OLDPWD

echo '## all done'

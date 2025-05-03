#!/bin/bash

flutter pub upgrade  

cd ./admin_app
flutter pub upgrade  
cd $OLDPWD

echo '## all done'

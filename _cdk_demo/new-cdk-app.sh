#!/bin/sh
# Set the terminal you use here: bash or zsh or another.
# Installs the latest AWS CDK. Only tested on macOS.
export TERM=xterm-256color

YELLOW='\033[1;33m'
CDK="CREATE_CDK_APP"
DATE=$( date "+%d-%m-%YT%H:%M:%S" )
DIR="new-cdk-app"
echo "$YELLOW"

select cdk in $CDK; do
case $cdk in
"CREATE_CDK_APP")

echo "Date/time: $DATE"
cd || exit
# if dir does not exists create it
if
  [ ! -d "$DIR" ]
then
  mkdir -p "$DIR" && chmod -R 755 "$DIR"
else
	rm -rvf "$DIR"
  mkdir -p "$DIR" && chmod -R 755 "$DIR"
fi

echo "Directory [ $DIR ] is created!"
cd "$DIR" || exit
 if command aws-cdk version &> /dev/null; then
     echo "⚠️""$YELLOW""CDK is already installed: $(cdk version)"
        echo "checking and installing update: $(npm i -g aws-cdk@latest)"
 	        echo "CDK installed successfully. ✨ ✨ "
 	            echo "Using AWS CDK: $(cdk version)"
 else
     echo "$YELLOW""Installing CDK: $(npm i -g aws-cdk@latest)"
         echo "Using AWS CDK: $(cdk version)"

if command -v cdk &> /dev/null; then
    echo "CDK installed successfully. ✨ ✨ "
    echo "Using AWS CDK: $(cdk version)"
else
    echo "Error: CDK installation failed."
    exit 1
fi
 fi

echo
break
;;
*)
echo "Error! Please check your logs."
;;
esac
done

echo "$YELLOW""Initializing app, using Typescript"
cdk init app --language typescript

echo "$YELLOW""Configure the app"
cd || exit
cd cfd-onboarding/_cdk_demo || exit
cp -rf new-cdk-app ~/new-cdk-app/bin/new-cdk-app.ts
cp -rf new-cdk-app-stack ~/new-cdk-app/lib/new-cdk-app-stack.ts
cp -rf gitignore ~/new-cdk-app/.gitignore

cd || exit
cd ${DIR} || exit

echo "$YELLOW""Uninstall deprecated package"
npm uninstall source-map-support

echo "$YELLOW""List the stack(s)"
cdk ls

open .

# Exit script.
kill -15 $PPID

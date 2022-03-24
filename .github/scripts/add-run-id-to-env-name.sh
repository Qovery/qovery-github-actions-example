#!/usr/bin/env bash

set -eo pipefail

echo "Getting the current environment name"
envName=$(curl -fs -X GET -H "Authorization: Token $QOVERY_API_TOKEN" \
    "https://api.qovery.com/environment/$ENVIRONMENT_ID" | jq -r .name)

if [[ $envName == *"- #"* ]];
then
    newEnvName=$(echo $envName | sed "s/#.*/#$GITHUB_RUN_ID/")
else
    newEnvName="$envName - #$GITHUB_RUN_ID"
fi

echo "New environment name: $newEnvName"

echo "Renaming the base environment ..."

curl -fs -o /dev/null -X PUT -d "{\"name\": \"$newEnvName\"}" -H 'Content-type: application/json' -H "Authorization: Token $QOVERY_API_TOKEN" \
    "https://api.qovery.com/environment/$ENVIRONMENT_ID"

echo "Done!"

## keep going
exit 0

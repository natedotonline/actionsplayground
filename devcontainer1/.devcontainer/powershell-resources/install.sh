#!/bin/sh
set -e

echo "Feature 'powershell-resources' starting..."

if ! command -v pwsh > /dev/null; then
    echo "PowerShell is not installed. Please ensure it is installed before using this feature."
    exit 127
fi

if [ "$REQUIREDRESOURCEJSONBASE64" != "" ] && [ "$REQUIREDRESOURCEJSONFILE" != "" ]; then
    echo "You cannot specify both requiredResourceJsonBase64 and requiredResourceJsonFile for this feature."
    exit 1
fi

if [ "$RESOURCES" != "" ] && [ "$REQUIREDRESOURCEJSONFILE" != "" ]; then
    echo "You cannot specify both resources and requiredResourceJsonFile for this feature."
    exit 1
fi

if [ "$REQUIREDRESOURCEJSONBASE64" != "" ] && [ "$RESOURCES" != "" ]; then
    echo "You cannot specify both requiredResourceJsonBase64 and resources for this feature."
    exit 1
fi

if [ -z "$RESOURCES" ] && [ -z "$REQUIREDRESOURCEJSONBASE64" ] && [ -z "$REQUIREDRESOURCEJSONFILE" ]; then
    echo "An input must be specified for this feature."
    exit 1
fi

cp install.ps1 $_REMOTE_USER_HOME

su - "$_REMOTE_USER" <<EOF
    pwsh -f $_REMOTE_USER_HOME/install.ps1
EOF

rm $_REMOTE_USER_HOME/install.ps1
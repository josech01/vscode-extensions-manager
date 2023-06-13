#!/bin/bash

settings_file=".vscode/extensions.json"

if [ -f "$settings_file" ]; then
  recommended_extensions=$(jq -r '.recommendations[]' "$settings_file")

  if [ -n "$recommended_extensions" ]; then
    for extension in $recommended_extensions; do
      code --install-extension "$extension"
    done

    echo "Recommended extensions have been installed for the repository."
  else
    echo "No recommended extensions found in the configuration file."
  fi
else
  echo "Visual Studio Code configuration file not found. Creating the file..."

  mkdir -p ".vscode"

  echo '{"recommendations": []}' > "$settings_file"
  echo "Empty Visual Studio Code configuration file has been created."

  echo "No recommended extensions to install for the repository."

  if [ -f "package.json" ]; then
    extensions='{"recommendations": ["dbaeumer.vscode-eslint", "esbenp.prettier-vscode", "vscode-es7-javascript-react-snippets"]}'
    if grep -q '"@angular/core"' package.json; then
      extensions+='{"recommendations": ["angular.ng-template", "angular.ng-language-service"]}'
    fi
    if grep -q '"vue"' package.json; then
      extensions+='{"recommendations": ["octref.vetur"]}'
    fi
    if grep -q '"react"' package.json; then
      extensions+='{"recommendations": ["msjsdiag.debugger-for-chrome", "msjsdiag.vscode-react-native"]}'
    fi
    if grep -q '"express"' package.json; then
      extensions+='{"recommendations": ["ms-azuretools.vscode-docker", "ritwickdey.LiveServer"]}'
    fi
    if grep -q '"nestjs"' package.json; then
      extensions+='{"recommendations": ["nrwl.angular-console", "prisma.prisma"]}'
    fi
  elif [ -f "requirements.txt" ]; then
    extensions='{"recommendations": ["ms-python.python"]}'
  elif [ -f "Gemfile" ]; then
    extensions='{"recommendations": ["rebornix.Ruby"]}'
  elif [ -f "pom.xml" ]; then
    extensions='{"recommendations": ["vscjava.vscode-java-pack", "SonarSource.sonarlint-vscode"]}'
  else
    echo "Unknown or unsupported repository type. Cannot automatically add recommended extensions."
    exit 1
  fi

  echo "$extensions" > "$settings_file"
  echo "Visual Studio Code configuration file has been created with the recommended extensions for the repository."

  for extension in $(jq -r '.recommendations[]' "$settings_file"); do
    code --install-extension "$extension"
  done

  echo "Recommended extensions have been installed for the repository."
fi

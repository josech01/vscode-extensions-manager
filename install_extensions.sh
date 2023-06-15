#!/bin/bash

settings_file=".vscode/extensions.json"
settings_json=".vscode/settings.json"

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

    if grep -q '"python"' package.json; then
      color_customizations='{"workbench.colorCustomizations": {
        "editorLineNumber.foreground": "#FF0000",
        "editorCursor.foreground": "#FF0000"
      }}'
      echo "$color_customizations" > "$settings_json"
      echo "Color customizations for Python have been added to settings.json."
    fi

    if grep -q '"node"' package.json; then
      color_customizations='{"workbench.colorCustomizations": {
        "editorLineNumber.foreground": "#00FF00",
        "editorCursor.foreground": "#00FF00"
      }}'
      echo "$color_customizations" > "$settings_json"
      echo "Color customizations for Node.js have been added to settings.json."
    fi
  elif [ -f "requirements.txt" ]; then
    extensions='{"recommendations": ["donjayamanne.python-extension-pack"]}'
    color_customizations='{"workbench.colorCustomizations": {
      "activityBar.background": "#990000",
      "activityBar.activeBorder": "#ff2020",
      "activityBar.foreground": "#e7e7e7",
      "activityBar.inactiveForeground": "#e7e7e799",
      "activityBarBadge.background": "#ff2020",
      "activityBarBadge.foreground": "#e7e7e7",
      "statusBar.background": "#640000",
      "statusBarItem.hoverBackground": "#990000",
      "statusBar.foreground": "#e7e7e7",
      "activityBar.activeBackground": "#990000",
      "titleBar.activeBackground": "#640000",
      "titleBar.activeForeground": "#e7e7e7",
      "titleBar.inactiveBackground": "#64000099",
      "titleBar.inactiveForeground": "#e7e7e799",
      "sash.hoverBorder": "#990000",
      "statusBarItem.remoteBackground": "#640000",
      "statusBarItem.remoteForeground": "#e7e7e7",
      "commandCenter.border": "#e7e7e799"
    }}'
    echo "$color_customizations" > "$settings_json"
    echo "Color customizations for Python have been added to settings.json."
  elif [ -f "Gemfile" ]; then
    extensions='{"recommendations": ["rebornix.Ruby"]}'
    color_customizations='{"workbench.colorCustomizations": {
      "editorLineNumber.foreground": "#FFFF00",
      "editorCursor.foreground": "#FFFF00"
    }}'
    echo "$color_customizations" > "$settings_json"
    echo "Color customizations for Ruby have been added to settings.json."
  elif [ -f "pom.xml" ]; then
    extensions='{"recommendations": ["vscjava.vscode-java-pack", "SonarSource.sonarlint-vscode"]}'
    color_customizations='{"workbench.colorCustomizations": {
      "editorLineNumber.foreground": "#0000FF",
      "editorCursor.foreground": "#0000FF"
    }}'
    echo "$color_customizations" > "$settings_json"
    echo "Color customizations for Java have been added to settings.json."
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


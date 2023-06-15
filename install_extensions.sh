#!/bin/bash

# Constants and variables
readonly SETTINGS_FILE=".vscode/extensions.json"
readonly SETTINGS_JSON=".vscode/settings.json"
readonly CONFIG_FOLDER=".vscode"
readonly RECOMMENDED_EXTENSIONS='{"recommendations": ["dbaeumer.vscode-eslint", "esbenp.prettier-vscode", "vscode-es7-javascript-react-snippets"]}'
readonly PYTHON_COLOR_CUSTOMIZATIONS='{"workbench.colorCustomizations": { 
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
      "commandCenter.border": "#e7e7e799"}}'
readonly NODE_COLOR_CUSTOMIZATIONS='{"workbench.colorCustomizations": {  
    "activityBar.background": "#009700",
    "activityBar.activeBorder": "#2020ff",
    "activityBar.foreground": "#e7e7e7",
    "activityBar.inactiveForeground": "#e7e7e799",
    "activityBarBadge.background": "#2020ff",
    "activityBarBadge.foreground": "#e7e7e7",
    "statusBar.background": "#006400",
    "statusBarItem.hoverBackground": "#009700",
    "statusBar.foreground": "#e7e7e7",
    "activityBar.activeBackground": "#009700",
    "titleBar.activeBackground": "#006400",
    "titleBar.activeForeground": "#e7e7e7",
    "titleBar.inactiveBackground": "#00640099",
    "titleBar.inactiveForeground": "#e7e7e799",
    "sash.hoverBorder": "#009700",
    "statusBarItem.remoteBackground": "#006400",
    "statusBarItem.remoteForeground": "#e7e7e7",
    "commandCenter.border": "#e7e7e799"}}'
readonly RUBY_COLOR_CUSTOMIZATIONS='{"workbench.colorCustomizations": { "editorLineNumber.foreground": "#FFFF00", "editorCursor.foreground": "#FFFF00" }}'
readonly JAVA_COLOR_CUSTOMIZATIONS='{"workbench.colorCustomizations": { "editorLineNumber.foreground": "#0000FF", "editorCursor.foreground": "#0000FF" }}'

# Function to install recommended extensions
install_recommended_extensions() {
  local extensions=$(jq -r '.recommendations[]' "$SETTINGS_FILE")

  if [ -n "$extensions" ]; then
    for extension in $extensions; do
      code --install-extension "$extension"
    done

    echo "Recommended extensions have been installed for the repository."
  else
    echo "No recommended extensions found in the configuration file."
  fi
}

# Function to create the settings file
create_settings_file() {
  echo "$RECOMMENDED_EXTENSIONS" > "$SETTINGS_FILE"
  echo "Visual Studio Code configuration file has been created with the recommended extensions for the repository."

  # Add customizations based on the project type
  if [ -f "package.json" ]; then
    if grep -q '"python"' package.json; then
      echo "$PYTHON_COLOR_CUSTOMIZATIONS" > "$SETTINGS_JSON"
      echo "Color customizations for Python have been added to settings.json."
    if grep -q '"node"' package.json; then
        echo "$NODE_COLOR_CUSTOMIZATIONS" > "$SETTINGS_JSON"
        echo "Color customizations for Node.js have been added to settings.json."
    fi
    # Add more logic for other project types (e.g., Vue, React, etc.)
    elif [ -f "requirements.txt" ]; then
      echo "$PYTHON_COLOR_CUSTOMIZATIONS" > "$SETTINGS_JSON"
      echo "Color customizations for Python have been added to settings.json."
    elif [ -f "Gemfile" ]; then
      echo "$RUBY_COLOR_CUSTOMIZATIONS" > "$SETTINGS_JSON"
      echo "Color customizations for Ruby have been added to settings.json."
    elif [ -f "pom.xml" ]; then
      echo "$JAVA_COLOR_CUSTOMIZATIONS" > "$SETTINGS_JSON"
      echo "Color customizations for Java have been added to settings.json."
    else
      echo "Unknown or unsupported repository type. Cannot automatically add recommended extensions."
      exit 1
    fi
  fi
}

# Check if the settings file exists
if [ -f "$SETTINGS_FILE" ]; then
  install_recommended_extensions
else
  echo "Visual Studio Code configuration file not found. Creating the file..."

  mkdir -p "$CONFIG_FOLDER"

  echo '{"recommendations": []}' > "$SETTINGS_FILE"
  echo "Empty Visual Studio Code configuration file has been created."

  echo "No recommended extensions to install for the repository."

  create_settings_file
  install_recommended_extensions
fi

   

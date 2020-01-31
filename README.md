# Slash BOT for Slack channels
## Introduction
This is a simple ruby slack bot which has custom /commands from Cloud Platform. This enable Cloud Platform to post automatic messages and users to search for specfic terms used by Cloud Platform.
## Setup
* This app can be deployed in the Cloud Platform kubernetes cluster. Use `kubectl_deploy` folder for deployment manifest.
* You'll need to add it in slack (you will need suitable permissions for this):
  * Create and Install a Slack app to your workspace
  * Create a bot user and give permissions to write to the channel
  * Enable slash commands and point to the url where your app is deployed

## Configuration
Set the bot token as `SLACK_TOKEN` and `SLACK_OAUTH` and pass it as environment variable
This one uses kubernetes secret to set the enviroment variable and used it in the deployment manifest.

## Development
See the makefile for details of how to run the bot code locally, during development.

## Usage
Update the `app.rb` for new slash commands and its respectively response messages.


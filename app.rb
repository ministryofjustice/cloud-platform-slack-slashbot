#!/usr/bin/env ruby

require 'sinatra'

require_relative 'slack_authorizer'
require_relative 'slack_messenger'

use SlackAuthorizer

CPHELP_RESPONSE = "Cloud Platform has below slash commands\n" \
                "/cpopenhours [day] [time]\n" \
                "/cpauthenticate\n" \
                "/cpalerts\n" \
                "/cprdsmigrate\n" \
                "/cpgitcrypt\n" \
                "/cptrouble\n" \
                "/cpdsd\n" \
                "/cp\n"

CPAUTHENTICATE_RESPONSE = "Here is the process for authenticating into the live cluster.\n" \
                        "https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/kubectl-config.html#authentication.\n" \
                        "Does this help?"

CPALERTS_RESPONSE = "Here is the guide for creating custom alerts for your applications. \n" \
                    "https://user-guide.cloud-platform.service.justice.gov.uk/documentation/monitoring-an-app/how-to-create-alarms.html#creating-your-own-custom-alerts.\n" \
                    "Does this help?"

CPRDSMIGRATE_RESPONSE = "Here is the guide for migrating your RDS instance.  \n" \
                        "https://user-guide.cloud-platform.service.justice.gov.uk/documentation/other-topics/aws-rds-migration.html#migrating-an-rds-instance.\n" \
                        "Does this help?"

CPGITCRYPT_RESPONSE = "Here is the guide to encrypt application secrets using git-crypt. \n" \
                      "https://user-guide.cloud-platform.service.justice.gov.uk/documentation/other-topics/git-crypt-setup.html#git-crypt. \n" \
                      "Does this help?"

CPTROUBLE_RESPONSE = "I think the information you need might be in the troubleshooting guide here:  \n" \
                     "https://user-guide.cloud-platform.service.justice.gov.uk/documentation/other-topics/troubleshooting.html#troubleshooting-guide \n"

CPDSD_RESPONSE = "That's handled by the digital service desk, not the cloud platform team. Please ask in #digitalservicedesk \n"

CPOPENHOURS_EXPRESSION = /^([\w\.\-_]+) ([\w\.\-_]+) (.+)/

CPOPENHOURS_RESPONSE = "Cloud Platform Open Hour (and a half!) - Got questions about the Cloud Platform? Want to know more about key concepts? Questions about deployment strategy? How to improve your build time? Have a need not already being met by the Platform? Well, come and talk to us!
Our Open “Hour” is [time] this Friday [day].
If you would like a 30 minute slot please reply to this tread. We’ll confirm your needs prior to the session.
We hope to make these a regular feature so don’t despair if you miss out this time.
This is open to everyone in all locations - Come and meet us in person or via a call. "

INVALID_RESPONSE = "Sorry, I didn’t quite get that. Try /cphelp for list of Cloud Platform slash commands"

post '/slack/command' do
  puts params
  day, time = ""
  case params['command']
  when '/cp' then
    message = CPHELP_RESPONSE
  when '/cpauthenticate' then
    message = CPAUTHENTICATE_RESPONSE
  when '/cpalerts' then
    message = CPALERTS_RESPONSE
  when '/cprdsmigrate' then
    message = CPRDSMIGRATE_RESPONSE
  when '/cpgitcrypt' then
    message = CPGITCRYPT_RESPONSE
  when '/cptrouble' then
    message = CPTROUBLE_RESPONSE
  when '/cpdsd' then
    message = CPDSD_RESPONSE
  when '/cpopenhours' then
    open_hours_response = CPOPENHOURS_RESPONSE
    case params['text']
    when CPOPENHOURS_EXPRESSION
      day, time = $1 + ' ' + $2, $3
      open_hours_response.gsub!("[day]",day)
      open_hours_response.gsub!("[time]",time)
      message = open_hours_response
    end
  else INVALID_RESPONSE
  end
  cpuser = false
  File.readlines('cp-usernames.vars').each {|username|
    if params['user_name'] == username.to_s.strip
      SlackMessenger.deliver(params['user_name'], 'ask-cloud-platform', message)
      cpuser = 1
      break
    end
  }
    if !cpuser
      message
    end
end

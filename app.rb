#!/usr/bin/env ruby

require 'sinatra'

require_relative 'slack_authorizer'
require_relative 'slack_messenger'

use SlackAuthorizer

HELP_RESPONSE = "Cloud Platform has below slash commands\n" \
                "/cpopenhours [day] [time]\n" \
                "/cp\n"

OPEN_HOURS_EXPRESSION = /^([\w\.\-_]+) ([\w\.\-_]+) (.+)/

OPEN_HOURS_RESPONSE = "Cloud Platform Open Hour (and a half!) - Got questions about the Cloud Platform? Want to know more about key concepts? Questions about deployment strategy? How to improve your build time? Have a need not already being met by the Platform? Well, come and talk to us!
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
    message = HELP_RESPONSE
  when '/cpopenhours' then
    open_hours_response = OPEN_HOURS_RESPONSE
    case params['text']
    when OPEN_HOURS_EXPRESSION
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
      SlackMessenger.deliver('@ruby_slack_bot', 'cloud-platform', message)
      cpuser = 1
      break
    end
  }
    if !cpuser
      message
    end
end

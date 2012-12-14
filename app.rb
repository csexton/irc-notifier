require 'sinatra'
require 'socket'
require 'json'

# {
#   "branch_name": "gem_updates",
#   "branch_url": "https://semaphoreapp.com/projects/44/branches/50",
#   "project_name": "base-app",
#   "build_url": "https://semaphoreapp.com/projects/44/branches/50/builds/15",
#   "build_number": 15,
#   "result": "passed",
#   "started_at": "2012-07-09T15:23:53Z",
#   "finished_at": "2012-07-09T15:30:16Z",
#   "commit": {
#     "id": "dc395381e650f3bac18457909880829fc20e34ba",
#     "url": "https://github.com/renderedtext/base-app/commit/dc395381e650f3bac18457909880829fc20e34ba",
#     "author_name": "Vladimir Saric",
#     "author_email": "vladimir@renderedtext.com",
#     "message": "Update 'shoulda' gem.",
#     "timestamp": "2012-07-04T18:14:08Z"}
# }

def putss(s, str)
  s.puts str
  puts s
end

def say_as(user, message)
  config = {
    server: ENV["IRC_SERVER"],
    password: ENV["IRC_PASSWORD"],
    user_name: ENV["IRC_USER"] || user,
    room: ENV["IRC_ROOM"],
    method: ENV["IRC_METHOD"] || 'action',
    # If you can't set -n on the channel, you can have the bot
    # join the channel first to send a message.
    #
    #     /mode #channel -n
    join_before_message: ENV["IRC_JOIN_BEFORE_MSG"] || false,
  }
  # Sometime going procedural is simpler
  s= TCPSocket.open(config[:server], config[:port] || 6667)
  putss(s, "PASS #{config[:password]}") if config[:password]
  putss(s, "NICK #{config[:user_name]}")
  putss(s, "USER #{config[:user_name]} 0 * :#{config[:user_name]}")
  sleep 10
  puts s.recv 1000
  if config[:join_before_message]
    putss(s, "JOIN :#{config[:room]}")
    sleep 7
  end
  puts s.recv 1000
  if config[:method] == 'action'
    putss(s,"PRIVMSG #{config[:room]} :\001ACTION #{message}\001")
  else
    putss(s, "PRIVMSG #{config[:room]} :#{message}")
  end
  if config[:join_before_message]
    putss(s, "PART :#{config[:room]}")
  end
  putss(s, "QUIT")
  puts s.gets until s.eof?
end

post '/semaphore' do
  post = JSON.parse(request.body.read.to_s)
  say_as "semaphore", "has #{post['result']} build #{post['build_number']} of #{post['project_name']}, on branch #{post['branch_name']}. #{post['build_url']}"
  "Thanks!"
end

post '/newrelic' do
  logger.info params.to_s
  if params[:alert]
    say_as "newrelic", "#{params[:alert]['application_name']} got an alert '#{params[:alert]['message']}' #{params[:alert]['alert_url']}"
  elsif params[:deployment]
    say_as "newrelic", "#{params[:deployment]['application_name']} has been deployed '#{params[:deployment]['description']}'"
  else
    say_as "newrelic", "I got a webhook I didn't understand:"
    say_as "newrelic", params.to_s
  end

  "Thanks!"
end


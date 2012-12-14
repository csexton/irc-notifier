# IRC Notifier for Webhooks

I love Semaphore, it is a truly awesome CI product. But they still haven't built an IRC notifier yet. So heorku and sinatra are bridging the gap for now. Same goes for New Relic.

To get setup with this:

    git clone https://github.com/csexton/irc-notifier.git
    cd irc-notifier
    heroku apps:create myappname
    git push heroku master
    heroku config:set IRC_SERVER="irc.example.com" IRC_PASSWORD="secrets" IRC_ROOM="#myroom"

### Semaphore

Configure Semaphore's webhooks to use `http://myappname.herokuapp.com/semaphore`

### New Relic

Configure New Relic's webhooks to use `http://myappname.herokuapp.com/newrelic`

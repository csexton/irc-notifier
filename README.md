# IRC Notifier for Semaphore App

I love Semaphore, it is a truly awesome CI product. But they still haven't built an IRC notifier yet. So heorku and sinatra are bridging the gap for now.

To get setup with this:

    git clone https://github.com/csexton/semaphore-irc-notifier.git
    cd semaphore-irc-notifier
    heroku apps:create myappname
    git push heroku master
    heroku config:set IRC_SERVER="irc.example.com" IRC_PASSWORD="secrets" IRC_ROOM="#myroom"

Now just configure the Semaphore webhooks to use `http://myappname.herokuapp.com/notify` then tweet at @semaphoreapp and tell them to hurry up with the IRC Notifier already. Mention this project.

slack2mqtt.rb
====
a bot for forwarding slack message to MQTT

How to
----
     $ sudo gem install slack-ruby-client
     $ sudo gem install eventmachine
     $ sudo gem install faye-websocket
     
     $ mkdir -p ~/work/
     $ cd ~/work/
     $ git clone https://github.com/yoggy/slack2mqtt.git
     $ cd slack2mqtt
     $ cp config.yaml.sample config.yaml
     $ vi config.yaml
       (edit mqtt_host, mqtt_publish_topic, slack_bot_token,...)
     
     $ ruby ./slack2mqtt.rb

Github
----

- https://github.com/yoggy/slack2mqtt

Copyright and license
----
Copyright (c) 2018 yoggy

Released under the [MIT license](LICENSE)

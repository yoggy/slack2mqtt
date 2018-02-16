#!/usr/bin/ruby
#
# slack2mqtt.rb - a bot for forwarding slack message to MQTT
#
# how to
#     $ sudo gem install slack-ruby-client
#     $ sudo gem install eventmachine
#     $ sudo gem install faye-websocket
#
#     $ mkdir -p ~/work/
#     $ cd ~/work/
#     $ git clone https://github.com/yoggy/slack2mqtt.git
#     $ cd slack2mqtt
#     $ cp config.yaml.sample config.yaml
#     $ vi config.yaml
#       (edit mqtt_host, mqtt_publish_topic, slack_bot_token,...)
#
#     $ ruby ./slack2mqtt.rb
#
# github
#     https://github.com/yoggy/slack2mqtt
#
# license
#     Copyright (c) 2018 yoggy <yoggy0@gmail.com>
#     Released under the MIT license
#     http://opensource.org/licenses/mit-license.php;
#
require 'slack-ruby-client'
require 'mqtt'
require 'yaml'
require 'pp'

$stdout.sync = true
Dir.chdir(File.dirname($0))
$current_dir = Dir.pwd

$log = Logger.new(STDOUT)
$log.level = Logger::DEBUG

$conf = OpenStruct.new(YAML.load_file("config.yaml"))

$conn_opts = {
  remote_host: $conf.mqtt_host
}

if !$conf.mqtt_port.nil? 
  $conn_opts["remote_port"] = $conf.mqtt_port
end

if $conf.mqtt_use_auth == true
  $conn_opts["username"] = $conf.mqtt_username
  $conn_opts["password"] = $conf.mqtt_password
end

Slack.configure do |config|
 config.token = $conf.slack_bot_token
end

MQTT::Client.connect($conn_opts) do |mqtt|

  slack = Slack::RealTime::Client.new
  
  slack.on :hello do
    $log.info(":hello")
  end
  
  slack.on :message do |d|
    $log.debug(d.pretty_inspect)
    mqtt.publish($conf.mqtt_publish_topic, d["text"])
  end
  
  slack.on :close do |d|
    $log.info(":close")
    exit 1
  end
  
  slack.on :closed do |d|
    $log.info(":closed")
    exit 1
  end
  
  slack.start!
end


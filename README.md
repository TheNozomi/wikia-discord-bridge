# wikia-discord-bridge
A chatbot-rb plugin intended to bridge a Wikia chat and a Discord channel. Using the [chatbot-rb](https://github.com/sactage/chatbot-rb) framework by [Sactage](https://github.com/sactage), and the [discordrb](https://github.com/meew0/discordrb) gem.


Prerequisites
----
* [Ruby](https://www.ruby-lang.org/) installed on your system.
* Ruby Gems *httparty*, *mediawiki-gateway* and *discordrb*. Once you installed Ruby, run `gem install httparty mediawiki-gateway discordrb` with terminal/command prompt to install them.
* A Wikia account for the bot, if you don't have one yet.
* A Discord bot account. You can follow [this tutorial](https://github.com/reactiflux/discord-irc/wiki/Creating-a-discord-bot-&-getting-a-token) to create one. After inviting the bot to your server, remember to save the client id and token.

Configuring the plugin
----
First, download and configure the chatbot-rb framework. [Here](http://community.wikia.com/wiki/User:KockaAdmiralac/chatbot-rb) is a guide of how to do that.

Then, download the discord_bridge.rb file from this repository and place it into the `plugins` folder.

After configuring the bot, your *main.rb* file should look like this:

```ruby
require_relative './client'
# Configuration part 1
require_relative './plugins/admin'
# End configuration part 1
$bot = Chatbot::Client.new
$bot.register_plugins(
# Configuration part 2
    Chatbot::Admin
# End configuration part 2
)
$bot.run!
```

Below all your `require_relative` lines, add this one:
`require_relative './plugins/discord_bridge'`
And register the plugin with the class name `Chatbot::DiscordBridge`.

Last, above the `$bot.run!` line, add this: `$discordbot.run:async`

Now close the main.rb file and open the discord_bridge.rb file, and find these lines:

```ruby
$discordbot = Discordrb::Bot.new token: "your token here", client_id: #your client id here, without quotes
$channel_id = #your channel id here, without quotes
```

In the first line replace with your bot token and client id, and in the second line with the channel id. You can find the channel id by right-clicking the channel that you want to use, and selecting "copy ID".

Now you can close the discord_bridge.rb file, and run `ruby main.rb` on your command line. When you type something in the Wikia chat, the bot should send it to the Discord channel you specified, and vice versa.

Issues
----
If you have any issue or question configuring or using the plugin, feel free to report it using the GitHub issues feature, or in my [Community Central message wall](http://c.wikia.com/wiki/Message_wall:ElNobDeTfm).

Contributing
----
Contributing is always welcome, if you want to do some improvement to the plugin, feel free to open a pull request.

require_relative '../plugin'
require_relative '../client'
require 'httparty'
require 'discordrb'

class Chatbot::DiscordBridge
  include Chatbot::Plugin

  def discord_send(content)
    $discordbot.send_message($channel_id, content)
  end

  match /(.*)/, use_prefix: false, method: :on_message
  listen_to :join, :on_join
  listen_to :part, :on_part
  listen_to :kick, :on_kick
  listen_to :ban, :on_ban

  def on_message(user, message)
    if message.start_with? '[b]<'
      nil
    elsif message.start_with? '/me '
      discord_send("**<#{user.name}>** * #{user.name} #{message.sub(%r{/\/me /}, '')}")
    else
      discord_send("**<#{user.name}>** #{message.gsub(%r{/\[b\]|\[\/b\]/}, '**').gsub(%r{/\[i\]|\[\/i\]/}, '*').gsub(%r{/\[s\]|\[\/s\]/}, '~~').gsub(%r{/\[u\]|\[\/u\]/}, '__').gsub(%r{/\[code\]|\[\/code\]/}, '`').gsub(%r{/\[(?:img|audio|video)="/}, 'http://').gsub(%r{/\[(?:yt|youtube)="/}, 'https://youtu.be/')}")
    end
  end

  def on_join(data)
    @client.send_msg data
    discord_send("~ #{data['attrs']['name']} has joined the chat. ~")
  end

  def on_part(data)
    @client.send_msg data
    discord_send("~ #{data['attrs']['name']} has left the chat. ~")
  end

  def on_kick(data)
    discord_send("~ #{data['attrs']['kickedUserName']} has been kicked by #{data['attrs']['moderatorName']}. ~")
  end

  def on_ban(data)
    discord_send("~ #{data['attrs']['kickedUserName']} has been banned by #{data['attrs']['moderatorName']}. ~")
  end

  def initialize(bot)
    super(bot)
    @c = client.config['discord'] || {}
    $discordbot = Discordrb::Bot.new token: @c['token'], client_id: @c['id']
    $channel_id = @c['channel']
    $discordbot.message(in: $channel_id) do |event|
      username = event.author.display_name
      message = event.content
      bot.send_msg "[b]<#{username}>[/b] #{message.gsub(/\*\*(.*)\*\*/, '[b\]\1[/b\]').gsub(/\*(.*)\*/, '[i\]\1[/i\]').gsub(/~~(.*)~~/, '[s\]\1[/s\]').gsub(/__(.*)__/, '[u\]\1[/u\]').gsub(/`(.*)`/, '[code\]\1[/code\]')}"
    end
    $discordbot.message(in: $channel_id) do |event|
      username = event.author.display_name
      message = event.content
    end
    $discordbot.run
  end
end

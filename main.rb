require_relative './client'

require_relative './plugins/admin'
require_relative './plugins/discord_bridge'

$bot = Chatbot::Client.new
$bot.register_plugins(
  Chatbot::Admin,
  Chatbot::DiscordBridge
)
$bot.run!

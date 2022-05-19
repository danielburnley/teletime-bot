require "discordrb"
require "dotenv"
require "pry"
require_relative "lib/teletime"
require_relative "lib/redis_teletime_store"
require_relative "lib/teletime_display"

Dotenv.load(".env")

bot_token = ENV["DISCORD_BOT_TOKEN"]
server_id = ENV["DISCORD_SERVER_ID"]

teletime = Teletime.new(RedisTeletimeStore.new)
teletime_display = TeletimeDisplay.new

bot = Discordrb::Bot.new(token: bot_token, intents: [:server_messages])

binding.pry

require "discordrb"
require "dotenv"
require_relative "lib/teletime"
require_relative "lib/redis_teletime_store"
require_relative "lib/teletime_display"

Dotenv.load(".env")

bot_token = ENV["DISCORD_BOT_TOKEN"]
server_id = ENV["DISCORD_SERVER_ID"]

teletime = Teletime.new(RedisTeletimeStore.new)
teletime_display = TeletimeDisplay.new

bot = Discordrb::Bot.new(token: bot_token, intents: [:server_messages])

bot.application_command(:teletime).subcommand(:show) do |event|
  overview = teletime.overview
  event.respond(content: teletime_display.format_teletime(overview))
end

bot.application_command(:teletime).subcommand(:add) do |event|
  branch = event.options["branch"]
  username = event.options["username"]
  teletime.add(branch, username)
  overview = teletime.overview
  event.respond(content: teletime_display.format_branch_updated(branch, username, overview))
end

bot.application_command(:teletime).subcommand(:set_hours) do |event|
  branch = event.options["branch"]
  hours = event.options["hours"]
  teletime.set_hours(branch, hours)
  overview = teletime.overview
  event.respond(content: teletime_display.format_branch_hours_updated(branch, overview))
end

bot.application_command(:teletime).subcommand(:clear_list) do |event|
  branch = event.options["branch"]
  teletime.clear_list(branch)
  overview = teletime.overview
  event.respond(content: teletime_display.format_branch_cleared(branch, overview))
end

bot.application_command(:teletime).subcommand(:manual_list) do |event|
  branch = event.options["branch"]
  usernames = event.options["usernames"]
  teletime.manual_list(branch, usernames)
  overview = teletime.overview
  event.respond(content: teletime_display.format_branch_manually_set(branch, overview))
end

bot.application_command(:teletime).subcommand(:done) do |event|
  branch = event.options["branch"]
  teletime.set_status(branch, "done")
  overview = teletime.overview
  event.respond(content: teletime_display.format_branch_status_update(branch, "done", overview))
end

bot.application_command(:teletime).subcommand(:on_hold) do |event|
  branch = event.options["branch"]
  teletime.set_status(branch, "on hold")
  overview = teletime.overview
  event.respond(content: teletime_display.format_branch_status_update(branch, "on hold", overview))
end

bot.application_command(:teletime).subcommand(:free) do |event|
  branch = event.options["branch"]
  teletime.set_status(branch, "free")
  overview = teletime.overview
  event.respond(content: teletime_display.format_branch_status_update(branch, "free", overview))
end

bot.run

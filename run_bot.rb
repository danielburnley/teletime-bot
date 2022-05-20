require "discordrb"
require "sinatra"
require "dotenv"
require "pry"
require_relative "lib/teletime"
require_relative "lib/redis_teletime_store"
require_relative "lib/teletime_display"
require_relative "lib/errors/branch_invalid_error"

Dotenv.load(".env")

bot_token = ENV["DISCORD_BOT_TOKEN"]
server_id = ENV["DISCORD_SERVER_ID"]

def with_teletime(event)
  redis_client = RedisTeletimeStore.new(event.server.id)
  teletime = Teletime.new(redis_client)

  current_teletime = teletime.overview
  if(current_teletime.keys.length == 0)
    teletime.reset
  end

  yield(teletime)
rescue BranchInvalidError => e
  event.respond(content: e.message, ephemeral: true)
ensure
  redis_client.close
end

teletime_display = TeletimeDisplay.new

bot = Discordrb::Bot.new(token: bot_token, intents: [:server_messages])

bot.application_command(:teletime).subcommand(:reset) do |event|
  unless(event.options["confirmation"] == "True")
    with_teletime(event) do |teletime|
      teletime.reset
      overview = teletime.overview
      event.respond(content: teletime_display.format_teletime_reset(overview))
    end
  end
end

bot.application_command(:teletime).subcommand(:show) do |event|
  with_teletime(event) do |teletime|
    overview = teletime.overview
    event.respond(content: teletime_display.format_teletime(overview))
  end
end

bot.application_command(:teletime).subcommand(:add) do |event|
  branch = event.options["branch"]
  username = event.options["username"]
  with_teletime(event) do |teletime|
    teletime.add(branch, username)
    overview = teletime.overview
    event.respond(content: teletime_display.format_branch_updated(branch, username, overview))
  end
end

bot.application_command(:teletime).subcommand(:set_hours) do |event|
  branch = event.options["branch"]
  hours = event.options["hours"]
  with_teletime(event) do |teletime|
    teletime.set_hours(branch, hours)
    overview = teletime.overview
    event.respond(content: teletime_display.format_branch_hours_updated(branch, overview))
  end
end

bot.application_command(:teletime).subcommand(:clear_list) do |event|
  branch = event.options["branch"]
  with_teletime(event) do |teletime|
    teletime.clear_list(branch)
    overview = teletime.overview
    event.respond(content: teletime_display.format_branch_cleared(branch, overview))
  end
end

bot.application_command(:teletime).subcommand(:manual_list) do |event|
  branch = event.options["branch"]
  usernames = event.options["usernames"]
  with_teletime(event) do |teletime|
    teletime.manual_list(branch, usernames)
    overview = teletime.overview
    event.respond(content: teletime_display.format_branch_manually_set(branch, overview))
  end
end

bot.application_command(:teletime).subcommand(:done) do |event|
  branch = event.options["branch"]
  with_teletime(event) do |teletime|
    teletime.set_status(branch, "done")
    overview = teletime.overview
    event.respond(content: teletime_display.format_branch_status_update(branch, "done", overview))
  end
end

bot.application_command(:teletime).subcommand(:on_hold) do |event|
  branch = event.options["branch"]
  with_teletime(event) do |teletime|
    teletime.set_status(branch, "on hold")
    overview = teletime.overview
    event.respond(content: teletime_display.format_branch_status_update(branch, "on hold", overview))
  end
end

bot.application_command(:teletime).subcommand(:free) do |event|
  branch = event.options["branch"]
  with_teletime(event) do |teletime|
    teletime.set_status(branch, "free")
    overview = teletime.overview
    event.respond(content: teletime_display.format_branch_status_update(branch, "free", overview))
  end
end

Thread.new do
  begin
    bot.run
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

set :port, ENV["PORT"]
get "/" do
  "ok"
end

require "discordrb"
require "dotenv"

Dotenv.load(".env")

bot_token = ENV["DISCORD_BOT_TOKEN"]
server_id = ENV["DISCORD_SERVER_ID"]

unless server_id
  raise StandardError.new("Please define a server ID")
end

bot = Discordrb::Bot.new(token: bot_token, intents: [:server_messages])

bot.register_application_command(:teletime, "Teletime", server_id: server_id) do |cmd|
  cmd.subcommand(:show, "Shows the current telephone")

  cmd.subcommand(:reset, "Resets current telephone") do |sub|
    sub.boolean("confirmation", "Please confirm you want to do this", required: true)
  end

  cmd.subcommand(:add, "Adds a user to the branch") do |sub|
    sub.string("branch", "The branch to add the person to", required: true)
    sub.string("username", "The username to add to the branch", required: true)
  end

  cmd.subcommand(:set_hours, "Sets the number of hours for the deadline") do |sub|
    sub.string("branch", "The branch to add the person to", required: true)
    sub.integer("hours", "The number of hours for the deadline", required: true)
  end

  cmd.subcommand(:clear_list, "Clears the branch") do |sub|
    sub.string("branch", "The branch to clear", required: true)
  end

  cmd.subcommand(:manual_list, "Manually set branch list") do |sub|
    sub.string("branch", "The branch to manually set", required: true)
    sub.string("usernames", "Comma separated usernames to add (e.g. Cat,Dog,Duck)", required: true)
  end

  cmd.subcommand(:done, "Marks the branch as done") do |sub|
    sub.string("branch", "The branch to mark as done", required: true)
  end

  cmd.subcommand(:on_hold, "Marks the branch as on hold") do |sub|
    sub.string("branch", "The branch to mark as on hold", required: true)
  end

  cmd.subcommand(:free, "Marks the branch as free") do |sub|
    sub.string("branch", "The branch to mark as free", required: true)
  end

  cmd.subcommand(:edit, "Edits the name of the last person in the branch") do |sub|
    sub.string("branch", "The branch to edit", required: true)
    sub.string("username", "The updated username", required: true)
  end
end



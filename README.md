# Teletime Bot

A bot for running telephone style art games :telephone: :paintbrush:

## Notes

This bot is currently only set up to run against a single server, if you want to run a copy of this bot you need to set it up yourself (See developer guide below)

## User guide

### Commands

- `/teletime reset <true/false>`
  - Resets the telephone, requires confirmation
- `/teletime show`
  - Shows the status of the current telephone
- `/teletime add <branch> <user>`
  - Adds a user to the end of the specified branch and sets the deadline to 72 hours
- `/teletime set_hours <branch> <hours>`
  - Sets the deadline to `<hours>` from now
- `/teletime clear_list <branch>`
  - Clears the branch names
- `/teletime manual_list <branch> <names>`
  - Manually sets the branch names to the names given
- `/teletime done <branch>`
  - Marks the branch as done
- `/teletime on_hold <branch>`
  - Marks the branch as on hold
- `/teletime free <branch>`
  - Marks the branch as free

## Developer guide

### Setting up your environment

**Prerequisites**

- Ruby version 3
- Redis
- (Optional) Docker with/without docker-compose

**Environment variables**

At the moment this bot is configured to run against a single server and uses environment variables to determine the server ID.

Create the file `.env` in the root of this folder containing the following:

```
DISCORD_BOT_TOKEN=<DISCORD_BOT_TOKEN>
DISCORD_SERVER_ID=<DISCORD_SERVER_ID>
REDIS_URL=<REDIS_URL>
```

### Running the bot

You can run this using either Docker (with or without docker-compose) or Ruby.

**Docker with docker-compose**

```
docker-compose up
```


require "redis"
require "json"

class RedisTeletimeStore
  def initialize(server_id)
    @redis = Redis.new(url: ENV["REDIS_URL"])
    @server_id = server_id
    @redis_key = "teletime_#{@server_id}"
  end

  def store(teletime)
    @redis.set @redis_key, teletime.to_json
  end

  def get
    begin
      JSON.parse(@redis.get(@redis_key), symbolize_names: true)
    rescue
      {}
    end
  end

  def close
    @redis.close
  end
end


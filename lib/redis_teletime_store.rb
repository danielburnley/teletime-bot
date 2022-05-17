require "redis"
require "json"

class RedisTeletimeStore
  def initialize
    @redis = Redis.new
  end

  def store(teletime)
    @redis.set "teletime", teletime.to_json
  end

  def get
    JSON.parse(@redis.get("teletime"), symbolize_names: true)
  end
end


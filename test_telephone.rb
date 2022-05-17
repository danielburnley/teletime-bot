require_relative "lib/teletime"
require_relative "lib/redis_teletime_store"

t = Teletime.new(RedisTeletimeStore.new)

def print_telephone(t)
  t.overview.each do |k, v|
    puts "#{k}: #{v[:names].join(",")}, deadline: <t:#{v[:deadline]}:R>"
  end
end

t.reset

puts "Start"

print_telephone(t)

t.add(:a, "first")
t.add(:a, "first2")
t.add(:a, "first3")
t.add(:b, "second")
t.add(:c, "third")
t.add(:d, "fourth")
t.add(:e, "fifth")

puts "First additions"

print_telephone(t)

puts "Clear A & Manual list B"

t.clear_list(:a)
t.manual_list(:b, "cat,dog,cow,squirrel")

print_telephone(t)

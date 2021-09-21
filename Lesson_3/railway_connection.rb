require_relative 'station'
require_relative 'route'
require_relative 'train'

#фаил для проверки работы методов

kazanskaya = Station.new("Казанская")
rostow = Station.new("Ростов")
krasnodar = Station.new("Краснодар")
sochi = Station.new("Сочи")


moscow_sochi = Route.new(kazanskaya, sochi)
 moscow_sochi.add_station(rostow)
 moscow_sochi.add_station(krasnodar)
 moscow_sochi.add_station(sochi)
print moscow_sochi.add_station(sochi)

puts 
moscow_sochi.all_station.each {|station| puts station.name}
puts
train_1 = Train.new("555", "passenger", 3)
train_2 = Train.new("777", "cargo", 4)
train_3 = Train.new("999", "passenger", 5)

puts "Arrival #{kazanskaya.arrival(train_1)[0].number }"
kazanskaya.arrival(train_2)
kazanskaya.arrival(train_3)#.each {|train| puts "Arrival train N #{train.number}, type: #{train.type}"}
puts
kazanskaya.trains_at_station.each { |train| puts train.number }
puts
kazanskaya.trains_by_type("cargo").each {|train| puts train.number}
kazanskaya.trains_by_type("passenger").each { |train| puts "Passenger: #{train.number}" }
puts
puts kazanskaya.count_trains_by_type("cargo")
puts kazanskaya.count_trains_by_type("passenger")
puts
puts train_1.speed
puts train_1.speed = 50
puts train_1.add_wagons
train_1.speed = 0
puts train_1.add_wagons
puts

train_1.set_route(moscow_sochi)

moscow_sochi.delete_station(sochi)
puts train_1.go_ahead.name
puts


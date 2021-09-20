require_relative 'station'
require_relative 'route'
require_relative 'train'

#фаил для проверки работы методов

kazanskaya = Station.new("Казанская")
rostow = Station.new("Ростов")
krasnodar = Station.new("Краснодар")
sochi = Station.new("Сочи")


moscow_sochi = Route.new(kazanskaya, sochi)
puts moscow_sochi.add_station(rostow)
puts moscow_sochi.add_station(krasnodar)
puts moscow_sochi.add_station(sochi)

puts 
puts moscow_sochi.show_stations
puts
train_1 = Train.new("555", "passenger", 3)
train_2 = Train.new("777", "cargo", 4)
train_3 = Train.new("999", "passenger", 5)

puts kazanskaya.arrival(train_1)
puts kazanskaya.arrival(train_2)
puts kazanskaya.arrival(train_3)
puts
puts kazanskaya.show_all_trains
puts
print kazanskaya.trains_by_type("cargo")
print kazanskaya.trains_by_type("passenger")
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

puts train_1.set_route(moscow_sochi)
puts
puts train_1.go_ahead
puts
puts train_1.go_back
puts train_1.go_back
puts train_1.go_ahead
puts train_1.go_ahead
puts train_1.go_ahead
puts train_1.go_ahead
puts train_1.next_station
puts train_1.previous_station

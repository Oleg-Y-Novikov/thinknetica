require_relative 'station'
require_relative 'route'
require_relative 'train'



kazanskaya = Station.new("Казанская")
rostow = Station.new("Ростов")
krasnodar = Station.new("Краснодар")
sochi = Station.new("Сочи")


moscow_sochi = Route.new(kazanskaya, sochi)
moscow_sochi.add_station(rostow)
moscow_sochi.add_station(krasnodar)
moscow_sochi.add_station(sochi)

puts 
moscow_sochi.show_stations
puts
train_1 = Train.new("555", "passenger", 3)
train_2 = Train.new("777", "cargo", 4)
train_3 = Train.new("999", "passenger", 5)

kazanskaya.arrival(train_1)
kazanskaya.arrival(train_2)
puts
kazanskaya.show_all_trains
puts
kazanskaya.show_type_train
puts

puts train_1.speed
puts train_1.speed = 50
train_1.add_wagons
train_1.speed = 0
train_1.add_wagons
puts

train_1.set_route(moscow_sochi)
puts
train_1.station_list
puts
train_1.next_station

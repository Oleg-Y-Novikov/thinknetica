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


train_1 = Train.new("555", "passenger", 3)
train_2 = Train.new("777", "cargo", 4)
train_3 = Train.new("999", "passenger", 5)

train_1.set_route(moscow_sochi)
puts train_1.current_station.name
train_1.go_ahead
puts train_1.current_station.name
puts train_1.next_station.name
puts train_1.previous_station.name

puts moscow_sochi.all_station
print kazanskaya.trains_at_station
puts
puts rostow.trains_at_station


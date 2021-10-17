require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'wagon'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'rail_road'

def create_object
  stations = %w[Moscow Rostov Krasnodar Novorossiysk Sochi Sankt-Peterburg Omsk Novosibirsk]
  passenger_trains = ["PAS-11","PAS-22"]
  cargo_trains = ["CAR-55", "CAR-75"]
  passenger_wagons = [["cupe-30", 30], ["cupe-36", 36], ["cupe-32", 32], ["plackart-54", 54], ["plackart-50", 50]]
  cargo_wagons = [["car-100", 100], ["car-130", 130], ["car-50", 50], ["car-70", 70], ["car-90", 90]]

  stations.map { |name| Station.new(name) }
  Route.new(Station.get_station("Moscow"), Station.get_station("Sochi"))
  Route.all_routes["Moscow-Sochi"].add_station(Station.get_station("Rostov"))
  Route.all_routes["Moscow-Sochi"].add_station(Station.get_station("Krasnodar"))
  Route.all_routes["Moscow-Sochi"].add_station(Station.get_station("Novorossiysk"))

  Route.new(Station.get_station("Sankt-Peterburg"), Station.get_station("Novosibirsk"))
  Route.all_routes["Sankt-Peterburg-Novosibirsk"].add_station(Station.get_station("Omsk"))

  passenger_trains.map { |name| PassengerTrain.new(name) }
  cargo_trains.map { |name| CargoTrain.new(name) }

  passenger_wagons.map { |arr| PassengerWagon.new("passenger", arr[0], arr[1]) }
  cargo_wagons.map { |arr| CargoWagon.new("cargo", arr[0], arr[1]) }

  Train.get_train("PAS-11").set_route(Route.all_routes["Moscow-Sochi"])
  Train.get_train("PAS-22").set_route(Route.all_routes["Sankt-Peterburg-Novosibirsk"])
  Train.get_train("CAR-55").set_route(Route.all_routes["Moscow-Sochi"])
  Train.get_train("CAR-75").set_route(Route.all_routes["Sankt-Peterburg-Novosibirsk"])

  Train.get_train("PAS-11").add_wagon(Wagon.get_wagon("cupe-30"))
  Train.get_train("PAS-11").add_wagon(Wagon.get_wagon("cupe-36"))
  Train.get_train("PAS-11").add_wagon(Wagon.get_wagon("plackart-54"))
  Train.get_train("PAS-22").add_wagon(Wagon.get_wagon("cupe-32"))
  Train.get_train("PAS-22").add_wagon(Wagon.get_wagon("plackart-50"))

  Train.get_train("CAR-55").add_wagon(Wagon.get_wagon("car-100"))
  Train.get_train("CAR-55").add_wagon(Wagon.get_wagon("car-130"))
  Train.get_train("CAR-55").add_wagon(Wagon.get_wagon("car-50"))
  Train.get_train("CAR-75").add_wagon(Wagon.get_wagon("car-70"))
  Train.get_train("CAR-75").add_wagon(Wagon.get_wagon("car-90"))
  Wagon.all_wagons.clear
end
create_object
RailRoad.run

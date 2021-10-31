# frozen_string_literal: true

require 'singleton'
require_relative 'validation'
require_relative 'accessors'
require_relative 'railroad'
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
require_relative 'user_interface'
=begin
def create_object(railroad)
  stations = %w[Moscow Rostov Krasnodar Novorossiysk Sochi Sankt-Peterburg Omsk Novosibirsk]
  passenger_trains = %w[PAS-11 PAS-22]
  cargo_trains = %w[CAR-55 CAR-75]
  passenger_wagons = [
    ["cupe-30", 30], ["cupe-36", 36], ["cupe-32", 32],
    ["plackart-54", 54], ["plackart-50", 50]
  ]
  cargo_wagons = [
    ["car-100", 100], ["car-130", 130], ["car-50", 50],
    ["car-70", 70], ["car-90", 90]
  ]

  stations.map { |name| Station.new(name) }
  Route.new(railroad.get_station("Moscow"), railroad.get_station("Sochi"))
  railroad.routes["Moscow-Sochi"].add_station(railroad.get_station("Rostov"))
  railroad.routes["Moscow-Sochi"].add_station(railroad.get_station("Krasnodar"))
  railroad.routes["Moscow-Sochi"].add_station(railroad.get_station("Novorossiysk"))

  Route.new(railroad.get_station("Sankt-Peterburg"), railroad.get_station("Novosibirsk"))
  railroad.routes["Sankt-Peterburg-Novosibirsk"].add_station(railroad.get_station("Omsk"))

  passenger_trains.map { |name| PassengerTrain.new(name) }
  cargo_trains.map { |name| CargoTrain.new(name) }

  passenger_wagons.map { |arr| PassengerWagon.new("passenger", arr[0], arr[1]) }
  cargo_wagons.map { |arr| CargoWagon.new("cargo", arr[0], arr[1]) }

  railroad.get_train("PAS-11").assign_route(railroad.routes["Moscow-Sochi"])
  railroad.get_train("PAS-22").assign_route(railroad.routes["Sankt-Peterburg-Novosibirsk"])
  railroad.get_train("CAR-55").assign_route(railroad.routes["Moscow-Sochi"])
  railroad.get_train("CAR-75").assign_route(railroad.routes["Sankt-Peterburg-Novosibirsk"])

  railroad.get_train("PAS-11").add_wagon(railroad.get_wagon("cupe-30"))
  railroad.get_train("PAS-11").add_wagon(railroad.get_wagon("cupe-36"))
  railroad.get_train("PAS-11").add_wagon(railroad.get_wagon("plackart-54"))
  railroad.get_train("PAS-22").add_wagon(railroad.get_wagon("cupe-32"))
  railroad.get_train("PAS-22").add_wagon(railroad.get_wagon("plackart-50"))

  railroad.get_train("CAR-55").add_wagon(railroad.get_wagon("car-100"))
  railroad.get_train("CAR-55").add_wagon(railroad.get_wagon("car-130"))
  railroad.get_train("CAR-55").add_wagon(railroad.get_wagon("car-50"))
  railroad.get_train("CAR-75").add_wagon(railroad.get_wagon("car-70"))
  railroad.get_train("CAR-75").add_wagon(railroad.get_wagon("car-90"))
  railroad.wagons.clear
end

create_object(Railroad.instance)
UserInterface.run

=end

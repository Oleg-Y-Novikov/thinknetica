# frozen_string_literal: true

class Railroad
  include Singleton

  attr_accessor :trains, :wagons, :stations, :routes

  def initialize
    @trains = []
    @wagons = []
    @stations = []
    @routes = {}
  end

  def get_wagon(number)
    @wagons.find { |wagon| wagon.number == number }
  end

  def get_train(number)
    @trains.find { |train| train.number == number }
  end

  def get_station(name)
    @stations.find { |station| station.name == name }
  end
end

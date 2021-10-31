# frozen_string_literal: true

class Route
  include InstanceCounter
  include Validation
  include Accessors

  validate :starting_station, :presence
  validate :terminal_station, :presence
  validate :starting_station, :type_object, Station
  validate :terminal_station, :type_object, Station
  validate :route, :includes
  validate :route, :equal

  attr_reader :all_station, :starting_station, :terminal_station

  def initialize(starting_station, terminal_station)
    @starting_station = starting_station
    @terminal_station = terminal_station
    validate!
    Railroad.instance.routes["#{starting_station.name}-#{terminal_station.name}"] = self
    @all_station = []
    @all_station.push(starting_station, terminal_station)
    register_instance
  end

  def add_station(station)
    return if @all_station.include?(station)

    @all_station.insert(-2, station)
  end

  def delete_station(station)
    return if station == @all_station.first || station == @all_station.last

    @all_station.delete(station)
  end
end

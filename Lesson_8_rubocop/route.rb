# frozen_string_literal: true

class Route
  include InstanceCounter

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

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def add_station(station)
    return if @all_station.include?(station)

    @all_station.insert(-2, station)
  end

  def delete_station(station)
    return if station == @all_station.first || station == @all_station.last

    @all_station.delete(station)
  end

  protected

  def includes?
    Railroad.instance.routes.key?("#{starting_station.name}-#{terminal_station.name}")
  end

  def validate!
    raise "Такой маршрут уже существует" if includes?
    raise "Начальная и конечная станция не должны совпадать" if starting_station == terminal_station
  end
end

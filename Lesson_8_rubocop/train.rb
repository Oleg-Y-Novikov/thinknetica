# frozen_string_literal: true

class Train
  include Manufacturer
  include InstanceCounter

  NUMBER_FORMAT = /^[a-zа-я\d]{3}-?[a-zа-я\d]{2}$/i.freeze
  attr_accessor :speed
  attr_reader :number, :type, :current_station, :route, :wagons

  def initialize(number)
    @type = "no type"
    @number = number
    validate!
    @wagons = []
    @speed = 0
    Railroad.instance.trains << self
    register_instance
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def each_wagons(&block)
    @wagons.each(&block) if block_given?
  end

  def train_info
    "Поезд № #{number}, тип - #{type}, вагонов в составе - #{amount_wagons}"
  end

  def get_wagon(number)
    @wagons.find { |w| w.number == number }
  end

  def amount_wagons
    @wagons.size
  end

  def add_wagon(wagon)
    add_wagon!(wagon)
  end

  def remove_wagon
    return if amount_wagons.zero?

    @wagons.pop if train_stopped?
  end

  def assign_route(route)
    @current_station = route.all_station.first
    @current_station.arrival(self)
    @route = route
  end

  def go_ahead
    return unless next_station

    @current_station.departure(self)
    @current_station = next_station
    @current_station.arrival(self)
    @current_station
  end

  def go_back
    return unless previous_station

    @current_station.departure(self)
    @current_station = previous_station
    @current_station.arrival(self)
    @current_station
  end

  def next_station
    return unless @route

    return unless @current_station != @route.all_station.last

    @route.all_station[@route.all_station.index(@current_station) + 1]
  end

  def previous_station
    return unless @route

    return unless @current_station != @route.all_station.first

    @route.all_station[@route.all_station.index(@current_station) - 1]
  end

  protected

  def train_stopped?
    @speed.zero?
  end

  def correct_type_wagon?(wagon)
    wagon.type == type
  end

  def add_wagon!(wagon)
    @wagons << wagon if train_stopped? && correct_type_wagon?(wagon)
  end

  def validate!
    raise "Номер поезда не может быть пустым" if number.empty?
    raise "Номер поезда имеет недопустимый формат" if number !~ NUMBER_FORMAT
    raise "Поезд с таким номером уже существует" if Railroad.instance.get_train(number)
  end
end

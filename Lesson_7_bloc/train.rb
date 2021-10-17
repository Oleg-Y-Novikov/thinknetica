class Train
  include Manufacturer
  include InstanceCounter

  NUMBER_FORMAT = /^[a-zа-я\d]{3}-?[a-zа-я\d]{2}$/i
  attr_accessor :speed
  attr_reader :number, :type, :current_station, :route, :wagons
  
  @@trains = []

  class << self
    def all_trains
      @@trains
    end

    def get_train(number)
      @@trains.find { |train| train.number == number }
    end
  end

  def initialize(number)
    @type = "no type"
    @number = number
    validate!
    @wagons = []
    @speed = 0
    @@trains << self
    register_instance
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def train_wagons_info(block)
    block.call(@wagons)
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
    return if amount_wagons == 0
    
    @wagons.pop if train_stopped?
  end

  def set_route(route)
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

    @route.all_station[@route.all_station.index(@current_station) + 1] if @current_station != @route.all_station.last
  end

  def previous_station
    return unless @route
    
    @route.all_station[@route.all_station.index(@current_station) - 1] if @current_station != @route.all_station.first
  end

  protected

  def train_stopped?
    @speed.zero?
  end

  def correct_type_wagon?(wagon)
    wagon.type == self.type
  end

  def add_wagon!(wagon)
    @wagons << wagon if train_stopped? && correct_type_wagon?(wagon)
  end

  def validate!
    raise "Номер поезда не может быть пустым" if number.empty?
    raise "Номер поезда имеет недопустимый формат" if number !~ NUMBER_FORMAT
    raise "Поезд с таким номером уже существует" if Train.get_train(number)
  end
end

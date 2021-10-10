=begin
  Класс Station (Станция):
  Имеет название, которое указывается при ее создании
  Может принимать поезда (по одному за раз)
  Может возвращать список всех поездов на станции, находящиеся в текущий момент
  Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
  Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
=end

class Station
  include InstanceCounter
  
  @@stations = []
  NAME_FORMAT = /^[a-zа-я']{1,20}-?.[a-zа-я\d]{1,20}$/i

  class << self
    def all_stations
      @@stations
    end

    def get_station(name)
      @@stations.find { |station| station.name == name }
    end

    def valid?(name)
      validate!(name)
      true
    rescue
      false
    end

    protected

    def validate!(name)
      raise "Название станции не можнет быть пустым" if name.empty?
      raise "Название станции имеет недопустимый формат" if name !~ NAME_FORMAT
      raise "Название станции должено быть не более 20 символов" if name.length > 20
      raise "Станция #{name} уже существует" if get_station(name)
    end
  end

  attr_reader :name, :trains_at_station

  def initialize(name)
    self.class.send :validate!, name
    @name = name
    @trains_at_station = []
    @@stations << self
    register_instance
  end

  def arrival(train)
    return if @trains_at_station.include?(train)
    
    @trains_at_station << train
  end

  def departure(train)
    @trains_at_station.delete(train) if @trains_at_station.include?(train)
  end

  def trains_by_type(type)
    @trains_at_station.select { |train| train.type == type }
  end

  def count_trains_by_type(type)
    @trains_at_station.count { |train| train.type == type }
  end

end

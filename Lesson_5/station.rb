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
  
  @@station = []

  def self.all
    @@station
  end

  attr_reader :name, :trains_at_station

  def initialize(name)
    @name = name
    @trains_at_station = []
    @@station << self
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

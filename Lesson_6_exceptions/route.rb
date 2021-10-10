=begin
  Класс Route (Маршрут):
  Имеет начальную и конечную станцию, а также список промежуточных станций. 
  Начальная и конечная станции указываются при создании маршрута, а промежуточные могут добавляться между ними.
  Может добавлять промежуточную станцию в список
  Может удалять промежуточную станцию из списка
  Может выводить список всех станций по-порядку от начальной до конечной
=end

class Route
  include InstanceCounter
  @@routes = {}

  class << self
    def all_routes
      @@routes
    end
    
    def valid?(starting_station, terminal_station)
      validate!(starting_station, terminal_station)
      true
    rescue
      false
    end

    protected

    def validate!(starting_station, terminal_station)
      raise "Такой маршрут уже существует" if @@routes.has_key?("#{starting_station.name}-#{terminal_station.name}")
      raise "Начальная и конечная станция не должны совпадать" if starting_station.name == terminal_station.name
    end
  end

  attr_reader :all_station
  
  def initialize(starting_station, terminal_station)
    self.class.send :validate!, starting_station, terminal_station
    @@routes["#{starting_station.name}-#{terminal_station.name}"] = self
    @all_station = []
    @all_station.push(starting_station, terminal_station)
    register_instance
  end

  def add_station(station)
    return if @all_station.include?(station)
    
    @all_station.insert(-2, station)
  end

  def delete_station(station)
    return unless !(station == @all_station.first || station == @all_station.last) && @all_station.include?(station)
    
    @all_station.delete(station)
  end
end

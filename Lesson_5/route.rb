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
  @count_instances = 0

  attr_reader :all_station
  
  def initialize(starting_station, terminal_station)
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

=begin
Класс Route (Маршрут):
Имеет начальную и конечную станцию, а также список промежуточных станций. Начальная и конечная станции указываются при создании маршрута,
а промежуточные могут добавляться между ними.
Может добавлять промежуточную станцию в список
Может удалять промежуточную станцию из списка
Может выводить список всех станций по-порядку от начальной до конечной
=end

class Route

  attr_accessor :intermediate_stations

  def initialize(starting_station, terminal_station)
    @starting_station = starting_station
    @terminal_station = terminal_station
    @intermediate_stations = []
  end

  def all_station
    puts @starting_station
    @intermediate_stations.each { |station| puts station }
    puts @terminal_station
  end 
end

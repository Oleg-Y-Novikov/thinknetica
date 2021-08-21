=begin
Класс Station (Станция):
Имеет название, которое указывается при ее создании
Может принимать поезда (по одному за раз)
Может возвращать список всех поездов на станции, находящиеся в текущий момент
Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
=end

class Station
  
  attr_reader :station_name

  def initialize(station_name)
    @station_name = station_name
    @all_trains = []
  end

  def take_train(train)
    @all_trains << train
  end

  def station_list
    @all_trains.each { |train| puts "Поезд № #{train.number}, тип - #{train.type}" }
    puts "Общее колличество поездов на станции #{@station_name} - #{@all_trains.size}"
  end

  def train_types
    pass, cargo = 0, 0
    @all_trains.each { |train| train.type == 'passenger' ? pass += 1 : cargo += 1 }
    puts "На станции #{@station_name}:\n - пассажирских поездов: #{pass};\n - грузовых поездов: #{cargo}."
	end

  def send_train(train)
    if @all_trains.include?(train)
      @all_trains.delete(train)
    else
      puts "this train is not at the station!"
    end
  end
end

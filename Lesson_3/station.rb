=begin
  Класс Station (Станция):
  Имеет название, которое указывается при ее создании
  Может принимать поезда (по одному за раз)
  Может возвращать список всех поездов на станции, находящиеся в текущий момент
  Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
  Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
=end

class Station

  attr_reader :name

  def initialize(name)
    @name = name
    @trains_at_station = []
  end

  def arrival(train)
    @trains_at_station << train
    "На станцию прибыл поезд №#{train.number}. Время прибытия: #{Time.now.strftime("%Y-%m-%d")} #{Time.now.strftime("%H:%M")}"
  end

  def show_all_trains
    @trains_at_station.map { |train| "Номер: #{train.number}, тип: #{train.type}" }
  end

  def departure(train)
    if @trains_at_station.include?(train)
      @trains_at_station.delete(train)
      "Со станции отправляется поезд #{train.number}. Время отправления: #{Time.now.strftime("%Y-%m-%d")} #{Time.now.strftime("%H:%M")}"
    else
      "Такого поезда нет на станции"
    end
  end

=begin
Давай заведем отдельный метод trains_by_type(type), который будет возвращать массив поездов определенного типа. 
И метод count_trains_by_type(type), который будет их считать. Тогда мы уйдем от ввода-вывода к полноценной работе с данными
=end
  def trains_by_type(type)
    @trains_at_station.select { |train| train.type == "#{type}" }
  end

  def count_trains_by_type(type)
    @trains_at_station.count { |train| train.type == "#{type}" }
  end

end

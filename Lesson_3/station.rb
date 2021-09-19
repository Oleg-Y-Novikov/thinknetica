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
    puts "На станцию прибыл поезд №#{train.number}. Время прибытия: #{Time.now.strftime("%Y-%m-%d")} #{Time.now.strftime("%H:%M")}"
    @trains_at_station << train
  end

  def show_all_trains
    puts "Всего поездов на станции: #{@trains_at_station.size}"
    @trains_at_station.each { |train| puts train.number }
  end

  def show_type_train
    cargo = @trains_at_station.select { |train| train.type == "cargo" }
    puts "Грузовые: #{cargo.size}"
    cargo.each { |train| puts "Номер: #{train.number}. Тип: #{train.type}"}
    passenger = @trains_at_station.select { |train| train.type == "passenger" }
    puts "Пассажирские: #{cargo.size}"
    passenger.each { |train| puts "Номер: #{train.number}. Тип: #{train.type}"}
  end

  def departure(train)
    if @trains_at_station.include?(train)
      puts "Со станции отправляется поезд #{train.number}. Время отправления: #{Time.now.strftime("%Y-%m-%d")} #{Time.now.strftime("%H:%M")}"
      @trains_at_station.delete(train)
    else
      puts "Такого поезда нет на станции"
    end
  end
end

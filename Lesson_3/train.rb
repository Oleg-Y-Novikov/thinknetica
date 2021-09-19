=begin
  Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
  Может набирать скорость
  Может возвращать текущую скорость
  Может тормозить (сбрасывать скорость до нуля)
  Может возвращать количество вагонов
  Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов). 
  Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
  Может принимать маршрут следования (объект класса Route). 
  При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
  Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
  Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
=end

class Train

  attr_accessor :speed
  attr_reader :number, :type, :wagons

  def initialize(number, type, wagons)
    @number = number
    @type = type
    @wagons = wagons
    @speed = 0
    @route = nil
    @current_station = nil
  end

  def add_wagons
    if @speed == 0
      @wagons += 1
      puts "Вагон прицеплен, общее колличество вагонов - #{@wagons}"
    else
      puts "Остановите поезд! Текущая скорость - #{@speed} км/ч"
    end
  end

  def remove_wagons
    return puts "Нет прицепленных вагонов!" if @wagons == 0
    if @speed == 0
      @wagons -= 1
      puts "Вагон отцеплен, общее колличество вагонов - #{@wagons}"
    else
      puts "Остановите поезд! Текущая скорость - #{@speed} км/ч"
    end
  end

  def set_route(route)
    @current_station = route.starting_station
    @route = route.all_station
    puts "Поезд № #{@number} установлен на станцию #{@current_station.name}"
  end

  def next_station
    puts "Введите: \"next\" - следующая станция, \"previous\" - предыдущая станция, \"stop\" - выйти"
    loop do
      direction = gets.chomp.downcase
      break if direction == "stop"
      case direction
        when "next"
          return puts "Вы на конечной станции: \"#{@current_station.name}\", покиньте вагон." if @current_station == @route.last
          @current_station = @route[@route.index(@current_station) + 1]
          puts "Поезд прибыл на следующую станцию \"#{@current_station.name}\""
        when "previous"
          return puts "Вы на начальной станции: \"#{@current_station.name}\", перемещение на предыдущую невозможно." if @current_station == @route.first
          @current_station = @route[@route.index(@current_station) - 1]
          puts "Поезд прибыл на предыдущую станцию \"#{@current_station.name}\""
        else
          puts "проверьте правильность ввода действия"
      end
    end
  end

  def station_list
    @current_station == @route.last ? next_station = "Депо" : next_station = @route[@route.index(@current_station) + 1]
    @current_station == @route.first ? previous_station = @current_station.name : previous_station = @route[@route.index(@current_station) - 1]
    puts "Текущая станция: #{@current_station.name}. Следующая станция: #{next_station.name}. Предыдущая станция: #{previous_station}"
  end

end

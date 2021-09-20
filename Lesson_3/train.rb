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
  attr_reader :number, :type, :wagons, :current_station

  def initialize(number, type, wagons)
    @number = number
    @type = type
    @wagons = wagons
    @speed = 0
    @route
    @current_station
  end

  def add_wagons
    if @speed == 0
      @wagons += 1
      "Вагон прицеплен, общее колличество вагонов - #{@wagons}"
    else
      "Остановите поезд! Текущая скорость - #{@speed} км/ч"
    end
  end

  def remove_wagons
    return "Нет прицепленных вагонов!" if @wagons == 0
    if @speed == 0
      @wagons -= 1
      "Вагон отцеплен, общее колличество вагонов - #{@wagons}"
    else
      "Остановите поезд! Текущая скорость - #{@speed} км/ч"
    end
  end

  def set_route(route)
    @current_station = route.all_station.first
    @route = route.all_station
    "Поезд № #{@number} установлен на станцию \"#{@current_station.name}\""
  end

#Ой. Давай откажемся тут от ввода-вывода. Иначе как-то много обязанностей.
#Кроме того, стоит сделать два отдельных метода - для движения вперед и движения назад

  def go_ahead
    return "Вы на конечной станции: \"#{@current_station.name}\", покиньте вагон." if @current_station == @route.last
    @current_station = next_station
    "Поезд прибыл на следующую станцию \"#{@current_station.name}\""
  end

  def go_back
    return "Вы на начальной станции: \"#{@current_station.name}\", перемещение на предыдущую невозможно." if @current_station == @route.first
    @current_station = previous_station
    "Поезд прибыл на предыдущую станцию \"#{@current_station.name}\""
  end

  #нужны отдельные методы для предыдущей и следующей станций, и они должны возвращать объекты. Тогда их можно будет использовать в методах движения
  def next_station
    @current_station == @route.last ? @current_station : @route[@route.index(@current_station) + 1]
  end

  def previous_station
    @current_station == @route.first ? @current_station : @route[@route.index(@current_station) - 1]
  end

end

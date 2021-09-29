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
  attr_reader :number, :type, :current_station, :route

  def initialize(number)
    @type = "no type"
    @number = number
    @wagons = []
    @speed = 0
  end

  def amount_wagons
    @wagons.size
  end

  def add_wagon(wagon)
    add_wagon!(wagon)
  end

  def remove_wagon
    return if amount_wagons == 0
    
    @wagons.pop if train_stopped?
  end

  def set_route(route)
    @current_station = route.all_station.first
    @current_station.arrival(self)
    @route = route
  end

  def go_ahead
    return unless next_station 
    
    @current_station.departure(self)
    @current_station = next_station
    @current_station.arrival(self)
    @current_station
  end

  def go_back
    return unless previous_station
    
    @current_station.departure(self)
    @current_station = previous_station
    @current_station.arrival(self)
    @current_station
  end

  def next_station
    return unless @route

    @route.all_station[@route.all_station.index(@current_station) + 1] if @current_station != @route.all_station.last
  end

  def previous_station
    return unless @route
    
    @route.all_station[@route.all_station.index(@current_station) - 1] if @current_station != @route.all_station.first
  end

  # методы не являются интерфейсом класса, служат для проверки и построения верной логики в программе
  protected

  def train_stopped?
    @speed.zero?
  end

  def correct_type_wagon?(wagon)
    wagon.type == self.type
  end

  def add_wagon!(wagon)
    @wagons << wagon if train_stopped? && correct_type_wagon?(wagon)
  end

end

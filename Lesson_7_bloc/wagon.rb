class Wagon
  include Manufacturer
  @@wagons = []
  
  class << self
    def all_wagons
      @@wagons
    end

    def get_wagon(number)
      @@wagons.find { |wagon| wagon.number == number }
    end 
  end

  attr_reader :type, :number

  def initialize(type, number)
    @type = type
    @number = number
    validate!
    @@wagons << self
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  protected

  def validate!
    raise "Тип вагона не может быть пустым" if type.empty?
    raise "Тип вагона должен быть не более 10 символов" if type.length > 10
    raise "Тип вагона имеет недопустимый формат" if type !~ type_format
    raise "Вагон с таким номером уже существует" if Wagon.get_wagon(number)
    raise "Номер вагона не может быть пустым" if number.empty?
  end

  def type_format
    /^[a-z]{,10}$/
  end
end

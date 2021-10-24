# frozen_string_literal: true

class Wagon
  include Manufacturer

  attr_reader :type, :number

  def initialize(type, number)
    @type = type
    @number = number
    validate!
    Railroad.instance.wagons << self
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  protected

  def validate!
    raise "Тип вагона не может быть пустым" if type.empty?
    raise "Тип вагона имеет недопустимый формат" if type !~ type_format
    raise "Вагон с таким номером уже существует" if Railroad.instance.get_wagon(number)
    raise "Номер вагона не может быть пустым" if number.empty?
  end

  def type_format
    /^[a-z]{,10}$/
  end
end

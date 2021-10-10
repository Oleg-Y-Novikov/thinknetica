class Wagon
  include Manufacturer
  @@wagons = []
  
  class << self
    def all_wagons
      @@wagons
    end

    def get_wagon(type)
      @@wagons.find { |wagon| wagon.type == type }
    end 
    
    def valid?(type)
      validate!(type)
      true
    rescue
      false
    end

    protected

    def validate!(type)
      raise "Тип вагона не может быть пустым" if type.empty?
      raise "Тип вагона должен быть не более 10 символов" if type.length > 10
      raise "Тип вагона имеет недопустимый формат" if type !~ type_format
    end

    def type_format
      /^[a-z]{,10}$/
    end
  end

  attr_reader :type

  def initialize(type)
    self.class.send :validate!, type
    @type = type
    @@wagons << self
  end

end

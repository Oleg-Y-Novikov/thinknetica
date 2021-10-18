class PassengerWagon < Wagon

  attr_reader :occupied_seats, :number_of_seats

  def initialize(type, number, number_of_seats)
    @number_of_seats = number_of_seats
    @occupied_seats = 0
    super(type, number)
  end

  def take_a_seat
    if @occupied_seats < @number_of_seats
      @occupied_seats += 1
    else
      raise "Извините, все места заняты!"
    end
  end

  def vacant_seats
    @number_of_seats - @occupied_seats
  end

  def wagon_info
    "   Вагон № #{self.number}, тип - #{self.type}, свободных мест - #{self.vacant_seats}, занятых мест - #{self.occupied_seats}"
  end

  protected

  def type_format
    /^passenger$/
  end

  def validate!
    super
    raise "Колличество мест не может равняться нулю" if number_of_seats.zero?
    raise "Колличество мест не может быть больше 54" if number_of_seats > 54
  end
end

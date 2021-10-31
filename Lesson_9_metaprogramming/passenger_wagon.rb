# frozen_string_literal: true

class PassengerWagon < Wagon
  TYPE_FORMAT = /^passenger$/.freeze

  validate :type, :format, TYPE_FORMAT

  attr_reader :occupied_seats, :number_of_seats

  def initialize(type, number, number_of_seats)
    @number_of_seats = number_of_seats
    @occupied_seats = 0
    super(type, number)
  end

  def take_a_seat
    raise "Извините, все места заняты!" unless @occupied_seats < @number_of_seats

    @occupied_seats += 1
  end

  def vacant_seats
    @number_of_seats - @occupied_seats
  end

  def wagon_info
    "   Вагон №#{number}, тип-#{type}, свободных мест-#{vacant_seats}, занятых-#{occupied_seats}"
  end

  protected

  def validate!
    super
    raise "Колличество мест не может равняться нулю" if number_of_seats.zero?
    raise "Колличество мест не может быть больше 54" if number_of_seats > 54
  end
end

# frozen_string_literal: true

class CargoWagon < Wagon
  TYPE_FORMAT = /^cargo$/.freeze

  validate :type, :format, TYPE_FORMAT

  attr_reader :occupied_volume, :total_volume

  def initialize(type, number, total_volume)
    @total_volume = total_volume.to_i
    @occupied_volume = 0
    super(type, number)
  end

  def upload(amount)
    raise "Недостаточно места" unless @occupied_volume < @total_volume && amount <= free_volume

    @occupied_volume += amount
  end

  def free_volume
    @total_volume - @occupied_volume
  end

  def wagon_info
    "   Вагон №#{number}, тип-#{type}, свободно-#{free_volume}м3, занято-#{occupied_volume}м3"
  end

  protected

  def validate!
    super
    raise "Общий объем не может равняться нулю" if total_volume.zero?
    raise "Внутренний объем не должен превышать 138м3" if total_volume > 138
  end
end

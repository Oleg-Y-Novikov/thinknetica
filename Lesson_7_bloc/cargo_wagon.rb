class CargoWagon < Wagon

  attr_reader :occupied_volume, :total_volume

  def initialize(type, number, total_volume)
    @total_volume = total_volume
    @occupied_volume = 0
    super(type, number)
  end

  def upload(amount)
    if @occupied_volume < @total_volume && amount <= free_volume
      @occupied_volume += amount
    else
      raise "Недостаточно места, доступный объем - #{free_volume}м3"
    end
  end

  def free_volume
    @total_volume - @occupied_volume
  end

  def wagon_info
    "   Вагон № #{self.number}, тип - #{self.type}, свободный объем - #{self.free_volume}м3, занятый объем - #{self.occupied_volume}м3"
  end

  protected

  def type_format
    /^cargo$/
  end

  def validate!
    super
    raise "Общий объем не может равняться нулю" if total_volume.zero?
    raise "Внутренний объем не должен превышать 138м3" if total_volume > 138
  end
end

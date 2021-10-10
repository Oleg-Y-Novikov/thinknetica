class CargoWagon < Wagon
  protected
  def self.type_format
    /^cargo$/
  end
end

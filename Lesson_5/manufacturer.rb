module Manufacturer
 
  attr_reader :manufacturer

  def set_manufacturer(name)
    @manufacturer = name if self.manufacturer.nil?
  end
end

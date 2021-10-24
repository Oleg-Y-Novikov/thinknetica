# frozen_string_literal: true

module Manufacturer
  attr_reader :manufacturer

  def manufacturing_plant(name)
    @manufacturer = name if manufacturer.nil?
  end
end

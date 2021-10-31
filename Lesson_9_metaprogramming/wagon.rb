# frozen_string_literal: true

class Wagon
  include Manufacturer
  include Validation
  include Accessors

  TYPE_FORMAT = /^[a-z]{,10}$/.freeze

  validate :type, :presence
  validate :number, :presence
  validate :type, :type_object, String
  validate :type, :format, TYPE_FORMAT
  validate :number, :contains

  attr_reader :type, :number

  def initialize(type, number)
    @type = type
    @number = number
    validate!
    Railroad.instance.wagons << self
  end
end

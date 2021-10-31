# frozen_string_literal: true

class Station
  include Validation
  include InstanceCounter
  include Accessors

  NAME_FORMAT = /^[a-zа-я']{1,20}-?.[a-zа-я\d]{1,20}$/i.freeze

  validate :name, :presence
  validate :name, :type_object, String
  validate :name, :format, NAME_FORMAT
  validate :name, :contains

  attr_reader :name, :trains_at_station

  def initialize(name)
    @name = name
    validate!
    @trains_at_station = []
    Railroad.instance.stations << self
    register_instance
  end

  def each_trains(&block)
    @trains_at_station.each(&block) if block_given?
  end

  def station_info
    "Станция - #{name}; поездов на станции - #{trains_at_station.size}"
  end

  def arrival(train)
    return if @trains_at_station.include?(train)

    @trains_at_station << train
  end

  def departure(train)
    @trains_at_station.delete(train) if @trains_at_station.include?(train)
  end

  def trains_by_type(type)
    @trains_at_station.select { |train| train.type == type }
  end

  def count_trains_by_type(type)
    @trains_at_station.count { |train| train.type == type }
  end
end

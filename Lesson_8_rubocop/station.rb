# frozen_string_literal: true

class Station
  include InstanceCounter

  NAME_FORMAT = /^[a-zа-я']{1,20}-?.[a-zа-я\d]{1,20}$/i.freeze

  attr_reader :name, :trains_at_station

  def initialize(name)
    @name = name
    validate!
    @trains_at_station = []
    Railroad.instance.stations << self
    register_instance
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
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

  protected

  def validate!
    raise "Название станции не можнет быть пустым" if name.empty?
    raise "Название станции имеет недопустимый формат" if name !~ NAME_FORMAT
    raise "Название станции должено быть не более 20 символов" if name.length > 20
    raise "Станция #{name} уже существует" if Railroad.instance.get_station(name)
  end
end

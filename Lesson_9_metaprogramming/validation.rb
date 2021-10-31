# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module InstanceMethods
    def validate!
      @errors = []
      self.class.instance_methods.each do |method|
        send(method) if method.to_s.start_with?("validate_")
      end

      raise @errors.join(', ') unless @errors.empty?
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    protected

    def presence(attr_name, value)
      @errors << "#{attr_name} cannot be empty and nil" if value.to_s.nil? || value.to_s.empty?
    end

    def format(attr_name, value, type_format)
      @errors << "#{attr_name} invalid format" if value !~ type_format
    end

    def type_object(attr_name, value, type)
      @errors << "#{attr_name} class does not match" unless value.is_a?(type)
    end

    def contains(_attr_name, value)
      @errors << "#{value} the object already exists" if Railroad.instance.send(
        "get_#{self.class.name.downcase}".sub(/cargo|passenger/, 'cargo' => '', 'passenger' => ''),
        value
      )
    end

    def includes(attr_name, starting_station, terminal_station)
      return unless starting_station.respond_to?(:name) && terminal_station.respond_to?(:name)

      @errors << "#{attr_name} such a route already exists" if Railroad.instance.routes.key?(
        "#{starting_station.name}-#{terminal_station.name}"
      )
    end

    def equal(attr_name, starting_station, terminal_station)
      @errors << "#{attr_name}: stations should not match" if starting_station.eql? terminal_station
    end
  end

  module ClassMethods
    def validate(attr_name, validator, validator_value = nil)
      if attr_name == :route
        define_method("validate_#{attr_name}_#{validator}".to_sym) do
          send(
            validator, attr_name, instance_variable_get(:@starting_station),
            instance_variable_get(:@terminal_station)
          )
        end
      else
        define_method("validate_#{attr_name}_#{validator}".to_sym) do
          if validator_value
            send(validator, attr_name, instance_variable_get("@#{attr_name}".to_sym), validator_value)
          else
            send(validator, attr_name, instance_variable_get("@#{attr_name}".to_sym))
          end
        end
      end
    end
  end
end

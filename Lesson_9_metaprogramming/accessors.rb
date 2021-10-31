# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module InstanceMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        var_history = "@#{name}_history".to_sym

        define_method(name) { instance_variable_get(var_name) }

        define_method("#{name}=".to_sym) do |value|
          instance_variable_set(var_name, value)
          instance_variable_set(var_history, []) unless instance_variable_defined?(var_history)
          instance_variable_get(var_history) << value
        end

        define_method("#{name}_history".to_sym) { instance_variable_get(var_history) }
      end
    end

    def strong_attr_accessor(arguments = {})
      arguments.each do |name, class_name|
        arg = "@#{name}".to_sym

        define_method(name) { instance_variable_get(arg) }

        define_method("#{name}=".to_sym) do |value|
          raise "Error, invalid object class" unless value.is_a?(class_name)

          instance_variable_set(arg, value)
        end
      end
    end
  end
end

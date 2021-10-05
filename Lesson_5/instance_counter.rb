
module InstanceCounter

  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module InstanceMethods

    private
    def register_instance
      self.class.send :counter
    end
  end
end

module ClassMethods
  
  def instances
    @instances ||= 0
  end

  private
  #def instances=(value)
    #@instances = value
  #end
  attr_writer :instances

  def counter
    self.instances += 1
  end
end

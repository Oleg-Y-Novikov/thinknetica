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

  module ClassMethods

    def instances
      @count_instances
    end

    private 

    def counter
      @count_instances += 1
    end

  end

end

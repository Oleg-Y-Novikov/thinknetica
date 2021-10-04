class CargoTrain < Train

  @count_instances = 0

  def initialize(number)
    super
    @type = "cargo"
  end
    
end

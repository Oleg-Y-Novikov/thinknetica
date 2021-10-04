class PassengerTrain < Train

  @count_instances = 0

  def initialize(number)
    super
    @type = "passenger"
  end

end

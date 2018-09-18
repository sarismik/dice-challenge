class WaitingRoom

  def initialize(patients = [])
    @patients = patients
  end

  def number_waiting
    @patients.length
  end

  # TODO add a method that computes the longest wait time based on patients

end
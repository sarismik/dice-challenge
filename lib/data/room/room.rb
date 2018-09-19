class Room
  # TODO change patient to bed if we ever have a use case where a Room has >1 Bed (requires introducing a Bed class)
  attr_accessor :name
  attr_accessor :patient

  def initialize(name = '', patient = nil)
    @name = name
    @patient = patient
  end

end
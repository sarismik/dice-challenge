class Patient
  attr_accessor :mrn
  attr_accessor :arrival_date_time

  def initialize(mrn = '', arrival_date_time = DateTime.now)
    @mrn = mrn
    @arrival_date_time = arrival_date_time
  end

end
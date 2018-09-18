require 'date'
require_relative '../../data/patient/patient'

class WaitingRoom

  def initialize(patients = [])
    @patients = patients
  end

  def number_waiting
    @patients.length
  end

  def longest_wait_time(current_time = DateTime.now)
    earliest_arrival_time = current_time
    @patients.each do |patient|
      patient_arrival_time = patient.arrival_date_time
      if patient_arrival_time < earliest_arrival_time
        earliest_arrival_time = patient_arrival_time
      end
    end
    ((current_time - earliest_arrival_time) * 24 * 60).to_i.to_s + ' MINUTES'
  end

end
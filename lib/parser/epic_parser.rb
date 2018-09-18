require 'rubygems'
require 'json'
require_relative '../data/waiting/waiting_room'
require_relative '../data/patient/patient'

class EpicParser
  attr_accessor :hash

  def initialize(json_filename = '')
    @json_filename = json_filename
  end

  def parse
    @hash = JSON.parse(File.read(@json_filename))
  end

  def extract_waiting_room
    if @hash.nil?
      parse
    end

    patients = []

    # TODO consider turning JSON field names (i.e. 'edInfo' etc) and magic string values (i.e. 'TJUH ED WAITING') into constants
    care_areas = @hash['edInfo']['edDetail']['CareAreas']
    unless care_areas.nil?
      care_areas.each do |care_area|
        if care_area['areaName'] == 'TJUH ED WAITING'
          # TODO consider optimizing so we break out of care_areas loop after we get in here
          care_area['Rooms'].each do |waiting_room|
            waiting_room['Beds'].each do |bed|
              bed['Patients'].each do |patient|
                # TODO consider making call to DateTime.parse safer/check for nil or unparseable value
                # TODO make sure arrivalDateTime and DateTime.now are in the same timezone
                patients.push(Patient.new(patient['mrn'], DateTime.parse(patient['arrivalDateTime'])))
              end
            end
          end
        end
      end
    end

    WaitingRoom.new(patients)
  end

end
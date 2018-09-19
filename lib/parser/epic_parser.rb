require 'rubygems'
require 'json'
require_relative '../data/waiting/waiting_room'
require_relative '../data/patient/patient'
require_relative '../data/room/room'
require_relative '../data/care_area/care_area'

class EpicParser
  attr_accessor :hash

  def initialize(json_filename = '')
    @json_filename = json_filename
  end

  def parse
    if @hash.nil?
      @hash = JSON.parse(File.read(@json_filename))
    end
  end

  def extract_waiting_room
    parse
    patients = []

    # TODO consider turning JSON field names (i.e. 'edInfo' etc) and magic string values (i.e. 'TJUH ED WAITING') into constants
    care_areas = get_care_areas
    unless care_areas.nil?
      care_areas.each do |care_area|
        if care_area['areaName'] == 'TJUH ED WAITING'
          # TODO consider optimizing so we break out of care_areas loop after we get in here
          care_area['Rooms'].each do |waiting_room|
            waiting_room['Beds'].each do |bed|
              bed['Patients'].each do |patient|
                extract_patient(patient, patients)
              end
            end
          end
        end
      end
    end

    WaitingRoom.new(patients)
  end

  INTAKE_CARE_AREA_NAME = 'TJUH ED INTAKE'

  def extract_intake_data
    parse
    rooms = []

    care_areas = get_care_areas
    unless care_areas.nil?
      care_areas.each do |care_area|
        # TODO consider optimizing so we break out of care_areas loop after we get in here
        if care_area['areaName'] == INTAKE_CARE_AREA_NAME
          care_area['Rooms'].each do |intake_room|
            patient = nil
            intake_room['Beds'].each do |bed|
              bed['Patients'].each do |raw_patient|
                patient = Patient.new(raw_patient['mrn'], DateTime.parse(raw_patient['arrivalDateTime']))
              end
            end
            rooms.push(Room.new(intake_room['roomName'], patient))
          end
        end
      end
    end

    CareArea.new(INTAKE_CARE_AREA_NAME, rooms)
  end

  private

  def extract_patient(patient, patients)
    # TODO consider making call to DateTime.parse safer/check for nil or unparseable value
    # TODO make sure arrivalDateTime and DateTime.now are in the same timezone
    patients.push(Patient.new(patient['mrn'], DateTime.parse(patient['arrivalDateTime'])))
  end

  def get_care_areas
    @hash['edInfo']['edDetail']['CareAreas']
  end

end
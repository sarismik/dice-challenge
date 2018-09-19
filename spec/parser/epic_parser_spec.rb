require_relative '../spec_helper'
require_relative '../../lib/parser/epic_parser'
require 'date'

# TODO figure out how to get this to run when I ask RubyMine to run all tests in the spec dir
describe EpicParser do
  describe 'Epic Parser' do
    before :all do
      json_filename = File.join(File.dirname(__FILE__), '..', 'data', 'patient_data.json')
      @object_under_test = EpicParser.new(json_filename)
    end

    # TODO Consider removing this test and no longer exposing hash once your feet are wet
    it 'should parse file into a hash' do
      expect(@object_under_test.parse).to be_kind_of(Hash)
    end

    it 'should extract waiting room data' do
      waiting_room_data = @object_under_test.extract_waiting_room
      expect(waiting_room_data).to be_kind_of(WaitingRoom)

      expected_number_waiting = 7
      expect(waiting_room_data.number_waiting).to eq(expected_number_waiting)

      expected_first_arrival = DateTime.parse('2018-06-13T16:34:00Z')
      now = DateTime.now
      minutes_since_first_arrival = ((now - expected_first_arrival) * 24 * 60).to_i.to_s
      expect(waiting_room_data.longest_wait_time(now)).to eq(minutes_since_first_arrival + ' MINUTES')
      # TODO consider making ' MINUTES' a constant that comes from WaitingRoom or some UI config
    end

    it 'should extract intake data' do
      intake_data = @object_under_test.extract_intake_data
      expect(intake_data).to be_kind_of(CareArea)
      expect(intake_data.name).to eq('TJUH ED INTAKE')

      expected_number_of_rooms = 5
      intake_rooms = intake_data.rooms
      expect(intake_rooms.length).to eq(expected_number_of_rooms)
      found_room_18i = false
      found_room_19i = false
      found_room_20i = false
      found_room_21i = false
      found_room_28 = false
      intake_rooms.each do |intake_room|
        expect(intake_room).to be_kind_of(Room)
        room_name = intake_room.name
        patient = intake_room.patient
        case room_name
          when '18i'
            expect(patient.mrn).to eq('100008184')
            expect(patient.arrival_date_time).to eq(DateTime.parse('2018-07-06T15:47:00Z'))
            found_room_18i = true
          when '19i'
            expect(patient).to eq(nil)
            found_room_19i = true
          when '20i'
            expect(patient.mrn).to eq('100007929')
            earliest_arrival_time = DateTime.parse('2018-04-26T14:19:00Z')
            expect(patient.arrival_date_time).to eq(earliest_arrival_time)
            found_room_20i = true
          when '21i'
            expect(patient).to eq(nil)
            found_room_21i = true
          when '28'
            expect(patient.mrn).to eq('100008669')
            earliest_arrival_time = DateTime.parse('2018-08-16T15:46:00Z')
            expect(patient.arrival_date_time).to eq(earliest_arrival_time)
            found_room_28 = true
          else
            raise 'Should not have a room named ' + room_name
        end
      end
      # TODO find more elegant way to check that all of the expected room names were included
      expect(found_room_18i).to eq(true)
      expect(found_room_19i).to eq(true)
      expect(found_room_20i).to eq(true)
      expect(found_room_21i).to eq(true)
      expect(found_room_28).to eq(true)
      # TODO check minutes since arrival time for each patient, seems like maybe each patient can/should be above to tell us this
      # TODO write a new class and test that longest wait time/duration in room is for patient in 20i/based on earliest_arrival_time (i.e. room 28 is filtered out by logic that is outside the parser)
    end

    # TODO test more edge cases, requires use of different patient_data.json files

  end
end
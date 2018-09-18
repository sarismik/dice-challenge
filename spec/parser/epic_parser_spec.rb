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

    # Consider removing this test and no longer exposing hash once your feet are wet
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

  end
end
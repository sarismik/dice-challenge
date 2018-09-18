require 'spec_helper'
require 'parser/epic_parser'
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
      expected_number_waiting_patients = 7
      expect(waiting_room_data.number_waiting).to eq(expected_number_waiting_patients)
      # TODO add check on longest wait time
    end

  end
end
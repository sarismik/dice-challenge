require_relative '../spec_helper'
require_relative '../../lib/graph/intake_graph'
require_relative '../../lib/data/room/room'
require_relative '../../lib/data/patient/patient'
require 'date'

describe IntakeGraph do
  describe 'Intake Graph' do
    before :each do
      @now = DateTime.now
      intake_time_limit = 15 # TODO make this a constant somewhere
      # TODO consider adding DateTimeUtil to put this date arithmetic into (or see if there's already a gem for it)
      minutes_in_a_day = 1440.0
      @y_value_for_18r = (intake_time_limit - 1)
      arrival_time_under_limit = @now - (@y_value_for_18r/minutes_in_a_day)
      @y_value_for_19r = intake_time_limit
      arrival_time_at_limit = @now - (@y_value_for_19r/minutes_in_a_day)
      @y_value_for_20r = (intake_time_limit + 1)
      arrival_time_above_limit = @now - (@y_value_for_20r/minutes_in_a_day)
      # TODO make room names into constants somewhere
      room_under_time_limit = Room.new('18i', Patient.new('MRN does not matter here', arrival_time_under_limit))
      room_at_time_limit = Room.new('19i', Patient.new('MRN does not matter here', arrival_time_at_limit))
      room_above_time_limit = Room.new('20i', Patient.new('MRN does not matter here', arrival_time_above_limit))
      empty_room = Room.new('21i')
      room_to_ignore = Room.new('28')
      intake_rooms = [room_under_time_limit, room_at_time_limit, room_above_time_limit, empty_room, room_to_ignore]
      intake_care_area = CareArea.new('Name does not matter here', intake_rooms)
      @intake_graph_under_test = IntakeGraph.new(intake_care_area)
      # TODO make x values below into constants that map to rooms names above
      # TODO make names and colors below into constants
      @intake_series_data = [
          {
              name: 'O',
              color: 'red',
              data: [{x:5, y:@y_value_for_20r}]
          },
          {
              name: 'U',
              color: '#57b7df',
              data: [{x:1, y:@y_value_for_18r}, {x:3, y:@y_value_for_19r}, {x:7, y:0}]
          }
      ]
    end

    it 'should create series data for intake care area' do
      expect(@intake_graph_under_test.series(@now)).to eq(@intake_series_data)
    end

  end
end
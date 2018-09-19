require_relative '../data/care_area/care_area'

class IntakeGraph
  ROOM_NAMES_TO_INCLUDE_IN_GRAPH = %w(18i 19i 20i 21i)
  TIME_LIMIT = 15

  def initialize(intake_care_area = CareArea.new)
    @intake_care_area = intake_care_area
  end

  def series(current_time = DateTime.now)
    points_under_limit = []
    points_above_limit = []
    @intake_care_area.rooms.each do |room|
      room_name = room.name
      if ROOM_NAMES_TO_INCLUDE_IN_GRAPH.include? room_name
        if room.patient.nil?
          minutes_in_intake = 0
        else
          # TODO another bit of date arithmetic for a DateTimeUtils class (or find a gem for this)
          minutes_in_intake = ((current_time - room.patient.arrival_date_time) * 24 * 60).to_i
        end

        point_for_room = {x: x_value(room_name), y: minutes_in_intake}
        if minutes_in_intake <= TIME_LIMIT
          points_under_limit.push(point_for_room)
        else
          points_above_limit.push(point_for_room)
        end
      end
    end
    [
        {
            name: 'O',
            color: 'red',
            data: points_above_limit
        },
        {
            name: 'U',
            color: '#57b7df',
            data: points_under_limit
        }
    ]
  end

  private

  def x_value(room_name)
    # TODO use a map/hash here (I was just too much of a ruby n00b to get that to work)
    case room_name
    when '18i'
      1
    when '19i'
      3
    when '20i'
      5
    when '21i'
      7
    else
      nil
    end
  end

end
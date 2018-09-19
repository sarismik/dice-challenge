require_relative '../data/care_area/care_area'

class IntakeGraph

  def initialize(intake_care_area = CareArea.new)
    @intake_care_area = intake_care_area
  end

  ROOM_NAMES_TO_INCLUDE_IN_GRAPH = %w(18i 19i 20i 21i)

  def series(now = DateTime.now)
    @intake_care_area.rooms.each do |room|
      if ROOM_NAMES_TO_INCLUDE_IN_GRAPH.include? room.name
        # TODO *RESUME HERE* flesh this out to get test to pass
      end
    end
  end

end
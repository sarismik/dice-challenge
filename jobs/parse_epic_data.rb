require_relative '../lib/parser/epic_parser'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', first_in: 0 do |job|
  json_filename = File.join(File.dirname(__FILE__), '..', 'spec', 'data', 'patient_data.json')
  parser = EpicParser.new(json_filename)

  waiting_room = parser.extract_waiting_room
  send_event('waiting', {value: waiting_room.number_waiting, moreinfo: waiting_room.longest_wait_time })

  # TODO consider turning magic string values like 'O' and 'U' into constants that are associated with their bar colors
  # TODO *RESUME HERE* use parser.extract_intake_data to populate data in each series below, should probably introduce a new ruby class that generates intake_series_data
  intake_series_data = [
      {
          name: 'O',
          color: 'red',
          data: [{x:1, y: 20}, {x:3, y:28}, {x:7, y:18}]
      },
      {
          name: 'U',
          color: '#57b7df',
          data: [{x:5, y:12}]
      }
  ]
  send_event('intake', { series: intake_series_data })
end

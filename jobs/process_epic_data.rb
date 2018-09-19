require_relative '../lib/parser/epic_parser'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', first_in: 0 do |job|
  json_filename = File.join(File.dirname(__FILE__), '..', 'spec', 'data', 'patient_data.json')
  parser = EpicParser.new(json_filename)

  waiting_room = parser.extract_waiting_room
  send_event('waiting', {value: waiting_room.number_waiting, moreinfo: waiting_room.longest_wait_time })

  intake_series_data = IntakeGraph.new(parser.extract_intake_data).series
  send_event('intake', { series: intake_series_data })
end

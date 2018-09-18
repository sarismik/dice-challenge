require_relative '../lib/parser/epic_parser'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', first_in: 0 do |job|
  json_filename = File.join(File.dirname(__FILE__), '..', 'spec', 'data', 'patient_data.json')
  parser = EpicParser.new(json_filename)
  # TODO consider optimization by renaming this job so its clear it applies to the whole dashboard, that way we can re-use parser for all widgets
  waiting_room = parser.extract_waiting_room
  send_event('waiting', {value: waiting_room.number_waiting, moreinfo: waiting_room.longest_wait_time })
end

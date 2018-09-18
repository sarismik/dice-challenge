# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  points = [{x:1, y: 4}, {x:2, y:27}, {x:3, y:6}, {x:4, y:6}]
  send_event('intake', { points: points })
end
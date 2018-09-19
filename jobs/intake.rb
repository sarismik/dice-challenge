# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  # TODO figure out how the static JSON here is wrong/not compatible with Rickshaw and/or specifics of intake widget
  series = [
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
  send_event('intake', { series: series })
end
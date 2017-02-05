require 'savon'
require 'pp'

def extract_missions(response) 
  missions=[]
  response.body[:get_missions_next_response][:return][:missions].each do |obj|
    mission = { code: obj[:code], 
                message: obj[:stations_messages], 
                direction: obj[:stations][1][:name],
                platform: obj[:stations_platforms] }
    missions.push mission
  end
  return missions
end

client = Savon.client(wsdl: "http://vps165577.ovh.net:1280/wsiv/services/Wsiv?wsdl")
client = Savon.client(wsdl: "wsiv.wsdl")

puts "Hello"
puts client.operations

response = client.call(:get_lines, message: { line: { realm: 'r' }})

#found = response.body[:get_lines_response][:return].select {|e| e[:image] == 'p_rer_a.gif'}
#puts found 

#response = client.call(:get_stations, message: { station: { line: { id: 'RA', realm: 'r' }}})
#pp response.body

response = client.call(:get_missions_next, message: { station: { id: '3', line: { id: 'RA', realm: 'r' }}, direction: { sens: 'A'}})
#pp response.body[:get_missions_next_response][:return][:missions]
missions = extract_missions(response)
pp missions

response = client.call(:get_missions_next, message: { station: { id: '3', line: { id: 'RA', realm: 'r' }}, direction: { sens: 'R'}})
#pp response.body[:get_missions_next_response][:return][:missions]
missions = extract_missions(response)
pp missions


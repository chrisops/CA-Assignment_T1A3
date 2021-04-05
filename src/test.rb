require 'json'

hash = {clients:[{
    id: 1
},{
    id: 2
},{
    id: 3
}]}

puts hash[client]


# if File.exist?('settings.cfg')
#     strVar = File.open('settings.cfg', &:readline)
#     puts strVar
# else
#     File.write('settings.cfg','coolguy co')
# end



# file = File.read('clients.json')

# client_hash = JSON.parse(file)

# hasherino = {
#     thing: "stuff",
#     cool: "thing",
#     shoes: 2
# }

# File.write("testthing.json", JSON.dump(hasherino))

# puts JSON.parse(File.read('testthing.json'), symbolize_names: true)
require 'json'

file = File.read('clients.json')

client_hash = JSON.parse(file)

hasherino = {
    thing: "stuff",
    cool: "thing",
    shoes: 2
}

File.write("testthing.json", JSON.dump(hasherino))

puts JSON.parse(File.read('testthing.json'), symbolize_names: true)
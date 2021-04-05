# Client object stores a hash of values that represent a client, and can be read from @profile

class Client
    def save(client_hash)
        # adds client to the client_hash clients: array and writes to clients.json, then returns updated hash
        client_hash[:clients].push(profile())
        File.write("clients.json", JSON.dump(client_hash))
        return client_hash
    end
    def initialize(id,name,phone,email,pendingcharges=[])
        @id = id
        @name = name
        @phone = phone
        @email = email
        @pendingcharges = pendingcharges
    end
    def profile
        return {
            id: @id,
            name: @name,
            phone: @phone,
            email: @email,
            pendingcharges: @pendingcharges
        }
    end
    def add_charge(description,hours,chargeperhour,flatfee)
        @pendingcharges.push({
            description: description,
            hours: hours,
            chargeperhour: chargeperhour,
            flatfee: flatfee
        })
    end
    
end
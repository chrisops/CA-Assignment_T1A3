require 'tty-prompt'

# Client object stores a hash of values that represent a client, and can be read from @profile

class Client

    def initialize(id,name,phone,email,pendingcharges=[])
        @id = id
        @name = name
        @phone = phone
        @email = email
        @pendingcharges = pendingcharges
    end

    # adds client to the client_hash clients: array and writes to clients.json, then returns updated hash
    def save(client_hash)
        
        client_hash[:clients].push(profile())
        File.write("clients.json", JSON.dump(client_hash))
        return client_hash
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

    def profile_print
        puts "ID: #{@id}\nName: #{@name}\nPhone Number: #{@phone}\nEmail Address: #{@email}"
        puts "Pending charges:"
        @pendingcharges.each do |charge|
            total = charge[:flatfee] + (charge[:hours] * charge[:chargeperhour])
            puts "#{charge[:description]} - $#{total} Total: $#{charge[:flatfee]} plus #{charge[:hours].to_s} hours at $#{charge[:chargeperhour].to_s} per hour."
        end
    end

    def add_charge(description,hours,chargeperhour,flatfee)
        @pendingcharges.push({
            description: description,
            hours: hours,
            chargeperhour: chargeperhour,
            flatfee: flatfee
        })
    end
    def edit_client
        prompt = TTY::Prompt.new
        puts "Editing client #{@name} - ID #{@id}\n\n\n"
        @name = prompt.ask("Name:", default: @name) do |q|
            q.default
            q.validate(/^[\w ]+$/)
            q.messages[:valid?] = "Invalid Name, must be alphanumeric"
        end
        @phone = prompt.ask("Phone number:", default: @phone) do |q|
            q.validate(/^\d+$/)
            q.messages[:valid?] = "Invalid Phone number, must be numeric"
        end
        @email = prompt.ask("Email address:", default: @email) do |q|
            q.validate(/^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$/)
            q.messages[:valid?] = "Invalid Email address format (must be something@domain.tld)"
        end
end
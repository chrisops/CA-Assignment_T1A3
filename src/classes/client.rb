require 'tty-prompt'
require_relative '../methods/files'

# Client object stores a hash of values that represent a client, and can be read from @profile

class Client

    def initialize(id,name,phone,email,pendingcharges=[])
        @id = id
        @name = name
        @phone = phone
        @email = email
        @pendingcharges = pendingcharges
        @client_hash = get_clienthash()
    end

    # adds client to the client_hash clients: array and writes to clients.json, then returns updated hash
    def save()
        
        @client_hash[:clients].push(profile())
        File.write("clients.json", JSON.dump(@client_hash))
        return @client_hash
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
        puts "Client ID: #{@id}\nName: #{@name}\nPhone Number: #{@phone}\nEmail Address: #{@email}"
        puts "Pending charges:"
        @pendingcharges.each do |charge|
            total = charge[:flatfee] + (charge[:hours] * charge[:chargeperhour])
            puts "\t#{charge[:description]} - $#{total} Total: $#{charge[:flatfee]} plus #{charge[:hours].to_s} hours at $#{charge[:chargeperhour].to_s} per hour."
        end
    end

    def add_charge()
        prompt = TTY::Prompt.new
        system('clear')
        puts "Add new charge to #{@name} account ID: #{@id}\n\n\n"

        description = prompt.ask("Description:", default: "Work done on #{Debug::Date}") do |q|
            q.validate(/^[-\/\\\d\w ]+$/)
            q.messages[:valid?] = "Invalid Description, must be alphanumeric"
        end
        flatfee = prompt.ask("Flat fee:", default: 0) do |q|
            q.convert(:float, "Invalid number")
        end
        hours = prompt.ask("Total hours:", default: 0) do |q|
            q.convert(:float, "Invalid number")
        end
        chargeperhour = prompt.ask("Charge per hour", default: 0) do |q|
            q.convert(:float, "Invalid number")
        end

        @pendingcharges.push({
            description: description,
            hours: hours,
            chargeperhour: chargeperhour,
            flatfee: flatfee
        })
        save()
    end

    def edit_client
        prompt = TTY::Prompt.new
        system('clear')
        puts "Editing client #{@name} - ID #{@id}\n\n\n"
        @name = prompt.ask("Name:", default: @name) do |q|
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
        save()
    end

    def send_invoice()
    end
end
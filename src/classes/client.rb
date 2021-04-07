require 'tty-prompt'
require 'mail'
require 'mailjet'
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
        @client_hash[:clients][@id-1] = profile()
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
        puts "Client ID: \t#{@id}\nName: \t\t#{@name}\nPhone Number: \t#{@phone}\nEmail Address: \t#{@email}"
        
        charges = ""
        bigtotal = 0
        @pendingcharges.each do |charge|
            total = charge[:flatfee] + (charge[:hours] * charge[:chargeperhour])
            bigtotal += total
            charges.concat("   #{charge[:description]} - \t\t$#{total} \n\t$#{charge[:flatfee]} fee + #{charge[:hours].to_s} hours at $#{charge[:chargeperhour].to_s} per hour.\n\n")
        end
        puts "\nPending charges:\t\t\t$#{bigtotal}"
        puts charges
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
        prompt = TTY::Prompt.new
        system('clear')
        puts "Invoice for #{@name}"
        puts "\nCharges on invoice:"
        chargelist = ""
        i = 0
        maintotal = 0
        Debug.show(@pendingcharges)
        @pendingcharges.each do |charge|
            i += 1
            total = charge[:flatfee] + (charge[:hours] * charge[:chargeperhour])
            maintotal += total
            chargelist.concat("\t#{charge[:description]} - \t$#{total} \n\t   $#{charge[:flatfee]} fee + #{charge[:hours].to_s} hours at $#{charge[:chargeperhour].to_s} per hour.\n\n")
        end
        puts chargelist
        if prompt.select("\nSend Invoice to #{@email}?", ["Yes","No"]) == "Yes"
            companyname = get_company_name()
            chargelist.gsub!(/\n/,"<br />")
            begin
                Mailjet.configure do |config|
                    config.api_key = 'e557cd3a5ef5b8db8f983dcc3e95c495'
                    config.secret_key = '1d114ee466c706babd2830d4fe6c8aec'
                    config.api_version = "v3.1"
                end
                variable = Mailjet::Send.create(messages: [{
                  'From'=> {
                    'Email'=> 'billing@makecoolstuff.net',
                    'Name'=> "#{companyname} Accounts Receivable"
                  },
                  'To'=> [
                    {
                      'Email'=> @email,
                      'Name'=> @name
                    }
                  ],
                  'Subject'=> "#{companyname} - Invoice",
                  'TextPart'=> 'Company Invoice',
                  'HTMLPart'=> "<h1>#{companyname}</h1><h2>Account ID: #{@id}</h2><h3>Dear #{@name},</h3<br /><h4>Please find below invoice:</h4><br /><h5 style='font-size:22px'><b>#{chargelist}</b></h5><br />Total due: <span style='font-weight:bold,margin-left:60px'>$#{maintotal}<br /><p style='color: darkgrey'>Invoice due within 14 days</p> ",
                  'CustomID' => 'InvoiceEmailBashBooksRubyApp'
                }]
                )
            rescue => error
                puts "Failed to deliver email:"
                puts error.message
                puts "\nPress enter to continue"
                input = gets
                return false
            end
            @pendingcharges = []
            save()
            return true
        end
    end
end
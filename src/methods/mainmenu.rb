require 'tty-prompt'
require 'colorize'
require_relative '../classes/client'
require_relative '../modules/debug'
require_relative 'files'

# mainmenu(companyname,user,client_hash) Returns option selected by user
def main_menu(companyname="Unknown",username="Unknown",client_hash)
    prompt = TTY::Prompt.new
    input = ""
    while input != "Exit"
        system('clear')
        Debug.show "Debug ON\ninput: #{input} | company_name: #{companyname} | username: #{username}"
        input = prompt.select("#{companyname} accounts\n\nLogged in as user #{username}\n\nTotal clients: #{client_hash[:clients].length}\n\n", ["Add new client","Search client","Exit"])
        
        if input == "Add new client"
            client_hash = add_new_client(client_hash)
        end

        if input == "Search client"
            clientsearch(client_hash)
        end
    end
    return input
end

# add_new_client(client_hash) - prompts for new client information, adds to client_hash, then returns the updated hash. Also updates the clients.json file
def add_new_client(client_hash)
    prompt = TTY::Prompt.new
    totalclients = client_hash[:clients].length
    system('clear')
    Debug.show("Debug ON")
    puts "Create new client: \n\n\n"
    name = prompt.ask("Name:") do |q|
        q.validate(/^[\w ]+$/)
        q.messages[:valid?] = "Invalid Name, must be alphanumeric"
    end
    phone = prompt.ask("Phone number:") do |q|
        q.validate(/^\d+$/)
        q.messages[:valid?] = "Invalid Phone number, must be numeric"
    end
    email = prompt.ask("Email address:") do |q|
        q.validate(/^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$/)
        q.messages[:valid?] = "Invalid Email address format (must be something@domain.tld)"
    end
    client = Client.new(totalclients+1,name,phone,email)
    return client.save()
end





# searches the client hash to match a string input from the user, then goes to clientselect menu
def clientsearch(client_hash)
    prompt = TTY::Prompt.new
    input = ""
    while input != "Exit"
        system('clear')
        Debug.show("Debug ON")
        input = prompt.select("Client lookup\n\n\n",["Fulltext search","ID search","Exit"])
        string = nil
        if input == "Fulltext search"
            string = prompt.ask("Fulltext search:") do |q|
                q.validate(/^[\w \d]+$/)
                q.messages[:valid?] = "Invalid search, must be alphanumeric"
            end
        elsif input == "ID search"
            string = prompt.ask("ID search:") do |q|
                q.validate(/^[\d]+$/)
                q.messages[:valid?] = "Invalid ID, must be numeric"
            end
        end
        if string != nil
            system('clear')
            puts "Client lookup\n\nSearch: #{string}\n"
            string.downcase!
            matches = []
            client_hash[:clients].each do |client|
                if input == "ID search"
                    if /#{string}/.match(client[:id].to_s)
                        matches.push(client[:id])
                    end
                    next
                end
                client.each do |key,value|
                    next if key == :pendingcharges
                    if /#{string}/.match(value.to_s.downcase)
                        
                        Debug.show "#{string} matches #{key} => #{value.to_s.downcase}\t#{client[:id]}"
                        matches.push(client[:id])
                        break
                    end
                end
            end
            if matches.length > 1 && matches.length < 7
                puts "Multiple results:\n\n"
                matches.each do |id|
                    puts "Client ID: #{client_hash[:clients][id-1][:id]} \t#{client_hash[:clients][id-1][:name]}\n"
                end
                input = prompt.select("\n\n",["Search again","Exit"])
            elsif matches.length >= 7
                puts "Too many results"
                input = prompt.select("\n\n",["Search again","Exit"])
            elsif matches.length == 0
                puts "No results"
                input = prompt.select("\n\n",["Search again","Exit"])
            elsif matches.length == 1
                puts "ID: #{client_hash[:clients][matches[0]-1][:id]} \nName: #{client_hash[:clients][matches[0]-1][:name]}"
                selectclient(client_hash[:clients][matches[0]-1])
            end
        end
    end
end

def selectclient(client)
    prompt = TTY::Prompt.new
    input = ""
    msg = ""
    selected = Client.new(client[:id],client[:name],client[:phone],client[:email],client[:pendingcharges])
    while input != "Exit"
        system('clear')
        selected.profile_print
        input = prompt.select("#{msg}\n",["Edit","Add pending charge","Send Invoice","Exit"])
        msg = ""
        case input
        when "Edit"
            selected.edit_client
        when "Add pending charge"
            selected.add_charge
        when "Send Invoice"
            if selected.send_invoice
                msg = "\nSuccessfully sent invoice to #{client[:email]}\n\n".colorize(:green)
            end
        end
    end
end

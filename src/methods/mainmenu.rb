require 'tty-prompt'
require_relative '../classes/client'

# mainmenu(companyname,user,client_hash) Returns option selected by user
def main_menu(companyname="Unknown",username="Unknown",client_hash)
    prompt = TTY::Prompt.new
    input = ""
    while input != "Exit"
        system('clear')
        input = prompt.select("#{companyname} accounts\n\nLogged in as user #{username}\n\nTotal clients: #{client_hash[:clients].length}\n\n", ["Add new client","Search client","Exit"])
        
        if input == "Add new client"
            client_hash = add_new_client(client_hash)
        end

        if input == "Search client"
        end
    end
    return input
end

# add_new_client(client_hash) - prompts for new client information, adds to client_hash, then returns the updated hash. Also updates the clients.json file
def add_new_client(client_hash)
    prompt = TTY::Prompt.new
    totalclients = client_hash[:clients].length
    system('clear')
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
    return client.save(client_hash)
end

# returns company name, asks for new one if can't find
def get_company_name
    prompt = TTY::Prompt.new
    if File.exist?('settings.cfg')
        begin
            companyname = File.open('settings.cfg', &:readline)
        rescue 
            puts "Error reading settings.cfg, re-creating..."
            File.delete('settings.cfg')
            companyname = prompt.ask("Enter company name:") do |q| 
                q.validate(/^[\w\d ]+$/)
                q.messages[:valid?] = "Invalid Company name, must be alphanumeric"
            end
            File.write('settings.cfg',companyname)
        end
    else
        companyname = prompt.ask("Enter company name:") do |q| 
            q.validate(/^[\w\d ]+$/)
            q.messages[:valid?] = "Invalid Company name, must be alphanumeric"
        end
        File.write('settings.cfg',companyname)
    end
    return companyname
end


# returns hash list of clients parsed from clients.json
def get_clienthash()
    if File.exist?('settings.cfg')
        begin
            file = File.read('clients.json')
            client_hash = JSON.parse(file, symbolize_names: true)
        rescue 
            system('clear')
            puts "Error reading clients.json: \nfile is corrupt or not in correct format\nre-creating..."
            puts "mv clients.json clients.json.bak"
            system('mv clients.json clients.json.bak')
            system('echo "{\"clients\":[]}" > clients.json')
            puts "\nOld clients list is saved to clients.json.bak\nPress Enter to continue..."
            gets
            client_hash = {clients: []}
        end
    else
        system('echo "{\"clients\":[]}" > clients.json')
        client_hash = {clients: []}
    end
    return client_hash
end


# searches the client hash to match a string input from the user, then goes to clientselect menu
def clientsearch(client_hash)
    prompt = TTY::Prompt.new
    system('clear')
    puts "Client lookup\n\n\n"
    string = prompt.ask("Fulltext search:") do |q|
        q.validate(/^[\w \d]+$/)
        q.messages[:valid?] = "Invalid search, must be alphanumeric"
    end
end

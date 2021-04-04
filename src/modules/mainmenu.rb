require 'tty-prompt'
require_relative '../classes/client'

# Returns option selected by user

def main_menu(companyname="Unknown",username="Unknown",clienthash)
    
    prompt = TTY::Prompt.new
    input = ""
    totalclients = clienthash[:clients].length
    while input != "Exit"
        system('clear')
        input = prompt.select("#{companyname} accounts\n\nWelcome #{username}\n\nTotal clients: #{totalclients}\n\n", ["Add new client","Search client","Exit"])
        
        if input == "Add new client"
            add_new_client(totalclients+1)
            totalclients += 1
        end

        if input == "Search client"
        end
    end
end

def add_new_client(clientid)
    client = Client.new(clientid)
end

def get_company_name
    prompt = TTY::Prompt.new
    if File.exist?('settings.cfg')
        begin
            companyname = File.open('settings.cfg', &:readline)
        rescue 
            puts "Error reading settings.cfg, re-creating..."
            File.delete('settings.cfg')
            companyname = prompt.ask("Enter company name:")
            File.write('settings.cfg',companyname)
        end
    else
        companyname = prompt.ask("Enter company name:")
        File.write('settings.cfg',companyname)
    end
    return companyname
end
require 'tty-prompt'

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
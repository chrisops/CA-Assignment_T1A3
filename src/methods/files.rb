require 'tty-prompt'

# returns company name, asks for new one if can't find

def loading_anim
    system('clear')
    while 1
        sleep(0.3)
        print "\rLoading gems |"
        sleep(0.3)
        print "\rLoading gems \\"
        sleep(0.3)
        print "\rLoading gems -"
        sleep(0.3)
        print "\rLoading gems /"
    end
end

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
    if File.exist?('clients.json')
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
            input = gets
            client_hash = {clients: []}
        end
    else
        system('echo "{\"clients\":[]}" > clients.json')
        client_hash = {clients: []}
    end
    return client_hash
end

# returns hash of invoices read from invoices.json
def get_invoices
    if File.exist?('invoices.json')
        begin
            all_invoices = JSON.parse(File.read('invoices.json'), symbolize_names: true)
        rescue => error
            system('clear')
            puts "Error reading invoices.json: #{error.message}\n\nre-creating..."
            puts "mv invoices.json invoices.json.bak"
            system('mv invoices.json invoices.json.bak')
            system('echo "{\"invoices\":[]}" > invoices.json')
            puts "\nOld invoice list is saved to invoices.json.bak\nPress Enter to continue..."
            input = gets
            return {invoices:[]}
        end
        return all_invoices
    else
        all_invoices = {invoices:[]}
        File.write("invoices.json", JSON.dump(all_invoices))
        return all_invoices
    end
end



# Saves invoice to invoices.json
def saveinvoice(invoice_hash)
    all_invoices = get_invoices()
    all_invoices[:invoices].push(invoice_hash)
    File.write("invoices.json", JSON.dump(all_invoices))
end



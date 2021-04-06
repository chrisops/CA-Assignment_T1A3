require 'mail'

mail = Mail.new do
    from    'billing@makecoolstuff.net'
    to      'chris@makecoolstuff.net'
    subject 'Invoice'
    body    'test'
end
options = { 
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => 'makecoolstuff.net',
    :user_name            => 'homebase.op@gmail.com',
    :password             => 'jlqolwsxiuhryjyd',
    :enable_starttls_auto => true  }
Mail.defaults do
    delivery_method :smtp, options
end
mail.deliver

# if File.exist?('settings.cfg')
#     strVar = File.open('settings.cfg', &:readline)
#     puts strVar
# else
#     File.write('settings.cfg','coolguy co')
# end



# file = File.read('clients.json')

# client_hash = JSON.parse(file)

# hasherino = {
#     thing: "stuff",
#     cool: "thing",
#     shoes: 2
# }

# File.write("testthing.json", JSON.dump(hasherino))

# puts JSON.parse(File.read('testthing.json'), symbolize_names: true)
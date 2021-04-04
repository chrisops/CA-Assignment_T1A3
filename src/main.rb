require 'json'
require 'tty-prompt'
require_relative 'modules/login'
require_relative 'modules/mainmenu'


# main script
#
# menu tree:
#
#   login_prompt 
#        |
#    main_menu
#        |
#   ----------    
#   |        |
#  add     search
#            |
#          select
#            |
#       -----------
#      |          |
#     edit    add charge


login_user_credentials = [{username: "admin", password: "admin"},{username: "guest", password: "guest"}]

user = login_prompt(login_user_credentials)

if !user
    exit 0
end

file = File.read('clients.json')
client_hash = JSON.parse(file, symbolize_names: true)

companyname = get_company_name()

main_menu(companyname,user,client_hash)

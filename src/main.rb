require 'json'
require 'tty-prompt'
require_relative 'methods/login'
require_relative 'methods/mainmenu'


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

user = true

while user
    user = login_prompt(getlogins())

    if !user
        exit 0
    end

    client_hash = get_clienthash()

    companyname = get_company_name()

    main_menu(companyname,user,client_hash)
end


require_relative 'login'


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

if !login_prompt(login_user_credentials)
    exit
end


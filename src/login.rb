require 'tty-prompt'

# prompt the user to login or exit, then asks for a username and password, accepting a hash of key/value pairs for the valid logins

# returns true if successful login, false if Exit is selected


def login_prompt(loginaccounts)
    
    raise TypeError.new("Login credentials in login_prompt() must be an array") if !loginaccounts.is_a?(Array)
    prompt = TTY::Prompt.new
    failedmsg = ""
    input = ""
    while input != "Exit"
        system("clear")
        input = prompt.select("BashBooks\nWelcome\n\n\n#{failedmsg}\n\n", %w(Login Exit))
        if input == "Login"
            input_un = prompt.ask("Enter username:", default: "admin")
            input_pw = prompt.mask("Enter password:")
            loginaccounts.each do |thing|
                if thing[:username] == input_un && thing[:password] == input_pw
                    return true
                end
            end
            sleep(2) # brute force protection lel
            failedmsg = "Incorrect username and password"
        end
    end
    return false
end
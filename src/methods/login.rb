require 'tty-prompt'

# prompt the user to login or exit, then asks for a username and password, accepting a hash of key/value pairs for the valid logins

# returns array of hashes of user login credentials
def getlogins()
    hash = []
    logins = File.foreach('login.accounts') do |line| 
        arr = line.chomp.split(',')
        hashit = {username: arr[0], password: arr[1]}
        hash.push(hashit)
    end
    return hash
end

# loginprompt(logins_array) returns username if login matches array of credentials, false otherwise
def login_prompt(loginaccounts)
    raise TypeError.new("Login credentials in login_prompt() must be an array") if !loginaccounts.is_a?(Array)
    prompt = TTY::Prompt.new
    failedmsg = ""
    input = ""
    while input != "Exit"
        system("clear")
        Debug.show("Debug ON")
        input = prompt.select("BashBooks login\n\n#{failedmsg}\n\n", %w(Login Exit))
        if input == "Login"
            input_un = prompt.ask("Enter username:", default: "admin")
            input_pw = prompt.mask("Enter password:")
            loginaccounts.each do |thing|
                if thing[:username] == input_un && thing[:password] == input_pw

                    # successful login and return account username that logged in
                    return input_un
                end
            end
            sleep(2) # brute force protection lel
            failedmsg = "Incorrect username and password"
        end
    end
    # exit loop and return false when exit is selected
    return false
end
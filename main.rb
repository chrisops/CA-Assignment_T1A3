require 'tty-prompt'

prompt = TTY::Prompt.new
puts `clear`
input = prompt.select("BashBooks\nWelcome\n\n\n\n", %w(Login Exit))

if input = "Login"
    username = prompt.ask("Enter username:", default: "admin")
    password = prompt.mask("Enter password:")
end


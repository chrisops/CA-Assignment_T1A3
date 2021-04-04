# Client object stores a hash of values that represent a client, and can be read from @profile

class Client
    attr_reader :profile
    def initialize(id)
        prompt = TTY::Prompt.new
        @profile = prompt.collect do
            puts "Create new client:\n\n\n"
            key(:name).ask("Name:")
          
            key(:phone).ask("Phone number:", validate: /\d/)
          
            key(:email).ask("Email address:", validate: /^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$/)
        end
        @profile[:pendingcharges] = []
        @profile[:id] = id
    end
end
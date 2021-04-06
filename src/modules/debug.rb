require 'colorize'

module Debug
    On = ARGV[0] == "-d" || ARGV[0] == "--debug"
    Date = `date +%D`.chomp
    def Debug.show(string)
        puts "#{string}".colorize(:red) if On == true
    end
end
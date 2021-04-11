require 'colorize'

module Debug
    On = ARGV[0] == "-d" || ARGV[0] == "--debug"
    Date = `date '+%d/%m/%Y'`.chomp
    DateT = `date '+%d/%m/%Y %T'`.chomp
    def Debug.show(string)
        puts "#{string}".colorize(:red) if On == true
    end
end
# Helper methods for the discord-webhook action

require 'json'

def literalNewline(args)
    print args[0].gsub(/\r{0,1}\n/, "\\n")
end

def handleJson(args)
    json = args[0].dup
    i = -1
    replace = ""
    while (i = i + 1) < json.size do
        if json[i] == "\n"
            cr = json[i - 1] == "\r" ? 1 : 0
            json[i - cr..i] = replace
        elsif json[i] == '"' && json[i - 1] != "\\"
            replace = replace == "" ? "\\n" : ""
        end
    end
    print JSON.generate(JSON.parse(json))
end

exit 0 if ARGV.size < 1
send ARGV.shift, ARGV

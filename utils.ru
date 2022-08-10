# Helper methods for the discord-webhook action

require 'yaml'
require 'json'

def prettyJson(args)
    print "```\n" + JSON.pretty_generate(JSON.parse(args[0])) "```\n"
end

def literalNewline(args)
    print args[0].gsub(/\r{0,1}\n/, "\\n")
end

def handleJson(args)
    json = args[0].dup.lstrip.rstrip
    return if json.size == 0
    if json[0] != "{" && json[0] != "["
        begin
            print JSON.generate(YAML.load(json))
            return
        end
    end
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

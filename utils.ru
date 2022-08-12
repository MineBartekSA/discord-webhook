# Helper methods for the discord-webhook action

require 'yaml'
require 'json'

def prettyJson(args)
    print JSON.pretty_generate(JSON.parse(args[0])) + "\n"
end

def literalNewline(args)
    print args[0].gsub(/\r{0,1}\n/, "\\n")
end

def handleJson(args)
    json = args[0].dup.lstrip.rstrip
    return if json.size == 0
    if json[0] != "{" && json[0] != "[" # Try to parse YAML if there are no signs it's JSON
        begin
            _endJson args, YAML.load(json)
            return
        end
    end
    i = -1
    replace = ""
    while (i = i + 1) < json.size do # If YAML parsing fails, assume JSON and celan it
        if json[i] == "\n"
            cr = json[i - 1] == "\r" ? 1 : 0
            json[i - cr..i] = replace
        elsif json[i] == '"' && json[i - 1] != "\\"
            replace = replace == "" ? "\\n" : ""
        end
    end
    _endJson args, JSON.parse(json)
end

def _endJson(args, data)
    if args.size > 1 && args[1] == "comp"
        type = (data.kind_of?(Array) ? data : (data = [data]))[0]["type"]
        data = {"type" => 1, "components" => data} if type != 1
    end
    print JSON.generate data
end

exit 0 if ARGV.size < 1
send ARGV.shift, ARGV

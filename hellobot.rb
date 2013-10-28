#my bot will look for some sort of helpful code in the the api docks of ruby
#and spit it out

require "socket"

class SearchBot

  def initialize(server = nil)
    @nick = "SearchBot"
    @channel = "#bitmaker"
    @serverconnect = server
    @port=6667
    @greeting_prefix = "privmsg #bitmaker :"
  end
  #xml near match look at->
  def start
    @server=TCPSocket.open(@serverconnect,@port)
    @server.puts "USER bhellobot 0 * BHelloBot"
    @server.puts "NICK #{@nick}"
    @server.puts "JOIN #{@channel}"
    @server.puts "PRIVMSG #{@channel} :Hello from IRB Bot"
    @server.puts "PRIVMSG #{channel} :Type the class you want to search\n 
    out of Hash, String, Array, or Enumerable, followed by the method\n 
    For example, String upto:"

    until @server.eof? do
      respond @server.gets.downcase
    end
  end

    def respond(msg)
      puts msg
      if msg.include? @greeting_prefix and wordindoc?(msg)
          response = "w00t! Someone talked to us!!!! Hello!!!"
          @server.puts "PRIVMSG #{@channel} :#{response}"
      end
    end

    #word in document
    def getdocument
      url = 'https://status.github.com/api/status.json'
      data = JSON.parse Curl.get(url).body_str
      return data["status"].to_sym
    end

    def wordindoc?(msg)
    end


    def greeted?(msg)
      greetings = ["hello", "hi", "hola", "yo", "wazup", "guten tag", "howdy", "salutations"]
      wasGreeted = false
      greetings.each do |g|
        wasGreeted = true if msg.include? g
      end
    end
end

bot= SearchBot.new("moorcock.freenode.net")
bot.start
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

  def start
    @server=TCPSocket.open(@serverconnect,@port)
    @server.puts "USER bhellobot 0 * BHelloBot"
    @server.puts "NICK #{@nick}"
    @server.puts "JOIN #{@channel}"
    @server.puts "PRIVMSG #{@channel} :Hello from IRB Bot"

    until @server.eof? do
      respond @server.gets.downcase
    end
  end

    def respond(msg)
      puts msg
      if msg.include? @greeting_prefix and greeted?(msg)
          response = "w00t! Someone talked to us!!!! Hello!!!"
          @server.puts "PRIVMSG #{@channel} :#{response}"
      end
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
#my bot will look for some sort of helpful code in the the api docks of ruby
#and spit it out

require "socket"
require 'nokogiri'
require 'net/http'
require 'open-uri'

class SearchBot

  def initialize(server = nil)
    @nick = "SearchBot"
    @channel = "#dogs"
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
    @server.puts "PRIVMSG #{@channel} :Type the class you want to search out of Hash, String, Array, or Enumerable, followed by the method For example, String upto:"
    until @server.eof? do
      answer= @server.gets.downcase
    end
    val=answer.split(" ")
    klass=val[0].capitalize
    begin
      doc=Nokogiri::HTML(open("http://ruby-doc.org/core-2.0.0/String.html"))
    rescue OpenURI::HTTPError => e 
      if e.message =="404 Not Found"
        @server.puts "PRIVMSG #{@channel} :Hello from IRB Bot WHO IS A GANGSTA"
      else
        raise e
      end
    end
    value=val[1]+"-method"
    last=doc.css("div#upto-method p")[0]
    @server.puts "PRIVMSG #{@channel} :#{last}"
  end
end

bot= SearchBot.new("moorcock.freenode.net")
bot.start


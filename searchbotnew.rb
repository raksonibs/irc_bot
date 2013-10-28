#my bot will look for some sort of helpful code in the the api docks of ruby
#and spit it out

require "socket"
require 'nokogiri'
require 'net/http'
require 'open-uri'
require 'debugger'

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
    @server.puts "PRIVMSG #{@channel} :Type the class you want to search out of Hash, String, Array, or Enumerable, followed by the method For example, String upto:"

    until @server.eof? do
      respond @server.gets
    end
  end

    def respond(msg)
      p msg
  
      paragraph=getdocument(msg)
      puts paragraph

      @server.puts "PRIVMSG #{@channel} :#{paragraph}" if (paragraph)
      #@server.puts "PRIVMSG #{@channel} :Sorry didn't work!" if !paragraph
    end

    #word in document
    def getdocument(msg)
        if msg.match(/Hash/) || msg.match(/String/) || msg.match(/Enumerable/) || msg.match(/Array/) ||

        
          val=msg.split(" ")
          klass=val[0].capitalize
          klass="String" #temporary fix for al input coming in
          doc=Nokogiri::HTML(open("http://ruby-doc.org/core-2.0.0/#{klass}.html"))
          # begin
          #   doc=Nokogiri::HTML(open("http://ruby-doc.org/core-2.0.0/#{klass}.html"))
          # rescue OpenURI::HTTPError => e 
          #   if e.message =="404 Not Found"
          #     until @server.eof? do
          #       respond @server.gets.downcase
          #     end
          #   else
          #     raise e
          #   end
          # end

          value=val[1]+"-method"
          value="upto-method"

          answer=doc.css("div\##{value} p")[0]
          answer

        end
      
    end

    def wordindoc?(doc, val)
      val=val[1]+"-method"
      doc.css("div\##{val} p")[0]
    end
end

bot= SearchBot.new("moorcock.freenode.net")
bot.start


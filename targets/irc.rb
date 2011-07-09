#!/usr/bin/env ruby
# (c) 2011 Ricky Elrod. All rights reserved.

require 'socket'

class Irc < SlothTarget

  attr_reader :ircbot

  def immediately
    super
    bot_connect
  end

  def bot_connect
    return if @ircbot
    @channels = @config['channels'].join(',')
    @ircbot = TCPSocket.new @config['server'], @config['port']
    @ircbot.puts "NICK #{@config['nick']}"
    @ircbot.puts "USER #{@config['nick']} * * :Sloth Utility Bot"

    Thread.new do
      while line = @ircbot.gets.strip
        puts line
        if line =~ /^PING/
          @ircbot.puts line.sub 'I', 'O'
        elsif line.split[1] == '376'
          @ircbot.puts "JOIN #{@channels}"
        elsif line =~ /!proove-existence/
          @ircbot.puts "PRIVMSG #{@channels} :I talk therefore I am."
        end
      end
    end

  end

  def activate(lines)
    bot_connect
    lines.each do |line|
      @ircbot.puts "PRIVMSG #{@channels} :#{line}"
    end
  end

end

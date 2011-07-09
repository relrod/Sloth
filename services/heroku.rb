#!/usr/bin/env ruby
# (c) 2011 Ricky Elrod. All rights reserved.
require 'pp'
class Heroku < SlothService

  def self.immediately
    super
    puts 'This is a sample override. It is called when this service is loaded.'
  end

  def do_GET(request, response)
    response.body = 'I work.'
    to_text
    raise HTTPStatus::OK
  end

  def do_POST(request, response)
    @query = request.query
    pp @query
    to_text
    raise HTTPStatus::OK
  end

  def to_text
    output_lines = []
    commits = @query['git_log'].split("\n").reverse
    output_lines << "Commit to #{@query['app']} (head is now "+
      "#{@query['head']}):"
    
    commits.each do |commit|
      # If there's any left, add them to output_lines.
      output_lines << commit
    end

    @options[0].each do |service|
      service.activate(output_lines)
    end
  end

end

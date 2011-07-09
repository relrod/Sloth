#!/usr/bin/env ruby
# (c) 2011 Ricky Elrod. All rights reserved.

require 'yaml'
require 'webrick'

include WEBrick

config = YAML.load_file 'config.yaml'
if !config
  puts 'Config file [config.yaml] not found.'
  exit
end

master = HTTPServer.new({
  :Port => config['master']['port'],
  :BindAddress => config['master']['address'],
})

class SlothService < HTTPServlet::AbstractServlet
  
  def self.immediately
    yield if block_given?
    puts "!!! Included module: #{self}"
  end

end

class SlothTarget

  attr_accessor :services

  def initialize(config)
    @config = config
  end

  def immediately
    yield if block_given?
    puts "!!! Included target: #{self.class}"
  end

end

services = []
targets = {}

config['targets'].each do |name, config_hash|
  class_name = config_hash.delete('target') || name
  require "targets/#{class_name}"
  target_services = config_hash.delete('services').split

  config_hash ||= {}
  class_const = Class.const_get(class_name.capitalize)
  target_instance = class_const.new(config_hash)
  target_instance.services = target_services
  target_instance.immediately
  targets[name] = target_instance
end

config['services'].each do |name, mount|
  require "services/#{name}"
  
  targets_which_require_this_service = []
  
  targets.each do |target_name, target_instance|
    if target_instance.services.include? name
      targets_which_require_this_service << target_instance
    end
  end
    
  class_const = Class.const_get(name.capitalize)
  master.mount(mount, class_const, targets_which_require_this_service)
  services << name
  class_const.immediately
end

['INT', 'TERM'].each do |signal| 
  trap(signal) do
    master.shutdown
  end
end

master.start

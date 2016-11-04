require 'rubygems'
require 'eventmachine'

EventMachine.run do
  EventMachine.add_periodic_timer(1) do
    puts "Hello world"
  end
end

require 'pg'

class App
  def initialize()
    puts 'Hello'
  end
end

if __FILE__ == $PROGRAM_NAME
  app = App.new()
end
require 'pg'

class App

  attr_reader :conn
  def initialize
  end

  def connect
    @conn = PG.connect :dbname => 'linechatdb', :user => 'linechat'
  end

  def close
    @conn.close if @conn
  end

  def create_user
    puts "Creating User."
    puts "Enter username: "
    username = STDIN.gets.chomp
    puts "Enter password: "
    password = STDIN.gets.chomp
    @conn.exec("INSERT INTO users (username, password, created_at) VALUES('#{username}', '#{password}', NOW())")
  end

  def display_tables
    result = @conn.exec('SELECT * FROM users')
    result.each do |res|
      puts "#{res.class} : #{res}"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  begin
    app = App.new
    app.connect
    app.display_tables
    #app.create_user
  rescue PG::Error => e
    puts "#{e.message}"
  ensure
    app.close
  end
end
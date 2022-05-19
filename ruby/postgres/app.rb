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

  def display_users
    result = @conn.exec('SELECT * FROM users')
    result.each do |res|
      puts "#{res.class} : #{res}"
    end
  end

  def update_user_password(user, new_password)
    @conn.exec("UPDATE users SET password = '#{new_password}' WHERE username = '#{user}'")
  end
end

if __FILE__ == $PROGRAM_NAME
  begin
    app = App.new
    app.connect
    app.display_users
    #app.create_user
    app.update_user_password('Bond', 'newpass')
  rescue PG::Error => e
    puts "#{e.message}"
  ensure
    app.close
  end
end
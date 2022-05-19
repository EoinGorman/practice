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

  def create_user(username, password)
    puts "Creating User."
    @conn.exec("INSERT INTO users (username, password, created_at) VALUES('#{username}', '#{password}', NOW())")
  end

  def display_users
    puts "Users:"
    result = @conn.exec('SELECT * FROM users')
    result.each do |res|
      puts "#{res.class} : #{res}"
    end
  end

  def update_user_password(user, new_password)
    puts "Updating user password for #{user}..."
    @conn.exec("UPDATE users SET password = '#{new_password}' WHERE username = '#{user}'")
  end

  def delete_user(user)
    puts "Deleting user #{user}..."
    @conn.exec("DELETE FROM users WHERE username = '#{user}'")
  end
end

if __FILE__ == $PROGRAM_NAME
  begin
    new_user = "Bond"
    new_password = "JamesBond"

    app = App.new
    app.connect

    # R
    app.display_users

    # C
    app.create_user(new_user, new_password)
    app.display_users

    # U
    new_password = 'newpass'
    app.update_user_password(new_user, new_password)
    app.display_users

    # D
    app.delete_user(new_user)
    app.display_users
  rescue PG::Error => e
    puts "#{e.message}"
  ensure
    app.close
  end
end
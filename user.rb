require 'sqlite3'

class User
 attr_accessor :id, :firstname, :lastname, :age, :password, :email

 def initialize
    db = SQLite3::Database.open 'db.sql'
    db.execute "CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY AUTOINCREMENT, firstname STRING, lastname STRING, age INTEGER, password STRING, email STRING)"
    db.close
 end

 def create(user_info)
      @firstname = user_info[:firstname]
      @lastname = user_info[:lastname]
      @age = user_info[:age] 
      @password = user_info[:password] 
      @email = user_info[:email]

    db = SQLite3::Database.open 'db.sql'
    db.execute "INSERT INTO users (firstname, lastname, age, password, email) VALUES (?, ?, ?, ?, ?)", @firstname, @lastname, @age, @password, @email
    id_num = db.last_insert_row_id
    db.close

    return id_num
 end

 def find(user_id)
    db = SQLite3::Database.open 'db.sql'
    user = db.execute "SELECT * FROM users WHERE id = ?", user_id
    db.close

    return user
 end

 def all
    db = SQLite3::Database.open 'db.sql'
    all_users = db.execute "SELECT * FROM users"
    db.close

    return all_users
 end

 def update(user_id, attribute, value)
     db = SQLite3::Database.open 'db.sql'
     db.execute "UPDATE users SET #{attribute} = ? WHERE id = ?", value, user_id
     user = db.execute "SELECT * FROM users WHERE id = ?", user_id
     db.close

     return user
 end

 def destroy(user_id)
   db = SQLite3::Database.open 'db.sql'
   db.execute "DELETE FROM users WHERE id = ? ", user_id
   db.close
 end

end

inno = User.new


#=begin
puts inno.create(
   {
   firstname: "innoe",
   lastname: "baba",
   age: 73,
   password: "wqjhdtgtqw",
   email: "innoe@yahoo.com"
   }
)
#=end

#puts inno.find(1)

=begin
all_users = inno.all

all_users.each do |user|
   puts user
end
=end


#puts inno.update(1,"firstname", "innocent")

#inno.destroy(1)
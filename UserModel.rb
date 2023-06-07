require 'sqlite3'

class User
   attr_accessor :id, :firstname, :lastname, :age, :password, :email

   #this is my initializer method
   def initialize
      db = SQLite3::Database.open 'db.sql'
      db.execute "CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY AUTOINCREMENT, firstname STRING, lastname STRING, age INTEGER, password STRING, email STRING)"
      db.close
   end

   #this is my personal attribute accersor 
   def my_attri_accersor(user_info)
      user = User.new
   
      if user_info
         user.id = user_info[0]
         user.firstname = user_info[1]
         user.lastname = user_info[2]
         user.age = user_info[3]
         user.password = user_info[4]
         user.email = user_info[5]
      end
   
      return user
   end

   #this method inserts a user into my database  and returns the users ID
   def create(user_info)
      @firstname = user_info[:firstname]
      @lastname = user_info[:lastname]
      @age = user_info[:age] 
      @password = user_info[:password] 
      @email = user_info[:email]

      db = SQLite3::Database.open 'db.sql'
      user = db.execute "INSERT INTO users (firstname, lastname, age, password, email) VALUES (?, ?, ?, ?, ?)", @firstname, @lastname, @age, @password, @email
      @id = db.last_insert_row_id
      db.close

   
      return @id
   end    

   #this method finds a user in my database using the users unique ID 
   def find(user_id)
      db = SQLite3::Database.open 'db.sql'
      user_info = db.execute "SELECT * FROM users WHERE id = ?", user_id
      db.close

      my_attri_accersor(user_info.first)
   end

   #this method returns all the users in my database
   def all
      db = SQLite3::Database.open 'db.sql'
      all_users = db.execute "SELECT * FROM users"
      db.close

      return all_users
   end

   #this method updates a users attribute 
   def update(user_id, attribute, value)
      db = SQLite3::Database.open 'db.sql'
      db.execute "UPDATE users SET #{attribute} = ? WHERE id = ?", value, user_id
      user_info = db.execute "SELECT * FROM users WHERE id = ?", user_id
      db.close

      my_attri_accersor(user_info.first)
   end

   def destroy(user_id)
      db = SQLite3::Database.open 'db.sql'
      db.execute "DELETE FROM users WHERE id = ? ", user_id
      db.close
   end


   def user_sign_in(email, password)
      db = SQLite3::Database.open 'db.sql'
      user_info = db.execute "SELECT * FROM users WHERE email = ? AND password = ?", email, password
      db.close

      my_attri_accersor(user_info.first)
   end
end


#you can test my methods using the below prompts one by one
=begin

inno = User.new

p inno.create(
   {
   firstname: "innoe",
   lastname: "baba",
   age: 73,
   password: "wqjhdtgtqw",
   email: "innoe@yahoo.com"
   }
)


p inno.find(1)

puts inno.all

p inno.update(1,"firstname", "innocent")

p inno.user_sign_in("inno.baba@qwasar.io","dkufsdfg12")

inno.destroy(1)

=end
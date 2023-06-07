require 'sinatra'
require_relative 'UserModel.rb'
enable :sessions

#this route displays all users in the db on a table without there password
get '/' do
    users = User.new
    @innos_users = users.all
    erb :index
end

#this route returns all users in the db in an array with thier password
get '/users' do
 users = User.new
 users.all.map { |element| element.to_json }

 #you can use below curl to request/test
 #curl -i http://localhost:4567/users
end


#this route craetes a user using the arguments passed in the curl request,
#pls ensure you pass all 5 aguments for 100% efficiency
post '/users' do 

    firstname = params[:firstname]
    lastname = params[:lastname]
    age = params[:age]
    password = params[:password]
    email = params[:email]

    user = User.new
    user.create(
        {
         firstname: firstname,
         lastname: lastname,
         age: age,
         password: password,
         email: email
        }
    )

    if user
        "A user created => ID NUMGER: #{user.id} firstname: #{user.firstname} lastname: #{user.lastname} age: #{user.age} email: #{user.email}."
    else
        status 500
        "server error"
    end

 #you can use below curl to request/test
 #curl -X POST -i http://localhost:4567/users -d "firstname=testing" -d "lastname=my users app" -d "age=100" -d "email=almost1.done@yahoo.com" -d "password=43562wqjhdtgtqw"
 #curl -X POST -d "firstname=John&lastname=Doe&age=25&password=helloword&email=johndoe@example.com" http://localhost:4567/users
end 



#this route checks if the password and email belongs to a user in the db, if True it signs in the user 
post '/sign_in' do 

    email = params[:email]
    password = params[:password]

    user = User.new

    user = user.user_sign_in(email, password)

    if user.id
        session[:user_id] = user.id
        return "User Logged In
        ID NUMBER: #{user.id} session id: #{session[:user_id]}
        firstname: #{user.firstname} lastname: #{user.lastname} age: #{user.age} email: #{user.email}."
    else
        status 401
        return "401! Sorry, you're not Authorized.
        Email or password is not correct."
    end

 #you can use below curl to request/test
 #curl -X POST -i http://localhost:4567/sign_in -d "email=almost1.done@yahoo.com" -d "password=43562wqjhdtgtqw" --cookie-jar cookies.txt
end


#this route updates a signed in users password
put '/users' do
    new_password = params[:password]

    
    user_id = session[:user_id]
    #user_id = 1
  
    if user_id
      user = User.new
      updated_user = user.update(user_id, 'password', new_password)
  
      if updated_user
        "password updated
        firstname: #{updated_user.firstname} lastname: #{updated_user.lastname} age: #{updated_user.age} email: #{updated_user.email}"
      else
        status 500
        "500! Sorry, something went wrong while updating the password"
      end
    else
      status 401
      "401! Sorry, you're not authorized, try requesing with session cookies"
    end


 #curl -X PUT -i http://localhost:4567/users -d "password=new_password" --cookie cookies.txt 
end


#this route signs a user out of a session 
delete '/sign_out' do
    session[:user_id] = nil
    status 204
   
 #curl -X DELETE -i http://localhost:4567/sign_out 
end 

#this route deletes a user from the DB
delete '/users' do
    user = User.new
    user.destroy(session[:user_id])
    session[:user_id] = nil
    status 204

 #curl -X DELETE -i http://localhost:4567/users --cookie cookies.txt
end

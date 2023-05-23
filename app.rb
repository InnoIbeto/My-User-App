require 'sinatra'

require_relative 'user.rb'

get '/' do
    erb :index
end

get '/users' do
  inno = User.new
  inno.all.map {|eachuser| eachuser.to_json}
end

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
        user.to_json
    else
        status 500
    end

end

#curl -X POST -d "firstname=John&lastname=Doe&age=25&password=helloword&email=johndoe@example.com" http://0.0.0.0:8080/users
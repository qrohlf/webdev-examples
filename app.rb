# app.rb
# This is where all of the controller logic for our app goes.
# Right now, it also handles reading the data from our text file "database"
# and rending it to html, but we'll be changing that up next week.

# use bundler
require 'rubygems'
require 'bundler/setup'
# load all of the gems in the gemfile
Bundler.require
require './models/TodoItem'
require './models/User'

# enable cookie-based sessions
enable :sessions
# set a secret used to encrypt the session cookie
# NOTE: best practice would be to store this value in
# an enviroment variable like ENV['SESSION_SECRET'] so
# that it's not checked in with our source code. For
# simplicity's sake, I'm not doing that here (but that means
# that anyone who can see this source code would be able to
# spoof cookies for this application)
set :session_secret, '85txrIIvTDe0AWPCvbeXuXXpULCWZgpoRo1LqY8YsR9GAbph0jfOHosvtY4QFxi6'

if ENV['DATABASE_URL']
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  ActiveRecord::Base.establish_connection(
    :adapter  => 'sqlite3',
    :database => 'db/development.db',
    :encoding => 'utf8'
  )
end

# Here we use the filters feature of Sinatra to run some
# code before EVERY route in the app. Notice that we are
# populating an instance (@) variable with the user -
# this is necesary to allow the user variable to be
# accessed in the other routes
before do
  @user = User.find_by(name: session[:name])
end

# We can now show a login page at / for logged-out
# visitors, and show a list of todos at / for logged-in
# visitors!
get '/' do
  if @user
    @tasks = @user.todo_items.order(:due)
    erb :todo_list
  else
    erb :login
  end
end

# Out login callback will recieve the submissions from
# the login form.
post '/login' do
  # Get a handle to a user with a name that matches the
  # submitted username. Returns nil if no such user
  # exists
  user = User.find_by(name: params[:name])

  if user.nil?
    # first, we check if the user is in our database
    @message = "User not found."
    erb :message_page

  elsif user.authenticate(params[:password])
    # if they are, we check if their password is valid,
    # then actually log in the user by setting a session
    # cookie to their username
    session[:name] = user.name
    redirect '/'

  else
    # if the password doesn't match our stored hash,
    # show a nice error page
    @message = "Incorrect password."
    erb :message_page
  end
end

# Our logout link simply deletes the session cookie and
# redirects the (now logged-out) user to the login page
get '/logout' do
  session.clear
  redirect '/'
end

# Handle the possiblity of errors while creating a new user
post '/new_user' do
  @user = User.create(params)
  if @user.valid?
    session[:name] = @user.name
    redirect '/'
  else
    @message = @user.errors.full_messages.join(', ')
    erb :message_page
  end
end

# because of the before filter, we no longer need to
# include the user id in our urls! We can simply
# reference the global @user variable.
post '/new_item' do
  @user.todo_items.create(description: params[:task], due: params[:date])
  redirect "/"
end

get '/delete_user' do
  @user.destroy
  redirect '/'
end

# since task ids are globally unique, we don't even need
# a user id to deleted them
get '/delete_item/:item' do
  @todo_item = TodoItem.find(params[:item])
  @user = @todo_item.user
  @todo_item.destroy
  redirect "/"
end

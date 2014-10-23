# app.rb
# This is where all of the controller logic for our app goes.
# Right now, it also handles reading the data from our text file "database"
# and rending it to html, but we'll be changing that up next week.

# use bundler
require 'rubygems'
require 'bundler/setup'
# load all of the gems in the gemfile
Bundler.require
require './models/User'
require './models/Email'

if ENV['DATABASE_URL']
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  ActiveRecord::Base.establish_connection(
    :adapter  => 'sqlite3',
    :database => 'db/development.db',
    :encoding => 'utf8'
  )
end


get '/' do
  @list = User.all.order(:name)
  erb :index
end

get '/Users' do
  @list = User.all.order(:name)
  erb :index
end

get '/Emails' do
  @list = Email.all
  erb :index
end


get '/User/:unicorn' do
  @model = User.find(params[:unicorn])
  erb :model
end

get '/delete/:id' do
  TodoItem.find(params[:id]).destroy
end

get '/Email/:id' do
  @model = Email.find(params[:id])
  erb :model
end
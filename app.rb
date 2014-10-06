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
  @tasks = TodoItem.all.order(:due)
  erb :index
end

post '/' do
  TodoItem.create(description: params[:task], due: params[:date])
  redirect '/'
end

get '/delete/:id' do
  TodoItem.find(params[:id]).destroy
  redirect '/'
end

helpers do
  # you can use helpers for common tasks, like determining if a
  # variable is nil or emptystring
  def blank?(x)
    x.nil? || x == ""
  end
end

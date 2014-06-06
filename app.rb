# app.rb
# This is where all of the controller logic for our app goes. 
# Right now, it also handles reading the data from our text file "database"
# and rending it to html, but we'll be changing that up next week.

# use bundler
require 'rubygems'
require 'bundler/setup'
# load all of the gems in the gemfile
Bundler.require

get '/' do
  lines = File.read("todo.txt").split("\n")
  @tasks = []
  lines.each do |line|
    task, date = line.split("-")
    @tasks << [task, date]
    # note that the same thing could be accomplished in 1 line:
    # @tasks << line.split("-")
  end
  erb :index
end

post '/' do
  File.open("todo.txt", "a") do |file|
    unless blank? params[:date]
      file.puts "#{params[:task]} - #{params[:date]}" 
    else
      file.puts "#{params[:task]}"
    end
  end
  redirect '/'
end

helpers do
  # you can use helpers for common tasks, like determining if a 
  # variable is nil or emptystring
  def blank?(x)
    x.nil? || x == ""
  end
end
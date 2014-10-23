require './app.rb'
require 'faker'

5.times do
  user = User.create(name: Faker::Name.name)
  10.times do
    Email.create(
      user: user,
      subject: Faker::Lorem.sentence(3),
      body: Faker::Lorem.sentence(5))
  end
end


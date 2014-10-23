class User < ActiveRecord::Base
  has_many :emails

  def to_s
    name
  end
end
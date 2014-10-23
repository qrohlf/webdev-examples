class Email < ActiveRecord::Base
  belongs_to :user

  def to_s
    id.to_s+" - "+subject
  end
end
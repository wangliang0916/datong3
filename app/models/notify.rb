class Notify < ActiveRecord::Base
  attr_accessible :content, :date, :time
  belongs_to :customer
end

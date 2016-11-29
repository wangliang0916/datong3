# encoding: utf-8
class Attachment < ActiveRecord::Base
  mount_uploader :file, FileUploader 
  attr_accessible :description, :file
  belongs_to :customer 

  validates_presence_of :file, message: "附件不能为空"
  validates_length_of :description, maximum: 250, message: "附件信息长度不能超过250个字符"
end

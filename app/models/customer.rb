# encoding: utf-8
class Customer < ActiveRecord::Base
  attr_accessible :mobile_phone, :name
  
  has_and_belongs_to_many :users, join_table: "users_customers"
  has_many :attachments, dependent: :destroy

  validates_presence_of :name, message: "姓名不能为空"
  validates_length_of :name, maximum: 20, message: "姓名长度不能超过20个字符", allow_blank: true

  VALID_PHONE_REGEX = /\d{11}/
  validates_presence_of :mobile_phone, message:"手机号码不能为空"
  validates_format_of :mobile_phone, with: VALID_PHONE_REGEX, message:"手机号码必须为11位数字", allow_blank: true 
  validates_uniqueness_of :mobile_phone,  allow_blank: true

before_save :create_pinyin
private
  def create_pinyin
    self.pinyin = PinYin.abbr(self.name)
  end
end

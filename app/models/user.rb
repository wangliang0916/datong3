# encoding: utf-8
class User < ActiveRecord::Base
  attr_accessible :mobile_phone, :name, :password, :password_confirmation
  has_secure_password

  has_and_belongs_to_many :customers, join_table: "users_customers"

  validates_presence_of :name, message: "姓名不能为空"
  validates_length_of :name, maximum: 20, message: "姓名长度不能超过20个字符", allow_blank: true

  VALID_PHONE_REGEX = /\d{11}/
  validates_presence_of :mobile_phone, message:"手机号码不能为空"
  validates_format_of :mobile_phone, with: VALID_PHONE_REGEX, message:"手机号码必须为11位数字", allow_blank: true 
  validates_uniqueness_of :mobile_phone,  allow_blank: true
  
  validates_presence_of :password, message:"密码不能为空" 
  validates_length_of :password, minimum: 6, message: "密码不能少于6位", allow_blank: true 
  validates_presence_of :password_confirmation, message:"两次密码不一致", allow_blank: true, allow_nil: true

  before_save :create_remember_token, :create_pinyin
private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  def create_pinyin
    self.pinyin = PinYin.abbr(self.name)
  end
end

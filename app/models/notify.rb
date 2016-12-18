# encoding: utf-8
class Notify < ActiveRecord::Base
  attr_accessible :content, :date, :time
  belongs_to :customer

  validates_presence_of :content, message: "通知内容不能为空"
  validates_length_of :content, maximum: 250, message: "通知内容不能超过250个字符", allow_blank: true
  validates_presence_of :date, message: "通知日期不能为空"
  validates_presence_of :time, message: "通知时间不能为空"
  VALID_TIME = /(0?[0-9]|1[0-9]|2[0-3]):(0?[0-9]|[1-5][0-9])/
  validates_format_of :time, with: VALID_TIME, message:"通知时间必须按格式hh:mm", allow_blank: true 
end

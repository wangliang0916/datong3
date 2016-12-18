# encoding: utf-8
class EveryMonthNotify < Notify
  VALID_DATE = /^(0?[1-9]|[1,2][0-9]|3[0,1])$/
  validates_format_of :date, with: VALID_DATE, message:"通知日期必须为一个月中的某一天", allow_blank: true 
end

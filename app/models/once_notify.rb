# encoding: utf-8
class OnceNotify < Notify
  VALID_DATE = /^\d{4}-(0?[1-9]|1[0-2])-(0?[1-9]|[1,2][0-9]|3[0,1])$/
  validates_format_of :date, with: VALID_DATE, message:"通知日期必须按格式yyyy-mm-dd", allow_blank: true 
end

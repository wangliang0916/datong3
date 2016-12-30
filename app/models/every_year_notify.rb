# encoding: utf-8
class EveryYearNotify < Notify
  VALID_DATE = /^(0?[1-9]|1[0-2])-(0?[1-9]|[1,2][0-9]|3[0,1])$/
  validates_format_of :date, with: VALID_DATE, message:"通知日期必须按格式mm-dd", allow_blank: true 

  def chinese_name
    "每年"
  end
end

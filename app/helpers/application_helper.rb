# encoding: utf-8
module ApplicationHelper
  #根据所在页面返回完整标题
  def full_title(page_title)
    base_title = "大童CRM"
    if page_title.empty?
      base_title
    else
      "#{base_title}_#{page_title}"  
    end
  end

  def create_time(obj)
    obj.created_at.strftime("%Y-%m-%d %H:%M")
  end

  def notify_type_of(notify, type_name)
    if notify.type == type_name
      true 
    else 
      false 
    end
  end

end

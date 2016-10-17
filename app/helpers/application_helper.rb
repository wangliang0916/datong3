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
end

module ApplicationHelper
  def page_title(page_name = '')
    base_title = 'Sample App'
    if page_name.empty?
      base_title
    else
      page_name + ' | ' + base_title
    end
  end
end

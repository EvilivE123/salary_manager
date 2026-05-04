module ApplicationHelper
  include Pagy::Frontend

  def sortable_column(column, title = nil)
    title ||= column.titleize
    direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
    icon = sort_icon(column)
    
    # link_to automatically updates the Turbo Frame if it's within one
    link_to "#{title} #{icon}".html_safe, 
            request.parameters.merge(sort: column, direction: direction), 
            data: { turbo_action: "replace" },
            class: "text-dark text-decoration-none"
  end

  private

  def sort_icon(column)
    return "" unless params[:sort] == column
    params[:direction] == "asc" ? "↑" : "↓"
  end  
end

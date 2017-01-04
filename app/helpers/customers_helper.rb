module CustomersHelper
  def search_path_by(all)
    if all 
      search_all_customers_path 
    else 
      search_customers_path 
    end
  end
end

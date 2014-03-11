
def fill_in_filter_form(params)
  params = {
    search_term: 'test',
    max_price: 1000,
    ending_time: 1,
    ending_time_unit: 'Day',
    sort_by: 'Ending Soonest'
  }.merge(params)

  page.find('#filter-form').fill_in "Search Term", with: params[:search_term]
  page.find('#filter-form').fill_in "Max Price", with: params[:max_price]
  page.find('#filter-form').fill_in "Ending Time", with: params[:ending_time]
  page.find('#filter-form').select params[:ending_time_unit], from: "end-unit"
  page.find('#filter-form').select params[:sort_by], from: "sort"
end

def fill_in_search_term_form(term)
  page.find('#search-term-form').fill_in "query", with: term
end

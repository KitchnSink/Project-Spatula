
def fill_in_filter_form(params = {})
  params.merge({
    term: 'test',
    max_price: 1000,
    ending_time: 1,
    ending_time_unit: 'Day',
    sort_by: 'Ending Soonest'
  })

  page.find('form#filter-form').fill_in "filter-form-search-term", with: params.term
  page.find('form#filter-form').fill_in "filter-form-max-price", with: params.max_price
  page.find('form#filter-form').fill_in "filter-form-ending-time", with: params.ending_time
  page.find('form#filter-form').select params.ending_time_unit, from: "filter-form-ending-time-unit"
  page.find('form#filter-form').select params.sort_by, from: "filter-form-sort-by"
end

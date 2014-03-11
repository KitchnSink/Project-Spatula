require "test_helper"

feature "I should be able to search ebay with custom filters" do
  # Need to use the webkit driver for these tests
  setup do
    Capybara.default_driver = :webkit
  end

  teardown do
    Capybara.default_driver = nil
  end

  scenario "Anyone can search" do
    # Given an anonymous user visits the filters page
    visit new_filter_path

    # After waiting 3 seconds results should be loaded
    fill_in_filter_form(search_term: 'Macbook Air')
    wait_ajax

    # The Search For title should be loaded
    page.find('.filter-title #query').text.must_include 'Macbook Air'
    # The 16 results should be loaded
    page.all('.search-grid li').count.must_equal 16
  end

  scenario "If no query given" do
    # Given an anonymous user visits the filters page
    visit new_filter_path

    # Fill in the Search Term with a blank
    fill_in_filter_form(search_term: '')
    wait_ajax

    # The Default error should 
    page.find('.search-grid li').text.must_include 'Search Term Required'
  end

  scenario "If a user loads more results" do
    # Given an anonymous user visits the filters page
    visit new_filter_path

    # After waiting 3 seconds results should be loaded
    fill_in_filter_form(search_term: 'Macbook Air')
    wait_ajax
    page.find('#filter-form').click_on 'Load More Results'
    wait_ajax

    # The 16 more results should be loaded    
    page.all('.search-grid li').count.must_equal 32
  end

end

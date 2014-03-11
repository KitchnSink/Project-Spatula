require "test_helper"

feature "I should be able to create savable ebay search filters" do

  scenario "Authenticated user can create a new filter" do
    # Given an authenticated user visits the filters page
    sign_in(:user)
    visit new_filter_path

    # When I submit the form
    fill_in_filter_form(search_term: 'Macbook Air')
    page.find('#filter-form').click_on "Save"

    # Then a new filter should be created and displayed
    page.find('h2.filter-title').text.must_include "Macbook Air"
  end

  scenario "Authenticated user can create a new filter from their homepage" do
    # Given an authenticated user visits the filters page
    sign_in(:user)

    # When I submit the form
    fill_in_search_term_form('Macbook Air')
    page.find('#search-term-form').click_on "Search"

    # Then I should end up on the search page with the search term field prefilled
    page.find('form #query').value.must_include "Macbook Air"
  end

  scenario "Anon user can create a new filter by logging in with an existing username/password" do
    # Given an anonymous user visits the filters page
    visit new_filter_path
    fill_in_filter_form(search_term: 'Macbook Air')

    # When I submit the form
    page.find('#filter-form').click_on "Save"

    # Then I should be forwarded to the login/signup page
    page.text.must_include "You need to sign in or sign up before continuing"

    fill_in_login_form(:user)

    # Then once I login, a new filter should be created and displayed
    page.find('h2.filter-title').text.must_include "Macbook Air"
  end

  scenario "Anon user can create a new filter by logging in with a new username/password" do
    # Given an anonymous user visits the filters page
    visit new_filter_path
    fill_in_filter_form(search_term: 'Macbook Air')

    # When I submit the form
    page.find('#filter-form').click_on 'Save'

    # Then I should be forwarded to the login/signup page
    page.text.must_include "You need to sign in or sign up before continuing"
    click_on "Create an account"

    # when I create an account
    fill_in_sign_up_form(:create_filter_test)

    # Then I should be redirected to the new filter
    page.text.must_include 'Macbook Air'
  end

end

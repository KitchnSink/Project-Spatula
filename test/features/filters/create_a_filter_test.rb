require "test_helper"

feature "I should be able to create savable ebay search filters" do

  scenario "Authenticated user can create a new filter" do
    # Given an authenticated user visits the filters page
    sign_in(:user)
    visit new_filter_path

    # When I submit the form
    fill_in_filter_form(search_search_term: 'Macbook Air')
    page.find('#filter-form').click_on "Save"

    # Then once I login, a new filter should be created and displayed
    page.text.must_include "Signed in successfully"
    page.find('h2.filter-title').text.must_include "Macbook Air"
  end

  scenario "Anon user can create a new filter by logging in with an existing username/password" do
    # Given an anonymous user visits the filters page
    visit new_filter_path
    fill_in_filter_form(search_term: 'Macbook Air')

    # When I submit the form
    page.find('#filter-form').click_on "Save"

    # Then I should be forwarded to the login/signup page
    page.text.must_include "Please login or create a new account to save your search results"

    fill_in_login_form(:user)

    # Then once I login, a new filter should be created and displayed
    page.text.must_include "Signed in successfully"
    page.find('h2.filter-title').text.must_include "Macbook Air"
  end

  scenario "Anon user can create a new filter by logging in with a new username/password" do
    # Given an anonymous user visits the filters page
    visit new_filter_path
    fill_in_filter_form(search_term: 'Macbook Air')

    # When I submit the form
    page.find('#filter-form').click_on 'Save'

    # Then I should be forwarded to the login/signup page
    page.text.must_include "Please login or create a new account to save your search results"

    # when I click on the
    click_on "Create Account"
    fill_in_sign_up_form(:user)

    # Then once I login, a new filter should be created and displayed
    page.text.must_include 'Welcome! You have signed up successfully.'
    page.find('h2.filter-title').text.must_include 'Macbook Air'
  end

end

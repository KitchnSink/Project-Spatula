require "test_helper"

feature 'As a user
        I want to be able to sign up for an account
        so that I can perform actions that require me to be logged in' do

  scenario "user submits registration form" do
    # Given a registration form
    visit "/"
    page.find('#header').click_on "Sign Up"

    # When I submit the login form with valid info
    fill_in_sign_up_form('sign_up_test')

    # Then I should be signed up
    page.text.must_include "Welcome! You have signed up successfully."
    page.text.wont_include "error prohibited this user from being saved"
    page.text.wont_include "errors prohibited this user from being saved"
  end
end

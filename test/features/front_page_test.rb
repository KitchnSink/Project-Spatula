require "test_helper"

feature "A front page to welcome users" do
  # As a user, I want to see a homepage, so I can introduced to the project
  scenario "Access the welcome page" do
    # Given I access the welcome page
    visit root_path

    # When I search the markup
    # The columns class is used
    page.find('h1').text.must_include "Introducing Spatula."
    page.find('h2').text.must_include "An easy online shopping tool for humans."
    page.must_have_selector(".row .columns")
  end

  # As a user, I want to see how many lists have been created, so I can be more confident in using the site
  scenario "There should be a counter that tells users how many lists have been created" do
    # Given I access the welcome page
    visit root_path
    listCount = Filter.all.size

    # When I search the markup
    # I can see the number of posts
    page.find('.subtitle').must_include listCount
  end

  # As a user, I want a search field on the homepage, so that I can start searching for products
  scenario "There should be a search input field that allows users to create their first filter" do
    # Given I access the welcome page
    visit root_path

    # When I search the markup
    # I can see the number of posts
    page.find('.subtitle').must_include listCount
  end

end

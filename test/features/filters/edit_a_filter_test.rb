require "test_helper"

feature "Editing a filter" do
  scenario "Admins can edit any filter" do
    # Given an admin user visiting an existing filter
    sign_in(:admin)
    page.find(".filter-list").click_on filters(:shirt).search_term

    # When the filter fields are updated and I click save
    fill_in_filter_form(search_term: 'TMNT Shirt')
    page.find('#filter-form').click_on "Save"

    # Then the filter is edited
    page.must_have_content "Filter was successfully updated."
    page.must_have_content 'TMNT Shirt'
  end

  scenario "Users can edit their own filter" do
    # Given an existing filter
    sign_in(:user)
    page.find(".filter-list").click_on filters(:iphone).search_term

    # When the edit link is clicked
    fill_in_filter_form(search_term: 'White iPhone 4s')
    page.find('#filter-form').click_on "Save"

    # Then the filter is edited
    page.must_have_content "Filter was successfully updated."
    page.must_have_content 'White iPhone 4s'

  end

  scenario "unauthenticated site visitors cannot see the edit form" do
    # given an anon user viewing a public filter page
    visit user_public_path users(:user).username

    # When the filter fields are updated and I click save
    page.find(".filter-list").click_on filters(:computer).search_term

    # I should not see the filter form
    page.must_have_content filters(:computer).search_term
    page.must_have_css 'input[type="hidden"]#query'
    page.wont_have_css 'input[type="text"]#query'

  end

  scenario "unauthorized users cannot see the edit form" do
    # Given I'm logged in as an user on another user's public page
    sign_in(:user_without_filters)
    visit user_public_path users(:user).username

    # when I click on a filter
    page.find(".filter-list").click_on filters(:computer).search_term

    # I should not see the filter form
    page.must_have_content filters(:computer).search_term
    page.must_have_css 'input[type="hidden"]#query'
    page.wont_have_css 'input[type="text"]#query'

  end
end

require "test_helper"

feature "Deleting a filter" do
  scenario "Admins can delete any filter with a click" do
    # Given an existing filter
    sign_in(:admin)

    # When the delete link is clicked
    page.find(".filter-list #filter-#{filters(:shirt).id}").click_on 'Delete'

    # Then the filter is deleted
    page.must_have_content "Filter was successfully deleted."
    page.wont_have_content filters(:shirt).search_term

  end

  scenario "Users can delete their own any filter with a click" do
    # Given an existing filter
    sign_in(:user)

    # When the delete link is clicked
    page.find(".filter-list #filter-#{filters(:iphone).id}").click_on 'Delete'

    # Then the filter is deleted
    page.must_have_content "Filter was successfully deleted."
    page.wont_have_content filters(:iphone).search_term

  end

  scenario "unauthenticated site visitors cannot see the delete button" do
    visit user_public_path users(:user).username
    page.find('.filter-list').must_have_content filters(:computer).search_term
    page.find('.filter-list').wont_have_content "Delete"
  end

  scenario "unauthorized users cannot see the delete button" do
    # Given I'm logged in as an user
    sign_in(:user_without_filters)

    # When I visit a filter that I didn't create
    visit user_public_path users(:user).username

    # I should not see the Delete button
    page.find('.filter-list').must_have_content filters(:computer).search_term
    page.find('.filter-list').wont_have_content "Delete"

  end

end

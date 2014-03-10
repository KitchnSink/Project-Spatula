require "test_helper"

feature "Publishing a filter" do
  scenario "Admins can publish any filter" do
    # Given an admin user visiting an existing filter
    sign_in(:admin)

    # When the publish link is clicked
    page.find(".filter-list #filter-#{filters(:iphone).id}").click_on 'Publish'

    # Then the filter is published
    page.must_have_content "Filter is now public."
    page.find(".filter-list #filter-#{filters(:iphone).id}").must_have_content 'Unpublish'
  end

  scenario "Users can publish their own filter" do
    # Given an existing filter
    sign_in(:user)

    # When the publish link is clicked
    page.find(".filter-list #filter-#{filters(:mba).id}").click_on 'Publish'

    # Then the filter is published
    page.must_have_content "Filter is now public."
    page.find(".filter-list #filter-#{filters(:mba).id}").must_have_content 'Unpublish'

  end

  scenario "Admins can unpublish any filter" do
    # Given an admin user visiting an existing filter
    sign_in(:admin)

    # When the publish link is clicked
    page.find(".filter-list #filter-#{filters(:computer).id}").click_on 'Unpublish'

    # Then the filter is published
    page.must_have_content "Filter is now private."
    page.find(".filter-list #filter-#{filters(:computer).id}").must_have_content 'Publish'
  end

  scenario "Users can unpublish their own filter" do
    # Given an existing filter
    sign_in(:user)

    # When the publish link is clicked
    page.find(".filter-list #filter-#{filters(:shirt).id}").click_on 'Unpublish'

    # Then the filter is published
    page.must_have_content "Filter is now private."
    page.find(".filter-list #filter-#{filters(:mba).id}").must_have_content 'Publish'

  end

  scenario "unauthenticated site visitors cannot see the publish button" do
    # given an anon user viewing a public filter page
    visit user_public_path users(:user).username

    # then I should not see the publish button
    page.find(".filter-list #filter-#{filters(:computer).id}").must_have_content filters(:computer).search_term
    page.find(".filter-list #filter-#{filters(:computer).id}").wont_have_content 'Publish'
    page.find(".filter-list #filter-#{filters(:computer).id}").wont_have_content 'Unpublish'

  end

  scenario "unauthenticated users cannot see the unpublished filters" do
    # Given I'm logged in as an user on another user's public page
    visit user_public_path users(:user).username

    # then I should not see the publish button
    page.must_have_css('.filter-list') # main list is present
    page.find(".filter-list #filter-#{filters(:shirt).id}").must_have_content filters(:shirt).search_term # published filter is present
    page.find(".filter-list").wont_have_content filters(:iphone).search_term # unpublished filter is not present
    page.wont_have_css(".filter-list #filter-#{filters(:iphone).id}") # unpublished filter is not present

  end

  scenario "unauthorized users cannot see the publish button" do
    # Given I'm logged in as an user on another user's public page
    sign_in(:user_without_filters)
    visit user_public_path users(:user).username

    # then I should not see the publish button
    page.find(".filter-list #filter-#{filters(:shirt).id}").must_have_content filters(:shirt).search_term
    page.find(".filter-list #filter-#{filters(:shirt).id}").wont_have_content 'Publish'
    page.find(".filter-list #filter-#{filters(:shirt).id}").wont_have_content 'Unpublish'

  end

  scenario "unauthorized users cannot see the unpublished filters" do
    # Given I'm logged in as an user on another user's public page
    sign_in(:user_without_filters)
    visit user_public_path users(:user).username

    # then I should not see the publish button
    page.must_have_css('.filter-list') # main list is present
    page.find(".filter-list #filter-#{filters(:shirt).id}").must_have_content filters(:shirt).search_term # published filter is present
    page.find(".filter-list").wont_have_content filters(:iphone).search_term # unpublished filter is not present
    page.wont_have_css(".filter-list #filter-#{filters(:iphone).id}") # unpublished filter is not present

  end
end

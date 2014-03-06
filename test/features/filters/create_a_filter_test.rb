require "test_helper"

feature "I should be able to create savable ebay search filters" do

  scenario "Anon user can create a new search" do
    # Given an anonymous user visits the filters page

    visit new_filter_path
    fill_in "Title", with: filters(:cr).title
    fill_in "Body", with: filters(:cr).body

    # When I submit the form
    click_on "Create Filter"

    # Then a new filter should be created and displayed
    page.text.must_include "Filter was successfully created"
    page.text.must_include filters(:cr).title
    page.has_css? "#author"
    page.text.must_include users(:author).username # Use your fixture name here.
    page.text.must_include "Status: Unpublished"
    page.find('article.filter').has_css? ".unpublished"
  end

  scenario "unauthenticated site visitors cannot see new filter button" do
    # When I visit the blog index page
    visit filters_path
    # Then I should not see the "New Filter" button
    page.wont_have_link "New Filter"
  end

  scenario "authors can't publish" do
    # Given an author's account
    sign_in(:author)

    # When I visit the new page
    visit new_filter_path

    # There is no checkbox for published
    page.wont_have_field('Published')
  end

  scenario "editors can publish" do
    # Given an editor's account
    sign_in(:editor)

    # When I visit the new page
    visit new_filter_path

    # There is a checkbox for published
    page.must_have_field('Published')

    # When I submit the form
    fill_in "Title", with: filters(:cr).title
    fill_in "Body", with: filters(:cr).body
    check "Published"
    click_on "Create Filter"

    # Then the published filter should be shown
    page.text.wont_include "Status: Unpublished"
    page.find('article.filter').has_css? ".published"
  end

end

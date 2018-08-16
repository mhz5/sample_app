require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "page title helper" do
    assert_equal page_title,         "Sample App"
    assert_equal page_title("Help"), "Help | Sample App"
  end
end

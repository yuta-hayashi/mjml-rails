require "test_helper"

class MjmlTest < ActiveSupport::TestCase

  test 'with Mjmltemplate processor' do
    assert_not_equal "<mj-body></mj-body>", Mjml::Mjmltemplate.to_html("<mjml><mj-body><mj-section><mj-column></mj-column></mj-section></mj-body></mjml>").strip
  end

end

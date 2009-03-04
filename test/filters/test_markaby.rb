require 'test/helper'

class Nanoc::Filters::MarkabyTest < MiniTest::Unit::TestCase

  def setup    ; global_setup    ; end
  def teardown ; global_teardown ; end

  def test_filter
    if_have 'markaby' do
      # Create filter
      filter = ::Nanoc::Filters::Markaby.new

      # Run filter
      result = filter.run("html do\nend")
      assert_equal("<html></html>", result)
    end
  end

end

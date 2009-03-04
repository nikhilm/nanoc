require 'test/helper'

class Nanoc::FilterTest < MiniTest::Unit::TestCase

  def setup    ; global_setup    ; end
  def teardown ; global_teardown ; end

  def test_initialize
    # Create filter
    filter = Nanoc::Filter.new

    # Test assigns
    assert_equal({}, filter.instance_eval { @assigns })
  end

  def test_assigns
    # Create filter
    filter = Nanoc::Filter.new({ :foo => 'bar' })

    # Check assigns
    assert_equal('bar', filter.assigns[:foo])
  end

  def test_run
    # Create filter
    filter = Nanoc::Filter.new

    # Make sure an error is raised
    assert_raises(NotImplementedError) do
      filter.run(nil)
    end
  end

  def test_filename_page
    # Mock items
    item = mock
    item.expects(:identifier).returns('/foo/bar/baz/')
    item_rep = mock
    item_rep.expects(:name).returns(:quux)

    # Create filter
    filter = Nanoc::Filter.new({ :_obj => item, :_obj_rep => item_rep, :page => mock })

    # Check filename
    assert_equal('page /foo/bar/baz/ (rep quux)', filter.filename)
  end

  def test_filename_asset
    # Mock items
    item = mock
    item.expects(:identifier).returns('/foo/bar/baz/')
    item_rep = mock
    item_rep.expects(:name).returns(:quux)

    # Create filter
    filter = Nanoc::Filter.new({ :_obj => item, :_obj_rep => item_rep, :asset => mock })

    # Check filename
    assert_equal('asset /foo/bar/baz/ (rep quux)', filter.filename)
  end

  def test_filename_unknown
    # Create filter
    filter = Nanoc::Filter.new({})

    # Check filename
    assert_equal('?', filter.filename)
  end

end

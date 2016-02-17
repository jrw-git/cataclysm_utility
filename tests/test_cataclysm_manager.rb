require "./lib/cataclysm_utility/cataclysm_manager.rb"
require "test/unit"

class TestCataclysmManager < Test::Unit::TestCase



  def test_a_setup
    Dir.mkdir("save") unless Dir.exist?("save")
    Dir.mkdir("save/Test World One") unless Dir.exist?("save/Test World One")
    Dir.mkdir("save/Test World Two") unless Dir.exist?("save/Test World Two")
    FileUtils.copy_entry("./test_data/Test World One", "./save/Test World One")
    FileUtils.copy_entry("./test_data/Test World Two", "./save/Test World Two")
    @@test_manager = CataclysmManager.new(Dir.pwd)
  end

  def test_scan_for_worlds_and_access
    assert_equal("Test World One",@@test_manager["Test World One"].name)
    assert_equal("Test World Two",@@test_manager["Test World Two"].name)
  end

  # all these call on things that are tested further in the test system
  def test_copy_char

  end

  def test_copy_world

  end

  def test_copy_vehicle

  end

  def test_save_vehicle

  end

  def test_delete_char

  end

  def test_delete_world

  end

  def test_print_vehicle_names

  end

  def test_do_action

  end

  def test_zzz_cleanup
    #FileUtils.remove_entry("save")
  end

end

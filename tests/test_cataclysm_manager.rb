require "./lib/cataclysm_utility/cataclysm_manager.rb"
require "test/unit"

class TestCataclysmManager < Test::Unit::TestCase

  @@test_manager = CataclysmManager.new
  
  def test_scan_for_worlds
    assert_equal("TESTDONOTDELETE",@@test_manager["TESTDONOTDELETE"].name)
    assert_equal("NEW_WORLD",@@test_manager["NEW_WORLD"].name)
  end

  def test_array_access
    # kinda tested for it already in scan for worlds
    assert_equal("TESTDONOTDELETE",@@test_manager["TESTDONOTDELETE"].name)
    assert_equal("NEW_WORLD",@@test_manager["NEW_WORLD"].name)
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
  
end
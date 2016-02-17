#require "./lib/cataclysm_utility/cataclysm_world.rb"
#require "./lib/cataclysm_utility/cataclysm_character.rb"
#require "./lib/cataclysm_utility/cataclysm_vehicle.rb"
#require "./lib/cataclysm_utility/ui.rb"
require "./lib/cataclysm_utility/cataclysm_manager"
require "test/unit"
#require "FileUtils"
#require "json"
#require "base64"

class TestCataclysmWorld < Test::Unit::TestCase

  def test_a_setup
    Dir.mkdir("save") unless Dir.exist?("save")
    Dir.mkdir("save/Test World One") unless Dir.exist?("save/Test World One")
    Dir.mkdir("save/Test World Two") unless Dir.exist?("save/Test World Two")
    FileUtils.copy_entry("./test_data/Test World One", "./save/Test World One")
    FileUtils.copy_entry("./test_data/Test World Two", "./save/Test World Two")
    @@test_world = CataclysmWorld.new("Test World One")
  end

  def test_initialize
    assert_equal(@@test_world.name, "Test World One")
  end

  def test_array_access
    assert_equal(@@test_world["Test Guy One"].name, "Test Guy One")
  end

  def test_each_character
    @@test_world.each_character do |name, character|
      assert_equal(name, character.name)
    end
  end

  def test_each_vehicle
    index = 0
    @@test_world.each_vehicle do |vehicle_in_map, map_filename, sub_array, map_index|
      index += 1
    end
    assert_equal(index, 5)
  end

  def test_grab_vehicle
    test_vehicle = @@test_world.grab_vehicle("WoodTest")
    assert_equal("WoodTest", test_vehicle.name)
    assert_equal(Hash.new.class, test_vehicle.to_h.class)
  end

  def test_replace_vehicle
    other_world = CataclysmWorld.new("Test World Two")
    woodtest_file = File.open("test_data/validated_woodtest.json",'r')
    validated_woodtest_json = JSON.load(woodtest_file)
    woodtest_file.close
    validated_woodtest_vehicle = CataclysmVehicle.new(validated_woodtest_json)
    other_world.replace_vehicle("SimpleBox1", validated_woodtest_vehicle)
    other_world.replace_vehicle("SimpleBox2", validated_woodtest_vehicle)
    other_world.replace_vehicle("SimpleBox3", validated_woodtest_vehicle)
    other_world.replace_vehicle("SimpleBox4", validated_woodtest_vehicle)
    other_world.replace_vehicle("SimpleBox5", validated_woodtest_vehicle)
    post_replacement_file = File.open("save/Test World Two/maps/3.1.0/126.42.0.map", 'r')
    post_replacement_string = post_replacement_file.read
    post_replacement_file.close
    validated_successful_replacement_file = File.open("test_data/validated_copy_woodbox_126.42.0.map", 'r')
    validated_successful_replacement_string = validated_successful_replacement_file.read
    validated_successful_replacement_file.close
    validated_successful_replacement_file_two = File.open("test_data/validated_modified_from_saved_json_126.42.0.map", 'r')
    validated_successful_replacement_string_two= validated_successful_replacement_file_two.read
    validated_successful_replacement_file_two.close
    assert_equal(post_replacement_string, validated_successful_replacement_string)
    assert_equal(validated_successful_replacement_string_two, validated_successful_replacement_string)
  end

  def test_find_characters
    assert_equal(@@test_world["Test Guy One"].name,"Test Guy One")
    assert_equal(@@test_world["Johan Copied One"].name,"Johan Copied One")
  end

  def test_save_me
    @@test_world.save_me("testing_world_saving")
    assert_equal(true, Dir.exist?("save/testing_world_saving"))
    assert_equal(true, Dir.exist?("save/testing_world_saving/maps/3.4.0"))
    assert_equal(true, File.exist?("save/testing_world_saving/maps/3.5.0/126.160.0.map"))
    assert_equal(true, File.exist?("save/testing_world_saving/#VGVzdCBHdXkgT25l.sav"))
  end

  def test_zdelete_me
    new_world = CataclysmWorld.new("testing_world_saving")
    new_world.delete_me
    assert_equal(false, Dir.exist?("save/testing_world_saving"))
    assert_equal(false, Dir.exist?("save/testing_world_saving/maps/3.4.0"))
    assert_equal(false, File.exist?("save/testing_world_saving/maps/3.5.0/126.160.0.map"))
    assert_equal(false, File.exist?("save/testing_world_saving/#VGVzdCBHdXkgT25l.sav"))
  end

  def test_zzz_cleanup
    FileUtils.remove_dir("save")
  end


end

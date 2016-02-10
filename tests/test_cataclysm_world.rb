require "./lib/cataclysm_utility/cataclysm_world.rb"
require "test/unit"

class TestCataclysmWorld < Test::Unit::TestCase

  @@test_world = CataclysmWorld.new("TESTDONOTDELETE")
  
  @@validated_vehicle_hash = {"type"=>"none", "posx"=>2, "posy"=>5, "om_id"=>0, "faceDir"=>45, "moveDir"=>0, "turn_dir"=>45, "velocity"=>0, "falling"=>false, "cruise_velocity"=>0, "vertical_velocity"=>0, "cruise_on"=>true, "engine_on"=>false, "tracking_on"=>false, "lights_on"=>false, "stereo_on"=>false, "chimes_on"=>false, "overhead_lights_on"=>false, "fridge_on"=>false, "recharger_on"=>false, "skidding"=>false, "turret_mode"=>0, "of_turn_carry"=>0.0, "name"=>"Clutter", "parts"=>[{"id"=>"xlframe_vertical_2", "mount_dx"=>0, "mount_dy"=>0, "hp"=>175, "amount"=>0, "blood"=>0, "bigness"=>0, "enabled"=>true, "flags"=>0, "passenger_id"=>0, "items"=>[], "target_first_x"=>0, "target_first_y"=>0, "target_first_z"=>0, "target_second_x"=>0, "target_second_y"=>0, "target_second_z"=>0}], "tags"=>[], "labels"=>[], "is_locked"=>false, "is_alarm_on"=>false, "camera_on"=>false, "dome_lights_on"=>false, "aisle_lights_on"=>false, "has_atomic_lights"=>false, "last_update_turn"=>1113143, "scoop_on"=>false, "plow_on"=>false, "reaper_on"=>false, "planter_on"=>false, "pivot"=>[0, 0]}

  def test_initialize
    assert_equal(@@test_world.name, "TESTDONOTDELETE")
  end
  
  def test_array_access
    assert_equal(@@test_world["Fresh Start Evac"].name, "Fresh Start Evac")
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
    assert_equal(index, 19)
  end
  
  def test_grab_vehicle
    test_vehicle = @@test_world.grab_vehicle("Electric Scooter")
    assert_equal("Electric Scooter", test_vehicle.name)
    assert_equal(Hash.new.class, test_vehicle.to_h.class)
  end

  def test_replace_vehicle
    other_world = CataclysmWorld.new("NEW_WORLD")
    FileUtils.cp("save/NEW_WORLD/maps/2.4.0/Backup86.144.0","save/NEW_WORLD/maps/2.4.0/86.144.0.map")
    other_world.replace_vehicle("Electric Scooter", CataclysmVehicle.new(@@validated_vehicle_hash))
    post_replacement_file = File.open("save/NEW_WORLD/maps/2.4.0/86.144.0.map", 'r')
    post_replacement_string = post_replacement_file.read
    post_replacement_file.close
    validated_successful_replacement_file = File.open("save/NEW_WORLD/maps/2.4.0/Copied86.144.0", 'r')
    validated_successful_replacement_string = validated_successful_replacement_file.read
    validated_successful_replacement_file.close
    assert_equal(post_replacement_string, validated_successful_replacement_string)
  end

  def test_find_characters
    assert_equal(@@test_world["Delete Me"].name,"Delete Me")
    assert_equal(@@test_world["Fresh Start Evac"].name,"Fresh Start Evac")
  end
  
  def test_save_me
    @@test_world.save_me("testing_world_saving")
    assert_equal(true, Dir.exist?("save/testing_world_saving"))
    assert_equal(true, Dir.exist?("save/testing_world_saving/maps/4.1.0"))
    assert_equal(true, File.exist?("save/testing_world_saving/maps/4.3.0/150.108.0.map"))
    assert_equal(true, File.exist?("save/testing_world_saving/#RGVsZXRlIE1l.sav"))
  end

  def test_zzdelete_me
    new_world = CataclysmWorld.new("testing_world_saving")
    new_world.delete_me
    assert_equal(false, Dir.exist?("save/testing_world_saving"))
    assert_equal(false, Dir.exist?("save/testing_world_saving/maps/4.1.0"))
    assert_equal(false, File.exist?("save/testing_world_saving/maps/4.3.0/150.108.0.map"))
    assert_equal(false, File.exist?("save/testing_world_saving/#RGVsZXRlIE1l.sav"))
  end

  def test_print_characters
    proper_return = "Character: Delete Me (World: TESTDONOTDELETE)\nCharacter: Fresh Start Evac (World: TESTDONOTDELETE)\n"
    puts @@test_world.print_characters
    puts proper_return
    assert_equal(proper_return, @@test_world.print_characters)
  end

end
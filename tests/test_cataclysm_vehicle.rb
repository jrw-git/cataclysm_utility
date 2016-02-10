require "./lib/cataclysm_utility/cataclysm_vehicle.rb"
require "test/unit"
require "json"

class TestCataclysmVehicle < Test::Unit::TestCase

@@validated_vehicle_hash = {"type"=>"none", "posx"=>0, "posy"=>0, "om_id"=>0, "faceDir"=>0, "moveDir"=>0, "turn_dir"=>0, "velocity"=>0, "falling"=>false, "cruise_velocity"=>0, "vertical_velocity"=>0, "cruise_on"=>true, "engine_on"=>false, "tracking_on"=>false, "lights_on"=>false, "stereo_on"=>false, "chimes_on"=>false, "overhead_lights_on"=>false, "fridge_on"=>false, "recharger_on"=>false, "skidding"=>false, "turret_mode"=>0, "of_turn_carry"=>0.0, "name"=>"Clutter", "parts"=>[{"id"=>"xlframe_vertical_2", "mount_dx"=>0, "mount_dy"=>0, "hp"=>175, "amount"=>0, "blood"=>0, "bigness"=>0, "enabled"=>true, "flags"=>0, "passenger_id"=>0, "items"=>[], "target_first_x"=>0, "target_first_y"=>0, "target_first_z"=>0, "target_second_x"=>0, "target_second_y"=>0, "target_second_z"=>0}], "tags"=>[], "labels"=>[], "is_locked"=>false, "is_alarm_on"=>false, "camera_on"=>false, "dome_lights_on"=>false, "aisle_lights_on"=>false, "has_atomic_lights"=>false, "last_update_turn"=>1, "scoop_on"=>false, "plow_on"=>false, "reaper_on"=>false, "planter_on"=>false, "pivot"=>[0, 0]}

@@valid_json_vehicle_string = '{"type":"none","posx":0,"posy":0,"om_id":0,"faceDir":0,"moveDir":0,"turn_dir":0,"velocity":0,"falling":false,"cruise_velocity":0,"vertical_velocity":0,"cruise_on":true,"engine_on":false,"tracking_on":false,"lights_on":false,"stereo_on":false,"chimes_on":false,"overhead_lights_on":false,"fridge_on":false,"recharger_on":false,"skidding":false,"turret_mode":0,"of_turn_carry":0.0,"name":"Clutter","parts":[{"id":"xlframe_vertical_2","mount_dx":0,"mount_dy":0,"hp":175,"amount":0,"blood":0,"bigness":0,"enabled":true,"flags":0,"passenger_id":0,"items":[],"target_first_x":0,"target_first_y":0,"target_first_z":0,"target_second_x":0,"target_second_y":0,"target_second_z":0}],"tags":[],"labels":[],"is_locked":false,"is_alarm_on":false,"camera_on":false,"dome_lights_on":false,"aisle_lights_on":false,"has_atomic_lights":false,"last_update_turn":1,"scoop_on":false,"plow_on":false,"reaper_on":false,"planter_on":false,"pivot":[0,0]}'
  
  def test_a_setup_provide_good_json
    test_load_file = File.open("./test_data/test_vehicle/Clutter.json", 'w')
    test_load_file.write(@@valid_json_vehicle_string)
    test_load_file.close
  end
  
  def test_load_from_file
    test_load_file = File.open("./test_data/test_vehicle/Clutter.json", 'r')
    test_load = JSON.load(test_load_file)
    test_load_file.close
    assert_equal("Clutter", test_load["name"])
    assert_equal("xlframe_vertical_2", test_load["parts"][0]["id"])
    new_vehicle = CataclysmVehicle.new(test_load)
    assert_equal("Clutter", new_vehicle.name)
    assert_equal(@@validated_vehicle_hash, test_load)
  end
  
  def test_save_to_file
    new_vehicle = CataclysmVehicle.new(@@validated_vehicle_hash)
    new_vehicle.save_to_file("test_vehicle_save")
    test_read_file = File.open("test_vehicle_save.json", 'r')
    test_read = test_read_file.read
    assert_equal('"name":"Clutter"', test_read.slice('"name":"Clutter"'))
    assert_equal('"parts":[{"id":"xlframe_vertical_2","mount_dx":0,"mount_dy":0,"hp":175,', 
                test_read.slice('"parts":[{"id":"xlframe_vertical_2","mount_dx":0,"mount_dy":0,"hp":175,'))
    test_read_file.close
    File.delete("test_vehicle_save.json")
  end
  
  def test_set_pos
    new_vehicle = CataclysmVehicle.new(@@validated_vehicle_hash)
    old_pos = new_vehicle.get_pos
    new_vehicle.set_pos([5,10])
    good_pos = [5, 10]
    assert_equal(good_pos, new_vehicle.get_pos)
  end
  
  def test_get_pos
    new_vehicle = CataclysmVehicle.new(@@validated_vehicle_hash)
    good_pos = [0, 0]
    assert_equal(good_pos, new_vehicle.get_pos)
  end
  
  def test_name
    new_vehicle = CataclysmVehicle.new(@@validated_vehicle_hash)
    assert_equal("Clutter", new_vehicle.name)
  end
  
  def test_to_h
    new_vehicle = CataclysmVehicle.new(@@validated_vehicle_hash)
    assert_equal("Clutter", new_vehicle.name)
  end
  
end
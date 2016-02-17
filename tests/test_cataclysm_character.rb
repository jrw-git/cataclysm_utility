require "./lib/cataclysm_utility/cataclysm_character.rb"
require "./lib/cataclysm_utility/cataclysm_manager"
require "test/unit"
#require "json"
#require "base64"
#require "FileUtils"
#require "./lib/cataclysm_utility/ui.rb"

class TestCataclysmCharacter < Test::Unit::TestCase

  ACTIVE_DIR = "./save/test_world"
  SOURCE_DIR = "./test_data"
  REAL_NAME = "Fresh Start Evac"
  ENCODED_NAME = "#RnJlc2ggU3RhcnQgRXZhYw=="

  def test_a_setup
    # copy over a saved test character to a world for testing
    Dir.mkdir("./save") unless Dir.exist?("./save")
    Dir.mkdir(ACTIVE_DIR) unless Dir.exist?(ACTIVE_DIR)
    Dir.glob("#{SOURCE_DIR}/*").each do |filename|
      FileUtils.cp(filename, ACTIVE_DIR) unless Dir.exist?(filename)
    end
    @@test_char = CataclysmCharacter.new("#{ACTIVE_DIR}/#{ENCODED_NAME}.sav")
    @@char_to_test_world_remove = CataclysmCharacter.new("#{ACTIVE_DIR}/#{ENCODED_NAME}.sav")
    #FileUtils.remove_dir(ACTIVE_DIR)
  end

  def test_load_character_from_file
    assert_equal(REAL_NAME, @@test_char.name)
    assert_equal("test_world", @@test_char.character_world)
    assert_equal("#{ACTIVE_DIR}/#{ENCODED_NAME}.sav", @@test_char.character_path)
    assert_equal(4, @@test_char.list_of_related_char_files.size)
  end

  def test_get_pos
    pos = @@test_char.get_pos
    correct_pos = [139,257,0,0,0,70,71,0]
    assert_equal(pos, correct_pos)
  end

  def test_set_pos
    new_pos = [100,200,0,0,0,70,70,0]
    @@test_char.set_pos(new_pos)
    assert_equal(@@test_char.get_pos, new_pos)
  end

  def test_remove_world_specific_json_information
    @@char_to_test_world_remove.remove_world_specific_json_information
    assert_equal(2, @@char_to_test_world_remove.list_of_related_char_files.size)
  end

  def test_write_character_json
    test_name = "test_json_write"
    encoded_test_name = "#" + Base64.encode64(test_name).chomp
    @@test_char.write_character_json(test_name,"temp_world")
    saved_file = File.open("./save/temp_world/#{encoded_test_name}.sav", 'r')
    saved_data = saved_file.readline.chomp
    assert_equal(saved_data,"# version 25")
    saved_data = saved_file.read
    assert_equal(saved_data.slice("61 1 98 1 140 1 96 1 72 1 38 1 17 1 5 1"), "61 1 98 1 140 1 96 1 72 1 38 1 17 1 5 1")
    saved_file.close
    File.delete("./save/temp_world/#{encoded_test_name}.sav")
  end

  def test_save_me
    new_pos = [100,200,0,0,0,70,70,0]
    Dir.mkdir("./save/temp_world") unless Dir.exist?("./save/temp_world")
    encoded_name = "#" + Base64.encode64("test_of_saving").chomp
    @@test_char.save_me("test_of_saving","temp_world", new_pos)
    assert_equal(File.exist?("./save/temp_world/#{encoded_name}.sav"),true)
    assert_equal(File.exist?("./save/temp_world/#{encoded_name}.apu.json"),true)
    assert_equal(File.exist?("./save/temp_world/#{encoded_name}.log"),true)
    assert_equal(File.exist?("./save/temp_world/#{encoded_name}.weather"),false)
    FileUtils.rm (Dir.glob("#{encoded_name}.*"))
  end

  def test_zdelete_me
    new_pos = [100,200,0,0,0,70,70,0]
    Dir.mkdir("./save/temp_world") unless Dir.exist?("./save/temp_world")
    @@test_char.save_me("test_of_deletion","temp_world", new_pos)
    encoded_name = "#" + Base64.encode64("test_of_deletion").chomp
    loaded_char = CataclysmCharacter.new("./save/temp_world/#{encoded_name}.sav")
    loaded_char.delete_me
    assert_equal(File.exist?("./save/temp_world/#{encoded_name}.sav"),false)
    assert_equal(File.exist?("./save/temp_world/#{encoded_name}.apu.json"),false)
    assert_equal(File.exist?("./save/temp_world/#{encoded_name}.log"),false)
  end

  def test_zzz_cleanup
    #FileUtils.remove_entry("save")
  end


end

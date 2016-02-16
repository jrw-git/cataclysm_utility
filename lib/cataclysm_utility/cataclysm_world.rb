
class CataclysmWorld

  attr_reader :name

  def initialize(world_name)
    @name = world_name
    @character_tracker = find_characters()
  end

  def [](name)
    # array-style access to the characters found based on character name
    return @character_tracker[name]
  end

  def get_mods
    if File.exist?("./save/#{@name}/mods.json")
      mod_file = File.open("save/#{@name}/mods.json", 'r')
      mod_list = JSON.load(mod_file)
      mod_file.close
    else
      mod_list = "none"
    end
    return mod_list
  end

  def each_character
    # iterator for characters, yields a simple name and the character instance itself
    @character_tracker.each do |name, char_object|
      yield(name, char_object)
    end
    return self
  end

  def each_vehicle
    # iterator for vehicles, yields the vehicle, the file name, and debug data
    # the sub_array is for multiple vehicles close together
    # the game saves them as an array-style. can be used for debugging.
    list_of_map_files = Dir.glob("save/#{@name}/maps/**/*.map")
    list_of_map_files.each do |map_filename|
      opened_map_file = File.open(map_filename, 'r+')
      source_map_json = JSON.load(opened_map_file)
      opened_map_file.close
      source_map_json.each_index do |map_index|
        sub_array = 0
        source_map_json[map_index]["vehicles"].each do |vehicle_in_map|
          yield(vehicle_in_map, map_filename, sub_array, map_index)
          sub_array += 1
        end
      end
    end
  end

  def grab_vehicle(search_string)
    # searches every map file in the world for a string occurance of the name
    # can be tricked by common things found in the map, thus the demand for a unique name
    # builds an array of results but kicks up a fuss if anything but one result is found
    array_of_results = Array.new
    self.each_vehicle do |vehicle, filename|
      if vehicle["name"] == search_string
        UI.display("Found vehicle name: #{search_string} in file #{filename}. Grabbing vehicle.", true)
        array_of_results << CataclysmVehicle.new(vehicle)
      end
    end
    unless array_of_results.size > 0
      UI.display("Vehicle not found. Try again.")
      # returning nil flags that we should keep trying
      return nil
    end
    if array_of_results.size > 1
      UI.display("Too many vehicles by that name found. Try again.")
      # returning nil flags that we should keep trying
      return nil
    end
    return array_of_results[0]
  end

  def replace_vehicle(search_string, source_vehicle)
    # replace found vehicle with our source vehicle
    # tricky because we need to load the map file into json, then edit it, then save it out
    # TODO, mesh better with vehicle iterator?
    success = false
    self.each_vehicle do |vehicle, filename, v_index, map_index|
      # find the map file
      if vehicle["name"] == search_string
        UI.display("Vehicle replacement found, name: #{search_string} in file #{filename}", true)
        # load in the map file (r+ lets us write to it later (we rewind it))
        opened_map_file = File.open(filename, 'r+')
        map_json = JSON.load(opened_map_file)
        # grab + set positional data
        target_pos = [vehicle["pos_x"],vehicle["pos_y"]]
        #source_vehicle.set_pos(target_pos)
        # replace vehicle
        map_json[map_index]["vehicles"][v_index] = source_vehicle.to_h
        # save data out in entirety
        opened_map_file.rewind
        opened_map_file.write(JSON.generate(map_json))
        opened_map_file.close
        success = true
        UI.display("Vehicle replaced. Source: #{source_vehicle.name}. Target: #{search_string}", true)
      end
    end
    if success
      puts "Vehicle replacement successful."
    else
      puts "Failed to find a vehicle by that name, try again..."
    end
  end

  def find_characters()
    # character file name is character name in base64 encoding plus ".sav"
    list_of_character_saves = Dir.glob("save/#{@name}/*.sav")
    character_tracker = Hash.new
    list_of_character_saves.each do |filename|
      name = Base64.decode64(filename.split("/")[-1][0...-4])
      character_tracker[name] = CataclysmCharacter.new(filename)
    end
    return character_tracker
  end

  def delete_me
    # TODO: Exception
    FileUtils.remove_dir("save/#{@name}")
    UI.display("Done deleting world #{@name}", true)
  end

  def save_me(new_name)
    # TODO: Exception
    UI.display("Copying world from #{@name} to #{new_name}, may take a while.", true)
    FileUtils.copy_entry("save/#{@name}", "save/#{new_name}")
    UI.display("Done copying world to #{new_name}", true)
  end

end

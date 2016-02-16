#$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
#$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), 'cataclysm_utility'))
require "base64"
require "json"
require "fileutils"
require "English"

require_relative "cataclysm_vehicle"
require_relative "cataclysm_world"
require_relative "cataclysm_character"
require_relative "ui"

class CataclysmManager

  def initialize(starting_directory)
    @original_directory = starting_directory
    @world_tracker = new_scan_for_worlds()
  end

  def each_world
    # iterator for worlds, yields a simple name and the instance of the world itself.
    @world_tracker.each do |name, world_object|
      yield(name, world_object)
    end
    return self
  end

  def [](name)
    # array-style access to worlds in the manager based on world name
    return @world_tracker[name]
  end

  def new_scan_for_worlds
    unless Dir.exist?("save")
      # check if we're in the CDDA directory
      # search a level up in directory structure
      directories_near_to_ours = Dir.glob("../*/*")
      directories_near_to_ours += Dir.glob("./*/*")
      directories_near_to_ours.each do |name|
        split_name_array = name.split("/")
        # is the directory "save" at the end?
        if split_name_array[-1] == "save"
          # get rid of the "save"
          split_name_array.pop
          # change to the directory above the "save"
          # ie the cataclysm directory
          Dir.chdir(split_name_array.join("/"))

        end
      end
    end
    # now that we've changed to the supposed cdda directory, check if there's a save dir again
    if Dir.exist?("save")
      savegame_list = Dir.entries("save")
      # delete all non-savegame directories from our list of saves
      savegame_list.delete(".")
      savegame_list.delete("..")
    else
      UI.display("Couldn't find a save directory, a few things could be wrong.", true)
      UI.display("The program could be bugged, or you could be running it from the wrong location", true)
      UI.display("Try running it inside the Catalcysm directory, or in a directory next to it or above it.", true)
      UI.display("Also, you might have installed Cataclysm but never actually run the program.", true)
      UI.display("Our current directory is #{Dir.pwd}", true)
      UI.display("Exiting in 5 seconds...", true)
      sleep(5)
      exit(1)
    end
    world_hash = Hash.new
    savegame_list.each do |world|
      world_hash[world] = CataclysmWorld.new(world)
    end
    return world_hash
  end

  def copy_char
    # gets all the UI data for copying a character
    # need originating character, a target world, a target character's position, and a new name
    UI.display("Copying/moving/renaming/backing-up a character.")
    UI.print_character_directions
    desired_world = UI.pick_a_world(self)
    character_ref = UI.pick_a_character(desired_world)
    UI.display("Pick a target world to copy #{character_ref.name} to:")
    target_world = UI.pick_a_world(self)
    UI.display("Choose target character in #{target_world.name}, we will move to their position.")
    target_pos = UI.pick_a_character(target_world).get_pos
    UI.display("Now we need a new character name for the copied character.")
    character_ref.save_me(UI.get_input("Enter new character name"), target_world.name, target_pos)
  end

  def copy_world
    # just need a name to copy the world
    UI.display("Copying/renaming/backing-up a world.")
    UI.pick_a_world(self).save_me(UI.get_input("To where?"))
  end

  def copy_vehicle
    # need unique names and worlds for the vehicle search to succeed
    UI.display("Copying a vehicle between worlds.")
    UI.print_vehicle_directions
    # keep looking for a vehicle until the user puts in a name that matches with one
    begin
      source_world = UI.pick_a_world(self)
      UI.print_unique_vehicles(source_world)
      source_vehicle = source_world.grab_vehicle(UI.get_vehicle_input("Source"))
    end while source_vehicle == nil
    target_world = UI.pick_a_world(self)
    if source_world.get_mods == target_world.get_mods
      UI.display("Worlds have identical mod list, continuing")
    else
      UI.print_vehicle_warning
    end
    UI.print_unique_vehicles(target_world)
    target_world.replace_vehicle(UI.get_vehicle_input("Destination"), source_vehicle)
  end

  def save_vehicle
    # saves in subdirectory 'saved_vehicles' under json extension in json format
    # extracts the vehicle hash from the map file
    Dir.mkdir("#{@original_directory}/saved_vehicles") unless Dir.exist?("#{@original_directory}/saved_vehicles")
    UI.display("Saving vehicle to a JSON file (.json), in #{@original_directory}/saved_vehicles")
    # keep looking for a vehicle until the user puts in a name that matches with one
    begin
      source_world = UI.pick_a_world(self)
      UI.print_unique_vehicles(source_world)
      source_vehicle = source_world.grab_vehicle(UI.get_vehicle_input("Source"))
    end while source_vehicle == nil
    save_name = UI.get_input("Enter a name for the saved vehicle:")
    source_vehicle.save_to_file("#{@original_directory}/saved_vehicles/" + save_name)
    mod_list = File.open("#{@original_directory}/saved_vehicles/" + save_name + ".modlist", 'w')
    mod_list.write(source_world.get_mods)
    mod_list.close
  end

  def load_vehicle
    # this function assumes the json is valid.
    # TODO: exception handling for json loading
    # overwrites target vehicle with loaded vehicle
    UI.display("Loading vehicle from JSON files (.json) in #{@original_directory}/saved_vehicles")
    UI.print_vehicle_directions
    UI.display("Pick a vehicle from the ones saved in the Cataclysm directory:")
    list_of_vehicle_jsons = Dir.glob("#{@original_directory}/saved_vehicles/*#{CataclysmVehicle::VEHICLE_FILENAME_SUFFIX}")
    list_of_vehicle_jsons.each_index do |index|
      # leave off the .json for user convenience
      UI.display(File.basename(list_of_vehicle_jsons[index], ".json"))
    end
    begin
      v_name = UI.get_input("Enter the name of the saved vehicle to load:")
      UI.display("Couldn't find vehicle by that name.") unless File.exist?("#{@original_directory}/saved_vehicles/#{v_name}.json")
    end until File.exist?("#{@original_directory}/saved_vehicles/#{v_name}.json")
    source_vehicle = CataclysmVehicle.load_from_file("#{@original_directory}/saved_vehicles/#{v_name}.json")
    target_world = UI.pick_a_world(self)
    if File.exist?("#{@original_directory}/saved_vehicles/" + v_name + ".modlist")
      mod_list_file = File.open("#{@original_directory}/saved_vehicles/" + v_name + ".modlist", 'r')
      mod_list = mod_list_file.read
      mod_list_file.close
    else
      UI.display("Mod list not found. May be from old version. Continuing anyway...", true)
      mod_list = "none"
    end
    if mod_list != target_world.get_mods
      UI.print_vehicle_warning
    else
      UI.display("Vehicle mod list matches new world, continuing", true)
    end

    UI.print_unique_vehicles(target_world)
    target_world.replace_vehicle(UI.get_vehicle_input("Destination"), source_vehicle)
  end

  def delete_char # deletes the character using the loaded object, which then deletes the files
    UI.display("Deleting a character.")
    target_world = UI.pick_a_world(self)
    target_char = UI.pick_a_character(target_world)
    target_char.delete_me if UI.get_confirmation_input_prompt("#{target_char.name} in #{target_world.name}")
  end

  def delete_world # deletes the world using the loaded object, which then deletes the files
    UI.display("Deleting a world.")
    target_world = UI.pick_a_world(self)
    target_world.delete_me if UI.get_confirmation_input_prompt(target_world.name)
  end

  def do_action(current_action)
    case current_action
    when 1 # print out some instructions for the user
      UI.print_directions
    when 2 # list all worlds and all characters in the manager
      UI.print_worlds_and_characters(self)
    when 3 # copy/move/backup character
      copy_char
    when 4 # copy a world
      copy_world
    when 5 # copy vehicle between worlds
      copy_vehicle
    when 6 # save vehicle to json
      save_vehicle
    when 7 # load vehicle from json
      load_vehicle
    when 8 # delete character
      delete_char
    when 9 # delete world
      delete_world
    when 10 # print all vehicles in the world
      target_world = UI.pick_a_world(self)
      UI.print_vehicle_names(target_world)
      UI.print_unique_vehicles(target_world)
    else
      UI.display("Unknown input.")
    end
  end

end

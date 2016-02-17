class UI

  LOG_FILENAME = "cdda_utility_log.txt"

  def self.display(string, log_it_too = false)
    # handle displaying UI string and logging in the same call
    puts string
    if log_it_too
      log(string)
    end
  end

  def self.log(string)
    # open our file in append mode and add the logged entry to the file
    # TODO: exception
    log_handle = File.open(LOG_FILENAME, 'a+')
    log_handle.write("#{Time.now}: #{string}\n")
    log_handle.close
  end

  def self.print_worlds(manager)
    big_string = String.new
    manager.each_world do |name, world|
      big_string += "World: #{name}\n"
    end
    self.display(big_string)
  end

  def self.print_worlds_and_characters(manager)
    display("List of worlds and characters:")
    #print_worlds(manager)
    manager.each_world do |world_name, world|
      print_characters(world)
    end
  end

  def self.print_characters(world)
    # pretty printing all characters in the world
    world.each_character do |name, character|
        display("World: #{world.name} Char: #{character.name}")
      end
  end

  def self.print_vehicle_names(world)
    display("Vehicles in world #{world.name}")
    world.each_vehicle do |vehicle_in_map, filename, sub_array, map_index|
      display("Name '#{vehicle_in_map["name"]}'  File '#{filename}'  SA:#{sub_array} MI:#{map_index}")
    end
  end

  def self.print_unique_vehicles(world, limit=1)
    display("Unique Vehicle Names Found")
    times_seen = Hash.new(0)
    world.each_vehicle do |vehicle_in_map, filename, sub_array|
      times_seen[vehicle_in_map["name"]] += 1
    end
    times_seen.each do |key, value|
      display("Unique vehicle named '#{key}' found.") unless limit < value
    end
  end

  def self.pick_a_world(manager)
    display("Pick a world:")
    print_worlds(manager)
    begin
      result = get_input("Enter a name")
      display("World not found, try again") if manager[result] == nil
    end while manager[result] == nil
    return manager[result]
  end

  def self.pick_a_character(world)
    display("Pick a character:")
    print_characters(world)
    begin
      result = get_input("Enter a character name")
      display("Character not found, try again.") if world[result] == nil
    end while world[result] == nil
    return world[result]
  end

  def self.print_vehicle_warning
    UI.display("WARNING:")
    UI.display("Different mods detected between original world and target world for this vehicle.", true)
    UI.display("This may not work at all if the vehicle is modded.", true)
    UI.display("If you continue, you should back up your world first.", true)
    UI.display("Resuming in three seconds....", true)
    sleep(3)
  end

  def self.print_intro
    puts "="*60
    puts "CDDA Save Editor Version #{CURRENT_VERSION}"
    puts "Please back up your world before making any changes."
    puts "-"*60
  end

  def self.print_directions
    puts "="*60
    puts "DIRECTIONS:"
    puts "To transfer anything to a new world, first create the world in Cataclysm."
    print_character_directions
    print_vehicle_directions
  end

  def self.print_character_directions
    puts "-"*60
    puts "To transfer a character, first create another character in the target world."
    puts "The transferred character will be sent to the target character's position."
  end

  def self.print_vehicle_directions
    puts "-"*60
    puts "To transfer a vehicle, first find another vehicle in the target world."
    puts "Or build a wooden frame and construct a vehicle in the construction menu."
    puts "Rename your initial vehicle and your target vehicle something UNIQUE, eg 'SuperRV'."
    puts "You can either save your vehicle to a json file, or transfer directly between worlds."
    puts "The transferred vehicle will be sent to the target vehicle's position."
    puts "WARNING: THE DESTINATION VEHICLE WILL BE OVERWRITTEN."
  end

  def self.print_action_prompt
    puts "CDDA Save Editor Version #{CURRENT_VERSION}"
    puts "Please back up your world before making any changes."
    puts "1) Print Directions"
    puts "2) List Characters/Worlds"
    puts "3) Copy/Backup/Transfer/Rename a Character"
    puts "4) Copy/Backup/Rename A World"
    puts "5) Copy A Vehicle Between Worlds"
    puts "6) Save A Vehicle to JSON"
    puts "7) Use Saved JSON To Replace Vehicle In Map"
    puts "8) Delete A Character"
    puts "9) Delete A World"
    puts "10) List all vehicles in a world, then list unique vehicles."
    return get_input("Enter a number").to_i
  end

  def self.get_confirmation_input_prompt(name_of_item)
    puts "WARNING: THIS WILL DELETE #{name_of_item} PERMANENTLY!!!"
    print "Deleting #{name_of_item}, are you SURE?! ('y' to continue, 'q' quits): "
    input = $stdin.gets.chomp.downcase
    if input == "y" || input == "Y"
      okay_to_delete = TRUE
    else
      puts "Okay, we won't delete #{name_of_item} after all."
      okay_to_delete = FALSE
    end
    return okay_to_delete
  end

  def self.get_input(prompt)
    print prompt + " ('q' quits): "
    action = $stdin.gets.chomp
    if action == 'q' || action == 'Q'
      exit
    end
    return action
  end

  def self.get_vehicle_input(string)
    puts "#{string} Vehicle Finder:"
    puts "You must have a unique name for the vehicle.\nIf you don't, load your game and rename your vehicle."
    search_string = get_input("Enter UNIQUE vehicle name")
    return search_string
  end

end


class CataclysmCharacter
  
  attr_reader :name, :character_path, :character_world, :list_of_related_char_files
  
  def initialize(path_to_char_file)
    load_character_from_file(path_to_char_file)
  end
  
  def load_character_from_file(path_to_char_file)
    # extract the name, decode it
    # TODO: exception
    @character_path = path_to_char_file
    @encoded_name = path_to_char_file.split("/")[-1][0...-4]
    @character_world = path_to_char_file.split("/")[-2]
    @rest_of_path = path_to_char_file.split("/")[0...-2]
    @name = Base64.decode64(@encoded_name)
    opened_file = File.open(path_to_char_file, 'r')
    # check to see if we recognize the file-format-version
    min_version = 25
    found_version = opened_file.readline.chomp[-2,2].to_i
    unless found_version == min_version
      UI.display("Unrecognized version in file. CDDA save routines may have changed.", true)
      UI.display("File version: #{found_version} Utility built for version:#{min_version}", true)
      UI.display("Safest thing to do is exit and contact the author.", true)
      UI.display("We will continue in the hopes the format is still readable.", true)
    end
    @loaded_char_json = JSON.load(opened_file)
    opened_file.close
    # grab a list of all related files for the save for future use.. but not the now-old char file
    @list_of_related_char_files = Dir.glob("save/#{@character_world}/#{@encoded_name}.*")
    @list_of_related_char_files.delete("save/#{@character_world}/#{@encoded_name}.sav")
  end
  
  def get_pos
    # we need to grab a variety of position data from our characters
    # there's no real organization to it in the json, loading manually
    # could be done as a hash, would be a bit more error-proof
    pos_ary =  [@loaded_char_json["levx"],
            @loaded_char_json["levy"],
            @loaded_char_json["levz"],
            @loaded_char_json["om_x"],
            @loaded_char_json["om_y"],
            @loaded_char_json["player"]["posx"], 
            @loaded_char_json["player"]["posy"],
            @loaded_char_json["player"]["posz"]]
    return pos_ary
  end
  
  def set_pos(position_array)
    # need to set the position data and again there's no organization in json
    log_string = "Setting #{name}'s character position to: "
    position_array.each { |val| log_string += val.to_s + " " }
    log_string += " from: "
    get_pos.each { |val| log_string += val.to_s + " " }
    UI.log(log_string)
    @loaded_char_json["levx"] = position_array[0]
    @loaded_char_json["levy"] = position_array[1]
    @loaded_char_json["levz"] = position_array[2]
    @loaded_char_json["om_x"] = position_array[3]
    @loaded_char_json["om_y"] = position_array[4]
    @loaded_char_json["player"]["posx"] = position_array[5]
    @loaded_char_json["player"]["posy"] = position_array[6]
    @loaded_char_json["player"]["posz"] = position_array[7]
  end
  
  def write_character_json(name=@name, world_string=@character_world)
    # save character under encoded filename in proper world
    # character file format: # + the name encoded in base64 + .sav
    # there's also always a '# version 25' first line...
    # version number can change of course...
    # TODO: exception
    saving_encoded_name = "#" + Base64.encode64(name).chomp
    saving_filename = "save/#{world_string}/#{saving_encoded_name}.sav"
    saving_file = File.open(saving_filename, 'w')
    saving_file.write("# version 25\n")
    saving_file.write(JSON.generate(@loaded_char_json))
    saving_file.close
    UI.display("Saved Character: '#{name}' In: '#{world_string}' Filename: '#{saving_filename}'", true)
  end
  
  def remove_world_specific_json_information
    # clear some stuff in the player data that isn't in a new world
    # otherwise they get debug errors on loading
    @loaded_char_json["active_monsters"] = []
    @loaded_char_json["player"]["active_mission"] = -1
    @loaded_char_json["player"]["active_missions"] = []
    @loaded_char_json["player"]["completed_missions"] = []
    @loaded_char_json["player"]["failed_missions"] = []
    # also remove the files which deal with weather and monsters seen
    # since all that will be different in the new world
    @list_of_related_char_files.delete("save/#{@character_world}/#{@encoded_name}.weather")
    @list_of_related_char_files.delete_if do |value|
      value.slice(".seen")
    end 
    UI.display("Removed world-specific info in #{@name}character file.", true)
  end
  
  def save_me(new_name, target_world_name, new_position=nil)
    # TODO: exception
    # scrub out anything that doesn't exist in a new world
    if @character_world != target_world_name
      remove_world_specific_json_information
    end
    # tweak the position of the loaded character and save everything
    set_pos(new_position) if new_position
    write_character_json(new_name, target_world_name)
    # copy over files
    encoded_filename = "#" + Base64.encode64(new_name).chomp
    full_destination_path = "save/#{target_world_name}/#{encoded_filename}"
    @list_of_related_char_files.each do |filename|
      # this handles any files with multiple.file.extensions.in.their.name
      file_extensions = filename.split(".")[1..-1].join(".")
      FileUtils.cp(filename, "#{full_destination_path}.#{file_extensions}")
    end
    UI.display("Finished copying all related character files for #{new_name}.", true)
  end

  def delete_me
    # TODO: exception
    @list_of_related_char_files.push("save/#{@character_world}/#{@encoded_name}.sav")
    @list_of_related_char_files.each do |filename|
      UI.log("Deleting character-related file #{filename}")
      File.delete(filename)
    end
    UI.display("Deleted char #{name} in: '#{@character_world}', filename #{@encoded_name}", true)
  end

end

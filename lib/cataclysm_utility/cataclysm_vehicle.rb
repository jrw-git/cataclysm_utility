
class CataclysmVehicle

  VEHICLE_FILENAME_SUFFIX = ".json"

  def initialize(vehicle_hash)
    @vehicle_hash = vehicle_hash
  end
  
  def save_to_file(filename)
    # save our vehicle in the json format to filename specified
    # TODO: exception
    saving_file = File.open(filename + VEHICLE_FILENAME_SUFFIX, 'w')
    saving_file.write(JSON.generate(@vehicle_hash))
    saving_file.close
    UI.display("Vehicle #{name} saved to #{filename}", true)
  end
  
  def self.load_from_file(filename)
    # load a file from json format into vehicle hash
    # no error checking beyond making sure it's a valid json
    # TODO: exception
    opened_vehicle_file = File.open(filename, 'r')
    vehicle_hash = JSON.load(opened_vehicle_file)
    opened_vehicle_file.close
    UI.display("Vehicle #{vehicle_hash["name"]} loaded from #{filename}", true)
    return CataclysmVehicle.new(vehicle_hash)
  end
  
  def get_pos
    # grab positional data from the vehicle (not including orientation etc)
    array_of_positions = Array.new
    array_of_positions << @vehicle_hash["posx"]
    array_of_positions << @vehicle_hash["posy"]
    return array_of_positions
  end
  
  def set_pos(array_of_positions)
    # set the same positional data
    @vehicle_hash["posx"] = array_of_positions[0]
    @vehicle_hash["posy"] = array_of_positions[1]
  end
  
  def name
    # convenient access to the name of the vehicle
    return @vehicle_hash["name"]
  end

  def to_h
    return @vehicle_hash
  end
  
  def to_s
    return @vehicle_hash.to_s
  end
  
end

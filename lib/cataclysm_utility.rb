require "./lib/cataclysm_utility/cataclysm_manager"

# 'Cataclysm: Dark Days Ahead' (CDDA) Save Utility Notes

# http://en.cataclysmdda.com/
# Github for the game (which I did not develop, to be clear):
# https://github.com/CleverRaven/Cataclysm-DDA

# My Personal Github:
# https://github.com/jrw-git
# This utility is built for the experimental version of CDDA
# Character files are encoded in base64
# Vehicles are buried in .map files under the world save
# Data structure of almost all CDDA files is json format

CURRENT_VERSION = 1.0
PROJECT_NAME = "CDDA Save Utility"
AUTHOR = "John White"

#test_mode = false || ARGV[0]
#if test_mode == "test"
  #Dir.chdir("../..")
  #Dir.chdir("TestingCDDA4223")
  #UI.display("*"*5+"Working in Test Mode - Won't find normal installation"+"*"*5)
#end

UI.log("#{PROJECT_NAME} Version #{CURRENT_VERSION} starting up from: " + File.expand_path($0))

begin  
  our_install = CataclysmManager.new()
  UI.print_intro
  current_action = UI.print_action_prompt
  our_install.do_action(current_action)
end until current_action == 'q'

##Transfer Utility for Cataclysm: Dark Days Ahead (CDDA)
####Written in Ruby, copy and save vehicles/characters between worlds

######Latest Version: https://github.com/jrw-git/cataclysm_utility/releases/latest

Cataclysm: Dark Days Ahead has no built-in ability to copy characters, worlds, or vehicles.
Most commonly, we want to move an existing character and the vehicle they've built into a new world.
This lets us explore a brand new world with an existing character and all the stuff they've accumulated.
It's quite difficult to transfer this data manually.

#####This utility makes it easier.

######However, there are a few steps you need to do beforehand:

##### First: BACK UP ANY WORLD (through this utility) BEFORE MAKING CHANGES

To copy a character, there must first be an existing character in the world you wish to copy to.
This gives us a safe location for your character to arrive at. The existing character is not overwritten.

To copy a vehicle, give it a unique name (within the world) such as "SuperRV". In the destination
world, find or create a vehicle and give it a unique name as well such as "MyTarget".
This vehicle IS OVERWRITTEN.

######This is a text based tool. There is no graphical interface.

###INSTALLATION (WINDOWS):

Download the latest release:
https://github.com/jrw-git/cataclysm_utility/releases/latest

For easiest use, unzip it directly into your Cataclysm directory
and run "cataclysm_utility.exe"

For compatibility with the launcher and game upgrading,
you can unzip in the game directory,
or above the Cataclysm directory,
or next to the Cataclysm install.

Example: Launcher is installed in /cdda, game is in /cdda/cataclysm.
This utility can be in /cdda/transfer_utility.
It can also be in /cdda, or in /cdda/cataclysm.

Any saved vehicles are saved in a sub-directory of the one the utility is run in.

Non-Windows users: It's best if you install Ruby
then download https://github.com/jrw-git/cataclysm_utility/releases/latest
and unzip as above, then "ruby cataclysm_utility.rb"

####General Usage:
Most users should first create a new Cataclysm world (within the game). Then load the game up and create
any kind of new character in the new world, probably an evac shelter starting character for safety.
Once in the game, you need to create or find a vehicle to serve as a transfer point for your own vehicle.
Easiest is to demolish the furniture in the starting shelter, make some basic tools, and craft a wooden frame.
Walk outside and use the construction menu to start building a vehicle. Name it something unique
such as "MyTarget". Then step back, save the game, and run the utility, choosing to transfer your own
character and vehicle. Make sure your own vehicle is named something unique such as "SuperRV", first.

######This utility DOES NOT copy between different versions of Cataclysm

Do that on your own by installing the new version and dragging the "save" folder over,
or using the new updater that's been released (not by me):
 https://github.com/remyroy/CDDA-Game-Launcher/releases


##### Version History:

###### Version 1.2.0 (2016-02-17)

cataclysm_utility executable is now STANDALONE, no other files required.

Major change in source code file arrangement to better mesh with OCRA compiler.

###### Version 1.1.1

Updated version numbers to SVN format

Re-implemented unit tests (old ruby style)

Included test data in master branch for unit tests

######Version 1.1:

When replacing vehicles, the utility prints a list of unique names found, for
your reference.

Can run the utility from inside CDDA directory, above it, or next to it now,
for increased compatibility with the cataclysm game launcher.

Mod-lists are now checked when copying vehicles.

Mods associated with vehicles are saved when vehicles are saved to json

Vehicles loaded from JSON have their mod-list checked against the new world's.

Increased documentation, warnings, and directions.

######Version 1.0:

Initial release


#####Game Website:

http://en.cataclysmdda.com/


#####Github for the game (which I did not develop, to be clear):

https://github.com/CleverRaven/Cataclysm-DDA


#####My Personal Github:

https://github.com/jrw-git


####Written by John White 2016
#####john@johnrw.com

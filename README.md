# cataclysm_utility

####Written by John White 2016 
#####john@johnrw.com

###Ruby Vehicle + Character Transfer Utility for Cataclysm: Dark Days Ahead (CDDA)

Cataclysm: Dark Days Ahead has no built-in ability to copy characters, worlds, or vehicles. 
Most commonly, we want to move an existing character and the vehicle they've built into a new world.
This lets us explore a brand new world with an existing character and all the stuff they've accumulated.
It's quite difficult to transfer this data by hand. This utility makes it easier. 

######However, there are a few steps you need to do by hand: 

To copy a character, there must first be an existing character in the world you wish to copy to.
This gives us a safe location for your character to arrive at.

To copy a vehicle, give it a unique name (within the world) such as "SuperRV". In the destination
world, find or create a vehicle and give it a unique name as well such as "MyTarget".

This is a text based tool. There is no graphical interface.

###INSTALLATION (WINDOWS):

Download the repository zip:
https://github.com/jrw-git/cataclysm_utility/archive/master.zip

Unzip into your Cataclysm directory and run cataclysm_utility.exe, then follow the directions.

Non-Windows users, it's best if you install Ruby, then
unzip as above into the Cataclysm directory, then run 
"ruby .\lib\cataclysm_utility.rb" in the Cataclysm directory.

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

 
#####Game Website:

http://en.cataclysmdda.com/


#####Github for the game (which I did not develop, to be clear):

https://github.com/CleverRaven/Cataclysm-DDA


#####My Personal Github:

https://github.com/jrw-git


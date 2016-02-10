# cataclysm_utility

####Written by John White 2016 john@johnrw.com

###Ruby Save Utility for Cataclysm: Dark Days Ahead (CDDA)

Cataclysm: Dark Days Ahead has no built-in ability to copy characters, worlds, or vehicles. 
Most commonly, we want to move an existing character and the vehicle they've built into a new world.
This lets us explore a brand new world with an existing character and all the stuff they've accumulated.
It's quite difficult to transfer this data by hand. This utility makes it easier. There are still steps
that haven't been automated, however.

Most users should first create a new Cataclysm world (within the game). Then load the game up and create
any kind of new character in the new world, probably an evac shelter starting character for safety.
Once in the game, you need to create or find a vehicle to serve as a transfer point for your own vehicle.
Easiest is to demolish the furniture in the starting shelter, make some basic tools, and craft a wooden frame.
Walk outside and use the construction menu to start building a vehicle. Name it something unique
such as "MyTarget". Then step back, save the game, and run the utility, choosing to transfer your own
character and vehicle. Make sure your own vehicle is named something unique such as "SuperRV", first.

This utility does the following things:

1) Copy vehicles between Cataclysm worlds, contents intact

2) Copy characters between Cataclysm worlds, contents intact

3) Copy worlds to new names (for backup etc)

4) Save vehicles to a file in json format

5) Load vehicles from a file in json format to a world

6) Delete characters or worlds

7) List all vehicles in a world

This utility DOES NOT: copy between different versions of Cataclysm


###INSTALLATION:

Download the repository zip:
https://github.com/jrw-git/cataclysm_utility/archive/master.zip

Unzip into your Cataclysm directory and run cataclysm_utility.exe, then follow the directions.


###USAGE NOTES:

#####To copy vehicles: 

You MUST manually create/find a vehicle in the NEW world.

It MUST be named a UNIQUE name such as "MyTarget"

Your source vehicle must also have a unique name.


#####To copy characters:

Create a new character in the new world FIRST.

It will mark a safe place in the new world for the transfer.


###CAVEAT:

I have tested this utility extensively, however it comes

with no promise or guarantee of success. Back up your world 

and/or your game itself before using this utility.


###GAME NOTES:

#####Game Website:

http://en.cataclysmdda.com/


#####Github for the game (which I did not develop, to be clear):

https://github.com/CleverRaven/Cataclysm-DDA


#####My Personal Github:

https://github.com/jrw-git


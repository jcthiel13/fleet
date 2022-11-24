# Fleet

**Import the ```import.sql``` file into your database**

+ Get in a vehicle you would like to register and drive to a point registered to your department via the config.

## Dependencies
+ Latest NAT2K15 framwork 
+ MySQL
+ MenuV (may swap to nativeUI in the future)

## FEATURES
+ Script is set up so you can configure a vehicle to any department (even if you aren't in it.)(This was a planned feature so that while configuring a vehicle you don't have to switch between departments)
+ Vehicles are saved on a per department basis.
+ Admin check is done via the framwork.
+ Script saves extras, liveries, and damage to the database.
+ You do not have to be in the vehicle to register it. The menu will automatically pull the last vehicle you were in.

## Known Issues/Limitations
+ Civ Department is not configured.
+ The menu can be opened multiple times overlapping with eachother.
+ Heli pads are configured in the config **BUT** the database is not configured to handle them.
+ Deleting the vehicle without using the script will still show the vehicle as out.
+ Currently no way to see vehicles that are out until they have returned.
+ May be able to spawn 2 of the same vehicle if the menu is opened by another player before the vehicle spawns. (will provide a check to prevent this in the future.)

## PLANNED FEATURES
+ Level checking (via future rank script)
+ Restrict garage to types (i.e. you can't spawn an engine in a parking space.)


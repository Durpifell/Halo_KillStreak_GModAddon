# README #

### DO NOT DOWNLOAD THIS AND PUT ON YOUR SERVER, IT IS CONSTANTLY BEING UPDATED, FOR MORE UPDATED README AND WORKING VERSION GO TO THE ADDON PAGE BELOW ###

### This repository is for the GMod [Halo Killstreak Addon](http://steamcommunity.com/sharedfiles/filedetails/?id=378274868) ###

Fairly simple addon that adds the basic Halo killstreaks and sprees sounds 
Goes from "Killing Spree" to "Unfrigginbelievable" and "Double Kill" to "Killionaire" 


### Console Commands ###
* "GetHaloVersion" - returns the currently downloaded version of this addon (Really not useful for most cases but I might be able to help you if something goes wrong) 

* "HaloServerSound" - Admin only, give argument either 1 or 0 to enable/disable playing the sounds outloud to nearby players respectively. 

* "HaloClientSound" - Admin only, same as above but only person getting the streak/spree can hear it. 

Does not save these settings across server restarts (Sorry), but defaults to client only when launched.
Note: If both are enabled, there will be a slight echo, also if neither are enabled, you have an addon that is wasting your resources. 



**(Note: Only counts kills on bots and people, not npcs, hence why it is server content)** 

Plan on working on more but I am pretty busy and I really don't play Gmod any more, but I made this addon because I noticed there were plenty of Doom sounds, but no Halo sounds (To which I am a huge fan of), so hopefully I will get to make everything like how I want exactly, but no promises. 

### Possible/eventual changes: ###
* Improve code (None of which will change the way the addon works Ok maybe a little, but don't worry about it) 
* Console commands for some of the features I have already put in (This will be eventually turned into a 'q' menu options tab thing, but for now, I will use console commands cus I suck) 
* Config file (Turn these things on and off and be able to save them for server restarts/client options) 
* Dynamic Sound (More impressive streaks/sprees will be louder) 
* Killfeed overlay (Which will show medals earned eventually) 
* Storing medals for players to view later (This one.... no idea how I would do exactly, but I will look into it) 
* Moar medals/sprees (Shotgun spree, sniper spree, etc.... Would have to setup a config file where server owners would put in the type of gun each weapon is, i.e. weapon_crossbow = sniper, or something like that) 

I have not done extensive testing so feel free to post any bugs you find and I will look into it. 

Funny side note for server owners: You do not have to make your clients download this addon (YET), it downloads all the sound files they need automatically and everything else is done serverside, this probably won't be the case in a few updates, but keep that in mind while you are chosing files for your server. But compared to other addons, this one is extremely light lua-wise so it's up to you. 


Thanks to Bungie and 343 Industries for their work on Halo

Thanks to SillyGoose for capture of not terrible sound files

### Note from creator of sound files ###
****************************************************** 
Halo 4 SFX - by SillyGoose 
http://www.youtube.com/SillyGooseGaming 


All sounds were: 
Recorded on the Map Erosion (Grifball Court). 
Recorded with a Hauppauge HD PVR Capture Card. 
Applied with a Noise Removal Effect in Audacity. 
Render out as 256kbps mp3's from Sony Vegas Pro 9. 


____________________ 

PLEASE if you tell someone else about this pack 
link them to this video: 
https://www.youtube.com/watch?v=cUfS1hHzFKY 

I would like to keep track of the downloads I'm getting. 
So please dont just download the pack from me and send it to your friend. 
**************************************************** 

I give permission to anyone to edit MY files (Lua files, not sound files) without asking, I am terrible lua coder and I know it. Link me your improved code and I will even check it out.

--[[
Lua is perhaps the worst programming language ever created, and I am sorry
to the developers of gmod, who which had to deal with all the terribleness
that comes with this god forsaken language. And whoever decided that lua
was a good language deserves to be executed at soonest convience. Along
with anyone who defends it as an even decent language. It is the
wannabe ugly younger brother of Python who doesn't actually know anything about
code what so ever. The simplest of ideas that have been implemented in other
languages for YEARS has evaded the minds of the developers of Lua. Such things
as even creating a class is practically impossible, you have to use a fucking
table and PRETEND it is a class. In all fairness, that is secretly what most languages
do. But if you are going to boost about how simple your language is to develop in,
you better fucking make it true. When every other page of your documentation says
how easy and obvious your language, it makes me want to vomit, and even the website
itself looks like it hasn't been updated since 1999. Fucking look at it yourself.
I am glad to see that your website supports this idea, as the only thing it
fucking has on it is fucking header and paragraph tags, because I don't think
anyone who likes or develops this terrible language could understand anything 
but the absolute simpliest of ideas. Do I seem angry? It's because developing
in Lua gives me figurative cancer, and I'm figuretively going to die...
It's even worse when people defend this pile of shit language, because most of
the time, it's because they haven't touched any other language. And honestly,
I feel sorry for anyone who's only experience is Lua, as it is like eating a piece
of dog shit whereas Python (in terms of scripting languages) is like eating lobster
stuffed with gold covered chocolate. If you reading this expecting to learn something,
I suggest you turn around...then turn around again because this is a fucking computer screen,
exit this shitty language and go learn some fucking Python, C, C++, Java, C#, ANYTHING, just
NOT LUA...
]]--
if CLIENT then return end 		-- Will get back to this later


--[[
Should I store sound file locations in database? What would that even accomplish?
Find out next time... 
]]--

local VERSION = "1.03.0"

--Important table for this entire addon :) (Soon not to be)
local Players = {}

--ENUMS
local CONSOLE = 3
local SUPERADMIN = 2
local ADMIN = 1
local EVERYONE = 0


--Default Values
local CLIENTSIDESOUND = true			-- These values state whether or not the sounds would play outloud or just clientside
local SERVERSIDESOUND = false			-- Note, if both are true, there will be a slight echo for the person who got the sound
										-- also, if neither are true, then no sound will played, will make a rather wasteful addon

local NPCKILLSCOUNT = true 				-- NPC kills count
								
local DYNAMICNOISE = true 			-- Set this to true if you want the more difficult streaks/sprees to increase in volume as they increase -- NOT IMPLEMENTED YET

local STREAKDELAY = 4.0			-- Seconds between kills to be considered part of Streak

--Access to edit each value
local HALOCLIENTSOUNDACCESS = SUPERADMIN
local HALOSETACCESSLEVELACCESS = SUPERADMIN
local HALOSERVERSOUNDACCESS = SUPERADMIN
local HALOSETLOGGINGLEVELACCESS = SUPERADMIN
local HALONPCKILLSACCESS = SUPERADMIN

--This is going to be moved to a database, wtf am I even doing right now?
local accessMap = {
	"haloclientsound": SUPERADMIN,
	"halosetaccesslevel": SUPERADMIN,
	"haloserversound": SUPERADMIN,
	"halosetlogginglevel": SUPERADMIN,
	"halonpckills": SUPERADMIN
}

--Who is given updates when addon is changed
local HALOLOGGINGLEVEL = SUPERADMIN

--Kills needed for each spree
local KILLINGSPREE = 5
local KILLINGFRENZY = 10
local RUNNINGRIOT = 15
local RAMPAGE = 20
local UNTOUCHABLE = 25
local INVINCIBLE = 30
local INCONCEIVABLE = 35
local UNFRIGGENBELIEVABLE = 40

function playerDies( victim, weapon, killer )
	if victim:IsNPC() && !NPCKILLSCOUNT then return end
	if !victim:IsPlayer() && !killer:IsPlayer() then return end
	if !victim:IsPlayer() && !victim:IsNPC() && killer:IsPlayer() then return end
	if killer:IsPlayer() then
		if killer != victim then
			addKill(killer, victim, weapon, CurTime())																										-- Killer gains kill
		end
		index = containsPlayer(victim)
		
		if !index && victim:IsPlayer() then addPlayer(victim)
		elseif victim:IsPlayer() && table.getn(Players[index]) >= 2 && Players[index][table.getn(Players[index])]["time"] + STREAKDELAY > CurTime() then		-- Player dies before their kill streak is rewarded, can't have that can we
			kills = getKillStreak(Players[index])
			dispenseSexyStreak(victim, kills)
		end
		if killer == victim then		-- Suicide is not the answer
			timer.Simple(2, function()
--				PrintMessage( HUD_PRINTTALK, victim:Name().." committed Suicide")
			end)
		end
		
		if (killer:GetClass () == "worldspawn") or (killer:GetClass() == "prop_physics") then		-- killed by guardians
--			PrintMessage( HUD_PRINTTALK, ply:Name().." was killed by the guardians" )
		end																			
	end
	if victim:IsPlayer() then clearPlayerKills(victim) end
end

-- If Players contains ply based on their id, returns the key for the player kill log
function containsPlayer(ply)
	if !ply:IsPlayer() then return false end
	id = ply:SteamID()
	for k,v in pairs(Players) do
		if k == id then
			return k
		end
	end
	return false
end

-- Adds ply to Players based on id
function addPlayer(ply)
	local id = ply:SteamID()
	Players[id] = {}
end

-- V This is such a cool function V Soon to be destroyed and replaced
function addKill(killer, victim, weapon, time)
	if !containsPlayer(killer) then
		addPlayer(killer)
	end
	index = containsPlayer(killer)
	killNumber = table.insert(Players[index],{})
	
	-- New Method
	Players[index][killNumber]["time"] = time
	Players[index][killNumber]["weapon"] =  weapon:GetClass()
	if victim:IsPlayer() then
		Players[index][killNumber]["victim"] = victim:GetName()
		Players[index][killNumber]["victimSteamID"] = victim:SteamID()
	elseif victim:IsNPC() then
		Players[index][killNumber]["victim"] = "NPC"
		Players[index][killNumber]["victimSteamID"] = victim:GetClass()
	end
	checkSprees(killer)
	handleKillStreaks(killer)
end


function clearPlayerKills(ply)
	index = containsPlayer(ply)
	if !index then return end
	Players[index] = {}
	
	
end

function removePlayer(ply)
	index = containsPlayer(ply)
	if !index then return end
	Players[index] = nil
end

-- Easy Peasy Lemon Squezy
function checkSprees(ply)
	index = containsPlayer(ply)
	kills = table.getn(Players[index])
	dispenseSexySprees(ply,kills)
end

function handleKillStreaks(ply)
	local index = containsPlayer(ply)
	local PlayerKills = Players[index]
	local numberOfKills = table.getn(PlayerKills)
	local kill = PlayerKills[numberOfKills]
	local killTime = kill["time"]
	timer.Simple(STREAKDELAY, function()
		local index = containsPlayer(ply)
		local PlayerKills2 = Players[index]
		if numberOfKills != table.getn(PlayerKills2) then return end 	-- Kill List has been updated, will give your kill streak later
		if ply:IsValid() && !ply:Alive() then return end
		if !ply:IsValid() then return end
		if table.getn(PlayerKills) >= 2 then
			kills = getKillStreak(PlayerKills)
			dispenseSexyStreak(ply, kills)
		end
	end)
end

function getKillStreak(killLog)
	kills = 1
	totalKills = table.getn(killLog)
	while (totalKills - kills > 0) and (killLog[totalKills - kills]["time"] + STREAKDELAY >= killLog[(totalKills-kills)+1]["time"]) do kills = kills + 1 end
	return kills
end

function dispenseSexyStreak(ply, kills)
	if CLIENTSIDESOUND then
		if kills == 2 then 																	-- double kill
			ply:SendLua("surface.PlaySound( \"updated/multikills/doublekill.mp3\" )")
		elseif kills == 3 then 																-- triple kill
			ply:SendLua("surface.PlaySound( \"updated/multikills/triplekill.mp3\" )")
		elseif kills == 4 then 																-- overkill
			ply:SendLua("surface.PlaySound( \"updated/multikills/overkill.mp3\" )")
		elseif kills == 5 then 																-- killtacular
			ply:SendLua("surface.PlaySound( \"updated/multikills/killtacular.mp3\" )")
		elseif kills == 6 then 																-- killtrocity
			ply:SendLua("surface.PlaySound( \"updated/multikills/killtrocity.mp3\" )")
		elseif kills == 7 then 																-- killamanjaro
			ply:SendLua("surface.PlaySound( \"updated/multikills/killimanjaro.mp3\" )")
		elseif kills == 8 then 																-- killtastrophe
			ply:SendLua("surface.PlaySound( \"updated/multikills/killtastrophe.mp3\" )")
		elseif kills == 9 then 																-- killpocalypse
			ply:SendLua("surface.PlaySound( \"updated/multikills/killpocalypse.mp3\" )")
		elseif kills >= 10 then 															-- killionaire
			ply:SendLua("surface.PlaySound( \"updated/multikills/killionaire.mp3\" )")
		end
	end
	if SERVERSIDESOUND then
		if kills == 2 then 																	-- double kill
			sound.Play( "updated/multikills/doublekill.mp3", ply:GetPos(), 100, 100, 1)
		elseif kills == 3 then 																-- triple kill
			sound.Play( "updated/multikills/triplekill.mp3", ply:GetPos(), 100, 100, 1)
		elseif kills == 4 then 																-- overkill
			sound.Play( "updated/multikills/overkill.mp3", ply:GetPos(), 100, 100, 1)
		elseif kills == 5 then 																-- killtacular
			sound.Play( "updated/multikills/killtacular.mp3", ply:GetPos(), 100, 100, 1)
		elseif kills == 6 then 																-- killtrocity
			sound.Play( "updated/multikills/killtrocity.mp3", ply:GetPos(), 100, 100, 1)
		elseif kills == 7 then 																-- killamanjaro
			sound.Play( "updated/multikills/killimanjaro.mp3", ply:GetPos(), 100, 100, 1)
		elseif kills == 8 then 																-- killtastrophe
			sound.Play( "updated/multikills/killtastrophe.mp3", ply:GetPos(), 100, 100, 1)
		elseif kills == 9 then 																-- killpocalypse
			sound.Play( "updated/multikills/killpocalypse.mp3", ply:GetPos(), 100, 100, 1)
		elseif kills >= 10 then 															-- killionaire
			sound.Play( "updated/multikills/killionaire.mp3", ply:GetPos(), 100, 100, 1)
		end
	end
end

function dispenseSexySprees(ply, kills)
	if CLIENTSIDESOUND then
		if (kills % 5) == 0 then
			if kills == KILLINGSPREE then 
				ply:SendLua("surface.PlaySound( \"updated/killingsprees/killingspree.mp3\" )")
			elseif kills == KILLINGFRENZY then
				ply:SendLua("surface.PlaySound( \"updated/killingsprees/killingfrenzy.mp3\" )")
			elseif kills == RUNNINGRIOT then
				ply:SendLua("surface.PlaySound( \"updated/killingsprees/runningriot.mp3\" )")
			elseif kills == RAMPAGE then
				ply:SendLua("surface.PlaySound( \"updated/killingsprees/rampage.mp3\" )")
			elseif kills == UNTOUCHABLE then
				ply:SendLua("surface.PlaySound( \"updated/killingsprees/untouchable.mp3\" )")
			elseif kills == INVINCIBLE then
				ply:SendLua("surface.PlaySound( \"updated/killingsprees/invincible.mp33\" )")
			elseif kills == INCONCEIVABLE then
				ply:SendLua("surface.PlaySound( \"updated/killingsprees/inconceivable.mp3\" )")
			elseif kills >= UNFRIGGENBELIEVABLE then
				ply:SendLua("surface.PlaySound( \"updated/killingsprees/unfrigginbelievable.mp3\" )")
			end
		end
	end
	if SERVERSIDESOUND then
		if (kills % 5) == 0 then
			if kills == KILLINGSPREE then 
				sound.Play( "updated/killingsprees/killingspree.mp3", ply:GetPos(), 100, 100, 1)
			elseif kills == KILLINGFRENZY then
				sound.Play( "updated/killingsprees/killingfrenzy.mp3", ply:GetPos(), 100, 100, 1)
			elseif kills == RUNNINGRIOT then
				sound.Play( "updated/killingsprees/runningriot.mp3", ply:GetPos(), 100, 100, 1)
			elseif kills == RAMPAGE then
				sound.Play( "updated/killingsprees/rampage.mp3", ply:GetPos(), 100, 100, 1)
			elseif kills == UNTOUCHABLE then
				sound.Play( "updated/killingsprees/untouchable.mp3", ply:GetPos(), 100, 100, 1)
			elseif kills == INVINCIBLE then
				sound.Play( "updated/killingsprees/invincible.mp3", ply:GetPos(), 100, 100, 1)
			elseif kills == INCONCEIVABLE then
				sound.Play( "updated/killingsprees/inconceivable.mp3", ply:GetPos(), 100, 100, 1)
			elseif kills >= UNFRIGGENBELIEVABLE then
				sound.Play( "updated/killingsprees/unfrigginbelievable.mp3", ply:GetPos(), 100, 100, 1)
			end
		end
	end
end


function playSound(soundfile, streakOrSpree, serversound)
	-- Not implemented yet, will use to clean up that mess above ^^^^^^^
	if CLIENTSIDESOUND then
		
	end
end

function getVersion()
	return VERSION
end

function printVersionToConsole(ply)
	if !ply:IsPlayer() then print(VERSION) return end
	ply:PrintMessage(2, VERSION)
end

-- Enable or disable sounds
function clientSideSound(enable, ply)
	CLIENTSIDESOUND = enable
	if enable then
		notifyHaloChange(ply, "Enabled clientside kill sounds (Halo Killstreak Addon)")
	else
		notifyHaloChange(ply, "Disabled clientside kill sounds (Halo Killstreak Addon)")
	end
end

-- Enable or disable sounds
function serverSideSound(enable, ply)
	SERVERSIDESOUND = enable
	if enable then
		notifyHaloChange(ply, "Enabled serverside kill sounds (Halo Killstreak Addon)")
	else
		notifyHaloChange(ply, "Disabled serverside kill sounds (Halo Killstreak Addon)")
	end
end


function notifyHaloChange(ply, str)
	if !ply:IsPlayer() then print(str) return end
	for k,v in pairs(player.GetAll()) do
		if v:IsPlayer() && (getPlayerLevel(v) >=  HALOLOGGINGLEVEL) then
			v:PrintMessage(3, ply:GetName().." SteamID: "..ply:SteamID().." "..str)
		end
	end
	print(ply:GetName().." SteamID: "..ply:SteamID().." "..str)
end

function myAutocomplete(cmd, args)
	-- Do later
	tabl = {}
	if cmd == "Haloserversound" then
		table.Insert(tabl, SERVERSIDESOUND)
	elseif cmd == "Haloclientsound" then
		table.Insert(tabl, CLIENTSIDESOUND)
	end
	return tabl
end
	

hook.Add("PlayerDeath", "halodeath", playerDies)
hook.Add("OnNPCKilled", "halonpcdeath", playerDies)
hook.Add("PlayerDisconnected", "halodisconnect", removePlayer)
hook.Add("PlayerInitialSpawn", "haloconnect", addPlayer)


concommand.Add("GetHaloVersion", function(ply) printVersionToConsole(ply) end)

function unknownArgumentNormal(ply)
	ply:PrintMessage(2, "Unknown Argument(s) passed with command")
	ply:PrintMessage(2, "Command descriptions are availible here --> http://steamcommunity.com/sharedfiles/filedetails/?id=378274868")
end

function getPlayerLevel(ply)
	if !ply:IsPlayer() then return 3 end
	if ply:IsSuperAdmin() then return 2 end
	if ply:IsAdmin() then return 1 end
	return 0
end

function setAccessLevel(ply, cmd, args)
	command = string.lower(args[1])
	level = args[2]

	if command == "haloserversound" then
		if level == "0" then
			HALOSERVERSOUNDACCESS = 0
			notifyHaloChange(ply, "Set the access level of "..command.." to everyone")
		elseif level == "1" then
			HALOSERVERSOUNDACCESS = 1
			notifyHaloChange(ply, "Set the access level of "..command.." to admin+")
		elseif level == "2" then
			HALOSERVERSOUNDACCESS = 2
			notifyHaloChange(ply, "Set the access level of "..command.." to superadmin+")
		elseif level == "3" then
			HALOSERVERSOUNDACCESS = 3
			notifyHaloChange(ply, "Set the access level of "..command.." to server console only")
		else
			unknownArgumentNormal(ply)
		end

	elseif command == "haloclientsound" then
		if level == "0" then
			HALOCLIENTSOUNDACCESS = 0
			notifyHaloChange(ply, "Set the access level of "..command.." to everyone")
		elseif level == "1" then
			HALOCLIENTSOUNDACCESS = 1
			notifyHaloChange(ply, "Set the access level of "..command.." to admin+")
		elseif level == "2" then
			HALOCLIENTSOUNDACCESS = 2
			notifyHaloChange(ply, "Set the access level of "..command.." to superadmin+")
		elseif level == "3" then
			HALOCLIENTSOUNDACCESS = 3
			notifyHaloChange(ply, "Set the access level of "..command.." to server console only")
		else
			unknownArgumentNormal(ply)
		end

	elseif command == "halosetaccesslevel" then
		if level == "0" then
			HALOSETACCESSLEVELACCESS = 0
			notifyHaloChange(ply, "Set the access level of "..command.." to everyone")
		elseif level == "1" then
			HALOSETACCESSLEVELACCESS = 1
			notifyHaloChange(ply, "Set the access level of "..command.." to admin+")
		elseif level == "2" then
			HALOSETACCESSLEVELACCESS = 2
			notifyHaloChange(ply, "Set the access level of "..command.." to superadmin+")
		elseif level == "3" then
			HALOSETACCESSLEVELACCESS = 3
			notifyHaloChange(ply, "Set the access level of "..command.." to server console only")
		else
			unknownArgumentNormal(ply)
		end

	elseif command == "halologginglevel" then
		if level == "0" then
			HALOSETLOGGINGLEVELACCESS = 0
			notifyHaloChange(ply, "Set the access level of "..command.." to everyone")
		elseif level == "1" then
			HALOSETLOGGINGLEVELACCESS = 1
			notifyHaloChange(ply, "Set the access level of "..command.." to admin+")
		elseif level == "2" then
			HALOSETLOGGINGLEVELACCESS = 2
			notifyHaloChange(ply, "Set the access level of "..command.." to superadmin+")
		elseif level == "3" then
			HALOSETLOGGINGLEVELACCESS = 3
			notifyHaloChange(ply, "Set the access level of "..command.." to server console only")
		else
			unknownArgumentNormal(ply)
		end

	elseif command == "halonpckills" then
		if level == "0" then
			HALONPCKILLSACCESS = 0
			notifyHaloChange(ply, "Set the access level of "..command.." to everyone")
		elseif level == "1" then
			HALONPCKILLSACCESS = 1
			notifyHaloChange(ply, "Set the access level of "..command.." to admin+")
		elseif level == "2" then
			HALONPCKILLSACCESS = 2
			notifyHaloChange(ply, "Set the access level of "..command.." to superadmin+")
		elseif level == "3" then
			HALONPCKILLSACCESS = 3
			notifyHaloChange(ply, "Set the access level of "..command.." to server console only")
		else
			unknownArgumentNormal(ply)
		end

	else
		unknownArgumentNormal(ply)
	end
end


function denyAccess(ply, levelRequired)
	if levelRequired == 1 then
		ply:PrintMessage(2, "You must be at least an admin to use this command")
	elseif levelRequired == 2 then
		ply:PrintMessage(2, "You must be superadmin to use this command")
	elseif levelRequired == 3 then
		ply:PrintMessage(2, "This command can only be used from the server console")
	end
end


function getAccessLevel(commandName)


end


concommand.Add("Haloserversound", function(ply, cmd, args)
	if getPlayerLevel(ply) >=  HALOSERVERSOUNDACCESS then
		if args[1] == "1" then 
			serverSideSound(true, ply) 
		elseif args[1] == "0" then
	 		serverSideSound(false, ply) 
		else
			unknownArgumentNormal(ply)
		end
	else
		denyAccess(ply, HALOSERVERSOUNDACCESS)
	end
end)



concommand.Add("Haloclientsound", function(ply, cmd, args)
	if getPlayerLevel(ply) >= HALOCLIENTSOUNDACCESS then
		if args[1] == "1" then
			clientSideSound(true, ply)
		elseif args[1] == "0" then
			clientSideSound(false, ply)
		else
			unknownArgumentNormal(ply)
		end
	else
		denyAccess(ply, HALOCLIENTSOUNDACCESS)
	end
end)



concommand.Add("Halosetaccesslevel", function(ply, cmd, args)
	if getPlayerLevel(ply) >= HALOSETACCESSLEVELACCESS then
		setAccessLevel(ply, cmd, args)
	else
		denyAccess(ply, HALOSETACCESSLEVELACCESS)
	end
end)


concommand.Add("Halologginglevel", function(ply, cmd, args)
	if getPlayerLevel(ply) >= HALOSETLOGGINGLEVELACCESS then
		if args[1] == "0" then
			notifyHaloChange(ply, "Set the logging level to everyone")
			HALOLOGGINGLEVEL = 0
		elseif args[1] == "1" then
			notifyHaloChange(ply, "Set the logging level to admin+")
			HALOLOGGINGLEVEL = 1
		elseif args[1] == "2" then
			notifyHaloChange(ply, "Set the logging level to superadmin+")
			HALOLOGGINGLEVEL = 2
		elseif args[1] == "3" then
			notifyHaloChange(ply, "Set the logging level to server console only")
			HALOLOGGINGLEVEL = 3
		else
			unknownArgumentNormal(ply)
		end
	else
		denyAccess(ply, HALOSETLOGGINGLEVELACCESS)
	end
end)


concommand.Add("HaloNPCKills", function(ply, cmd, args)
	if getPlayerLevel(ply) >= HALONPCKILLSACCESS then
		if args[1] == "0" then
			NPCKILLSCOUNT = false
			notifyHaloChange(ply, "Disabled NPC kills counting for kill rewards (Halo KillStreak Addon)")
		elseif args[1] == "1" then
			NPCKILLSCOUNT = true
			notifyHaloChange(ply, "Enabled NPC kills counting for kill rewards (Halo KillStreakAddon)")
		else
			unknownArgumentNormal(ply)
		end
	else
		denyAccess(ply, HALONPCKILLSACCESS)
	end
end)
rank = require("ranks")
ranks = rank.ranks
local default_config = {
	CLIENTSIDESOUND = true,				-- These values state whether or not the sounds would play outloud or just clientside
	SERVERSIDESOUND = false,			-- Note, if both are true, there will be a slight echo for the person who got the sound
										-- also, if neither are true, then no sound will played, will make a rather wasteful addon
	
	NPCKILLSCOUNT = true, 				-- NPC kills count
	DYNAMICNOISE = true, 				-- Set this to true if you want the more difficult streaks/sprees to increase in volume as they increase -- NOT IMPLEMENTED YET
	STREAKDELAY = 4.0,					-- Seconds between kills to be considered part of Streak

	--Access to edit each value
	HALOCLIENTSOUNDACCESS = ranks.SUPERADMIN,
	HALOSETACCESSLEVELACCESS = ranks.SUPERADMIN,
	HALOSERVERSOUNDACCESS = ranks.SUPERADMIN,
	HALOSETLOGGINGLEVELACCESS = ranks.SUPERADMIN,
	HALONPCKILLSACCESS = ranks.SUPERADMIN,
	test = ranks.SUPERADMIN,

	--Who is given updates when addon is changed
	HALOLOGGINGLEVEL = ranks.SUPERADMIN,

	--Kills needed for each spree
	KILLINGSPREE = 5,
	KILLINGFRENZY = 10,
	RUNNINGRIOT = 15,
	RAMPAGE = 20,
	UNTOUCHABLE = 25,
	INVINCIBLE = 30,
	INCONCEIVABLE = 35,
	UNFRIGGENBELIEVABLE = 40
}

local answer
while 1 do
io.write("Value: ")
io.flush()
answer=io.read()
ok = rank.get_rank_name(default_config[answer])
print(ok)
end
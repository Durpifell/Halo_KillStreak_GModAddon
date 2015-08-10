require("class")

Kill = class(function(kill, killer, victim, weapon, time)
              	kill.killer = killer:GetName()
              	kill.killerId = killer:SteamID()
              	kill.time = time
            	if victim:IsPlayer() then
					kill.victim = victim:GetName()
					kill.victimId = victim:SteamID()
				elseif victim:IsNPC() then
					kill.victim = "NPC"
					kill.victimId = victim:GetClass()
				end
              	kill.weapon = weapon:GetClass()
        	end)

function Kill:getKiller()
   return (self.killer, self.killerId)
end

function Kill:getVictim()
	return (self.victim, self.victimId)
end

function Kill:getWeapon()
	return self.weapon
end

function Kill:getTime()
	return self.time
end

function Kill:PrintableData()
	return self.killer + " (" + self.killerId ") killed " + self.victim + " (" + self.vitcimId + ") with " + self.weapon + " at " + self.time 
end
function Kill(killer, victim, weapon, time)
	local killData = {
		killer = killer:GetName()
        killerId = killer:SteamID()
        time = time

        if victim:IsPlayer() then
			victim = victim:GetName()
			victimId = victim:SteamID()
		elseif victim:IsNPC() then
			victim = "NPC"
			victimId = victim:GetClass()
		end
      	weapon = weapon:GetClass()

      	PrintableData = function(self)
			return self.killer + " (" + self.killerId ") killed " + self.victim + " (" + self.vitcimId + ") with " + self.weapon + " at " + self.time 
		end
		TableName = "KillsTable"
		QueryTableCreateStatement = "CREATE TABLE "..TableName.." (".." KillerName varchar(255), KillerId varchar(30), Victim varchar(255), VictimId varchar(255), Weapon varchar(255), Time Timestamp"
		QueryInsertStatement = ""
	}
	return killData
end
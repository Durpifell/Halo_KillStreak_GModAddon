return function Kill(killer, victim, weapon, time)
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

      	PrintableData = killer + " (" + killerId ") killed " + victim + " (" + vitcimId + ") with " + weapon + " at " + time

		TableName = "KillsTable"
		QueryTableCreateStatement = "CREATE TABLE "..TableName.." ( KillerName varchar(255), KillerId varchar(30), Victim varchar(255), VictimId varchar(255), Weapon varchar(255), Time timestamp )"
		QueryInsertStatement = "INSERT INTO "..TableName.." VALUES ( " table.concat({killer, killerId, vitcim, victimId, weapon, time}, ", ")
	}
	return killData
end
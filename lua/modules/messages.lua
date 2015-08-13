
function notifyHaloChange(ply, str)
	if !ply:IsPlayer() then print(str) return end
	for k,v in pairs(player.GetAll()) do
		if v:IsPlayer() && (getPlayerLevel(v) >=  HALOLOGGINGLEVEL) then
			v:PrintMessage(3, ply:GetName().." SteamID: "..ply:SteamID().." "..str)
		end
	end
	print(ply:GetName().." SteamID: "..ply:SteamID().." "..str)
end

function unknownArgumentNormal(ply)
	ply:PrintMessage(2, "Unknown Argument(s) passed with command")
	ply:PrintMessage(2, "Command descriptions are availible here --> http://steamcommunity.com/sharedfiles/filedetails/?id=378274868")
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
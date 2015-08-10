-- Database interaction file
require("kill")

-- Check to see Table exists, if it doesn't, creates it.
function CheckTableExists(tableName)

end

function UpdateKillTable(kill)

end

function UpdateConfigTable()

end

function GetPlayerDataById(steamId)

end

function GetPlayerData(ply)

end

-- Time will be attached by itself, formatted in UTC now
function LogHaloData(message)
	time = os.date("!%c")
	sql.Query("")
end

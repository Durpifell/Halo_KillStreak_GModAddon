return {
	--ENUMS
	ranks = {
		CONSOLE = 3,
		SUPERADMIN = 2,
		ADMIN = 1,
		EVERYONE = 0
	},
	
	get_rank_name = function(num)
		for k,v in pairs(ranks) do
			if(num == v) then
				return k
			end
		end
		return nil
	end
}
local M = {}

function split_string(input, separator)
	if separator == nil then
		separator = "%s"
	end
	local t = {}
	for str in string.gmatch(input, "([^" .. separator .. "]+)") do
		table.insert(t, str)
	end
	return t
end

-- Function to get the date for the next occurrence of a given day of the week
function M.getNextWeekday(snippet)
	print(snippet[1])
	local split = split_string(snippet, ",")
	local task_type = split[1]
	local dow = split[2]
	local weeks_count = tonumber(split[3])
	print(dow, weeks_count, task_type)
	local days = { sun = 0, mon = 1, tue = 2, wed = 3, thu = 4, fri = 5, sat = 6 }
	local target_day = days[string.lower(dow)]
	if target_day == nil then
		return nil
	end

	local current_time = os.time()
	local current_day = os.date("*t", current_time).wday - 1
	local days_ahead = ((target_day - current_day + 7) % 7) + (7 * weeks_count)
	if days_ahead == 0 then
		days_ahead = 7
	end

	local target_time = current_time + days_ahead * 24 * 60 * 60
	return "@" .. task_type .. os.date("%Y%m%d", target_time)
end

-- Function to generate combinations
-- -- Define parts arrays
local parts1 = { "d", "s", "v" }
local parts2 = { "sun", "mon", "tue", "wed", "thu", "fri", "sat" }
local parts3 = { "0", "1", "2" }
function M.generate_combinations()
	local combinations = {}
	for _, part1 in ipairs(parts1) do
		for _, part2 in ipairs(parts2) do
			for _, part3 in ipairs(parts3) do
				local combination = part1 .. "," .. part2 .. "," .. part3
				table.insert(combinations, combination)
			end
		end
	end
	return combinations
end

return M

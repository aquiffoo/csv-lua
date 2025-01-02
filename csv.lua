local file = io.open(arg[1], "r")

if not file then
	io.write("file not found!\n")
	return
end

io.write("send the separator you use in the file > ")
local separator = io.read()

local data = {}  

for line in file:lines() do
	local fields = {}
	for field in line:gmatch("([^" .. separator .. "]+)") do
		table.insert(fields, field)
	end
	table.insert(data, fields)
end

file:close()

local function saveCSV(filedata, path, sep)
	local outF = io.open(path, "w")
	for _, row in ipairs(filedata) do
		outF:write(table.concat(row, sep) .. "\n")
	end
	outF:close()
end

local function printCSV(filedata)
	for i, row in ipairs(filedata) do
		local rowstr = i .. ". "
		for j, field in ipairs(row) do
			rowstr = rowstr .. field
			if j < #row then
				rowstr = rowstr .. separator
			end
		end
		print(rowstr)
	end
end

printCSV(data)

while true do
	io.write("=== options ===\n")
	io.write("1. add row\n")
	io.write("2. delete row\n")
	io.write("3. edit row\n")
	io.write("4. view data\n")
	io.write("5. exit\n")
	io.write("select an option > ")
	local option = tonumber(io.read())

	if option == 1 then
		io.write("enter the data with " .. separator .. " as separator > ")
		local fields = io.read()
		local new = {}
		for field in fields:gmatch("([^" .. separator .. "]+)") do
			table.insert(new, field)
		end
		table.insert(data, new)
	elseif option == 2 then
		io.write("enter the row number to delete (leave blank to delete the last row) > ")
		local row = io.read()
		if row == "" then
			row = #data
			if row <= #data then
				table.remove(data, row)
			end
			table.remove(data, row)
		elseif row <= #data and row > 0 then
			table.remove(data, row)
		else
			io.write("invalid input!\n")
		end
	elseif option == 3 then
		io.write("enter the row number to edit (leave blank to edit the last row) > ")
		local row = io.read()
		if row then
			row = tonumber(row)
			if row <= #data then
				io.write("enter the new data with " .. separator .. " as separator > ")
				local fields = io.read()
				local newRow = {}
				for field in fields:gmatch("([^" .. separator .. "]+)") do
					table.insert(newRow, field)
				end
				data[row] = newRow
			end
		elseif row == "" then
			row = tonumber(#data)
			if row <= #data then
				io.write("enter the new data with " .. separator .. " as separator > ")
				local fields = io.read()
				local newRow = {}
				for field in fields:gmatch("([^" .. separator .. "]+)") do
					table.insert(newRow, field)
				end
				data[row] = newRow
			end
		else
			io.write("invalid input!\n")
		end
	elseif option == 4 then
		printCSV(data)
	elseif option == 5 then
		io.write("do you want to save the changes? (y/n) > ")
		local answer = io.read()
		if answer == "y" or answer == "Y" then
			saveCSV(data, arg[1], separator)
		elseif answer == "n" or answer == "N" then
			break
		else
			io.write("invalid input!\n")
		end
		break
	else
		io.write("invalid input!\n")
	end
end

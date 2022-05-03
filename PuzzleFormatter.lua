-- Wheel Of Fortune Puzzle Formatter by Wheel326

word = "WHEEL OF FORTUNE"
puzzleLengths = {12, 14, 14, 12}
lines = {"","","",""}

str = string.split(word, " ")
print ("There are "..#str .. " words in this puzzle")
local wordStopAt = 1
local run = true
local stopLoop = false

-- Error Checks
if #word > puzzleLengths[1]+puzzleLengths[2]+puzzleLengths[3]+puzzleLengths[4] then
	print ("Error: Puzzle is too long (" .. #word .. " out of " .. puzzleLengths[1]+puzzleLengths[2]+puzzleLengths[3]+puzzleLengths[4] .. " chars)")
end

for i = 1, #str do
	if #str[i] > puzzleLengths[1] or #str[i] > puzzleLengths[2] then
		print ("Error: Word '"..str[i].."' is too long (" .. #str[i].. " chars)")
	end
end

-- Multi Line
for i = 1, 4 do
	if stopLoop == false then
		run = true
		while run == true do
			wait()
			for j = wordStopAt, #str do
				if (#lines[i] + #str[j]) > puzzleLengths[i]  then
					print ("Stopping at word "..j .. " out of word " .. #str)
					run = false
					wordStopAt = j
					break
				else
					lines[i] = lines[i]..str[j].."_"
					if #lines[i] > puzzleLengths[i] then
						lines[i] = lines[i]:sub(0, -2)
					end	
					if wordStopAt == #str then
						print ("All words used, stopping process")
						stopLoop = true
						run = false
						break
					else
						print ("	Row:  " .. i)
						print ("	Word: " ..str[j])
						print ("	Stop: " .. wordStopAt)
						wordStopAt += 1
					end	
					print("Current length is ".. #lines[i] .. " out of " .. puzzleLengths[i] .. " on row " .. i)
				end
			end
		end
			else
		break
	end
	
end
print (lines)

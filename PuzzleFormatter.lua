-- Wheel Of Fortune Puzzle Formatter by Wheel326

board = game.Workspace.PuzzleBoard -- Puzzleboard with Row1, Row2, Row3, etc.
punct = {"!", "?", ",", "-", "#", "&", "$", "'"}
tbl = require(script.Parent.Puzzles) -- ModuleScript in Workspace
word = ""
puzzleLengths = {12, 14, 14, 12} -- Specify the lengths of each row
lines = {"","","",""}

script.Parent.SolvePuzzle.Changed:Connect(function() 
	if script.Parent.SolvePuzzle.Value == true then
		script.Parent.Parent.Sounds.Solve:Play()
		for i = 1, #lines do
			for j = 1, puzzleLengths[i] do
				if string.sub(lines[i], j,j) ~= "_" then
					board["Row"..i]["Tile"..j].Letter.Material = "Neon"
					board["Row"..i]["Tile"..j].Blank.Material = "Neon"
					board["Row"..i]["Tile"..j].CenterPiece.ClickDetector.MaxActivationDistance = 10
				end

			end
		end
		script.Parent.SolvePuzzle.Value = false
	end
	
end)

script.Parent.RevealPuzzle.Changed:Connect(function() 
	if script.Parent.RevealPuzzle.Value == true then
		game.Workspace.Sounds.puzzlereveal:Play()
		game.Workspace.CategoryBar.SurfaceGui.TextBox.Text = tbl[script.Parent.Round.Value][2]
		script.Parent.RevealPuzzle.Value = false
	end

	
end)

script.Parent.ResetPuzzle.Changed:Connect(function() 
	if script.Parent.ResetPuzzle.Value == true then
		for i,v in pairs(game.Workspace.UsedLetters:GetChildren()) do
			v.SurfaceGui.Enabled = true
		end
		
		script.Parent.LetterPicked.Value = ""
		game.Workspace.CategoryBar.SurfaceGui.TextBox.Text = ""
		lines = {"","","",""}
		for i = 1, #lines do
			for j = 1, puzzleLengths[i] do
				board["Row"..i]["Tile"..j].Letter.Material = "SmoothPlastic"
				board["Row"..i]["Tile"..j].Blank.Material = "SmoothPlastic"
				local TweenService = game:GetService("TweenService")
				local root = board["Row"..i]["Tile"..j].CenterPiece
				local info = TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				board["Row"..i]["Tile"..j].Letter.SurfaceGui.TextLabel.Text = ""
				
				if board["Row"..i]["Tile"..j].HasLetter.Value == true then
					local spin = TweenService:Create(root, info, {CFrame = root.CFrame * CFrame.Angles(0, math.rad(120), 0)})
					spin:Play()
					board["Row"..i]["Tile"..j].HasLetter.Value = false
					
					if  board["Row"..i]["Tile"..j].Turned.Value == true then
						local spin = TweenService:Create(root, info, {CFrame = root.CFrame * CFrame.Angles(0, math.rad(-120), 0)})
						spin:Play()
						board["Row"..i]["Tile"..j].Turned.Value = false
					end
				end

			end
		end
		script.Parent.ResetPuzzle.Value = false
	end

end)

script.Parent.ShowPunctuation.Changed:Connect(function() 
	if script.Parent.ShowPunctuation.Value == true then
		for i = 1, #lines do
			for j = 1, puzzleLengths[i] do
				for k = 1, #punct do

					if string.sub(lines[i],j,j) == punct[k] then
						board["Row"..i]["Tile"..j].CenterPiece.ClickDetector.MaxActivationDistance = 10
						board["Row"..i]["Tile"..j].Letter.Material = "Neon"
						board["Row"..i]["Tile"..j].Blank.Material = "Neon"
						game.Workspace.Sounds.LetterDing:Play()
						wait(1)
					end

				end


			end
		end
		script.Parent.ShowPunctuation.Value = false
	end

	
end)

script.Parent.Round.Changed:Connect(function() 
	word = tbl[script.Parent.Round.Value][1]
	
local str = string.split(word, " ")
print ("There are "..#str .. " words in this puzzle")
local wordStopAt = 1
local run = true
local stopLoop = false

-- Error Checks
print ("The length is " .. #word .. " out of " .. puzzleLengths[1]+puzzleLengths[2]+puzzleLengths[3]+puzzleLengths[4] .. " chars")
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

for i = 1, #lines do
	local tempCount = math.floor(#lines[i]/2)
	local underscoresToAdd = ""
	for j = 1, tempCount do
		underscoresToAdd = "" .. "_"
	end
	lines[i] = underscoresToAdd .. lines[i] .. underscoresToAdd
	
	
		while #lines[i] > puzzleLengths[i] do
			wait()
			lines[i] = lines[i]:sub(0, -2)
			if string.sub(lines[i], 1,1) == "_" then
				lines[i] = lines[i]:sub(2)
			end
		end
		while #lines[i] < puzzleLengths[i] do
			wait()
			lines[i] = "_" .. lines[i] .. "_"
		end

end
	
	
	for i = 1, #lines do
		for j = 1, puzzleLengths[i] do
			if string.sub(lines[i],j,j) ~= "_" then
				board["Row"..i]["Tile"..j].Letter.SurfaceGui.TextLabel.Text = string.sub(lines[i],j,j)
				board["Row"..i]["Tile"..j].HasLetter.Value = true
				local TweenService = game:GetService("TweenService")
				local root = board["Row"..i]["Tile"..j].CenterPiece
				local info = TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

				local spin = TweenService:Create(root, info, {CFrame = root.CFrame * CFrame.Angles(0, math.rad(-120), 0)})
				spin:Play()
			end
			
		end
	end
	print (lines)
	script.Parent.LetterPicked.Changed:Connect(function() 
		local count = 0
		for i = 1, #lines do
			for j = 1, puzzleLengths[i] do
				if script.Parent.LetterPicked.Value == string.sub(lines[i],j,j) then
					count += 1
				end
			end
		end
		print("There are " .. count .. " " .. script.Parent.LetterPicked.Value .. "'s in the puzzle.")
		game.Workspace.LetterFrequency.Value.Value = script.Parent.LetterPicked.Value .. " " .. count
		wait(2)
		if count ~= 0 then
			for i = 1, #lines do
				for j = 1, puzzleLengths[i] do

					if script.Parent.LetterPicked.Value == string.sub(lines[i],j,j) then
						board["Row"..i]["Tile"..j].CenterPiece.ClickDetector.MaxActivationDistance = 10

						board["Row"..i]["Tile"..j].Letter.Material = "Neon"
						board["Row"..i]["Tile"..j].Blank.Material = "Neon"
						game.Workspace.Sounds.LetterDing:Play()
						wait(1.5)

					end
				end
			end
		else
			game.Workspace.Sounds.Buzzer:Play()

		end
		game.Workspace.UsedLetters[script.Parent.LetterPicked.Value].SurfaceGui.Enabled = false
		game.Workspace.LetterFrequency.Value.Value = ""


	end)
	

end)

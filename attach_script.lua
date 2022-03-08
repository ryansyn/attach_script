-- GAME LINK: https://www.roblox.com/games/8504045630/Untitled-Game

local SS = game:GetService("ServerStorage")
local RS = game:GetService("ReplicatedStorage");

local attachEvent = RS:WaitForChild("attachEvent");

local function correctHeadMesh(character)
	print("correct head mesh")
	for _,v in ipairs (character:GetChildren()) do
		if v:IsA("Part") then
			if v.Name == "Head" then
				if v:FindFirstChild("Mesh") then
					if v.Mesh.MeshId == 'http://www.roblox.com/asset/?id=2924029023' then
						v.Mesh:Destroy(); v.Transparency = 1; v.face:Destroy();
						print("no head")
					else 
						v.Mesh:Destroy(); SS.display_character.Mesh:Clone().Parent = v; 
						print("default head")
					end
				end
			end
		end
	end
end

local function removeAccessories(character)
	for _,v in ipairs (character:GetChildren()) do
		if v:IsA("Accessory") then
			v:Destroy();
		end
	end
end

local function morphAttach(character, morph_clone)
	morph_clone.Parent = character;
	for _,v in ipairs (morph_clone:GetChildren()) do
		
		-- BODY COLOR ATTATCHING
		if v:IsA("BodyColors") then
			if character:FindFirstChild("Body Colors") then
				character:FindFirstChild("Body Colors"):Destroy()
			end
			v.Parent = character;
		end
		
		-- CLOTHING ATTACHING
		if v:IsA("Shirt") or v:IsA("Pants") then
			for _,w in ipairs(character:GetChildren()) do
				if w.className == v.className then
					w:Destroy();
				end
			end
			v.Parent = character;
		end
		
		-- MORPH ATTATCHING
		if v:IsA("Model") then
			
			-- MORPH PART WELDING
			for _,w in ipairs(v:GetChildren()) do
				if w.Name ~= "Middle" and w:IsA("Part") or w:IsA("UnionOperation") or w:IsA("WedgePart") or w:IsA("MeshPart") then
					w.Anchored = false; w.Massless = true; w.CanCollide = false;
					local one = v.Middle;
					local one_cframe = CFrame.new(one.Position);
					local two = w;

					local weld = Instance.new("Weld");
					weld.Part0 = one;
					weld.Part1 = two;

					local C0 = one.CFrame:inverse() * one_cframe
					local C1 = two.CFrame:inverse() * one_cframe
					weld.C0 = C0
					weld.C1 = C1
					weld.Parent = one;
				end
			end
			
			-- CHARACTER WELDING
			local one = v.Middle; one.Anchored = false; one.Massless = true; one.CanCollide = false;
			local two = character:FindFirstChild(v.Name);
			one.Transparency = 1;

			local weld = Instance.new("Weld");
			weld.Part0 = two;
			weld.Part1 = one;
			weld.C0 = CFrame.new(0, 0, 0)
			weld.Parent = weld.Part0
			
		end
	end
end

attachEvent.OnServerEvent:Connect(function(player, team, morph, primary, secondary)
	local character = player.Character;
	print(player.Name..team..morph..primary..secondary);
	
	if character:FindFirstChild("morph") then
		character.morph:Destroy();
		local morph_clone = SS.character_morphs:FindFirstChild(team):FindFirstChild(morph).morph:Clone();
		correctHeadMesh(character);
		removeAccessories(character);
		morphAttach(character, morph_clone);
	else
		local morph_clone = SS.character_morphs:FindFirstChild(team):FindFirstChild(morph).morph:Clone();
		correctHeadMesh(character);
		removeAccessories(character);
		morphAttach(character, morph_clone);
	end
	
	for _,v in ipairs(player.Backpack:GetChildren()) do
		if v and v:IsA("Tool") then
			v:Destroy()
		end
	end
	
	if SS.character_guns.primaries:FindFirstChild(primary) then
		local weapon_clone = SS.character_guns.primaries:FindFirstChild(primary):Clone();
		weapon_clone.Parent = player.Backpack;
	end
	
	if SS.character_guns.secondaries:FindFirstChild(secondary) then
		local weapon_clone = SS.character_guns.secondaries:FindFirstChild(secondary):Clone();
		weapon_clone.Parent = player.Backpack;
	end
	
end)

true

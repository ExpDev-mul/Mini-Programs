-- // Services
local runService = game:GetService("RunService");
local players = game:GetService("Players");

-- // References
local character;

-- // Constants
local xGrid = 1000;
local zGrid = 1000;
local MAX_HEIGHT = 150;
local TERRAIN_FREQUENCY = 1/100;
local BLOCK_SIZE = Vector3.new(5, 5, 5);
local SNOW_LEVEL = MAX_HEIGHT - 60;
local WATER_LEVEL = 4.9;

-- // Functions & Events
local flowers = script:WaitForChild("Flowers"):GetChildren();
local trees = script:WaitForChild("Trees"):GetChildren();
local collisionBlock = Instance.new("Part")
collisionBlock.Anchored = true
collisionBlock.Transparency = 1
collisionBlock.CastShadow = false
collisionBlock.Size = Vector3.new(10^3, 0, 10^3)
collisionBlock.Parent = workspace
local waterBlock = Instance.new("Part")
waterBlock.Anchored = true
waterBlock.Transparency = 0.3
waterBlock.Material = Enum.Material.Ice
waterBlock.CanCollide = false
waterBlock.Color = Color3.fromRGB(0, 150, 255)
waterBlock.CastShadow = false
waterBlock.Size = Vector3.new(10^6, WATER_LEVEL/2, 10^6)
waterBlock.Parent = workspace
function RenderStepped(dt)
	character = players.LocalPlayer.Character or players.LocalPlayer.CharacterAdded:Wait();
	character:WaitForChild("HumanoidRootPart", math.huge)
	collisionBlock.Position = character.HumanoidRootPart.Position - Vector3.new(0, character.HumanoidRootPart.Position.Y, 0)
	waterBlock.Position = character.HumanoidRootPart.Position - Vector3.new(character.HumanoidRootPart.Position.X - math.round(character.HumanoidRootPart.Position.X/1000)*1000, 
		character.HumanoidRootPart.Position.Y - WATER_LEVEL, 
		character.HumanoidRootPart.Position.Z - math.round(character.HumanoidRootPart.Position.Z/1000)*1000
	) + Vector3.new(math.sin(tick()*0.025)*100, 0, math.sin(tick()*0.025)*100)
end;

runService:BindToRenderStep("Terrain", Enum.RenderPriority.First.Value, RenderStepped)
function CreateBlock(x, z)
	local y = math.noise(x*TERRAIN_FREQUENCY, 0.00001, z*TERRAIN_FREQUENCY)*MAX_HEIGHT;
	y = math.round(y/BLOCK_SIZE.Y)*BLOCK_SIZE.Y
	
	local newBlock = Instance.new("Part");
	newBlock.Material = Enum.Material.SmoothPlastic
	newBlock.Anchored = true
	newBlock.Size = BLOCK_SIZE + Vector3.new(0, y, 0)
	newBlock.Position = Vector3.new(x, newBlock.Size.Y/2, z)
	newBlock.Parent = workspace
		
	if y > SNOW_LEVEL then
		newBlock.Color = Color3.fromRGB(190, 190, 190):Lerp(Color3.fromRGB(255, 255, 255), (SNOW_LEVEL-y)/SNOW_LEVEL)
		return newBlock
	end;
	
	newBlock.Color = Color3.fromRGB(0, 170, 0):Lerp(Color3.fromRGB(170, 85, 0), (y + WATER_LEVEL)/SNOW_LEVEL)
	if y > WATER_LEVEL then
		if math.random(1, 20) == 1 then
			local newTree = trees[math.random(1, #trees)]:Clone();
			newTree.Parent = workspace
			newTree:SetPrimaryPartCFrame(CFrame.new(newBlock.Position + Vector3.new(0, newBlock.Size.Y/2 + newTree.PrimaryPart.Size.Y/2, 0)))
			return newBlock
		end;
		
		if math.random(1, 10) == 1 then
			local newFlower = flowers[math.random(1, #flowers)]:Clone();
			newFlower.Parent = workspace
			newFlower:SetPrimaryPartCFrame(CFrame.new(newBlock.Position + Vector3.new(0, newBlock.Size.Y/2 + newFlower.PrimaryPart.Size.Y/2, 0)))
			return newBlock
		end;
	end;
end;

for x = 1, xGrid, BLOCK_SIZE.X do
	for z = 1, zGrid, BLOCK_SIZE.Z do
		CreateBlock(x, z)
	end;
end;

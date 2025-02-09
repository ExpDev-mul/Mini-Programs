local runService = game:GetService("RunService");

local BEZIER_STEPS = 10

local TRAIN_STEPS = 5
local TRACK_THICKNESS = 0.5
local TRAIN_VELOCITY = 8
function QuadBezierInterpolation(p0, p1, pz, t)
	return p0:Lerp(pz, t):Lerp(p1, t)
end;

local ldir = nil
function PartConnect(part, p0, p1, roffset)
	--if ldir then
		--part.Size = Vector3.new(TRACK_THICKNESS, TRACK_THICKNESS, (p1 - p0).Magnitude - roffset*(ldir:Cross((p1 - p0).Unit).Magnitude) + 0.05)
	--else
		part.Size = Vector3.new(TRACK_THICKNESS, TRACK_THICKNESS, (p1 - p0).Magnitude + 0.05)
	--end;
	
	part.CFrame = CFrame.lookAt(p0:Lerp(p1, 0.5), p1) * CFrame.new(roffset, 0, 0)
end;

local trainTracksFolder = workspace:WaitForChild("TrainTracks");
local pointFolder = trainTracksFolder:WaitForChild("Points");
local curvePointsFolder = trainTracksFolder:WaitForChild("CurvePoints");

local trackParts = trainTracksFolder:WaitForChild("TrackParts");

function UpdateTracks()
	local total = #pointFolder:GetChildren()
	for i = 1, total do
		local p0 = pointFolder:FindFirstChild(tostring(i)).Position
		local p1 = pointFolder:FindFirstChild(tostring(i + 1))
		if not p1 then
			break
		end;

		p1 = p1.Position

		local pz = curvePointsFolder:FindFirstChild(tostring(i)).Position

		local pl = nil
		local stepc = 0
		for t = 0, 1, 1/BEZIER_STEPS do
			local p = QuadBezierInterpolation(p0, p1, pz, t)
			if pl then
				local part1 = trackParts:FindFirstChild(tostring(i.. "_".. stepc).. "1")
				if not part1 then
					part1 = Instance.new("Part", trackParts)
					part1.Name = tostring(i.. "_".. stepc).. "1"
					part1.Anchored = true
					part1.CanCollide = false
					part1.Material = Enum.Material.SmoothPlastic
				end;

				PartConnect(part1, pl, p, 2)

				local part2 = trackParts:FindFirstChild(tostring(i.. "_".. stepc).. "2")
				if not part2 then
					part2 = Instance.new("Part", trackParts)
					part2.Name = tostring(i.. "_".. stepc).. "2"
					part2.Anchored = true
					part2.CanCollide = false
					part2.Material = Enum.Material.SmoothPlastic
				end;

				PartConnect(part2, pl, p, -2)
				stepc += 1
				
				ldir = (p1 - p0).Unit
			end;

			pl = p
		end;
	end;
end;

UpdateTracks()
task.spawn(function()
	while task.wait(1) do
		UpdateTracks()
	end;
end)

local trainParts = {}

local i = 1
local trainPart1 = script:WaitForChild("TrainPart"):Clone()
trainPart1.Parent = workspace
table.insert(trainParts, trainPart1)
function Ride()
	while i < #pointFolder:GetChildren() do
		local stepc = 0
		for t = 0, 1, 1/BEZIER_STEPS do
			if not trackParts:FindFirstChild(tostring(i.. "_".. stepc).. "1") then
				continue
			end;
			
			local p0;
			if t == 0 then
				p0 = pointFolder:FindFirstChild(tostring(i)).Position
			else
				p0 = trackParts:FindFirstChild(tostring(i.. "_".. stepc).. "1").Position:Lerp(trackParts:FindFirstChild(tostring(i.. "_".. stepc).. "2").Position, 0.5)
			end;
			
			local p1;
			if trackParts:FindFirstChild(tostring(i.. "_".. (stepc + 1)).. "1") then
				p1 = trackParts:FindFirstChild(tostring(i.. "_".. (stepc + 1)).. "1").Position:Lerp(trackParts:FindFirstChild(tostring(i.. "_".. (stepc + 1)).. "2").Position, 0.5)
			else
				p1 = pointFolder:FindFirstChild(tostring(i + 1)).Position
			end;
			
			local s = (p1 - p0).Magnitude
			local it = s/TRAIN_VELOCITY
			local k = 0
			while k < 1 do
				local dt = runService.Heartbeat:Wait()
				k = math.min(k + dt/it, 1)
				
				local tp = p0:Lerp(p1, k)
				trainPart1.CFrame = CFrame.lookAt(tp, p1) * CFrame.new(0, trainPart1.Size.Y/2 + TRACK_THICKNESS/2, 0)
			end;
			
			stepc += 1 
		end;
		
		i += 1
	end;
end;

task.wait(3)
print("Started!")
Ride()
while true do
	i = 1
	Ride()
end;

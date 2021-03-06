--[[	Util.lua
		Some utility functions used by the other files in the Arc library.
		This module is licensed under MIT, refer to the LICENSE file or:
		https://github.com/buildthomas/ElectricArc/blob/master/LICENSE
]]

local Util = {}

local GLOBAL_ID = 0

-- Obtaining a unique ID for every call
function Util.getGlobalId()
	GLOBAL_ID = GLOBAL_ID + 1
	return GLOBAL_ID
end

-- Shorthands
local vec3 = Vector3.new
local cframe = CFrame.new
local zeroVector = vec3(0, 0, 0)
local uz = vec3(0, 0, 1)
local ux = vec3(1, 0, 0)
local sqrt = math.sqrt

--[[
-- Unused because too expensive to be worth the benefit since you'd have to call it often
local function RealignArcToCamera(self)
    local relativeCamPos = self.cframe:inverse() * workspace.CurrentCamera.CFrame.p
    for _, v in pairs(self.segments) do
        local c = v.CFrame
        local po = c.p
        local up = c.upVector
        local lf = cross(relativeCamPos - po, up).unit
        local fr = cross(lf, up).unit
        v.CFrame = cframe(po.x, po.y, po.z, lf.x, up.x, fr.x, lf.y, up.y, fr.y, lf.z, up.z, fr.z)
    end
end
]]

-- Making a CFrame value from an origin position and unit direction:
function Util.makeOrientation(sourcePos, dir)
	-- Construct CFrame to rotate parts from x-axis alignment (where they are constructed) to
	-- the world orientation of the arc from a quaternion rotation that describes the
	-- rotation of ux-->axis
	dir = dir.Unit

	-- Proportionate angle between ux and direction:
	local angleUxAxis = ux:Dot(dir)

	if (angleUxAxis > 0.99999) then
		return cframe(sourcePos, sourcePos - uz)
	elseif (angleUxAxis < -0.99999) then
		return cframe(sourcePos, sourcePos + uz)
	else
		local q = ux:Cross(dir)
		local qw = 1 + angleUxAxis
		local qnorm = sqrt(q.Magnitude * q.Magnitude + qw * qw)
		q = q / qnorm
		qw = qw / qnorm
		return cframe(sourcePos.X, sourcePos.Y, sourcePos.Z, q.X, q.Y, q.Z, qw)
	end
end

return Util

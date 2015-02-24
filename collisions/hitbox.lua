require 'utils/Vector'

Hitbox = {}
Hitbox.__index = Hitbox

function Hitbox.new(min, max)
	local new = {}
	new.min = min
	new.max = max
	setmetatable(new, Hitbox)
	return new
end

function Hitbox:collide(oth)
	collision = {
		depth = nil,
		normal = nil
	}

	-- the side on which the collision occurs is the side the least into the other object
	local function testOverlap(overlap, normal)
		if overlap < 0 then return false end

		if (not collision.depth) or (overlap < collision.depth) then
			collision.depth = overlap
			collision.normal = normal
		end

		return true
	end

	if not testOverlap(self.max.x - oth.min.x, Vector.right) then return nil end
	if not testOverlap(oth.max.x - self.min.x, Vector.left) then return nil end
	if not testOverlap(self.max.y - oth.min.y, Vector.down) then return nil end
	if not testOverlap(oth.max.y - self.min.y, Vector.up) then return nil end

	return collision
end

function Hitbox:move(dir)
	self.min = self.min + dir
	self.max = self.max + dir
end

function Hitbox:draw()
	local min, max = self.min, self.max

	love.graphics.setColor(255,0,0)
	love.graphics.rectangle('line',min.x,min.y,max.x-min.x,max.y-min.y)
end

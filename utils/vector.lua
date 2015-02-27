Vector = {}
Vector.__index = Vector

function Vector.new(x, y)
	local new

	if type(x) == "table" and x.__class == "Vector" then
		new = {x = x.x, y = x.y}
	else
		x = x or 0
		y = y or 0
		new = {x = x, y = y}
	end

	setmetatable(new, Vector)
	return new
end

Vector.__tostring = function (self)
	return string.format("(%f, %f)", self.x, self.y)
end

Vector.__add = function (lhs, rhs)
	if lhs.__class == "Vector" and type(rhs) == "number" then
		return Vector.new(lhs.x + rhs, lhs.y + rhs)
	elseif lhs.__class == "Vector" and rhs.__class == "Vector" then
		return Vector.new(lhs.x + rhs.x, lhs.y + rhs.y)
	end
end

Vector.__sub = function (lhs, rhs)
	if lhs.__class == "Vector" and type(rhs) == "number" then
		return Vector.new(lhs.x - rhs, lhs.y - rhs)
	elseif lhs.__class == "Vector" and rhs.__class == "Vector" then
		return Vector.new(lhs.x - rhs.x, lhs.y - rhs.y)
	end
end

Vector.__unm = function (rhs)
	if (rhs.__class == "Vector") then
		return Vector.new(-rhs.x, -rhs.y)
	end
end

Vector.__mul = function (lhs, rhs)
	if type(rhs) == "number" then
		return Vector.new(lhs.x * rhs, lhs.y * rhs)
	end
end

function Vector:copy(oth)
	if type(oth) == "table" and oth.__class == "Vector" then
		self.x = oth.x
		self.y = oth.y
	end
end

function Vector:clone()
	local new = Vector.new()
	new:copy(self)

	return new
end

function Vector:norm()
	return math.sqrt(self.x^2 + self.y^2)
end

function Vector:normalize()
	local norm = self:norm()
	return Vector.new(self.x / norm, self.y / norm)
end

function Vector:dot(oth)
	return self:norm() * oth:norm() * math.cos(math.abs(self:angle(oth)))
end

function Vector:rotate(angle)
	local cos, sin = math.cos(angle), math.sin(angle)
	return Vector.new(self.x * cos - self.y * sin, self.x * sin + self.y * cos)
end

-- in radians
function Vector:angle(oth)
	return math.atan2(oth.y,oth.x) - math.atan2(self.y,self.x)
end

function Vector:set(x, y)
  self.x = x
  self.y = y
end

Vector.__class = "Vector"
Vector.up = Vector.new(0, -1)
Vector.down = Vector.new(0, 1)
Vector.left = Vector.new(-1, 0)
Vector.right = Vector.new(1, 0)

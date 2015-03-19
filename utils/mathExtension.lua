local floor, min, max = math.floor, math.min, math.max

function math.lerp(start, stop, t)
	return start + (stop - start) * t
end

local function clamp(value, minv, maxv)
	return min(maxv, max(minv, value))
end
math.clamp = clamp

function math.repeat_(t, length)
	return t - floor(t / length) * length
end

function math.round(num)
  return floor(num + 0.5)
end

math.twoPi = 2 * math.pi

function math.deltaAngle(current, target)
    local num = math.repeat_(target - current, math.twoPi)
    if num > math.pi then
        num = num - math.twoPi
    end
    return num;
end

function math.smoothDamp(current, target, currentVelocity, smoothTime, maxSpeed, deltaTime)
	smoothTime = max(0.0001, smoothTime)
	local num = 2 / smoothTime
	local num2 = num * deltaTime
	local num3 = 1 / (1 + num2 + 0.48 * num2 * num2 + 0.235 * num2 * num2 * num2)
	local num4 = current - target
	local num5 = target
	local num6 = maxSpeed * smoothTime
	num4 = clamp(num4, -num6, num6)
	target = current - num4
	local num7 = (currentVelocity + num * num4) * deltaTime
	currentVelocity = (currentVelocity - num * num7) * num3
	local num8 = target + (num4 + num7) * num3
	if (num5 - current > 0) == (num8 > num5) then
		num8 = num5
		currentVelocity = (num8 - num5) / deltaTime
	end
	return num8, currentVelocity
end

function math.smoothDampAngle(current, target, currentVelocity, smoothTime, maxSpeed, deltaTime)
	target = current + math.deltaAngle(current, target)
	return math.smoothDamp(current, target, currentVelocity, smoothTime, maxSpeed, deltaTime)
end

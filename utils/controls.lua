Controls = {}

local _keysPressed = {}
local _keysHold = {}
local _lastClick

function Controls.update()
	_keysPressed = {}
	_lastClick = nil
end

-- Keyboard
function love.keypressed(key)
  _keysPressed[key] = true
	_keysHold[key] = true
end

function love.keyreleased(key)
	_keysHold[key] = nil
end

function Controls.isKeyPressed(key)
	return _keysPressed[key]
end

function Controls.isOnePressed(keys)
  for _, key in ipairs(keys) do
    if Controls.isKeyPressed(key) then
      return true
    end
  end
  return false
end

function Controls.isKeyHeld(key)
	return _keysHold[key]
end

function Controls.isOneHeld(keys)
  for _, key in ipairs(keys) do
    if Controls.isKeyHeld(key) then
      return true
    end
  end
  return false
end

function Controls.isKeyReleased(key)
	return not _keysHold[key]
end

function Controls.isOneReleased(keys)
  for _, key in ipairs(keys) do
    if Controls.isKeyReleased(key) then
      return true
    end
  end
  return false
end

-- Mouse
function love.mousepressed(x, y, button)
	_lastClick = {x = x, y = y, button = button}
end

function Controls.isMouseLeftClicked()
	return _lastClick ~= nil and _lastClick.button == 'l'
end

function Controls.getClickPosition()
	if _lastClick ~= nil then
		return _lastClick.x, _lastClick.y
	end
end

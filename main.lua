require 'controls'
require 'hitbox'
require 'state'
require 'stateMachine'
require 'vector'

math.randomseed(os.time())

Keymap = {
  changeState = ' ',
  quit = 'escape',
  generateBox = 'b',
  debugMode = 'f1'
}

-- WATERMELON OBJECT
Watermelon = StateMachine.new()
Watermelon.radius = 200
Watermelon.position = Vector.new(love.window.getWidth() / 2, love.window.getHeight() / 2)
Watermelon.hitbox = Hitbox.new( Vector.new(Watermelon.position.x - Watermelon.radius, Watermelon.position.y),
                                Watermelon.position + Watermelon.radius)
function Watermelon:drawIt()
  local x, y = self.position.x, self.position.y
  local radius = self.radius

  love.graphics.setColor(0, 0, 0)
  love.graphics.circle('fill', x, y, radius)
  radius = radius - 5

  love.graphics.setColor(67, 206, 124)
  love.graphics.circle('fill', x, y, radius)
  radius = radius - 20

  love.graphics.setColor(255, 255, 255)
  love.graphics.circle('fill', x, y, radius)
  radius = radius - 10

  love.graphics.setColor(206, 64, 64)
  love.graphics.circle('fill', x, y, radius)

  x, y = x - self.radius, y - self.radius
  local w, h = self.radius * 2, self.radius
  love.graphics.setColor(love.graphics.getBackgroundColor())
  love.graphics.rectangle('fill', x, y, w, h)
end

WatermelonWaitingState = State.new('Waiting', Watermelon)
function WatermelonWaitingState:draw()
  self.parent:drawIt()
end

WatermelonRotatingState = State.new('Rotating', Watermelon)
WatermelonRotatingState.rotation = 0

function WatermelonRotatingState:update(dt)
  self.rotation = self.rotation + math.pi * dt

  if self.rotation >= math.pi * 2 then
    self.parent:setState('Waiting')
  end
end

function WatermelonRotatingState:draw()
  love.graphics.push()
  love.graphics.translate(self.parent.position.x, self.parent.position.y)
  love.graphics.rotate(self.rotation)
  love.graphics.translate(-self.parent.position.x, -self.parent.position.y)
  self.parent:drawIt()
  love.graphics.pop()
end

function WatermelonRotatingState:leave()
  self.rotation = 0
end

-- FALLING OBJECTS
Box = {}
Box.__index = Box

function Box.new(x, y, size)
  local new = {}
  new.size = size
  new.position = Vector.new(x, y)
  new.hitbox = Hitbox.new(new.position:clone(), new.position + size)
  new.velocity = Vector.down * 9.81 * math.random(30, 50)
  new.color = {
    math.random(30, 220),
    math.random(30, 220),
    math.random(30, 220)
  }

  setmetatable(new, Box)
  return new
end

function Box:update(dt)
  -- gravity
  local move = self.velocity * dt
  self.position = self.position + move
  self.hitbox:move(move)

  -- collisions
  if Watermelon.currentState == 'Waiting' then
    local collision = self.hitbox:collide(Watermelon.hitbox)
    if collision then
      move = -collision.normal * collision.depth
      self.position = self.position + move
      self.hitbox:move(move)
    end
  end
end

function Box:draw()
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', self.position.x, self.position.y, self.size, self.size)
end

-- LOVE CALLBACKS
local debugMode = false
local boxes = {}

function love.load()
  love.graphics.setBackgroundColor(255, 255, 255)
  Watermelon:setState('Waiting')
end

function love.update(dt)
  Watermelon:update(dt)
  local keep = {}
  for _, box in ipairs(boxes) do
    box:update(dt)
    if box.position.y <= love.window.getHeight() then
      table.insert(keep, box)
    end
  end
  boxes = keep

  -- Controls
  if Controls.isKeyPressed(Keymap.quit) then
    love.event.push('quit')
    return
  end

  if Controls.isKeyPressed(Keymap.debugMode) then
    debugMode = not debugMode
  end

  if Controls.isKeyPressed(Keymap.changeState) and Watermelon.currentState ~= 'Rotating' then
    Watermelon:setState('Rotating')
  end

  if Controls.isKeyHeld(Keymap.generateBox) and Watermelon.currentState ~= 'Rotating' then
    table.insert(boxes, Box.new(math.random(0, love.window.getWidth()), -100, math.random(10, 40)))
  end

  -- Controls.update should always be called last.
  Controls.update()
end

function love.draw()
  Watermelon:draw()
  if debugMode then
    Watermelon.hitbox:draw()
  end

  for _, box in ipairs(boxes) do
    box:draw()
    if debugMode then
      box.hitbox:draw()
    end
  end

  love.graphics.setColor(0, 0, 0)
  love.graphics.print('Hold B to spawn cubes', 20, 20)
  love.graphics.print('Press SPACE to rotate the watermelon', 20, 40)
  love.graphics.print('Press ESC to quit', 20, 60)
end

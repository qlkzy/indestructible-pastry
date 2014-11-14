local Player = {}
Player.__index = Player

-- "constructor"
function Player.new(x, name, color)
    self = {
        -- properties
        -- velocity
        vx = 0,
        vy = 0,
        -- position
        y = love.graphics.getHeight(),
        x = x,
        -- other properties
        name = name,
        color = color,
        health = 100,
        punch_time = -2,         -- internal timer for displaying punch
    }
    setmetatable(self, Player)
    return self
end

function Player.moveLeft(self)
    self.vx = -100
end

function Player.moveRight(self)
    self.vx = 100
end

function Player.stop(self)
    self.vx = 0
end

function Player.punch(self)
    if self.punch_time < -0.75 then
        self.punch_time = 0.25
    end
end

function Player.jump(self)
    -- allow jumping if vertical velocity is low
    -- (allows double-jump but requires good timing)
    if math.abs(self.vy) < 50 then
        -- impart a vertical impulse
        self.vy = 250
    end
end

function Player.update(self, dt)

    -- apply velocity to position
    self.x = self.x + self.vx * dt
    self.y = self.y - self.vy * dt

    -- apply horizontal bounds
    if self.x < 0 then
        self.x = 0
    elseif self.x > love.graphics.getWidth() then
        self.x = love.graphics.getWidth()
    end

    -- apply vertical bounds
    if self.y >= love.graphics.getHeight() then
        self.y = love.graphics.getHeight()
    end

    if self:onGround() then
        -- if we are on the ground, stop moving
        self.vy = 0
    else
        -- otherwise, accelerate downwards
        self.vy = self.vy - 500 * dt
    end

    -- decay the "punch" timer
    self.punch_time = self.punch_time - dt
end

function Player.draw(self)
    -- save previous color
    local r, g, b, a = love.graphics.getColor()

    -- draw the "body" rectangle
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x, self.y - 40, 20, 40)

    -- if we are punching, draw the "arms" rectangle
    if self.punch_time > 0 then
        love.graphics.rectangle('fill', self.x - 10, self.y - 30, 40, 5)
    end

    -- restore previous color
    love.graphics.setColor(r, g, b, a)
end

function Player.onGround(self)
    max_y = love.graphics.getHeight()
    return self.y >= max_y - 0.1
end

function Player.near(self, o)
    return math.abs(self.x - o.x) < 30 and math.abs(self.y - o.y) < 20
end

function Player.hit(self)
    self.health = self.health - 5
end

return Player

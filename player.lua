local Player = {}


-- "constructor"
function Player.new(x, name, color)
    return {
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
        punch_time = 0,         -- internal timer for displaying punch

        -- methods
        -- commands
        moveLeft = Player.moveLeft,
        moveRight = Player.moveRight,
        punch = Player.punch,
        jump = Player.jump,
        stop = Player.stop,
        -- called by top-level love methods
        update = Player.update,
        draw = Player.draw,
        -- utility methods
        onGround = Player.onGround,
        near = Player.near,
        hit = Player.hit,
    }
end

function Player.moveLeft(p)
    p.vx = -100
end

function Player.moveRight(p)
    p.vx = 100
end

function Player.stop(p)
    p.vx = 0
end

function Player.jump(p)
    -- allow jumping if vertical velocity is low
    -- (allows double-jump but requires good timing)
    if math.abs(p.vy) < 50 then
        -- impart a vertical impulse
        p.vy = 250
    end
end

function Player.update(p, dt)

    -- apply velocity to position
    p.x = p.x + p.vx * dt
    p.y = p.y - p.vy * dt

    -- apply horizontal bounds
    if p.x < 0 then
        p.x = 0
    elseif p.x > love.graphics.getWidth() then
        p.x = love.graphics.getWidth()
    end

    -- apply vertical bounds
    if p.y >= love.graphics.getHeight() then
        p.y = love.graphics.getHeight()
    end

    if p:onGround() then
        -- if we are on the ground, stop moving
        p.vy = 0
    else
        -- otherwise, accelerate downwards
        p.vy = p.vy - 500 * dt
    end

    -- decay the "punch" timer
    p.punch_time = p.punch_time - dt
    
    -- clamp the "punch" timer
    if p.punch_time <= 0 then
        p.punch_time = 0
    end
end

function Player.onGround(p)
    max_y = love.graphics.getHeight()
    return p.y >= max_y - 0.1
end

function Player.punch(p)
    p.punch_time = 0.25
end

function Player.draw(p)
    -- save previous color
    local r, g, b, a = love.graphics.getColor()

    -- draw the "body" rectangle
    love.graphics.setColor(p.color)
    love.graphics.rectangle('fill', p.x, p.y - 40, 20, 40)

    -- if we are punching, draw the "arms" rectangle
    if p.punch_time > 0 then
        love.graphics.rectangle('fill', p.x - 10, p.y - 30, 40, 5)
    end

    -- restore previous color
    love.graphics.setColor(r, g, b, a)
end

function Player.near(p, o)
    return math.abs(p.x - o.x) < 30 and math.abs(p.y - o.y) < 20
end

function Player.hit(p)
    p.health = p.health - 5
end

return Player

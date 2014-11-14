local Player = require "player"

-- global variables, hooray!
local player1
local player2
local game_over

function love.load()
    player1 = Player.new(100, 'Blue', {0, 0, 255})
    player2 = Player.new(500, 'Red', {255, 0, 0})
    game_over = false
end

function love.update(dt)
    player1:update(dt)
    player2:update(dt)
    if player1.health == 0 or player2.health == 0 then
        game_over = true
    end
end

function love.draw()
    if game_over and player1.health <= 0 then
        love.graphics.print("Red wins!\nPress Enter to Restart",
                            100, 300, 0, 2)
    elseif game_over and player2.health <= 0 then
        love.graphics.print("Blue wins!\nPress Enter to Restart",
                            100, 200, 0, 2)
    else
        -- draw players
        player1:draw()
        player2:draw()


        -- draw player 1 health (top left)
        love.graphics.setColor({0, 0, 255})
        love.graphics.printf(player1.health,
                             0, 0, -- upper left
                             love.graphics.getWidth() / 2, -- alignment limit
                             "left",                       -- alignment mode
                             0,                            -- rotation
                             2)                            -- scale factor

        -- draw player 2 health (top right)
        love.graphics.setColor({255, 0, 0})
        love.graphics.printf(player2.health,
                             0, 0, -- upper left
                             love.graphics.getWidth() / 2, -- alignment limit
                             "right",                      -- alignment mode
                             0,                            -- rotation
                             2)                            -- scale factor
    end
end

function love.keypressed(key)

    if game_over then
        if key == 'return' then
            love.load()
        end
        return                  -- if game is over, stop here
    end
    
    -- player 1 keys
    if key == 'w' then
        player1:jump()
    elseif key == 'a' then
        player1:moveLeft()
    elseif key == 'd' then
        player1:moveRight()
    elseif key == ' ' then
        player1:punch()
        if player1:near(player2) then
            player2:hit()
        end
    end

    -- player 2 keys
    if key == 'kp8' then
        player2:jump()
    elseif key == 'kp4' then
        player2:moveLeft()
    elseif key == 'kp6' then
        player2:moveRight()
    elseif key == 'kp0' then
        player2:punch()
        if player2:near(player1) then
            player1:hit()
        end
    end
end

function love.keyreleased(key)
    if key == 'a' or key == 'd' then
        player1:stop()
    end
    if key == 'kp4' or key == 'kp6' then
        player2:stop()
    end
end

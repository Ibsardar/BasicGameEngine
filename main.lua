--[[--------------------------
    
    FILE:   main.lua
    AUTH:   Ibrahim Sardar
    DATE:   11 / 10 / 2016
    
--]]--------------------------



require("Blob")

-- note: returns true if enemy spawned
function generate_badies( player, group )

    seconds = fish:get_elapsed()
    
    if seconds >= 1 then
        fish:reset_time()
        
        local rx = math.random(25,love.graphics.getWidth()-75) -- between 25 and width-75
        local ry = math.random(25,love.graphics.getHeight()-75) -- between 25 and height-75
        local rs = math.random(3125,31250) / 100000 -- between 0.03125 and 0.3125
        local rt = math.random(1000,36000) / 100 -- between 1 and 360
        local rd = math.random(1,100) / 100 -- between .01 and 1
        local neg = math.random(1,2)
        
        if neg == 1 then
            rd = -rd
        end
        
        f = Sprite()
        f:load( "fish2.png", rx, ry )
        f:set_turn( rt )
        f:set_ang_accel( rd )
        f:scale( rs )
        f:set_speed( 0.125/rs )
        
        table.insert( group, f )
        
        return true
        
    end
    
    return false
    
end

function game_over()
    love.load()
end



-- \
-- =>  Game Loop Functions:
-- /

function love.load()

    local cx = love.graphics.getWidth() / 2
    local cy = love.graphics.getHeight() / 2
    
    bullets = {}
    goodspr = {}
    badspr  = {}
    
    -- originally was a blob but then I made a fish :|
    fish = Blob()
    fish : load( "blob.png", cx, cy+100 )
    fish : set_turn( 180 )
    fish : init( bullets )
    
    table.insert( goodspr, fish )

    --fnt = love.graphics.newFont( 45 )
    
    --pic = love.graphics.newImage( "blob.png" )
    
    love.graphics.setBackgroundColor( 255,255,255 )
    
    
    
end

function love.update( dt )
    
    --[[love.window.showMessageBox("info", "pos: "..p:get_x()..", "..p:get_y(), "info")
    love.window.showMessageBox("info", "dim: "..p:get_w()..", "..p:get_h(), "info")
    if p:is_destroyed() then
        love.window.showMessageBox("err", "sprite is destroyed", "error")
    end]]--
    
    -- cap fps at 40FPS
    if dt < 1 / 40 then
        love.timer.sleep( 1 / 40 - dt)
    end
    
    -- generate enemies
    generate_badies( fish, badspr )
    
    -- for each bad guy
    for key,val in pairs(badspr) do
        -- check collisions
        
        -- player
        if fish:colliding( val ) then
            -- try to eat bad fish
            if fish:try_to_eat( val ) == false then
                game_over()
            end
            -- go away (deletes automatically)
            val:set_pos(-100,-100)
        end
        
        -- bullets
        for key2,val2 in pairs(bullets) do
            if val2:colliding( val ) then
                -- shrink, if too small, die
                if val:get_w() < 10 then
                    val:set_pos(-100,-100)
                else
                    val:scale( val:get_scalex() * 0.9 )
                end
                -- remove bullet
                val2:set_pos(-100,-100)
            end
        end
    end
    
    -- update bullets
    for key,val in pairs(bullets) do
        val:update(dt)
    end
    -- update good sprites
    for key,val in pairs(goodspr) do
        val:update(dt)
    end
    -- update bad sprites
    for key,val in pairs(badspr) do
        val:update(dt)
    end

end

function love.draw(dt)

    --local x = cx - ( pic : getWidth()  /2 )
    --local y = cy - ( pic : getHeight() /2 )
    
    --love.graphics.draw( pic,x,y )
    
    -- draw bullets
    for key,val in pairs(bullets) do
        val:draw()
    end
    -- draw good sprites
    for key,val in pairs(goodspr) do
        val:draw(dt)
    end
    -- draw bad sprites
    for key,val in pairs(badspr) do
        val:draw(dt)
    end
    
end
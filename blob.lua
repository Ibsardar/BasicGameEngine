--[[--------------------------

    FILE:   blob.lua
    AUTH:   Ibrahim Sardar
    DATE:   11 / 11 / 2016

--]]--------------------------



require ("Sprite")

Blob = class()
Blob : addparent(Sprite) --inherit from Sprite class

-- initialize once
function Blob:init( bullet_group )
    self:scale(0.375/4)
    self.rank = 1
    self.bullets = bullet_group
    self.quickness = 0.1
    self:set_dir( 0 )
    self:set_speed( 1 )
    self.max_spd = 2
    self.food = 0
end

-- update continuously (override)
function Blob:update_more()

    -- upgrade after eating enough enemy fishies
    if self.food >= self.rank*self.rank then
        self:rank_up()
        self.food = 0
        love.window.showMessageBox( "LEVEL "..self.rank, "level up!", info )
    end

end

-- handle events continuously (override)
function Blob:interact()

    local curr_spd = self:get_speed()
    local curr_trn = self:get_dir()

    -- if key released
    function love.keyreleased(key, cd, rpt)

        -- "Q" to quit
        if key == "q" then
            love.event.quit()
        end

        -- shoot when space-bar is hit
        if key == "space" then
            self:shoot()
        end

    end

    --[[function love.keypressed(key, cd, rpt)

        if key == "up" then
            self:set_accel(curr_acl + self.quickness/2)
        elseif key == "down" then
            self:set_accel(curr_acl - self.quickness/2)
        end

        if key == "right" then
            self:set_turn(curr_trn - self.quickness*2)
        elseif key == "left" then
            self:set_turn(curr_trn + self.quickness*2)
        end

    end]]

    -- move forward/backward with up/down arrow keys
    if love.keyboard.isDown( 'up' ) then
        self:set_speed(curr_spd + self.quickness/2)
    elseif love.keyboard.isDown( 'down' ) then
        self:set_speed(curr_spd - self.quickness/2)
    end

    if self:get_speed() > self.max_spd then
        self:set_speed( self.max_spd )
    elseif self:get_speed() < -self.max_spd then
        self:set_speed( -self.max_spd )
    end

    -- turn with left/right arrow keys
    if love.keyboard.isDown( 'right' ) then
        self:set_turn(curr_trn - self.quickness*10)
    elseif love.keyboard.isDown( 'left' ) then
        self:set_turn(curr_trn + self.quickness*10)
    end

end

-- handle bounds continuously (override) (WRAP)
function Blob:bound()

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local x = self:get_cx()
    local y = self:get_cy()

    if x > w then

        self:set_cx( 0 )

    elseif x < 0 then

        self:set_cx( w )

    elseif y > h then

        self:set_cy( 0 )

    elseif y < 0 then

        self:set_cy( h )

    end

end

-- shoot a small blob
function Blob:shoot()

    b = Sprite()
    b:load( "blob.png", self:get_x(), self:get_y() )
    b:set_turn( self:get_dir() )
    b:scale( 0.25/4 )
    b:set_speed( 10 )

    table.insert( self.bullets, b )

end

-- rank up
function Blob:rank_up()

    -- inc rank
    self.rank = self.rank + 1

    -- inc size
    local s = self:get_scalex()
    self:scale( s * 1.25 )

    -- inc speed
    self.quickness = self.quickness + 0.2
    self.max_spd = self.max_spd + 1

 end

 -- try to eat other sprite
 function Blob:try_to_eat( spr )

    if self:get_w() > spr:get_w() then
        self.food = self.food + 1
		self:scale( self:get_scalex() * 1.05 )
        return true
    end

    -- if failed
    return false

 end


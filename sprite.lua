--[[--------------------------
    
    FILE:   sprite.lua
    AUTH:   Ibrahim Sardar
    DATE:   11 / 11 / 2016
    
--]]--------------------------


-- dependencies
require("SECL")


--| Sprite Class
--|
Sprite = class()


-- -\
-- --> --- PROPERTIES ----------------------------------------<
-- -/


-- pic
Sprite.pic = nil
Sprite.pic_lord = ""


-- size
Sprite.scale_x = 1
Sprite.scale_y = 1


-- pos
Sprite.x = 0
Sprite.y = 0


-- vel
Sprite.speed = 0
Sprite.dx = 0
Sprite.dy = 0


-- acc
Sprite.accel = 0


-- ang
Sprite.dir = 0
Sprite.rot = 0
Sprite.dr = 0
Sprite.max_rot = 0


-- time
Sprite.elapsed = 0


-- memberships
Sprite.group = nil


-- debug
Sprite.is_debug = false
Sprite.d_delay = 0
Sprite.d_timer = 0


-- other
Sprite.dead = false
Sprite.layer = 0 --> default layer


-- -\
-- --> --- ESSENTIAL methods ---------------------------------<
-- -/


function Sprite:load( img, x, y )
    --|     constructor
    --|
    
    self.pic_lord = img
    self.pic = love.graphics.newImage( img )
    self.x = x
    self.y = y

end


function Sprite:update(dt)
    --|    Called every frame. Updates changing
    --|    parameters.
    --|
       
    -- skip if marked for deletion
    if self.dead == true then
        return
    end
       
    -- update clock
    self.elapsed = self.elapsed + dt
      
    -- update all movement
    self:move()
    
    -- bounds the sprite appropriately
    self:bound();
    
    -- user custom event handler
    self:interact();
    
    -- user custom update
    self:update_more();
    
end

function Sprite:draw(dt)
    --|     Called every frame. Processes graphics
    --|     based on current parameters.
    --|
      
    -- skip if marked for deletion
    if self.dead == true then
        return
    end
    
    -- degs to radians
    local rot = self.dir * math.pi / 180
    rot = rot * -1
        
    -- draw
    love.graphics.draw ( self.pic,
                         self.x,
                         self.y, 
                         rot,
                         self.scale_x,
                         self.scale_y,
                         self:get_w_orig()/2,
                         self:get_h_orig()/2 )
    
end

function Sprite:destroy()
    --|     Marks current instance for deletion
    --|
    
    self.dead = true
    self = nil
    
end


-- -\
-- --> --- SUB-ESSENTIAL methods -----------------------------<
-- -/


function Sprite:move()
    --|     Called in update. Updates position and
    --|     rotation.
    --|
    
    
    --   acceleration:
    --
    -- linear
    self.speed = self.speed + self.accel
    -- angular
    self.rot = self.rot + self.dr
    self.dir = self.dir + self.dr

    
    --   speed:
    --
    -- get radians
    local theta = self.dir * math.pi / 180
    theta = theta * -1
    -- speed vector
    self.dx = math.cos(theta) * self.speed
    self.dy = math.sin(theta) * self.speed 
    -- update difference in x and y position
    self.x = self.x + self.dx
    self.y = self.y + self.dy

end

function Sprite:bound()
    --|     Called in update. Default destroy
    --|     on leave screen +/- 50.
    --|     Meant to be over-ridden.
    --|
    
    local offset = 50
    
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local r = self:get_right() + offset
    local t = self:get_top() - offset
    local l = self:get_left() - offset
    local b = self:get_bottom() + offset
    
    if r < 0 or
       t > h or
       l > w or
       b < 0 then
        
        self:destroy()
    end
    
end

function Sprite:update_more()
    --|     Called in update. Meant to be over-ridden.
    --|
    
    return
    
end

function Sprite:interact()
    --|     Called in update. Meant to be over-ridden.
    --|     Meant to be used as an event-handler.
    --|
    
    return
    
end


-- -\
-- --> --- GET methods ---------------------------------------<
-- -/


--###
--###>  visual:


function Sprite:get_w()
    --|     Returns width of sprite.
    --|
    
    return self.pic:getWidth() * self.scale_x

end

function Sprite:get_h()
    --|     Returns height of sprite.
    --|
    
    return self.pic:getHeight() * self.scale_y

end

function Sprite:get_w_orig()
    --|     Returns original width of sprite.
    --|
    
    return self.pic:getWidth()

end

function Sprite:get_h_orig()
    --|     Returns original height of sprite.
    --|
    
    return self.pic:getHeight()

end

function Sprite:get_pic()
    --|     Returns the image link of sprite.
    --|
    
    return self.pic_lord

end

function Sprite:get_scalex()
    --|     Returns image scale in the x direction
    --|
    
    return self.scale_x
    
end

function Sprite:get_scaley()
    --|     Returns image scale in the y direction
    --|
    
    return self.scale_y
    
end


--###
--###>  positional:


function Sprite:get_x()
    --|     Returns the accurate x position.
    --|     ( left )
    --|
    
    return self.x

end

function Sprite:get_y()
    --|     Returns the accurate y position.
    --|     ( top )
    --|
    
    return self.y

end

function Sprite:get_pos()
    --|     Returns the accurate position.
    --|     ( top left )
    --|
    
    return {self.x, self.y}

end

function Sprite:get_cx()
    --|     Returns the accurate center x position.
    --|
    
    return self.x + ( self:get_w()/2 )

end

function Sprite:get_cy()
    --|     Returns the accurate center y position.
    --|
    
    return self.y + ( self:get_h()/2 )

end

function Sprite:get_center()
    --|     Returns the accurate center position.
    --|
    
    return { self:get_cx(), self:get_cy() }

end

function Sprite:get_right()
    --|     Returns the accurate right x position.
    --|
    
    return self.x + self:get_w()
    
end

function Sprite:get_top()
    --|     Returns the accurate top y position.
    --|
    
    return self.y
    
end

function Sprite:get_left()
    --|     Returns the accurate left x position.
    --|
    
    return self.x
    
end

function Sprite:get_bottom()
    --|     Returns the accurate bottom y position.
    --|
    
    return self.y + self:get_h()
    
end


--###
--###>  speed-related:


function Sprite:get_speedx()
    --|     Returns the accurate speed in
    --|     the x direction.
    --|
    
    local rads = self.dir * math.pi / 180
    return math.cos(rads) * self.speed
    
end

function Sprite:get_speedy()
    --|     Returns the accurate speed in
    --|     the y direction.
    --|
    
    local rads = self.dir * math.pi / 180
    return math.sin(rads) * self.speed * -1
    
end

function Sprite:get_speed()
    --|     Returns the accurate speed.
    --|
    
    return self.speed
    
end


--###
--###>  acceleration-related:


function Sprite:get_accelx()
    --|     Returns the accurate acceleration
    --|     in the x direction.
    --|
    
    local rads = self.dir * math.pi / 180
    return math.cos(rads) * self.accel
    
end

function Sprite:get_accely()
    --|     Returns the accurate acceleration
    --|     in the y direction.
    --|
    
    local rads = self.dir * math.pi / 180
    return math.sin(rads) * self.accel * -1
    
end

function Sprite:get_accel()
    --|     Returns the accurate acceleration.
    --|
    
    return self.accel
    
end


--###
--###>  angular:


function Sprite:get_dir()
    --|     Returns the accurate direction. (deg)
    --|
    
    return self.dir
    
end

function Sprite:get_ang_speed()
    --|     Returns the accurate angular speed.
    --|     (deg per update)
    --|
    
    return self.rot
    
end

function Sprite:get_ang_accel()
    --|     Returns the accurate angular acceleration.
    --|     (angular speed per update)
    --|
    
    return self.dr
    
end


--###
--###>  other:


function Sprite:is_destroyed()
    --|     Returns true if sprite is dead/destroyed
    --|
    
    return self.dead
    
end

function Sprite:get_elapsed()
    --|     Returns elapsed time since last updated
    --|
    
    return self.elapsed
    
end

function Sprite:get_layer()
    --|     Returns sprite's layer.
    --|     (used for collision, not visuals)
    --|
    
    return self.layer
    
end

function Sprite:get_population()
    --|     Returns group of sprites self is aware of
    --|     
    
    return self.group
    
end


-- -\
-- --> --- SET methods ---------------------------------------<
-- -/


--###
--###>  visual:


function Sprite:set_pic( img )
    --|     Initializes sprite graphics. "img" is
    --|     the image file link.

    self.pic_lord = img
    self.pic = love.graphics.newImage( img )
   
end

function Sprite:scale( n )
    --|     Scale sprite by n in all directions.
    --|
    
    self.scale_x = n
    self.scale_y = n
    
end

function Sprite:scale_width( n )
    --|     Scale sprite by n in the x axis.
    --|
    
    self.scale_x = n
    
end

function Sprite:scale_height( n )
    --|     Scale sprite by n in the y axis.
    --|
    
    self.scale_y = n
    
end


--###
--###>  positional:


function Sprite:set_x( x )
    --|     Sets x position. (left)
    --|
    
    self.x = x
    
end

function Sprite:set_y( y )
    --|     Sets y position. (top)
    --|
    
    self.y = y
    
end

function Sprite:set_pos( x,y )
    --|     Sets position. (top left)
    --|
    
    self.x = x
    self.y = y
    
end

function Sprite:set_cx( cx )
    --|     Sets center x position.
    --|
    
    self.x = cx - ( self:get_w()/2 )
    
end

function Sprite:set_cy( cy )
    --|     Sets center y position.
    --|
    
    self.y = cy - ( self:get_h()/2 )
    
end

function Sprite:set_center( cx,cy )
    --|     Sets center position.
    --|
    
    self:set_cx( cx )
    self:set_cy( cy )
    
end

function Sprite:set_right( a )
    --|     Sets right x position.
    --|
    
    self.x = a + ( self:get_w()/2 )
    
end

function Sprite:set_top( a )
    --|     Sets top y position.
    --|
    
    self.y = a
    
end

function Sprite:set_left( a )
    --|     Sets left x position.
    --|
    
    self.x = a
    
end

function Sprite:set_bottom( a )
    --|     Sets bottom y position.
    --|
    
    self.y = a + ( self:get_h()/2 )
    
end


--###
--###>  speed-related:


function Sprite:set_speed( spd )
    --|     Sets the accurate speed.
    --|
    
    self.speed = spd
    
end


--###
--###>  acceleration-related:


function Sprite:set_accel( acl )
    --|     Sets the accurate acceleration.
    --|
    
    self.accel = acl
    
end


--###
--###>  angular:


function Sprite:set_dir( ang )
    --|     Sets the accurate direction
    --|
    
    self.dir = ang
    
end

function Sprite:set_turn( ang )
    --|     Sets the accurate direction and
    --|     rotation
    --|
    
    self.dir = ang
    self.rot = ang
    
end

function Sprite:set_ang_accel( angaccel )
    --|     Sets the accurate angular acceleration
    --|
    
    self.dr = -angaccel
    
end


--###
--###>  other:


function Sprite:set_layer( level )
    --|     Sets sprite's layer.
    --|     (used for collision, not visuals)
    --|
    
    self.layer = level
    
end

function Sprite:set_population( pop )
    --|     Sets group of sprites self is aware of
    --|     
    
    self.group = pop
    
end


-- -\
-- --> --- OTHER methods -------------------------------------<
-- -/


function Sprite:colliding( spr )
    --|     if input sprite is colliding and is in
    --|     the same layer as self, return true
    --|
    
    -- you
    local urr = spr:get_right()
    local urt = spr:get_top()
    local url = spr:get_left()
    local urb = spr:get_bottom()
    -- me
    local myr = self:get_right()
    local myt = self:get_top()
    local myl = self:get_left()
    local myb = self:get_bottom()
    
    -- check layer
    if spr.layer == self.layer then
        -- check collision
        if myr > url and
           myt < urb and
           myl < urr and
           myb > urt then
           
            return true
        end
    end
    
    return false

end

function Sprite:reset_time()
    --|     Resets elapsed time to 0
    --|     
    
    self.elapsed = 0
    
end

function Sprite:__debug( delay )
    --|     Print all of self's info every 'delay' frames.
    --|     (stops printing if delay is < 1)
    --|
    
    -- ...
    return
    
end

function Sprite:__trace()
    --|     Print all of self's info if debug
    --|     interval reached.
    --|
    
    -- ...
    return
    
end




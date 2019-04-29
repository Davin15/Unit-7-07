---------------------------------------------------------------------------------------
--
-- main.lua
--ByDavin Rousseau
-- created on apr.27th/2019
-- program allows character to shoot bullets both ways
-----------------------------------------------------------------------------------------
display.setDefault("background", 0, 1, 2)
-- Character move

local dPad = display.newImageRect( "assets/d-pad.png", 100, 80 )
dPad.x = 120
dPad.y = 280
dPad.id = "d-pad"

local upArrow = display.newImageRect( "assets/upArrow.png", 30, 20 )
upArrow.x = 120
upArrow.y = 250
upArrow.id = "up arrow"

local downArrow = display.newImageRect( "assets/downArrow.png", 30, 20 )
downArrow.x = 120
downArrow.y = 310
downArrow.id = "down arrow"

local leftArrow = display.newImageRect( "assets/leftArrow.png", 30, 20 )
leftArrow.x = 92
leftArrow.y = 280
leftArrow.id = "left arrow"

local rightArrow = display.newImageRect( "assets/rightArrow.png", 30, 20 )
rightArrow.x = 152
rightArrow.y = 280

rightArrow.id = "right arrow"

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 25 ) -- ( x, y )

local playerBullets = {} 

local leftWall = display.newRect( 0, display.contentHeight, 50, 1000, 1, display.contentHeight )
-- myRectangle.strokeWidth = 10
-- myRectangle:setFillColor( 0.5 )
-- myRectangle:setStrokeColor( 1, 0, 0 )
leftWall.alpha = 1
physics.addBody( leftWall, "static", { 
    friction = 1.5, 
    bounce = 0.
    } )


local theCharacter = display.newImageRect( "assets/character.png", 80, 100 )
theCharacter.x = 150
theCharacter.y = 180
theCharacter.id = "the character"
physics.addBody( theCharacter, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.3 
    } )
theCharacter.isFixedRotation = true

local theGround = display.newImageRect( "assets/land.png", 300, 125 )
theGround.x = display.contentCenterX 
theGround.y = display.contentHeight
theGround.id = "the ground"
physics.addBody( theGround, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local landSquare = display.newImage( "assets/landSquare.png", 100, 125 )
landSquare.x = 80
landSquare.y = display.contentHeight - 230
landSquare.id = "land Square"
physics.addBody( landSquare, "dynamic", { 
    friction = 0.5, 
    bounce = 0.3 
    } )
 
 local jumpButton = display.newImageRect( "assets/jumpButton.png", 100, 80 )
jumpButton.x = display.contentWidth - 80
jumpButton.y = display.contentHeight - 250
jumpButton.id = "jump button"
jumpButton.alpha = 1

local shootButton = display.newImageRect( "assets/shootButton.png",100,100 )
shootButton.x = display.contentWidth - 250
shootButton.y = display.contentHeight - 80
shootButton.id = "shootButton"
shootButton.alpha = 0.5

local shootButton2 = display.newImageRect( "assets/shootButton2.png",100,100 )
shootButton2.x = display.contentWidth - 300
shootButton2.y = display.contentHeight - 100
shootButton2.id = "shootButton2"
shootButton2.alpha = 0.5

function upArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( theCharacter, { 
        	x = 0, -- move 0 in the x direction 
        	y = -50, -- move up 50 pixels
        	time = 100 -- move in a 1/10 of a second
        	} )
    end

    return true
end



function downArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( theCharacter, { 
        	x = 0, -- move 0 in the x direction 
        	y = 50, -- move down 50 pixels
        	time = 100 -- move in a 1/10 of a second
        	} )
    end

    return true
end



function leftArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( theCharacter, { 
        	x = -50, -- move 50 pixels in the x direction "left" 
        	y = 0, -- move 0 pixels in y direction
        	time = 100 -- move in a 1/10 of a second
        	} )
    end

    return true
end



function rightArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( theCharacter, { 
        	x = 50, -- move 50 pixels in the x direction "right" 
        	y = 0, -- move 0 pixels in y direction
        	time = 100 -- move in a 1/10 of a second
        	} )
    end
    

    return true
end

 

function jumpButton:touch( event )
    if ( event.phase == "ended" ) then
        -- make the character jump
        theCharacter:setLinearVelocity( 0, -450 )
    end

    return true
end

local function characterCollision( self, event )
 
    if ( event.phase == "began" ) then
        print( self.id .. ": collision began with " .. event.other.id )
 
    elseif ( event.phase == "ended" ) then
        print( self.id .. ": collision ended with " .. event.other.id )
    end
end

function Bulletoutofbounds()
    -- check if any bullets have gone off the screen
    local bulletCounter

    if #playerBullets > 0 then
        for bulletCounter = #playerBullets, 1 ,-1 do
            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then
                playerBullets[bulletCounter]:removeSelf()
                playerBullets[bulletCounter] = nil
                table.remove(playerBullets, bulletCounter)
                print("remove bullet")
            end
        end
    end
end

function shootButton:touch( event )
    if ( event.phase == "began" ) then
        -- make a bullet appear
        local aSingleBullet = display.newImageRect( "assets/bullet.png", 75, 25 )
        aSingleBullet.x = theCharacter.x
        aSingleBullet.y = theCharacter.y
        physics.addBody( aSingleBullet, 'dynamic' )
        -- Make the object a "bullet" type object
        aSingleBullet.isBullet = true
        aSingleBullet.gravityScale = 2
        aSingleBullet.id = "bullet"
        aSingleBullet:setLinearVelocity( 700, 0 )

        table.insert(playerBullets,aSingleBullet)
        print("# of bullet: " .. tostring(#playerBullets))
    end

    return true
end

function shootButtonb:touch( event )
    if ( event.phase == "began" ) then
        -- make a bullet appear
        local aSingleBullet = display.newImageRect( "assets/bullet.png", 75, 25 )
        aSingleBullet.x = theCharacter.x
        aSingleBullet.y = theCharacter.y
        physics.addBody( aSingleBullet, 'dynamic' )
        -- Make the object a "bullet" type object
        aSingleBullet.isBullet = true
        aSingleBullet.gravityScale = 2
        aSingleBullet.id = "bullet"
        aSingleBullet:setLinearVelocity( -700, 0 )

        table.insert(playerBullets,aSingleBullet)
        print("# of bullet: " .. tostring(#playerBullets))
    end

    return true
end

upArrow:addEventListener( "touch", upArrow )
downArrow:addEventListener( "touch", downArrow )
leftArrow:addEventListener( "touch", leftArrow )
jumpButton:addEventListener( "touch", jumpButton )
rightArrow:addEventListener( "touch", rightArrow )

shootButton:addEventListener( "touch", shootButton )
shootButtonb:addEventListener( "touch", shootButtonb )
Runtime:addEventListener( "enterFrame", Bulletoutofbounds )

--theCharacter.collision = characterCollision
--theCharacter:addEventListener( "collision" )
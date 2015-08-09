-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- RG Collision Calculator Example (RGCC)
-- =============================================================
-- 								License
-- =============================================================
--[[
	> RGCC is free to use.
	> RGCC is free to edit.
	> RGCC is free to use in a free or commercial game.
	> RGCC is free to use in a free or commercial non-game app.
	> RGCC is free to use without crediting the author (credits are still appreciated).
	> RGCC is free to use without crediting the project (credits are still appreciated).
	> RGCC is NOT free to sell for anything.
	> RGCC is NOT free to credit yourself with.
]]
-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages
-- =============================================================

-- =============================================================
-- Step 1. - Load RGCC 
-- =============================================================
local ccmgr = require "RGCC"


local group = display.newGroup() 

local physics = require("physics")
physics.start()
physics.setGravity(0,9.8)
--physics.setDrawMode( "hybrid" )

local createBlock
local createBall

-- Easily set up collision filters with an RGCC Collision Calculator
local myCC = ccmgr:newCalculator()

myCC:addNames( "block", "redBall", "greenBall" )
myCC:collidesWith( "redBall", "block", "greenBall"  )

createBall = function( x, y, r, color, type)
	local tmp = display.newCircle( group, x, y, r )
	tmp:setFillColor( unpack( color ) )
	physics.addBody( tmp, "dynamic", { radius = r, friction = 0.2, bounce = 0.85, filter = myCC:getCollisionFilter( type ) } )
	timer.performWithDelay( 1000, function() createBall(x, y, r, color, type) end )
end

createBlock = function( x, y, size, angle)
	local tmp = display.newRect( group, 0, 0, size, size)
	tmp.x = x
	tmp.y = y
	tmp:setFillColor( 0.5, 0.5, 0.5 )
	tmp:setStrokeColor( 1, 1, 0 )
	tmp.strokeWidth = 2
	tmp.rotation = angle
	physics.addBody( tmp, "static", { radius = r, friction = 0.2, bounce = 0.5, filter = myCC:getCollisionFilter( block ) } )
end

createBlock( display.contentCenterX - 100, display.actualContentHeight - 20, 40, 10)
createBlock( display.contentCenterX + 100, display.actualContentHeight - 20, 40, 0)

createBall( display.contentCenterX - 100, 30, 10, {1,0,0}, "redBall" )
createBall( display.contentCenterX + 100, 30, 10, {0,1,0}, "greenBall" )


myCC:dump()





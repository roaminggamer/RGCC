RGCC
============

RGCC makes it easy calculate and configure single-body collisions in Corona SDK.

Basic Usage
-------------------------

##### Require the code
```lua
local ccmgr = require "RGCC"
```

##### Create your calculator
```lua
local myCC = ccmgr:newCalculator()
```

##### Add collider name
```lua
myCC:addName( "block" )
myCC:addName( "redBall" )
myCC:addName( "greenBall" )
```


##### Add collider names (alternative)
```lua
myCC:addNames( "block", "redBall", "greenBall" )
```

##### Set collision rules
```lua
myCC:collidesWith( "redBall", "block", "greenBall"  )
```

##### Get Filter
```lua
	local tmp = display.newCircle( 100, 100, 10  )
	tmp:setFillColor( 1, 0, 0 )
	physics.addBody( tmp, "dynamic", { radius = 10, 
	   filter = myCC:getCollisionFilter( "redBall" ) } )
```

##### Get Category Bits
```lua
	local categoryBits =  myCC:getCategoryBits( "redBall" ) 
```

##### Get Mask Bits
```lua
	local maskBits =  myCC:getMaskBits( "redBall" ) 
```

##### Dump Calculator Settings (Debug)
```lua
	myCC:dump()

	-- Prints something like this:
	*********************************************

	Dumping collision settings...
	name           | num | cat bits | col mask
	-------------- | --- | -------- | --------
	redBall        | 2   | 2        | 5
	block          | 1   | 1        | 2
	greenBall      | 3   | 4        | 2

	*********************************************
```


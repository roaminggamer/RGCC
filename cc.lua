-- Create library
local lib = {}

-------------------------------------------------------------------------------
-- BEGIN (Insert your implementation starting here)
-------------------------------------------------------------------------------

local function rpad(str, len, char)
    if char == nil then char = ' ' end
    return str .. string.rep(char, len - #str)
end

local lib = {}
	
function lib.newCalculator()

	local collisionsCalculator = {}

	collisionsCalculator._colliderNum = {}
	collisionsCalculator._colliderCategoryBits = {}
	collisionsCalculator._colliderMaskBits = {}
	collisionsCalculator._knownCollidersCount = 0

	function collisionsCalculator:addName( colliderName )

		colliderName = string.lower(colliderName)

		for k,v in pairs(self._colliderNum)	do
			assert( k ~= colliderName, "\nplugin.cc - Attempting to add duplicate collider name: " .. tostring(colliderName) )
		end

		assert( self._knownCollidersCount < 16, "\nplugin.cc - Attempting to add more than 16 unique collider names.  \nUnable to add collider name: " .. tostring(colliderName) )

		if(not self._colliderNum[colliderName]) then
			-- Be sure we don't create more than 16 named collider types
			local newColliderNum = self._knownCollidersCount + 1
			self._knownCollidersCount = newColliderNum
			self._colliderNum[colliderName] = newColliderNum
			self._colliderCategoryBits[colliderName] = 2 ^ (newColliderNum - 1)
			self._colliderMaskBits[colliderName] = 0
		end

		return true
	end

	function collisionsCalculator:addNames( ... )
		for key, value in ipairs(arg) do
        	self:addName( value )
			--print("Added name:", value)
		end
	end

	function collisionsCalculator:configureCollision( colliderNameA, colliderNameB )

		colliderNameA = string.lower(colliderNameA)
		colliderNameB = string.lower(colliderNameB)
		--
		-- Verify both colliders exist before attempting to configure them:
		--
		if( not self._colliderNum[colliderNameA] ) then
			print("Error: collidesWith() - Unknown collider: " .. colliderNameA)
			return false
		end
		if( not self._colliderNum[colliderNameB] ) then
			print("Error: collidesWith() - Unknown collider: " .. colliderNameB)
			return false
		end
		
		-- Add the CategoryBit for A to B's collider mask and vice versa
		-- Note: The if() statements encapsulating this setup work ensure
		--       that the faked bitwise operation is only done once 
		local colliderCategoryBitA = self._colliderCategoryBits[colliderNameA]
		local colliderCategoryBitB = self._colliderCategoryBits[colliderNameB]
		if( (self._colliderMaskBits[colliderNameA] % (2 * colliderCategoryBitB) ) < colliderCategoryBitB ) then
			self._colliderMaskBits[colliderNameA] = self._colliderMaskBits[colliderNameA] + colliderCategoryBitB
		end
		if( (self._colliderMaskBits[colliderNameB] % (2 * colliderCategoryBitA) ) < colliderCategoryBitA ) then
			self._colliderMaskBits[colliderNameB] = self._colliderMaskBits[colliderNameB] + colliderCategoryBitA
		end

		return true
	end


	function collisionsCalculator:collidesWith( colliderName, otherColliders )
		colliderName = string.lower(colliderName)
		for key, value in ipairs(otherColliders) do

			value = string.lower(value)
        	self:configureCollision( colliderName, value )
		end
	end

	function collisionsCalculator:getCategoryBits( colliderName )
		colliderName = string.lower(colliderName)
		return self._colliderMaskBits[colliderName] 
	end

	function collisionsCalculator:getMaskBits( colliderName )
		colliderName = string.lower(colliderName)
		return self._colliderCategoryBits[colliderName] 
	end

	function collisionsCalculator:getCollisionFilter( colliderName )
		colliderName = string.lower( colliderName )
		local collisionFilter =  
		{ 
	   	categoryBits = self._colliderCategoryBits[colliderName],
	   	maskBits     = self._colliderMaskBits[colliderName], 
		}  

		return collisionFilter
	end

	function collisionsCalculator:dump()
		print("*********************************************\n")
		print("Dumping collision settings...")
		print("name           | num | cat bits | col mask")
		print("-------------- | --- | -------- | --------")
		for colliderName, colliderNum in pairs(self._colliderNum) do
			print(rpad(colliderName,15,' ') .. "| ".. 
		      	rpad(tostring(colliderNum),4,' ') .. "| ".. 
			  	rpad(tostring(self._colliderCategoryBits[colliderName]),9,' ') .. "| ".. 
			  	rpad(tostring(self._colliderMaskBits[colliderName]),8,' '))
		end
		print("\n*********************************************\n")
	end

	return collisionsCalculator
end

return lib

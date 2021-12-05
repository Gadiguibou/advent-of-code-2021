local lib = {}

local function testCallee()
    print("testCallee")
end

function lib.test1()
    testCallee()
    print("test1")
end

return lib

MegamanTester = {}

local function read_u8(address)
    return memory.readbyte(0x7e0000 + address)
end

local function read_s8(address)
    return memory.readbytesigned(0x7e0000 + address)
end

local function read_u16(address)
    return memory.readword(0x7e0000 + address)
end

local function read_s16(address)
    return memory.readwordsigned(0x7e0000 + address)
end

local function read_u24(address)
    return 256 * read_u16(address + 2) + read_u8(address)
end





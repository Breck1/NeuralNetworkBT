Megaman_io = {}

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

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local ADDR = 
{
--Fyll med sprite data
--[[
    CAMERAX                     = 0x001a,
    CAMERAY                     = 0x001c,

    MEGAMANX                    = 0x0094,
    MEGAMANY                    = 0x0096,

    TIMER_HUNDREDS              = 0x0f31,
    TIMER_TENS                  = 0x0f32,
    TIMER_ONES                  = 0x0f33,
    MARIO_SCORE                 = 0x0f34,

    SPRITEX_LOWER               = 0x00e4,
    SPRITEX_HIGHER              = 0x14e0,
    SPRITEY_LOWER               = 0x00d8,
    SPRITEY_HIGHER              = 0x14d4,
    SPRITE_STATUS               = 0x14c8,
    SPRITE_NUMBER               = 0x009e,
    SPRITE_INTERACT             = 0x15dc,
    SPRITE_MWR1                 = 0x1656,
    SPRITE_MWR2                 = 0x1662,
    SPRITE_MWR3                 = 0x166e,
    SPRITE_MWR4                 = 0x167a,
    SPRITE_MWR5                 = 0x1686,

    EXTENDED_SPRITEX_LOWER      = 0x171f,
    EXTENDED_SPRITEX_HIGHER     = 0x1733,
    EXTENDED_SPRITEY_LOWER      = 0x1715,
    EXTENDED_SPRITEY_HIGHER     = 0x1729,
    EXTENDED_SPRITE_NUMBER      = 0x170b,

    MINOR_SPRITEX_LOWER         = 0x1808,
    MINOR_SPRITEX_HIGHER        = 0x18ea,
    MINOR_SPRITEY_LOWER         = 0x17fc,
    MINOR_SPRITEY_HIGHER        = 0x1814,
    MINOR_SPRITE_NUMBER         = 0x17f0
    ]]
}

local SPRITE_COUNT              = 0
local EXTENDED_SPRITE_COUNT     = 0
local MINOR_SPRITE_COUNT        = 0

local ENEMY_SPRITES =
{
    --[[
        
    GREEN_KOOPA_NOSHELL         = 0x00,
    RED_KOOPA_NOSHELL           = 0x01,
    BLUE_KOOPA_NOSHELL          = 0x02,
    YELLOW_KOOPA_NOSHELL        = 0x03,
    GREEN_KOOPA                 = 0x04,
    RED_KOOPA                   = 0x05,
    BLUE_KOOPA                  = 0x06,
    YELLOW_KOOPA                = 0x07,
    GREEN_KOOPA_FLYING_LEFT     = 0x08,
    GREEN_KOOPA_BOUNCING        = 0x09,
    RED_KOOPA_FLYING_VERTICAL   = 0x0a,
    RED_KOOPA_FLYING_HORIZONTAL = 0x0b,
    YELLOW_KOOPA_WITH_WINGS     = 0x0c,
    BOB_OMB                     = 0x0d,
    GOOMBA                      = 0x0f,
    BOUNCING_GOOMBA             = 0x10,
    BUZZY_BEETLE                = 0x11,
    SPINY                       = 0x13,
    SPINY_FALLING               = 0x14,
    CHEEP_SHEEP_HORIZONTAL      = 0x15,
    CHEEP_SHEEP_VERTICAL        = 0x16,
    CHEEP_SHEEP_FLYING          = 0x17,
    CHEEP_SHEEP_JUMPING         = 0x18,
    PIRANHA_PLANT               = 0x1a,
    BOUNCING_FOOTBALL           = 0x1b,
    BULLET_BILL                 = 0x1c,
    HOPPING_FLAME               = 0x1d,
    LAKITU                      = 0x1e,
    MAGIKOOPA                   = 0x1f,
    MAGIKOOPA_MAGIC             = 0x20,
    GREEN_NET_KOOPA_VERTICAL    = 0x22,
    RED_NET_KOOPA_VERTICAL      = 0x23,
    GREEN_NET_KOOPA_HORIZONTAL  = 0x24,
    RED_NET_KOOPA_HORIZONTAL    = 0x25,
    THWOMP                      = 0x26,
    THWIMP                      = 0x27,
    BIG_BOO                     = 0x28,
    KOOPA_KID                   = 0x29,
    UPSIDE_DOWN_PIRANHA_PLANT   = 0x2a,
    SOMO_BROTHERS_LIGHTNING     = 0x2b,
    SPIKE_TOP                   = 0x2e,
    DRY_BONES_THROWS_BONES      = 0x30,
    BONY_BEETLE                 = 0x31,
    DRY_BONES_STAYS_ON_LEDGES   = 0x32,
    PODOBOO_VERTICAL_FIREBALL   = 0x33,
    BOSS_FIREBALL               = 0x34,
    BOO                         = 0x37,
    EERIE_MOVES_STRAIGHT        = 0x38,
    EERIE_MOVES_IN_A_WAVE       = 0x39,
    URCHIN_MOVES_FIXED          = 0x3a,
    URCHIN_MOVES_BETWEEN_WALLS  = 0x3b,
    URCHIN_FOLLOWS_WALLS        = 0x3c,
    RIP_VAN_FISH                = 0x3d,
    PARA_GOOMBA                 = 0x3f,
    PARA_BOMB                   = 0x40,
    DOLPHIN_ONE_DIRECTION       = 0x41,
    DOLPHIN_BACK_AND_FOURTH     = 0x42,
    DOLPHIN_UP_AND_DOWN         = 0x43,
    TORPEDO_TED                 = 0x44,
    DIGGIN_CHUCK                = 0x46,
    SWIMMING_JUMPING_FISH       = 0x47,
    DIGGIN_CHUCKS_ROCK          = 0x48,
    PIPE_DWELLING_LAKITU        = 0x4b,
    EXPLODING_BLOCK             = 0x4c,
    MONTY_MOLE_GROUND_DWELLING  = 0x4d,
    MONTY_MOLE_LEDGE_DWELLING   = 0x4e,
    JUMPING_PIRANHA_PLANT       = 0x4f,
    JUMPING_PIRANHA_PLANT_FIRE  = 0x50,
    NINJI                       = 0x51,
    FLOATING_SKULL              = 0x61,
    CHAINSAW                    = 0x65,
    UPSIDE_DOWN_CHAINSAW        = 0x66,
    GRINDER                     = 0x67,
    FUZZY                       = 0x68,
    DINO_RHINO                  = 0x6e,
    DINO_TORCH                  = 0x6f,
    POKEY                       = 0x70,
    SUPER_KOOPA_RED_CAPE        = 0x71,
    SUPER_KOOPA_YELLOW_CAPE     = 0x72,
    SUPER_KOOPA_ON_THE_GROUND   = 0x73,
    WIGGLER                     = 0x86,
    CHARGIN_CHUCK               = 0x91,
    SPLITTIN_CHUCK              = 0x92,
    BOUNCIN_CHUCK               = 0x93,
    WHISTLIN_CHUCK              = 0x94,
    CHARGIN_CHUCK_TWO           = 0x95,
    PUNTIN_CHUCK                = 0x97,
    PITCHIN_CHUCK               = 0x98,
    VOLCANO_LOTUS               = 0x99,
    SUMP_BROTHER                = 0x9a,
    AMAZING_FLYING_HAMMER_BRO   = 0x9c,
    BALL_N_CHAIN                = 0x9e,
    BANZAI_BILL                 = 0x9f,
    BOWSERS_BOWLING_BALL        = 0xa1,
    MECHA_KOOPA                 = 0xa2,
    FLOATING_SPYKE_BALL         = 0xa4,
    WALL_FOLLOWING_SPARKY       = 0xa5,
    HOTHEAD                     = 0xa6,
    IGGYS_BALL_PROJECTILE       = 0xa7,
    BLARGG                      = 0xa8,
    REZNOR                      = 0xa9,
    FISHBONE                    = 0xaa,
    REX                         = 0xab,
    WOODEN_SPIKE_POINTING_DOWN  = 0xac,
    WOODEN_SPIKE_POINTING_UP    = 0xad,
    FISHIN_BOO                  = 0xae,
    FALLING_SPIKE               = 0xb2,
    BOWSER_STATUE_FIREBALL      = 0xb3,
    GRINDER_UNDERGROUND         = 0xb4,
    REFLECTING_FIREBALL         = 0xb6,
    SLIDING_KOOPA               = 0xbd,
    SWOOPER                     = 0xbe,
    MEGA_MOLE                   = 0xbf,
    BLURP                       = 0xc2,
    PROCU_PUFFER                = 0xc3,
    BIG_BOO_BOSS                = 0xc5
    ]]
}

local POWERUP_SPRITES =
{
    --[[
    MUSHROOM                    = 0x74,
    FLOWER                      = 0x75,
    STAR                        = 0x76,
    FEATHER                     = 0x77,
    ONE_UP_MUSHROOM             = 0x78
    ]]

}

local ENEMY_EXTENDED_SPRITES =
{
    --[[

    REZNOR_FIREBALL             = 0x02,
    HAMMER                      = 0x04,
    BONE                        = 0x06,
    TORPEDO_RED_SHOOTER_ARM     = 0x08,
    PIRANHA_FIREBALL            = 0x0b,
    LAVA_LOTUS_FIRE             = 0x0c,
    BASEBALL                    = 0x0d,
    FLOWER_OF_WIGGLER           = 0x0e
    ]]
}

local ENEMY_MINOR_SPRITES =
{
 --   PODOBOO_FLAME               = 0x04
}

local SPRITE_CLIPPINGS  =
{
    --[[
    [0x00] = { x = 2,   y = 3,   w = 12, h = 10 },
    [0x01] = { x = 2,   y = 3,   w = 12, h = 21 },
    [0x02] = { x = 16,  y = -2,  w = 16, h = 18 },
    [0x03] = { x = 20,  y = 8,   w = 8,  h = 8  },
    [0x04] = { x = 0,   y = -2,  w = 48, h = 14 },
    [0x05] = { x = 0,   y = -2,  w = 80, h = 14 },
    [0x06] = { x = 1,   y = 2,   w = 14, h = 24 },
    [0x07] = { x = 8,   y = 8,   w = 40, h = 48 },
    [0x08] = { x = -8,  y = -2,  w = 32, h = 16 },
    [0x09] = { x = -2,  y = 8,   w = 20, h = 30 },
    [0x0a] = { x = 3,   y = 7,   w = 1,  h = 2  },
    [0x0b] = { x = 6,   y = 6,   w = 3,  h = 3  },
    [0x0c] = { x = 1,   y = -2,  w = 13, h = 22 },
    [0x0d] = { x = 0,   y = -4,  w = 15, h = 16 },
    [0x0e] = { x = 6,   y = 6,   w = 20, h = 20 },
    [0x0f] = { x = 2,   y = -2,  w = 36, h = 18 },
    [0x10] = { x = 0,   y = -2,  w = 15, h = 32 },
    [0x11] = { x = -24, y = -24, w = 64, h = 64 },
    [0x12] = { x = -4,  y = 16,  w = 8,  h = 52 },
    [0x13] = { x = -4,  y = 16,  w = 8,  h = 1  },
    [0x14] = { x = 4,   y = 2,   w = 24, h = 12 },
    [0x15] = { x = 0,   y = -2,  w = 15, h = 14 },
    [0x16] = { x = -4,  y = -12, w = 24, h = 24 },
    [0x17] = { x = 2,   y = 8,   w = 12, h = 69 },
    [0x18] = { x = 2,   y = 19,  w = 12, h = 58 },
    [0x19] = { x = 2,   y = 34,  w = 12, h = 42 },
    [0x1a] = { x = 2,   y = 50,  w = 12, h = 26 },
    [0x1b] = { x = 2,   y = 66,  w = 12, h = 10 },
    [0x1c] = { x = 0,   y = 10,  w = 10, h = 48 },
    [0x1d] = { x = 2,   y = -3,  w = 28, h = 27 },
    [0x1e] = { x = -32, y = -8,  w = 48, h = 32 },
    [0x1f] = { x = -16, y = -4,  w = 48, h = 18 },
    [0x20] = { x = -4,  y = -24, w = 8,  h = 24 },
    [0x21] = { x = -4,  y = -16, w = 8,  h = 24 },
    [0x22] = { x = 0,   y = 0,   w = 16, h = 16 },
    [0x23] = { x = -8,  y = -25, w = 32, h = 32 },
    [0x24] = { x = -12, y = -32, w = 56, h = 56 },
    [0x25] = { x = -14, y = -4,  w = 60, h = 20 },
    [0x26] = { x = 0,   y = 88,  w = 32, h = 8  },
    [0x27] = { x = -4,  y = -4,  w = 24, h = 24 },
    [0x28] = { x = -14, y = -24, w = 28, h = 40 },
    [0x29] = { x = -16, y = -4,  w = 32, h = 27 },
    [0x2a] = { x = 3,   y = -8,  w = 12, h = 19 },
    [0x2b] = { x = 0,   y = 2,   w = 16, h = 76 },
    [0x2c] = { x = -8,  y = -8,  w = 16, h = 16 },
    [0x2d] = { x = 4,   y = 4,   w = 8,  h = 4  },
    [0x2e] = { x = 2,   y = -2,  w = 28, h = 34 },
    [0x2f] = { x = 2,   y = -2,  w = 28, h = 32 },
    [0x30] = { x = 8,   y = -14, w = 16, h = 28 },
    [0x31] = { x = 0,   y = -2,  w = 48, h = 18 },
    [0x32] = { x = 0,   y = -2,  w = 48, h = 18 },
    [0x33] = { x = 0,   y = -2,  w = 64, h = 18 },
    [0x34] = { x = -4,  y = -4,  w = 8,  h = 8  },
    [0x35] = { x = 3,   y = 0,   w = 18, h = 32 },
    [0x36] = { x = 8,   y = 8,   w = 52, h = 46 },
    [0x37] = { x = 0,   y = -8,  w = 15, h = 20 },
    [0x38] = { x = 8,   y = 16,  w = 32, h = 40 },
    [0x39] = { x = 4,   y = 3,   w = 8,  h = 10 },
    [0x3a] = { x = -8,  y = 16,  w = 32, h = 16 },
    [0x3b] = { x = 0,   y = 0,   w = 16, h = 13 },
    [0x3c] = { x = 12,  y = 10,  w = 3,  h = 6  },
    [0x3d] = { x = 12,  y = 21,  w = 3,  h = 20 },
    [0x3e] = { x = 13,  y = 18,  w = 4,  h = 16 },
    [0x3f] = { x = 8,   y = 8,   w = 8,  h = 24 },
    ]]
}

local EXTENDED_SPRITE_CLIPPINGS =
{
    --[[
    [0x01] = { x = 3,   y = 3,   w = 0,  h = 0  },
    [0x02] = { x = 3,   y = 3,   w = 1,  h = 1  },
    [0x03] = { x = 3,   y = 3,   w = 1,  h = 1  },
    [0x04] = { x = 4,   y = 4,   w = 8,  h = 8  },
    [0x05] = { x = 3,   y = 3,   w = 1,  h = 1  },
    [0x06] = { x = 4,   y = 4,   w = 8,  h = 8  },
    [0x07] = { x = 0,   y = 0,   w = 0,  h = 0  },
    [0x08] = { x = 0,   y = 0,   w = 0,  h = 0  },
    [0x09] = { x = 0,   y = 0,   w = 15, h = 15 },
    [0x0a] = { x = 4,   y = 2,   w = 8,  h = 12 },
    [0x0b] = { x = 3,   y = 3,   w = 1,  h = 1  },
    [0x0c] = { x = 3,   y = 3,   w = 1,  h = 1  },
    [0x0d] = { x = 3,   y = 3,   w = 1,  h = 1  },
    [0x0e] = { x = 3,   y = 3,   w = 0,  h = 0  },
    [0x0f] = { x = 3,   y = 3,   w = 0,  h = 0  },
    [0x10] = { x = 3,   y = 3,   w = 0,  h = 0  },
    [0x11] = { x = -1,  y = -4,  w = 11, h = 19 },
    [0x12] = { x = 3,   y = 3,   w = 0,  h = 0  },
    ]]
}

function Megaman_io.getCameraPos()
    return read_s16(ADDR.CAMERAX), read_s16(ADDR.CAMERAY)
end

function Megaman_io.getMegamanPos()
    return read_u16(ADDR.megamanPosX),  read_u16(ADDR.megamanPosY) 
end

function Megaman_io.getMegamanScreenPos()
    local mx, my = Megaman_io.getMegamanPos()
    local cx, cy = Megaman_io.getCameraPos()

    return mx - cx, my - cy
end

function Megaman_io.getTile(x, y)
    local numX = math.floor(x/16)
    local numY = math.floor(y/16)

    if numX < 0 or numY < 0 then
        return nil
    end

    if numX >= 0 or numY >= 0 then
        if numX <= 16 * memory.readword(0x5e) and numY <= 27 then
            local id = 16 * 27 * math.floor(num_x / 16) + numY * 16 + numX % 16
            if id >= 0 and id <= 0x35ff then
                kind = 256 * memory.readbyte(0x7fc800 + id) + numY.readbyte(0x7ec800 + id)
            end
        end
    end

    return {
        x = numX,
        y = numY,
        kind = kind
    }
end

function Megaman_io.get_inputs(radius)
    inputs = {}
    sprites = Megaman_io.get_sprites()

    local mx, my = Megaman_io.get_mario_pos()
    local cx, cy = Megaman_io.get_camera_pos()

    for dy = -radius * 16, radius * 16, 16 do
        for dx = -radius * 16, radius * 16, 16 do
            local tile = Megaman_io.get_tile(mx + dx, my + dy)
            local wall = 0
            local enemy = 0
            local powerup = 0

            if tile ~= nil and tile.kind ~= -1 then

                if tile.kind >= 0x100 then
                    wall = 1
                end

                for _, sprite in ipairs(sprites) do
                    if sprite.status ~= 0 then
                        if Megaman_io.sprite_intersects(sprite, tile.x * 16, tile.y * 16, 16, 16) then
                            if sprite.powerup then
                                powerup = 1
                            elseif sprite.enemy then
                                enemy = 1
                            end
                        end
                    end
                end
            end

            table.insert(inputs, wall)
            table.insert(inputs, powerup)
            table.insert(inputs, enemy)
        end
    end
    return inputs
end


function Megaman_io.get_sprites()
    sprites = {}
    for slot = 0, SPRITE_COUNT do
        table.insert(sprites, smw_io.get_sprite(slot))
    end
    for slot = 0, EXTENDED_SPRITE_COUNT do
        table.insert(sprites, smw_io.get_extended_sprite(slot))
    end
    for slot = 0, MINOR_SPRITE_COUNT do
        table.insert(sprites, smw_io.get_minor_sprite(slot))
    end
    return sprites
end

function Megaman_io.sprite_intersects(sprite, x, y, w, h)
    if sprite.sprite_clipping ~= nil then
        if (sprite.x + sprite.sprite_clipping.x + sprite.sprite_clipping.w) < x or
            (sprite.y + sprite.sprite_clipping.y + sprite.sprite_clipping.h) < y or
            (sprite.x + sprite.sprite_clipping.x) > (x + w) or
            (sprite.y + sprite.sprite_clipping.y) > (y + h) then
                return false
        end
        return true
    end
    return false
end
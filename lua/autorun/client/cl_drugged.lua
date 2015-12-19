local rgbMin, rgbMax = 0.2, 0.7

local red = rgbMin
local green = red + (rgbMax - rgbMin / 3)
local blue =  green + (rgbMax - rgbMin / 3)

local redOperator = "+"
local greenOperator = "-"
local blueOperator = "+"

local increment = 0.007

local function flashColors()
    -- Increase or decrease color values depending on the operator
    if (redOperator == "+") then red = red + increment else red = red - increment end
    if (greenOperator == "+") then green = green + increment else green = red - increment end
    if (blueOperator == "+") then blue = blue + increment else blue = blue - increment end

    -- Switch operator if color value beyond rgbMin or rgbMax
    if (red > rgbMax) then redOperator = "-" elseif (red < rgbMin) then redOperator = "+" end
    if (green > rgbMax) then greenOperator = "-" elseif (green < rgbMin) then greenOperator = "+" end
    if (blue > rgbMax) then blueOperator = "-" elseif (blue < rgbMin) then blueOperator = "+" end

    local tab = {
        ["$pp_colour_addr"] = red, -- The amount of reds to add
        ["$pp_colour_addg"] = green, -- The amount of greens to add
        ["$pp_colour_addb"] = blue, -- The amount of blues to add
        ["$pp_colour_contrast"] = 1, --  Overall contrast
        ["$pp_colour_colour"] = 2 -- Makes colors more vivid
    }

    DrawColorModify(tab)
end

local swingAngleRoll = 0
local swingOperator = "+"
local function swingScreen(ply, pos, angles, fov)
    if (swingOperator == "+") then
        swingAngleRoll = swingAngleRoll + 1
    else
        swingAngleRoll = swingAngleRoll - 1
    end

    if (swingAngleRoll%60 == 0 and swingAngleRoll ~= 0) then
        if (swingOperator == "+") then swingOperator = "-" else swingOperator = "+" end
    end

    angles.roll = swingAngleRoll

    local view = {
        ["origin"] = pos,
        ["angles"] = angles,
        ["fov"] = fov
    }

    return view
end

local function TRTD_DruggedEffect()
    local enable = net.ReadBool()
    if enable then
        hook.Add("RenderScreenspaceEffects", "TRTD_FlashColors", flashColors)
        hook.Add("CalcView", "TRTD_SwingScreen", swingScreen)
    else
        hook.Remove("RenderScreenspaceEffects", "TRTD_FlashColors", flashColors)
        hook.Remove("CalcView", "TRTD_SwingScreen", swingScreen)
    end
end
net.Receive("TRTD_DruggedEffect", TRTD_DruggedEffect)

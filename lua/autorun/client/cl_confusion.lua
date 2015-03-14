function invertMouse(cmd, x, y, angles)

    -- Mouse sensitivity
    local s = 0.02
    x, y = x * -s, y * s

    -- Set custom view angle
    cmd:SetViewAngles(angles + Angle(-y, -x, 0))

    -- Return true because we modified something
    return true

end

function invertMovement(cmd)
    local side = cmd:GetSideMove()
    local forward = cmd:GetForwardMove()
    cmd:SetSideMove(-side)
    cmd:SetForwardMove(-forward)
end

local active = false
local function TRTD_ConfusedEffect()
    if (not active) then
        hook.Add("InputMouseApply", "TRTD_invertMouse", invertMouse)
        hook.Add("CreateMove", "TRTD_invertMovement", invertMovement)
    else
        hook.Remove("InputMouseApply", "TRTD_invertMouse", invertMouse)
        hook.Remove("CreateMove", "TRTD_invertMovement", invertMovement)
    end

    active = not active
end
net.Receive("TRTD_ConfusedEffect", TRTD_ConfusedEffect)

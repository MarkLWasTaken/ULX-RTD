--[[
    Addon: Timmy's Roll the Dice module for ULX
    Author: Timmy
    Contact: timmy[at]timmy[dot]ws
--]]

--[[
    Namespace module under TRTD
--]]

TRTD = {} or TRTD
TRTD.Settings = {} or TRTD.Settings
TRTD.Colors = {} or TRTD.Colors
TRTD.Effects = {} or TRTD.Effects
TRTD.AddEffect = function(data)
    table.insert(TRTD.Effects, data)
end

--[[
    Module settings
--]]

TRTD.Settings.Category = "Roll the Dice"
-- Under what category will this show up in the ULX GUI
TRTD.Settings.Tag = "RTD"
-- Every chat notification from the dice will be prefixed by this value
TRTD.Settings.Cooldown = 90
-- Time (in seconds) before a player can roll the dice again
TRTD.Settings.Notifications = 1
-- Broadcast notification to all players when a player rolls the dice

--[[
    Module colors
--]]

TRTD.Colors.Tag = Color(255, 105, 180)
TRTD.Colors.Default = Color(255, 255, 255)
TRTD.Colors.Effect = Color(105, 255, 180)
TRTD.Colors.Timer = Color(255, 255, 123)

--[[
    Create console variables
--]]

TRTD.Settings.Category = CreateConVar("trtd_category", TRTD.Settings.Category, {FCVAR_DEMO, FCVAR_GAMEDLL, FCVAR_SERVER_CAN_EXECUTE}, "Under what category will this show up in the ULX GUI")
TRTD.Settings.Tag = CreateConVar("trtd_tag", TRTD.Settings.Tag, {FCVAR_DEMO, FCVAR_GAMEDLL, FCVAR_SERVER_CAN_EXECUTE}, "Every chat notification from the dice will be prefixed by this value")
TRTD.Settings.Cooldown = CreateConVar("trtd_cooldown", TRTD.Settings.Cooldown, {FCVAR_DEMO, FCVAR_GAMEDLL, FCVAR_SERVER_CAN_EXECUTE}, "Time (in seconds) before a player can roll the dice again")
TRTD.Settings.Notifications = CreateConVar("trtd_notifications", TRTD.Settings.Notifications, {FCVAR_DEMO, FCVAR_GAMEDLL, FCVAR_SERVER_CAN_EXECUTE}, "Broadcast notification to all players when a player rolls the dice")

--[[
    Add effects to the dice
    Some effects are not automatically disabled. They don't have a duration or disable function.
--]]

TRTD.AddEffect({name="double health", enable=function(ply)
    ply:SetHealth(ply:Health() * 2)
end})

TRTD.AddEffect({name="faster speed", duration=20, enable=function(ply)
    ply:SetWalkSpeed(ply:GetWalkSpeed() * 2)
    ply:SetRunSpeed(ply:GetRunSpeed() * 2)
end, disable=function(ply)
    ply:SetWalkSpeed(ply:GetWalkSpeed() / 2)
    ply:SetRunSpeed(ply:GetRunSpeed() / 2)
end})

TRTD.AddEffect({name="godmode", duration=10, enable=function(ply)
    ply:GodEnable()
end, disable=function(ply)
    ply:GodDisable()
end})

TRTD.AddEffect({name="invisibility", duration=15, enable=function(ply)
    ULib.invisible(ply, true, 255)
end, disable=function(ply)
    ULib.invisible(ply, false, 255)
end})

TRTD.AddEffect({name="low gravity", duration=15, enable=function(ply)
    ply:SetGravity(0.25)
end, disable=function(ply)
    ply:SetGravity(1)
end})

TRTD.AddEffect({name="tiny player", duration=15, enable=function(ply)
    ply:SetModelScale(ply:GetModelScale() * 0.25, 0)
    ply.viewoffset = ply:GetViewOffset()
    ply.viewoffsetducked = ply:GetViewOffsetDucked()
    ply:SetViewOffset(Vector(0, 0, 15))
    ply:SetViewOffsetDucked(Vector(0, 0, 15))
end, disable=function(ply)
    ply:SetModelScale(ply:GetModelScale() * 4, 0)
    ply:SetViewOffset(ply.viewoffset)
    ply:SetViewOffsetDucked(ply.viewoffsetducked)
end})

TRTD.AddEffect({name="blindness", duration=10, enable=function(ply)
    umsg.Start("ulx_blind", ply)
    umsg.Bool(true)
    umsg.Short(200)
    umsg.End()
end, disable=function(ply)
    umsg.Start("ulx_blind", ply)
    umsg.Bool(false)
    umsg.Short(200)
    umsg.End()
end})

TRTD.AddEffect({name="earthquake", duration=5, enable=function(ply)
    ply:Freeze(true)
    local trtdshake = ents.Create("env_shake")
    trtdshake:SetOwner(ply)
    trtdshake:SetPos(ply:GetPos())
    trtdshake:SetKeyValue("amplitude", "16") -- The amount of noise in the screen shake (range 0-16)
    trtdshake:SetKeyValue("radius", "100") -- The radius around this entity in which to affect players
    trtdshake:SetKeyValue("frequency", "255") -- The frequency used to apply the screen shake (range 0-255)
    trtdshake:SetKeyValue("duration", "10") -- Duration for the earthquake is hard coded
    trtdshake:SetKeyValue("spawnflags", "4")
    trtdshake:Spawn()
    trtdshake:Activate()
    trtdshake:Fire("StartShake")
end, disable=function(ply)
    ply:Freeze(false)
end})

TRTD.AddEffect({name="reduced speed", duration=15, enable=function(ply)
    ply:SetWalkSpeed(ply:GetWalkSpeed() * 0.25)
    ply:SetRunSpeed(ply:GetRunSpeed() * 0.25)
end, disable=function(ply)
    ply:SetWalkSpeed(ply:GetWalkSpeed() * 4)
    ply:SetRunSpeed(ply:GetRunSpeed() * 4)
end})

TRTD.AddEffect({name="rocket", enable=function(ply)
    local trail = util.SpriteTrail(ply, 0, Color(80, 80, 90), false, 60, 30, 4, 1/(60+30)*0.5, "trails/smoke.vmt")
    ply:SetVelocity(Vector(0, 0, 2048))
    timer.Simple(2.5, function()
        local position = ply:GetPos()
        local effect = EffectData()
        effect:SetOrigin(position)
        effect:SetStart(position)
        effect:SetMagnitude(512)
        effect:SetScale(128)
        util.Effect("Explosion", effect)
        timer.Simple(0.1, function()
            ply:Kill()
            trail:Remove()
        end)
    end)
end})

TRTD.AddEffect({name="reduced health", enable=function(ply)
    ply:SetHealth(1)
end})

TRTD.AddEffect({name="spontaneous combustion", duration=15, enable=function(ply)
    ply:Ignite(255)
end, disable=function(ply)
    ply:Extinguish()
end})

--[[
    Define network strings
--]]

if (SERVER) then
    util.AddNetworkString("TRTDEffectCountdown")
    util.AddNetworkString("TRTDEffectCountdownStop")
end

--[[
    Client-side effect countdown
--]]

if (CLIENT) then
    local function TRTDEffectCountdown()
        local delay = 1
        local seconds = net.ReadInt(6)
        local font = "DermaLarge"
        local color = TRTD.Colors.Timer
        local x, y = ScrW() * 0.5, ScrH() * 0.25
        local align = TEXT_ALIGN_CENTER

        timer.Create("TRTDEffectCountdown", delay, seconds, function()
            hook.Add("HUDPaint", "TRTDScreenCountdownPaint", function()
                draw.DrawText(seconds, font, x, y, color, align)
            end)

            seconds = seconds - 1

            if (seconds < 1) then
                hook.Remove("HUDPaint", "TRTDScreenCountdownPaint")
            end
        end)
    end
    net.Receive("TRTDEffectCountdown", TRTDEffectCountdown)

    local function TRTDEffectCountdownStop()
        timer.Remove("TRTDEffectCountdown")
        hook.Remove("HUDPaint", "TRTDScreenCountdownPaint")
    end
    net.Receive("TRTDEffectCountdownStop", TRTDEffectCountdownStop)
end

--[[
    Create the ULX command
--]]

function ulx.rtd(calling_ply)
    if (!IsValid(calling_ply)) then return end

    if (calling_ply.TRTDCooldown == nil) then
        calling_ply.TRTDCooldown = 0
    end

    if (calling_ply.TRTDCooldown-1 > CurTime()) then
        ULib.tsayError(calling_ply, "You have to wait " .. math.Round(calling_ply.TRTDCooldown - CurTime()) .. " more seconds before you can Roll the Dice again.")
        return
    end

    if (!calling_ply:Alive()) then
        ULib.tsayError(calling_ply, "You can't Roll the Dice when you're dead.")
        return
    end

    calling_ply.TRTDCooldown = CurTime() + TRTD.Settings.Cooldown:GetInt()

    local effect = TRTD.Effects[math.random(1, #TRTD.Effects)]

    MsgN("[".. TRTD.Settings.Tag:GetString() .."] " .. calling_ply:Nick() .. " has rolled " .. effect.name)

    effect.enable(calling_ply)

    if (effect.disable ~= nil && effect.duration ~= nil) then
        -- Trigger the client-side countdown
        net.Start("TRTDEffectCountdown")
        net.WriteInt(effect.duration, 6) -- Bit count of 6 allows any int between 0 and 63
        net.Send(calling_ply)

        -- If the player dies during an effect, we want to stop it as well as the countdown
        hook.Add("PlayerDeath", "TRTDEffectDisable", function(victim)
            if (victim == calling_ply) then
                net.Start("TRTDEffectCountdownStop")
                net.Send(calling_ply)
                effect.disable(calling_ply)
            end
        end)

        -- Disable the effect
        timer.Simple(effect.duration, function()
            if (!IsValid(calling_ply)) then return end
            effect.disable(calling_ply)
            hook.Remove("PlayerDeath", "TRTDEffectDisable")
        end)
    end

    local notification = {}
    table.insert(notification, TRTD.Colors.Tag)
    table.insert(notification, "[" .. TRTD.Settings.Tag:GetString() .. "] ")
    table.insert(notification, team.GetColor(calling_ply:Team()))
    table.insert(notification, calling_ply:Nick())
    table.insert(notification, TRTD.Colors.Default)
    table.insert(notification, " has received ")
    table.insert(notification, TRTD.Colors.Effect)
    table.insert(notification, effect.name)
    table.insert(notification, TRTD.Colors.Default)
    table.insert(notification, " from the dice.")
    ULib.tsayColor((TRTD.Settings.Notifications:GetBool() == 1 and nil or calling_ply), false, unpack(notification))
end
local rtd = ulx.command(TRTD.Settings.Category:GetString(), "ulx rtd", ulx.rtd, "rtd", true)
rtd:defaultAccess(ULib.ACCESS_ALL)
rtd:help("Roll the Dice and receive a random, temporary effect.")

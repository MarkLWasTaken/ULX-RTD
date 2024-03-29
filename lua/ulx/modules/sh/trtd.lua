--[[
    Addon: Timmy's Roll the Dice module for ULX
    Author: Timmy
    Contact: hello[at]timmy[dot]ws
--]]

--[[
    Namespace module under TRTD
--]]

local TRTD = {} or TRTD
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
    Define network strings
--]]

if (SERVER) then
    util.AddNetworkString("TRTD_EffectCountdown")
    util.AddNetworkString("TRTD_EffectCountdownStop")
    util.AddNetworkString("TRTD_ConfusedEffect")
    util.AddNetworkString("TRTD_DruggedEffect")
    util.AddNetworkString("TRTD_EarthquakeEffect")
end

--[[
    Add effects to the dice
    Some effects are not automatically disabled. They don't have a duration or disable function.
--]]

TRTD.AddEffect{name="double health", enable=function(ply)
    ply:SetHealth(ply:Health() * 2)
end}

TRTD.AddEffect{name="faster speed", duration=20, enable=function(ply)
    -- Store initial values only once
    if (ply.walkspeed == nil) then
        ply.walkspeed = ply:GetWalkSpeed()
        ply.runspeed = ply:GetRunSpeed()
    end

    ply:SetWalkSpeed(ply.walkspeed * 2)
    ply:SetRunSpeed(ply.runspeed * 2)
end, disable=function(ply)
    ply:SetWalkSpeed(ply.walkspeed)
    ply:SetRunSpeed(ply.runspeed)
end}

TRTD.AddEffect{name="godmode", duration=10, enable=function(ply)
    ply:GodEnable()
end, disable=function(ply)
    ply:GodDisable()
end}

TRTD.AddEffect{name="invisibility", duration=15, enable=function(ply)
    ULib.invisible(ply, true, 0)
end, disable=function(ply)
    ULib.invisible(ply, false, 255)
end}

TRTD.AddEffect{name="low gravity", duration=15, enable=function(ply)
    ply:SetGravity(0.25)
end, disable=function(ply)
    ply:SetGravity(1)
end}

TRTD.AddEffect{name="noclip", duration=20, enable=function(ply)
    ply:SetMoveType(MOVETYPE_NOCLIP)
end, disable=function(ply)
    ply:SetMoveType(MOVETYPE_WALK)
    ply:UnTrap()
end}

TRTD.AddEffect{name="tiny player", duration=15, enable=function(ply)
    -- Store initial values only once
    if (ply.modelscale == nil) then
        ply.modelscale = ply:GetModelScale()
        ply.viewoffset = ply:GetViewOffset()
        ply.viewoffsetducked = ply:GetViewOffsetDucked()
    end

    ply:SetModelScale(ply:GetModelScale() * 0.25)
    ply:SetViewOffset(Vector(0, 0, 15))
    ply:SetViewOffsetDucked(Vector(0, 0, 15))
end, disable=function(ply)
    ply:SetModelScale(ply.modelscale)
    ply:SetViewOffset(ply.viewoffset)
    ply:SetViewOffsetDucked(ply.viewoffsetducked)
end}

TRTD.AddEffect{name="blindness", duration=10, enable=function(ply)
    ply:ScreenFade(SCREENFADE.STAYOUT, Color(0, 0, 0, 254), 0, 0)
end, disable=function(ply)
    ply:ScreenFade(SCREENFADE.PURGE, Color(0, 0, 0, 254), 0, 0)
end}

TRTD.AddEffect{name="confused", duration=15, enable=function(ply)
    net.Start("TRTD_ConfusedEffect")
    net.WriteBool(true)
    net.Send(ply)
end, disable=function(ply)
    net.Start("TRTD_ConfusedEffect")
    net.WriteBool(false)
    net.Send(ply)
end}

TRTD.AddEffect{name="drugged", duration=20, enable=function(ply)
    net.Start("TRTD_DruggedEffect")
    net.WriteBool(true)
    net.Send(ply)
end, disable=function(ply)
    net.Start("TRTD_DruggedEffect")
    net.WriteBool(false)
    net.Send(ply)
end}

TRTD.AddEffect{name="earthquake", duration=5, enable=function(ply)
    net.Start("TRTD_EarthquakeEffect")
    net.WriteBool(true)
    net.Send(ply)
end, disable=function(ply)
    net.Start("TRTD_EarthquakeEffect")
    net.WriteBool(false)
    net.Send(ply)
end}

TRTD.AddEffect{name="reduced speed", duration=15, enable=function(ply)
    -- Store initial values only once
    if (ply.walkspeed == nil) then
        ply.walkspeed = ply:GetWalkSpeed()
        ply.runspeed = ply:GetRunSpeed()
    end

    ply:SetWalkSpeed(ply.walkspeed * 0.25)
    ply:SetRunSpeed(ply.runspeed * 0.25)
end, disable=function(ply)
    ply:SetWalkSpeed(ply.walkspeed)
    ply:SetRunSpeed(ply.runspeed)
end}

TRTD.AddEffect{name="rocket", enable=function(ply)
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
end}

TRTD.AddEffect{name="reduced health", enable=function(ply)
    ply:SetHealth(1)
end}

TRTD.AddEffect{name="spontaneous combustion", duration=10, enable=function(ply)
    ply:Ignite(255)
end, disable=function(ply)
    ply:Extinguish()
end}

TRTD.AddEffect{name="nothing", enable=function(ply)
    -- Do nothing!
end}

TRTD.AddEffect{name="corporal punishment", enable=function(ply)
    timer.Create("trtd_slap_" .. ply:EntIndex(), 0.5, math.Clamp(math.random(18), 5, 15), function()
        if not IsValid(ply) then return end
        ULib.slap(ply, math.random(8))
    end)
end}

if engine.ActiveGamemode() == "sandbox" then
    TRTD.AddEffect{name="increased armor", enable=function(ply)
        ply:SetArmor(math.Clamp(ply:Armor() + math.random(255), 0, 255))
    end}

    TRTD.AddEffect{name="reduced armor", enable=function(ply)
        ply:SetArmor(math.Clamp(ply:Armor() - math.random(255), 0, 255))
    end}
end

TRTD.AddEffect{name="respawn", enable=function(ply)
    ply:StripWeapons()
    ply:Spawn()
    hook.Call("PlayerLoadout", GAMEMODE, ply)
end}

--[[
    Client-side effect countdown
--]]

if CLIENT then
    local function TRTD_EffectCountdown()
        local delay = 1
        local seconds = net.ReadInt(6)
        local font = "DermaLarge"
        local color = TRTD.Colors.Timer
        local x, y = ScrW() * 0.5, ScrH() * 0.25
        local align = TEXT_ALIGN_CENTER

        timer.Create("TRTD_Countdown", delay, seconds, function()
            hook.Add("HUDPaint", "TRTD_Countdown", function()
                draw.DrawText(seconds, font, x, y, color, align)
            end)

            seconds = seconds - 1

            if seconds < 1 then
                hook.Remove("HUDPaint", "TRTD_Countdown")
            end
        end)
    end
    net.Receive("TRTD_EffectCountdown", TRTD_EffectCountdown)

    local function TRTD_EffectCountdownStop()
        timer.Remove("TRTD_Countdown")
        hook.Remove("HUDPaint", "TRTD_Countdown")
    end
    net.Receive("TRTD_EffectCountdownStop", TRTD_EffectCountdownStop)
end

--[[
    Pick "random" effect for a player
--]]

function randomEffect(ply)
    if ply.history == nil then
        ply.history = {}
    end

    -- Generate random number that's not in the players' history
    local rand = math.random(1, #TRTD.Effects)
    while table.HasValue(ply.history, rand) do
        rand = math.random(1, #TRTD.Effects)
    end

    -- We don't want more than x items in history
    local keep = math.ceil(#TRTD.Effects * 0.25)
    if table.maxn(ply.history) >= keep then
        local temp = {}
        for i=1, keep do
            if (i == keep) then
                temp[i] = nil
            else
                temp[i] = ply.history[i+1]
            end
        end
        ply.history = temp
    end

    table.insert(ply.history, rand)

    return TRTD.Effects[rand]
end

--[[
    Create the ULX command
--]]

function ulx.rtd(calling_ply)
    if not IsValid(calling_ply) then return end

    if calling_ply.TRTD_Cooldown == nil then
        calling_ply.TRTD_Cooldown = 0
    end

    if calling_ply.TRTD_Cooldown-1 > CurTime() then
        ULib.tsayError(calling_ply, "You have to wait " .. math.Round(calling_ply.TRTD_Cooldown - CurTime()) .. " more seconds before you can Roll the Dice again.")
        return
    end

    if not calling_ply:Alive() then
        ULib.tsayError(calling_ply, "You can't Roll the Dice when you're dead.")
        return
    end

    calling_ply.TRTD_Cooldown = CurTime() + TRTD.Settings.Cooldown:GetInt()

    local effect = randomEffect(calling_ply)

    MsgN("[".. TRTD.Settings.Tag:GetString() .."] " .. calling_ply:Nick() .. " has rolled " .. effect.name)

    effect.enable(calling_ply)

    if effect.disable ~= nil and effect.duration ~= nil then
        -- Trigger the client-side countdown
        net.Start("TRTD_EffectCountdown")
        net.WriteInt(effect.duration, 6) -- Bit count of 6 allows any int between 0 and 63
        net.Send(calling_ply)

        -- Make sure all hook IDs are unique...
        local session = util.CRC(SysTime())
        local hookId = "TRTD_EffectTimer_" .. calling_ply:SteamID64() .. session
        local timerId = "TRTD_DeathListener_" .. calling_ply:SteamID64() .. session

        -- If the player dies during an effect, we want to stop it as well as the countdown
        hook.Add("PlayerDeath", hookId, function(victim)
            if victim == calling_ply then
                net.Start("TRTD_EffectCountdownStop")
                net.Send(calling_ply)
                effect.disable(calling_ply)
                timer.Destroy(timerId)
            end
        end)

        -- Disable the effect
        timer.Create(timerId, effect.duration, 1, function()
            if not IsValid(calling_ply) then return end
            effect.disable(calling_ply)
            hook.Remove("PlayerDeath", hookId)
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

    local effectNotifications = nil -- nil will send to all players
    if (TRTD.Settings.Notifications:GetBool() == false) then
        effectNotifications = calling_ply
    end

    ULib.tsayColor(effectNotifications, false, unpack(notification))
end
local rtd = ulx.command(TRTD.Settings.Category:GetString(), "ulx rtd", ulx.rtd, {"!rtd", "rtd"}, true)
rtd:defaultAccess(ULib.ACCESS_ALL)
rtd:help("Roll the Dice and receive a random, temporary effect.")

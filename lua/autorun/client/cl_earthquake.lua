function shakePlayer(ply, mvd)
    mvd:SetVelocity(VectorRand() * 600)
end

local function TRTD_EarthquakeEffect()
    local enable = net.ReadBool()
    if (enable) then
        hook.Add("SetupMove", "TRTD_earthquake", shakePlayer)
    else
        hook.Remove("SetupMove", "TRTD_earthquake", shakePlayer)
    end
end
net.Receive("TRTD_EarthquakeEffect", TRTD_EarthquakeEffect)

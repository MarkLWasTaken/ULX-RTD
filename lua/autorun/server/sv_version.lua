local version = "v1.3.1"
local version_url = "http://users.silenceisdefeat.com/timmy/gmod/trtd.txt"
local update_url = "github.com/timmyws/ULX-RTD"
local msg_outdated = "[RTD] Newer version available! Download here: " .. update_url

hook.Add("PlayerInitialSpawn", "TRTDVersionCheck", function(ply)
    if (ply:IsSuperAdmin() ~= true) then return end

    local notification_count = tonumber(ply:GetPData("trtd_outdated_" .. version, 5))
    if (notification_count == -1) then return end

    http.Fetch(version_url, function(body, len, headers, code)

        if (string.Trim(body) ~= version) then
            notification_count = notification_count - 1
            ply:SetPData("trtd_outdated_" .. version, notification_count)

            if (notification_count > 0) then
                ply:PrintMessage(HUD_PRINTTALK, msg_outdated .. " - Will display " .. notification_count .. " more time(s).")
            else
                ply:PrintMessage(HUD_PRINTTALK, msg_outdated)
            end
        end

    end, function(error)

        -- Silently fail

    end)
end)

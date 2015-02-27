local version = "v1.0"
local version_url = "http://users.silenceisdefeat.com/timmy/gmod/trtd.txt"
local update_url = "github.com/Killua13/ULX-RTD"

local messages = {}
messages.outdated = "[RTD] A newer version is available. Update me here: " .. update_url;
messages.updated  = "[RTD] Running the latest version."
messages.error    = "[RTD] Checking for updates failed."

hook.Add("PlayerInitialSpawn", "TRTDVersionCheck", function(ply)
    http.Fetch(version_url, function(body, len, headers, code)
        if (string.Trim(body) ~= version) then
            MsgN(messages.outdated)

            if (ply:IsAdmin() or ply:IsSuperAdmin()) then
                ply:PrintMessage(HUD_PRINTTALK, messages.outdated)
            end
        else
            MsgN(messages.updated)
        end
    end, function(error)
        MsgN(messages.error)
    end)
end)

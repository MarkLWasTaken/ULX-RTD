--[[
    Credits to XCIV
    http://facepunch.com/showthread.php?t=1000180&p=24819253&viewfull=1#post24819253
--]]

local meta = FindMetaTable("Player");

local function CheckAndAdjust(posMax, posMin, tr, npos)
    tr.start, tr.endpos = posMin, posMax;
    local res = util.TraceLine(tr);
    if (res.Hit && !res.StartSolid) then
        return (npos - (posMax - res.HitPos));
    else
        tr.start, tr.endpos = posMax, posMin;
        res = util.TraceLine(tr);
        if (res.Hit && !res.StartSolid) then
            return (npos - (posMin - res.HitPos));
        end
    end
    return npos;
end

function meta:UnTrap()
    local tr = { filter = self };
    local res;
    local traceline = util.TraceLine; --save time hurrrrrrrrrrrrr

    --Left/right checks for top and bottom
    local bmin, bmax = self:WorldSpaceAABB();
    local TFL = Vector(bmin.x, bmax.y, bmax.z);
    local TFR = bmax;
    self:SetPos(CheckAndAdjust(TFL, TFR, tr, self:GetPos()));
    local bmin, bmax = self:WorldSpaceAABB();
    local TAL = Vector(bmin.x, bmin.y, bmax.z);
    local TAR = Vector(bmax.x, bmin.y, bmax.z);
    self:SetPos(CheckAndAdjust(TAL, TAR, tr, self:GetPos()));
    local bmin, bmax = self:WorldSpaceAABB();
    local BFL = Vector(bmin.x, bmax.y, bmin.z);
    local BFR = Vector(bmax.x, bmax.y, bmin.z);
    self:SetPos(CheckAndAdjust(BFL, BFR, tr, self:GetPos()));
    local bmin, bmax = self:WorldSpaceAABB();
    local BAL = bmin;
    local BAR = Vector(bmax.x, bmin.y, bmin.z);
    self:SetPos(CheckAndAdjust(BAL, BAR, tr, self:GetPos()));

    --Front/back checks for top and bottom
    local bmin, bmax = self:WorldSpaceAABB();
    local TFL = Vector(bmin.x, bmax.y, bmax.z);
    local TAL = Vector(bmin.x, bmin.y, bmax.z);
    self:SetPos(CheckAndAdjust(TFL, TAL, tr, self:GetPos()));
    local bmin, bmax = self:WorldSpaceAABB();
    local TFR = bmax;
    local TAR = Vector(bmax.x, bmin.y, bmax.z);
    self:SetPos(CheckAndAdjust(TFR, TAR, tr, self:GetPos()));
    local bmin, bmax = self:WorldSpaceAABB();
    local BFL = Vector(bmin.x, bmax.y, bmin.z);
    local BAL = bmin;
    self:SetPos(CheckAndAdjust(BFL, BAL, tr, self:GetPos()));
    local bmin, bmax = self:WorldSpaceAABB();
    local BFR = Vector(bmax.x, bmax.y, bmin.z);
    local BAR = Vector(bmax.x, bmin.y, bmin.z);
    self:SetPos(CheckAndAdjust(BFR, BAR, tr, self:GetPos()));
end

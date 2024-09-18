local ENTMETA = FindMetaTable"Entity"

local SSV = ENTMETA.SetSaveValue
local GSV = ENTMETA.GetSaveValue
local GEFL=ENTMETA.GetEFlags
local GETPHYCOUNT=ENTMETA.GetPhysicsObjectCount
local GETPHYNUM=ENTMETA.GetPhysicsObjectNum
local SETVEL=ENTMETA.SetVelocity
local GETVEL=ENTMETA.GetVelocity
--no ISPLY
ENTMETA.SetEFlags_Old = ENTMETA.SetEFlags
ENTMETA.AddEFlags_Old = ENTMETA.AddEFlags
function ENTMETA:SetEFlags(eflags)
    SSV(self, "m_iEFlags", eflags)
end

function ENTMETA:AddEFlags(eflags) --Fix cant add EFL_KILLME
    SSV(self, "m_iEFlags'", bit.bor(GEFL(self), eflags))
end

function ENTMETA:StopThink()
    self:NextThink(CurTime() + 1e9)
    if self.Think then self.Think = function() end end
end

function ENTMETA:MarkAsRemoved()
    self:AddEFlags(EFL_KILLME)
end

function ENTMETA:UnmarkAsRemoved()
    self:RemoveEFlags(EFL_KILLME)
end

function ENTMETA:IsMarkedAsRemoved()
    return self:IsEFlagSet(EFL_KILLME)
end

UTIL_Remove = ENTMETA.Remove
util.Remove = ENTMETA.Remove
local vec_zero = Vector(0, 0, 0)
function ENTMETA:StopVelocity()
    if self:IsPlayer() then SETVEL(self,-GETVEL(self)) end
    SETVEL(self,vec_zero)
    for i = 0, GETPHYCOUNT(self) - 1 do
        local phy = GETPHYNUM(self,i)
        if IsValid(phy) then phy:SetVelocity(vec_zero) end
    end

    SSV(self, "m_flVelocity", vec_zero)
end

function ENTMETA:SetThrower(thrower)
    SSV(self, "m_hThrower", thrower)
    if GSV(self, "m_hOriginalThrower") == NULL then SSV(self, "m_hOriginalThrower", thrower) end
end

function ENTMETA:GetThrower()
    return GSV(self, "m_hThrower")
end

function ENTMETA:GetOriginalThrower()
    return GSV(self, "m_hOriginalThrower")
end

function ENTMETA:GRENADE_SetLive(live)
    return SSV(self, "m_bIsLive", true)
end

function ENTMETA:GRENADE_IsLive()
    return GSV(self, "m_bIsLive")
end

function ENTMETA:GRENADE_GetDamageRadius()
    return GSV(self, "m_DmgRadius")
end

function ENTMETA:GRENADE_SetDamageRadius(rad)
    return SSV(self, "m_DmgRadius", rad)
end

function ENTMETA:GRENADE_GetDetonateTime()
    return GSV(self, "m_flDetonateTime")
end

function ENTMETA:GRENADE_HasWarnedAI()
    return GSV(self, "m_bHasWarnedAI")
end

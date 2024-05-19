local ENTMETA=FindMetaTable 'Entity'
function ENTMETA:SetEFlags(eflags)
  self:SetSaveValue("m_iEFlags",eflags)
end
function ENTMETA:AddEFlags(eflags)--Fix cant add EFL_KILLME
  self:SetSaveValue("m_iEFlags",bit.bor(self:GetEFlags(),eflags))
end
function ENTMETA:StopThink()
  self:NextThink(CurTime()+1e9)
  if(self.Think)then self.Think=function() end end
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
UTIL_Remove=ENTMETA.Remove
util.Remove=ENTMETA.Remove
local vec_zero=Vector(0,0,0)
function ENTMETA:StopVelocity()
  if(self:IsPlayer())then self:SetVelocity(-self:GetVelocity()) end
  self:SetVelocity(vec_zero)
  for i=0,self:GetPhysicsObjectCount() do
    local phy=self:GetPhysicsObjectNum(i)
    if(IsValid(phy))then
        phy:SetVelocity(vec_zero)
    end
  end
  self:SetSaveValue("m_flVelocity",tostring(vec_zero))
end

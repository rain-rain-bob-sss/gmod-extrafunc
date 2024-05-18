local ENTMETA=FindMetaTable 'Entity'
function ENTMETA:SetEFlags(eflags)
  self:SetSaveValue("m_iEFlags",eflags)
end
function ENTMETA:AddEFlags(eflags)--Fix cant add EFL_KILLME
  self:SetSaveValue("m_iEFlags",bit.bor(self:GetEFlags(),eflags))
end

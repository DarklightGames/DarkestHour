//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Pak40ATGun_CamoOne extends DH_Pak40ATGun;

defaultproperties
{
    Skins(0)=Texture'DH_Pak40_tex.Pak40.Pak40_ext_camo'
    CannonSkins(0)=Texture'DH_Pak40_tex.Pak40.Pak40_ext_camo'
    RandomAttachmentGroups(0)=(Options=((Probability=1.0,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_Pak40_stc.PAK40_BODY_FOLIAGE'))))
    RandomAttachmentGroups(1)=(Options=((Probability=1.0,Attachment=(AttachBone="YAW",StaticMesh=StaticMesh'DH_Pak40_stc.PAK40_YAW_FOLIAGE',bAttachToWeapon=true))))
}

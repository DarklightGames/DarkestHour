//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Pak36ATGunCamo extends DH_Pak36ATGun;

defaultproperties
{
    Skins(0)=Texture'DH_Pak36_tex.pak36_ext_camo'
    CannonSkins(0)=Texture'DH_Pak36_tex.pak36_ext_camo'
    DestroyedMeshSkins(0)=Material'DH_Pak36_tex.pak36_ext_camo_destroyed'
    VehicleAttachments(0)=(AttachBone="GUN_YAW",StaticMesh=StaticMesh'DH_Pak36_stc.pak36_yaw_foliage',bAttachToWeapon=true)
}

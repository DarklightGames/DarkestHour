//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Pak38ATGunCamoTwo extends DH_Pak38ATGun;

defaultproperties
{
    Skins(0)=Texture'DH_Pak38_tex.pak38_ext_camo1'
    CannonSkins(0)=Texture'DH_Pak38_tex.pak38_ext_camo1'
    VehicleAttachments(0)=(AttachBone="BODY",StaticMesh=StaticMesh'DH_Pak38_stc.PAK38_BODY_FOLIAGE',Skins=(Texture'WildBush_A'))
    VehicleAttachments(1)=(AttachBone="GUN_YAW",StaticMesh=StaticMesh'DH_Pak38_stc.PAK38_TURRET_FOLIAGE_YAW',Skins=(Texture'WildBush_A'),bAttachToWeapon=true)
    DestroyedMeshSkins(0)=Material'DH_Pak38_tex.pak38_ext_camo1_destroyed'
}

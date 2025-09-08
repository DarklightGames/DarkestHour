//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Pak43ATGun_Camo extends DH_Pak43ATGun;

defaultproperties
{
    Skins(0)=Texture'DH_Pak43_tex.pak43_ext_camo'
    CannonSkins(0)=Texture'DH_Pak43_tex.pak43_ext_camo'
    DestroyedMeshSkins(0)=Combiner'DH_Pak43_tex.pak43_ext_camo_destroyed'
    VehicleAttachments(0)=(AttachBone="BODY",StaticMesh=StaticMesh'DH_Pak43_stc.PAK43_BODY_FOLIAGE')
    VehicleAttachments(1)=(AttachBone="GUN_YAW",StaticMesh=StaticMesh'DH_Pak43_stc.PAK43_TURRET_FOLIAGE',bAttachToWeapon=true)
}

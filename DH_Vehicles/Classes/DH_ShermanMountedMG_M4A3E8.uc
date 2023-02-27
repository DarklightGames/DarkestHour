//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanMountedMG_M4A3E8 extends DH_ShermanMountedMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_ShermanM4A3E8_anm.mg_ext'
    Skins(0)=Texture'DH_ShermanM4A3E8_tex.body_ext'

    WeaponFireAttachmentBone="muzzle"
    WeaponFireOffset=(X=0,Y=0,Z=0)
    WeaponAttachOffset=(X=0,Y=0,Z=0)
    FireAttachBone="muzzle"
}


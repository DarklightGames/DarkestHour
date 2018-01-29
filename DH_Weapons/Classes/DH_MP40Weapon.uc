//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_MP40Weapon extends DHAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Mp40_1st.ukx

defaultproperties
{
    ItemName="Maschinenpistole 40"
    FireModeClass(0)=class'DH_Weapons.DH_MP40Fire'
    FireModeClass(1)=class'DH_Weapons.DH_MP40MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_MP40Attachment'
    PickupClass=class'DH_Weapons.DH_MP40Pickup'

    Mesh=SkeletalMesh'DH_Mp40_1st.mp40-mesh'
    HighDetailOverlay=shader'Weapons1st_tex.SMG.MP40_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=35.0
    ZoomOutTime=0.15

    MaxNumPrimaryMags=7
    InitialNumPrimaryMags=7
}

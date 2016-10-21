//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M38Weapon extends DHBoltActionWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_Nagant_1st.ukx

defaultproperties
{
    ItemName="Mosin-Nagant M38 Carbine"
    FireModeClass(0)=class'DH_Weapons.DH_M38Fire'
    FireModeClass(1)=class'DH_Weapons.DH_M38MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_M38Attachment'
    PickupClass=class'DH_Weapons.DH_M38Pickup'

    Mesh=SkeletalMesh'Allies_Nagant_1st.Mosin_Nagant_Carbine_mesh'
    HighDetailOverlay=shader'Weapons1st_tex.Rifles.MN9138_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=25.0
    ZoomOutTime=0.35
    FreeAimRotationSpeed=7.0

    MaxNumPrimaryMags=10
    InitialNumPrimaryMags=10
}

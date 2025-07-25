//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M38Weapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Mosin M38"
    SwayModifyFactor=0.52  // -0.08
    FireModeClass(0)=Class'DH_M38Fire'
    FireModeClass(1)=Class'DH_M38MeleeFire'
    AttachmentClass=Class'DH_M38Attachment'
    PickupClass=Class'DH_M38Pickup'

    Mesh=SkeletalMesh'DH_Nagant_1st.Mosin_Nagant_Carbine_mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.MN9138_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=47.0
    DisplayFOV=85.0
    ZoomOutTime=0.35
    FreeAimRotationSpeed=7.0

    MaxNumPrimaryMags=10
    InitialNumPrimaryMags=10

    PreReloadAnim="single_open"
    FullReloadAnim="reload"
    SingleReloadAnim="single_insert"
    PostReloadAnim="single_close"
}

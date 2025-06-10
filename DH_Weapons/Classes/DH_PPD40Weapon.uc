//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PPD40Weapon extends DH_PPSh41Weapon;

defaultproperties
{
    ItemName="PPD-40"

    FireModeClass(0)=Class'DH_PPD40Fire'
    FireModeClass(1)=Class'DH_PPD40MeleeFire'
    AttachmentClass=Class'DH_PPD40Attachment'
    PickupClass=Class'DH_PPD40Pickup'

    Mesh=SkeletalMesh'DH_Ppd40_1st.PPD-40-1st'
    HighDetailOverlay=Shader'Weapons1st_tex.SMG.PPD40_1_S'

    IronSightDisplayFOV=60.0
    DisplayFOV=85.0

    SelectFireAnim="fireswitch"
    SelectFireIronAnim="Iron_fireswitch"
    SelectFireEmptyAnim="fireswitch_empty"
    SelectFireIronEmptyAnim="Iron_fireswitch_empty"

    //alternative reload (this one is "normal", so more common)
    MagEmptyReloadAnims(1)="reload_emptyB"
    MagEmptyReloadAnims(2)="reload_emptyB"
    MagEmptyReloadAnims(3)="reload_emptyB"
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Nagant1895Weapon extends DHRevolverWeapon;

defaultproperties
{
    ItemName="Nagant M1895"
    FireModeClass(0)=Class'DH_Nagant1895Fire'
    FireModeClass(1)=Class'DH_Nagant1895MeleeFire'
    AttachmentClass=Class'DH_Nagant1895Attachment'
    PickupClass=Class'DH_Nagant1895Pickup'

    Mesh=SkeletalMesh'DH_Nagant1895_1st.Nagant1895'

    bUseHighDetailOverlayIndex=false
    Skins(0)=Texture'DH_Nagant1895_tex.Nagant1895'
    HandNum=1
    SleeveNum=2

    DisplayFOV=85.0
    IronSightDisplayFOV=75.0

    InitialNumPrimaryMags=10
    MaxNumPrimaryMags=10

    SwayModifyFactor=1.8    //very hard double action trigger

    PreReloadAnim="single_open"
    SingleReloadAnim="single_insert"
    PostReloadAnim="single_close"
}

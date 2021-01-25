//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_G41Weapon extends DHSemiAutoWeapon;

// Modified to add hint about weapon's two clip loading capacity
simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    if (Instigator != none && DHPlayer(Instigator.Controller) != none)
    {
        DHPlayer(Instigator.Controller).QueueHint(22, true);
    }
}

defaultproperties
{
    ItemName="Gewehr 41(W)"
    SwayModifyFactor=0.93 // +0.13 because it was a heavy, disbalanced and awkward rifle
    FireModeClass(0)=class'DH_Weapons.DH_G41Fire'
    FireModeClass(1)=class'DH_Weapons.DH_G41MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_G41Attachment'
    PickupClass=class'DH_Weapons.DH_G41Pickup'

    Mesh=SkeletalMesh'DH_G41_1st.G41_mesh'
    HighDetailOverlay=shader'Weapons1st_tex2.Rifles.G41_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=33.0
    DisplayFOV=85.0
    FreeAimRotationSpeed=7.5

    MaxNumPrimaryMags=11
    InitialNumPrimaryMags=11

    bTwoMagsCapacity=true
    bPlusOneLoading=false
    MagEmptyReloadAnim="reload_striper_empty"
    MagPartialReloadAnim="reload_striper"
}

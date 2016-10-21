//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_G41Weapon extends DHSemiAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\Axis_G41_1st.ukx

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
    FireModeClass(0)=class'DH_Weapons.DH_G41Fire'
    FireModeClass(1)=class'DH_Weapons.DH_G41MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_G41Attachment'
    PickupClass=class'DH_Weapons.DH_G41Pickup'

    Mesh=SkeletalMesh'Axis_G41_1st.G41_mesh'
    HighDetailOverlay=shader'Weapons1st_tex2.Rifles.G41_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=20.0
    FreeAimRotationSpeed=7.5

    MaxNumPrimaryMags=11
    InitialNumPrimaryMags=11
    bTwoMagsCapacity=true
    bPlusOneLoading=false
    MagEmptyReloadAnim="reload_striper_empty"
    MagPartialReloadAnim="reload_striper"
}

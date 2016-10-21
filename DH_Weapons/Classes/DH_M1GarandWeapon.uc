//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M1GarandWeapon extends DHSemiAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Garand_1st.ukx

var     bool    bIsLastRound;

// Modified to support garand last round clip eject for client only
simulated function Fire(float F)
{
    super.Fire(F);

    bIsLastRound = AmmoAmount(0) == 1;
}

// New function to support garand last round clip eject for server only
simulated function bool WasLastRound()
{
    return AmmoAmount(0) == 0;
}

// Modified to add hint about garand's ping noise on clip ejection
simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    if (Instigator != none && DHPlayer(Instigator.Controller) != none)
    {
        DHPlayer(Instigator.Controller).QueueHint(20, true);
    }
}

defaultproperties
{
    ItemName="M1 Garand"
    FireModeClass(0)=class'DH_Weapons.DH_M1GarandFire'
    FireModeClass(1)=class'DH_Weapons.DH_M1GarandMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_M1GarandAttachment'
    PickupClass=class'DH_Weapons.DH_M1GarandPickup'

    Mesh=SkeletalMesh'DH_Garand_1st.M1_Garand'

    IronSightDisplayFOV=20.0
    FreeAimRotationSpeed=7.5

    MaxNumPrimaryMags=11
    InitialNumPrimaryMags=11
    bPlusOneLoading=false
    bDiscardMagOnReload=true

    bHasBayonet=true
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"
    BayonetBoneName="bayonet"

    PutDownAnim="putaway"
    IronBringUpEmpty="Iron_In_empty"
    IronPutDownEmpty="Iron_Out_empty"
    IdleEmptyAnim="idle_empty"
    IronIdleEmptyAnim="iron_idle_empty"
}

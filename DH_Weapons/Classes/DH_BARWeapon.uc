//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BARWeapon extends DHBipodAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_BAR_1st.ukx

var     bool    bSlowFireRate;

// Modified as BAR switches between slow/fast auto fire
simulated function ToggleFireMode()
{
    bSlowFireRate = !bSlowFireRate;

    if (bSlowFireRate)
    {
        FireMode[0].FireRate = 0.2;  // slow rate 300rpm

    }
    else
    {
        FireMode[0].FireRate = 0.12; // fast rate 500rpm
    }

}

// Modified as BAR switches between slow/fast auto fire, so the HUD ammo icon needs to display based on that (not the usual semi/full auto fire)
simulated function bool UsingAutoFire()
{
    return !bSlowFireRate;
}

defaultproperties
{
    SelectFireAnim="switch_fire"
    SelectFireIronAnim="Iron_switch_fire"
    SightUpSelectFireIronAnim="SightUp_iron_switch_fire"
    bSlowFireRate=true
    bCanBeResupplied=true
    NumMagsToResupply=2
    MaxNumPrimaryMags=6
    InitialNumPrimaryMags=6
    IronSightDisplayFOV=25.0
    FreeAimRotationSpeed=2.0
    bHasSelectFire=true
    FireModeClass(0)=class'DH_Weapons.DH_BARFire'
    FireModeClass(1)=class'DH_Weapons.DH_BARMeleeFire'
    PickupClass=class'DH_Weapons.DH_BARPickup'
    AttachmentClass=class'DH_Weapons.DH_BARAttachment'
    ItemName="Browning Automatic Rifle"
    Mesh=SkeletalMesh'DH_BAR_1st.BAR'
}

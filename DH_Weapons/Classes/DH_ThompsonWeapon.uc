//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ThompsonWeapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="M1A1 Thompson"
    SwayModifyFactor=0.78 // +0.08
    FireModeClass(0)=class'DH_Weapons.DH_ThompsonFire'
    FireModeClass(1)=class'DH_Weapons.DH_ThompsonMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_ThompsonAttachment'
    PickupClass=class'DH_Weapons.DH_ThompsonPickup'

    Mesh=SkeletalMesh'DH_Thompson_1st.M1A1_Thompson' // TODO: there is no specularity mask for this weapon

    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=65.0

    DisplayFOV=86.0

    MaxNumPrimaryMags=9
    InitialNumPrimaryMags=9

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_ThompsonBarrel'
    BarrelSteamBone="Muzzle"

    bHasSelectFire=true
    SelectFireAnim="fire_select"
    SelectFireIronAnim="Iron_fire_select"
    PutDownAnim="put_away"

    MagEmptyReloadAnims(0)="reload_m1a1"
    MagPartialReloadAnims(0)="reload_m1a1"
}

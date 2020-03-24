//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_M1928_20rndWeapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="M1928 Thompson /20rnd"
	SwayModifyFactor=0.85 // +0.05 
    FireModeClass(0)=class'DH_Weapons.DH_M1928_20rndFire'
    FireModeClass(1)=class'DH_Weapons.DH_ThompsonMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_M1928_20rndAttachment'
    PickupClass=class'DH_Weapons.DH_M1928_20rndPickup'

    Mesh=SkeletalMesh'DH_Thompson_1st.M1928_20rnd'

    PlayerIronsightFOV=75.0
    IronSightDisplayFOV=60.0

    MaxNumPrimaryMags=11
    InitialNumPrimaryMags=11

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_ThompsonBarrel'
    BarrelSteamBone="Muzzle"

    bHasSelectFire=true
    SelectFireAnim="fire_select"
    SelectFireIronAnim="Iron_fire_select"
    PutDownAnim="put_away"

    MagEmptyReloadAnim="reload"
    MagPartialReloadAnim="reload"

    HandNum=0
    SleeveNum=1
    HighDetailOverlayIndex=2
}

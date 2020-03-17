//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_M1928_30rndWeapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="M1928 Thompson /30rnd"
	SwayModifyFactor=0.88 // +0.08 
    FireModeClass(0)=class'DH_Weapons.DH_M1928_30rndFire'
    FireModeClass(1)=class'DH_Weapons.DH_ThompsonMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_M1928_30rndAttachment'
    PickupClass=class'DH_Weapons.DH_M1928_30rndPickup'

    Mesh=SkeletalMesh'DH_Thompson_1st.M1928_30rnd' // TODO: there is no specularity mask for this weapon

    PlayerIronsightFOV=75.0
    IronSightDisplayFOV=60.0

    MaxNumPrimaryMags=9
    InitialNumPrimaryMags=9

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_ThompsonBarrel'
    BarrelSteamBone="Muzzle"

    bHasSelectFire=true
    SelectFireAnim="fire_select"
    SelectFireIronAnim="Iron_fire_select"
    PutDownAnim="put_away"

    MagEmptyReloadAnim="reload_m1a1"
    MagPartialReloadAnim="reload_m1a1"

    HandNum=1
    SleeveNum=0
    HighDetailOverlayIndex=2
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_BARWeapon extends DHBipodAutoWeapon;

var     bool    bSlowFireRate; // flags that the slower firing rate is currently selected

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
    SwayModifyFactor=1.1 // Increased sway because of length, weight, and general awkwardness

    ItemName="Browning Automatic Rifle"
    TeamIndex=1
    FireModeClass(0)=class'DH_Weapons.DH_BARFire'
    FireModeClass(1)=class'DH_Weapons.DH_BARMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_BARAttachment'
    PickupClass=class'DH_Weapons.DH_BARPickup'

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_BARBarrel'
    BarrelSteamBone="MuzzleNew"

    Mesh=SkeletalMesh'DH_BAR_1st.BAR'
    bUseHighDetailOverlayIndex=false
	handnum=0
	sleevenum=2
	Skins(1)=Texture'DH_Weapon_tex.AlliedSmallArms.BAR'


	DisplayFOV=86.0
    IronSightDisplayFOV=45.0
    FreeAimRotationSpeed=2.0

    MaxNumPrimaryMags=12
    InitialNumPrimaryMags=12

    bHasSelectFire=true
    bSlowFireRate=true
    SelectFireAnim="fireswitch"
    SelectFireIronAnim="fireswitch_aim"
    SightUpSelectFireIronAnim="fireswitch_aim"
	
    SelectAnim="Draw"
    PutDownAnim="Put_away"
	
    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"
	
    SightUpIronBringUp="bipod_in"
    SightUpIronPutDown="bipod_out"
    SightUpIronIdleAnim="iron_idle"
    SightUpMagEmptyReloadAnim="bipod_reload_empty"
    SightUpMagPartialReloadAnim="bipod_reload_half" 
	
    //BipodHipToDeploy="aim_to_Bipod"
	//to do: fix the above
	
}

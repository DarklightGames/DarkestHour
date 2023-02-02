//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BARNoBipodWeapon extends DHAutoWeapon;

var     bool    bSlowFireRate; // flags that the slower firing rate is currently selected

simulated function UpdateFireRate()
{
    if (bSlowFireRate)
    {
        FireMode[0].FireRate = 0.2;  // slow rate ~330rpm (? to be tested)

    }
    else
    {
        FireMode[0].FireRate = 0.12; // fast rate ~550rpm
    }
}

// Modified as BAR switches between slow/fast auto fire
simulated function ToggleFireMode()
{
    bSlowFireRate = !bSlowFireRate;

    UpdateFireRate();
}

// Modified as BAR switches between slow/fast auto fire, so the HUD ammo icon needs to display based on that (not the usual semi/full auto fire)
simulated function bool UsingAutoFire()
{
    return !bSlowFireRate;
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    // removing the bipod
    SetBoneScale(0, 0.0, 'Bipod');
}

defaultproperties
{
    SwayModifyFactor=1.0 //-0.1 from full variant

    ItemName="Browning Automatic Rifle M1918A2 (No Bipod)"
    TeamIndex=1
    FireModeClass(0)=class'DH_Weapons.DH_BARNoBipodFire'
    FireModeClass(1)=class'DH_Weapons.DH_BARNoBipodMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_BARNoBipodAttachment'
    PickupClass=class'DH_Weapons.DH_BARNoBipodPickup'

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_BARBarrel'
    BarrelSteamBone="MuzzleNew"

    Mesh=SkeletalMesh'DH_BAR_1st.BAR'
    bUseHighDetailOverlayIndex=false
    HandNum=0
    SleeveNum=2
    Skins(1)=Texture'DH_Weapon_tex.AlliedSmallArms.BAR'

    DisplayFOV=86.0
    IronSightDisplayFOV=45.0
    FreeAimRotationSpeed=2.0

    MaxNumPrimaryMags=12
    InitialNumPrimaryMags=12
    NumMagsToResupply=3

    SelectAnim="Draw"
    PutDownAnim="Put_away"

    bHasSelectFire=true
    bSlowFireRate=true
    SelectFireAnim="fireswitch"
    SelectFireIronAnim="fireswitch_aim"
    //SightUpSelectFireIronAnim="fireswitch_aim"

    MagEmptyReloadAnims(0)="reload_empty"
    MagPartialReloadAnims(0)="reload_half"

    //SightUpIronBringUp="bipod_in"
    //SightUpIronPutDown="bipod_out"
    //SightUpIronIdleAnim="iron_idle"
    //SightUpMagEmptyReloadAnim="bipod_reload_empty"
    //SightUpMagPartialReloadAnim="bipod_reload_half"
}

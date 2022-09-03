//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_BARWeapon extends DHAutoWeapon;

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

simulated state Reloading
{
    simulated function BeginState()
    {
        super.BeginState();

        // Since we have a custom animation for the bipod during reload, we'll
        // lock the sim to zero and then unlock it after it's done.
        if (BipodPhysicsSimulation != none)
        {
            BipodPhysicsSimulation.LockBipod(self, 0, 0.25);
        }
    }

    simulated function EndState()
    {
        super.EndState();

        if (BipodPhysicsSimulation != none && !Instigator.bBipodDeployed)
        {
            BipodPhysicsSimulation.UnlockBipod();
        }
    }
}

defaultproperties
{
    SwayModifyFactor=1.1 // Increased sway because of length, weight, and general awkwardness

    ItemName="Browning Automatic Rifle M1918A2"
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
    HandNum=0
    SleeveNum=2
    Skins(1)=Texture'DH_Weapon_tex.AlliedSmallArms.BAR'

    DisplayFOV=86.0
    IronSightDisplayFOV=45.0
    FreeAimRotationSpeed=2.0

    MaxNumPrimaryMags=12
    InitialNumPrimaryMags=12
    NumMagsToResupply=3

    bHasSelectFire=true
    bSlowFireRate=true
    SelectFireAnim="fireswitch"
    SelectFireIronAnim="fireswitch_aim"
    SelectFireBipodIronAnim="fireswitch_bipod"

    SelectAnim="Draw"
    PutDownAnim="Put_away"

    MagEmptyReloadAnims(0)="reload_empty"
    MagPartialReloadAnims(0)="reload_half"

    IdleToBipodDeploy="bipod_in"
    BipodDeployToIdle="bipod_out"
    BipodIdleAnim="iron_idle"
    BipodMagEmptyReloadAnim="bipod_reload_empty"
    BipodMagPartialReloadAnim="bipod_reload_half"
    IronToBipodDeploy="aim_to_Bipod"

    bCanBipodDeploy=true
    bCanBeResupplied=true
    ZoomOutTime=0.1

    // Bipod Physics
    bDoBipodPhysicsSimulation=true
    Begin Object Class=DHBipodPhysicsSettings Name=DHBarBipodPhysicsSettings
        BarrelBoneRotationOffset=(Roll=-16384)
    End Object
    BipodPhysicsSettings=DHBarBipodPhysicsSettings
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_BARWeapon extends DHAutoWeapon;

var     bool    bSlowFireRate; // flags that the slower firing rate is currently selected

var     DHBipodPhysicsSimulation    BipodPhysicsSimulation;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        // TODO: in future, move this to the super-class!
        BipodPhysicsSimulation = new class'DHBipodPhysicsSimulation';
        BipodPhysicsSimulation.BarrelBoneName = 'MuzzleNew';
        BipodPhysicsSimulation.BipodBoneName = 'bipod';
    }
}

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

simulated event WeaponTick(float DeltaTime)
{
    super.WeaponTick(DeltaTime);

    if (BipodPhysicsSimulation != none)
    {
        BipodPhysicsSimulation.PhysicsTick(self, DeltaTime);
    }
}

simulated function BipodDeploy(bool bNewDeployedStatus)
{
    super.BipodDeploy(bNewDeployedStatus);

    if (BipodPhysicsSimulation != none)
    {
        if (bNewDeployedStatus)
        {
            BipodPhysicsSimulation.LockBipod(self, 0, 0.5);
        }
        else
        {
            BipodPhysicsSimulation.UnlockBipod();
        }
    }
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

//============================================================================
// DEBUG FUNCTIONS FOR BIPOD PHYSICS SIMULATION
// TODO: move to superclass
//============================================================================
simulated exec function PAL(float V)
{
    if (Level.NetMode == NM_Standalone)
    {
        BipodPhysicsSimulation.ArmLength = V;
    }
}

simulated exec function PAD(float V)
{
    if (Level.NetMode == NM_Standalone)
    {
        BipodPhysicsSimulation.AngularDamping = V;
    }
}

simulated exec function PGS(float V)
{
    if (Level.NetMode == NM_Standalone)
    {
        BipodPhysicsSimulation.GravityScale = V;
    }
}

simulated exec function PYDF(float V)
{
    if (Level.NetMode == NM_Standalone)
    {
        BipodPhysicsSimulation.YawDeltaFactor = V;
    }
}

simulated exec function PAVT(float V)
{
    BipodPhysicsSimulation.AngularVelocityThreshold = V;
}

simulated exec function PCOR(float V)
{
    BipodPhysicsSimulation.CoefficientOfRestitution = V;
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
    NumMagsToResupply=2
    ZoomOutTime=0.1
}

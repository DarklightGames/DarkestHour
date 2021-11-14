//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_ZB30Weapon extends DHBipodAutoWeapon;

var     DHBipodPhysicsSimulation    BipodPhysicsSimulation;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        // TODO: in future, move this to the super-class!
        BipodPhysicsSimulation = new class'DHBipodPhysicsSimulation';
        BipodPhysicsSimulation.BarrelBoneName = 'Barrel';
        BipodPhysicsSimulation.BipodBoneName = 'bipod_base';
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
    
    ItemName="ZB vz.30 Machine Gun"

    FireModeClass(0)=class'DH_Weapons.DH_ZB30AutoFire'
    //FireModeClass(1)=class'DH_Weapons.DH_ZB30MeleeFire'  no melee!
    AttachmentClass=class'DH_Weapons.DH_ZB30Attachment'
    PickupClass=class'DH_Weapons.DH_ZB30Pickup'

    Mesh=SkeletalMesh'DH_ZB_1st.ZB30_1st'
    HighDetailOverlay=Shader'DH_Weapon_CC_tex.Spec_Maps.ZB30_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=0
    Skins(0)=Shader'DH_Weapon_CC_tex.Spec_Maps.ZB30_s'
    Skins(1)=Shader'Weapons1st_tex.Bullets.kar98k_stripper_s'
    HandNum=2
    SleeveNum=3
    
    DisplayFOV=85.0
    IronSightDisplayFOV=65.0

    bHasSelectFire=true
    SelectFireAnim="fireswitch"
    SelectFireIronAnim="iron_fireswitch"
    SelectFireBipodIronAnim="deploy_fireswitch"

    MaxNumPrimaryMags=11
    InitialNumPrimaryMags=11
    NumMagsToResupply=3

    InitialBarrels=2
    BarrelClass=class'DH_Weapons.DH_ZB30Barrel'
    BarrelSteamBone="Barrel"
    
    SightUpIronBringUp="deploy"
    SightUpIronPutDown="undeploy"
    SightUpIronIdleAnim="deploy_idle"
    SightUpMagEmptyReloadAnim="bipod_reload"
    SightUpMagPartialReloadAnim="bipod_reload"
    
    MagEmptyReloadAnims(0)="reload"
    MagPartialReloadAnims(0)="reload"

    IronBipodDeployAnim="iron_deploy"

    IronIdleAnim="iron_Idle"
    IronBringUp="iron_in"
    IronPutDown="iron_out"
    IronIdleAnim_"iron_idle"
    SprintStartAnim="Sprint_Start"
    SprintLoopAnim="sprint_middle"
    SprintEndAnim="Sprint_End"
    //CrawlForwardAnim="crawl_F"
    //CrawlBackwardAnim="crawl_B"
    //CrawlStartAnim="crawl_in"
    //CrawlEndAnim="crawl_out"
    IdleAnim="Idle"
    SelectAnim="Draw"
    PutDownAnim="Putaway"
    
    FirstSelectAnim="draw1"
    BarrelChangeAnim="BarrelChange"
}

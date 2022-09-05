//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHMGWeapon extends DHProjectileWeapon
    abstract;

var     class<ROFPAmmoRound>    BeltBulletClass;   // class to spawn for each bullet on the ammo belt
var     array<ROFPAmmoRound>    MGBeltArray;       // array of first person ammo rounds
var     array<name>             MGBeltBones;       // array of bone names to attach the belt to

// Modified to spawn the ammo belt
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        SpawnAmmoBelt();
    }
}

// Handles making ammo belt bullets disappear
simulated function UpdateAmmoBelt()
{
    local int i;

    if (AmmoAmount(0) < 10)
    {
        for (i = AmmoAmount(0); i < MGBeltArray.Length; ++i)
        {
            if (MGBeltArray[i] != none)
            {
                MGBeltArray[i].SetDrawType(DT_None);
            }
        }
    }
}

// Spawn the first person linked ammo belt
simulated function SpawnAmmoBelt()
{
    local int i;

    for (i = 0; i < MGBeltBones.Length; ++i)
    {
        MGBeltArray[i] = Spawn(BeltBulletClass, self);
        AttachToBone(MGBeltArray[i], MGBeltBones[i]);
    }
}

// Make the full ammo belt visible again (called by anim notifies)
simulated function RenewAmmoBelt()
{
    local int i;

    for (i = 0; i < MGBeltArray.Length; ++i)
    {
        if (MGBeltArray[i] != none)
        {
            MGBeltArray[i].SetDrawType(DT_StaticMesh);
        }
    }
}

// Overridden to make ironsights key try to deploy/undeploy the bipod, otherwise it goes to a hip fire mode if weapon allows it
simulated function ROIronSights()
{
    local DHPlayer PC;

    if (Instigator != none && (Instigator.bBipodDeployed || Instigator.bCanBipodDeploy))
    {
        if (Instigator.IsLocallyControlled())
        {
            PC = DHPlayer(Instigator.Controller);

            if (PC == none || Level.TimeSeconds < PC.NextToggleDuckTimeSeconds)
            {
                return;
            }
        }

        Deploy();
    }
    else if (bCanFireFromHip)
    {
        PerformZoom(!bUsingSights);
    }
}

simulated function bool StartFire(int Mode)
{
    if (super.StartFire(Mode))
    {
        AnimStopLooping();

        if (!FireMode[Mode].IsInState('FireLoop'))
        {
            FireMode[Mode].StartFiring();

            return true;
        }
    }

    return false;
}

// Modified to prevent MG from playing fire end anims while auto firing
simulated function AnimEnd(int Channel)
{
    local name  Anim;
    local float Frame, Rate;

    if (FireMode[0].IsInState('FireLoop'))
    {
        return;
    }

    if (ClientState == WS_ReadyToFire)
    {
        GetAnimParams(0, Anim, Frame, Rate);

        if ((Anim == FireMode[0].FireAnim || Anim == DHAutomaticFire(FireMode[0]).BipodDeployFireLoopAnim) && !FireMode[0].bIsFiring)
        {
            FireMode[0].PlayFireEnd();
        }
        else if (DHProjectileFire(FireMode[0]) != none && Anim == DHProjectileFire(FireMode[0]).FireIronAnim && !FireMode[0].bIsFiring)
        {
            PlayIdle();
        }
        else if (!FireMode[0].bIsFiring && !FireMode[1].bIsFiring)
        {
            PlayIdle();
        }
    }
}

// Modified to use free aim when 'ironsighted', because for an MG that just means it's in hipped fire mode (melee attack stuff also removed as MG has none)
simulated function bool ShouldUseFreeAim()
{
    return bUsesFreeAim && bUsingSights;
}

// Modified to avoid ironsights stuff because an 'ironsighted' MG is actually just hipped fire mode
simulated state IronSightZoomIn
{
    simulated function EndState() // avoids setting DisplayFOV & PlayerViewOffset
    {
    }

Begin: // do nothing (avoids calling SmoothZoom)
}

// Modified to avoid ironsights stuff because an 'ironsighted' MG is actually just hipped fire mode
simulated state TweenDown
{
Begin:
    if (bUsingSights)
    {
        ZoomOut();
    }

    if (InstigatorIsLocallyControlled())
    {
        PlayIdle();
    }

    SetTimer(FastTweenTime, false);
}

simulated state StartSprinting
{
// Take the player out of ironsights
Begin:
    if (bUsingSights)
    {
        ZoomOut();
    }
    else if (DisplayFOV != default.DisplayFOV && InstigatorIsLocallyControlled())
    {
        SmoothZoom(false);
    }
}

simulated state StartCrawling
{
// Take the player out of ironsights
Begin:
    if (bUsingSights)
    {
        ZoomOut();
    }
    else if (DisplayFOV != default.DisplayFOV && InstigatorIsLocallyControlled())
    {
        SmoothZoom(false);
    }
}

// Modified to allow for different free aim conditions in this class (due to possibility of hip fire from ironsights key))
function SetServerOrientation(rotator NewRotation)
{
    local rotator WeaponRotation;

    if (bUsesFreeAim && bUsingSights && Instigator != none)
    {
        // Remove the roll component so the weapon doesn't tilt with the terrain
        WeaponRotation = Instigator.GetViewRotation();
        WeaponRotation.Pitch += NewRotation.Pitch;
        WeaponRotation.Yaw += NewRotation.Yaw;

        if (ROPawn(Instigator) != none)
        {
            WeaponRotation.Roll += ROPawn(Instigator).LeanAmount;
        }

        SetRotation(WeaponRotation);
        SetLocation(Instigator.Location + Instigator.CalcDrawOffset(self));
    }
}

// Overridden because we have no melee attack
simulated function bool IsBusy()
{
    return false;
}

// Modified to add BeltBulletClass static mesh
static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    if (default.BeltBulletClass != none && default.BeltBulletClass.default.StaticMesh != none)
    {
        L.AddPrecacheStaticMesh(default.BeltBulletClass.default.StaticMesh);
    }
}

defaultproperties
{
    bPlusOneLoading=true
    bCanBeResupplied=true
    NumMagsToResupply=2
    SprintStartAnim="Rest_Sprint_Start"
    SprintLoopAnim="Rest_Sprint_Middle"
    SprintEndAnim="Rest_Sprint_End"
    BipodMagEmptyReloadAnim="Reload"
    BipodMagPartialReloadAnim="Reload"

    Priority=10
    bCanBipodDeploy=true
    bCanRestDeploy=false
    bMustReloadWithBipodDeployed=true
    bMustFireWhileSighted=true

    IronBringUp="Rest_2_Bipod"
    IronPutDown="Bipod_2_Rest"
    IdleAnim="Rest_Idle"
    BipodIdleAnim="Bipod_Idle"
    IdleToBipodDeploy="Rest_2_Bipod"
    BipodDeployToIdle="Bipod_2_Rest"
    MagEmptyReloadAnims(0)="Reload"

    bCanUseIronsights=false
}

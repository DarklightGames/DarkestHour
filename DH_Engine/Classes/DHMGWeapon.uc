//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMGWeapon extends DHBipodWeapon
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

// Overridden because we have no melee attack
simulated function bool IsBusy()
{
    return false;
}

// Modified to prevent deploying if player is moving
simulated exec function Deploy()
{
    if (Instigator != none && VSizeSquared(Instigator.Velocity) == 0.0)
    {
        super.Deploy();
    }
}

// Overridden to make ironsights key try to deploy/undeploy the bipod, otherwise it goes to a hip fire mode if weapon allows it
simulated function ROIronSights()
{
    if (Instigator != none && (Instigator.bBipodDeployed || Instigator.bCanBipodDeploy))
    {
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

simulated function AnimEnd(int Channel)
{
    if (!FireMode[0].IsInState('FireLoop'))
    {
        super.AnimEnd(Channel);
    }
}

// Modified so works in DHDebugMode, & to log barrels & their current temperature & state
simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
    local DHWeaponBarrel Barrel;
    local int            i;

    if (Level.NetMode != NM_Standalone && !class'DH_LevelInfo'.static.DHDebugMode())
    {
        return;
    }

    super(Weapon).DisplayDebug(Canvas, YL, YPos); // skip over Super in ROWeapon, as it requires RODebugMode

    // The super from ROWeapon, logging the FOV settings
    Canvas.SetDrawColor(0, 255, 0);
    Canvas.DrawText("DisplayFOV is" @ DisplayFOV $ ", default is" @ default.DisplayFOV $ ", zoomed default is" @ IronSightDisplayFOV);
    YPos += YL;
    Canvas.SetPos(4.0, YPos);

    // Show the barrel info - only works in multi-player as barrel actors don't exist on net clients
    if (Role == ROLE_Authority)
    {
        for (i = 0; i < Barrels.Length; ++i)
        {
            Barrel = Barrels[i];

            if (Barrel != none)
            {
                if (i == BarrelIndex)
                {
                    Canvas.DrawText("Active barrel temp:" @ Barrel.Temperature @ "State:" @ Barrel.GetStateName());
                }
                else
                {
                    Canvas.DrawText("Hidden barrel temp:" @ Barrel.Temperature @ "State:" @ Barrel.GetStateName());
                }

                YPos += YL;
                Canvas.SetPos(4.0, YPos);
            }
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

simulated event RenderOverlays(Canvas Canvas)
{
    local ROPlayer Playa;
    local ROPawn   RPawn;
    local rotator  RollMod;
    local int      LeanAngle, i;

    if (Instigator == none)
    {
        return;
    }

    Playa = ROPlayer(Instigator.Controller);

    // Draw muzzle flashes/smoke for all fire modes so idle state won't cause emitters to just disappear
    Canvas.DrawActor(none, false, true);

    for (i = 0; i < NUM_FIRE_MODES; ++i)
    {
        FireMode[i].DrawMuzzleFlash(Canvas);
    }

    // Adjust weapon position for lean
    RPawn = ROPawn(Instigator);

    if (RPawn != none && RPawn.LeanAmount != 0.0)
    {
        LeanAngle += RPawn.LeanAmount;
    }

    SetLocation(Instigator.Location + Instigator.CalcDrawOffset(self));

    // Remove the roll component so the weapon doesn't tilt with the terrain
    RollMod = Instigator.GetViewRotation();
    RollMod.Roll += LeanAngle;

    if (IsCrawling())
    {
        RollMod.Pitch = CrawlWeaponPitch;
    }

    if (Playa != none)
    {
        if (!IsCrawling())
        {
            RollMod.Pitch += Playa.WeaponBufferRotation.Pitch;
        }

        RollMod.Yaw += Playa.WeaponBufferRotation.Yaw;
    }

    SetRotation(RollMod);

    bDrawingFirstPerson = true;
    Canvas.DrawActor(self, false, false, DisplayFOV);
    bDrawingFirstPerson = false;
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
    bCanFireFromHip=true
    bCanBeResupplied=true
    NumMagsToResupply=2
    bSniping=false
}

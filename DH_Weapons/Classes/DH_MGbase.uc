//=============================================================================
// DH_ProjectileWeapon
//=============================================================================
// Base class for all projectile (bullets, rockets, etc) firing weapons
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson & Jeffrey "Antarian" Nakai
//=============================================================================
class DH_MGbase extends DH_BipodWeapon
    abstract;

//=============================================================================
// Variables
//=============================================================================

// MG Resupplying
var     int                 NumMagsToResupply;      // Number of ammo mags to add when this weapon has been resupplied

var     array<ROFPAmmoRound>    MGBeltArray;        // An array of first person ammo rounds
var     array<name>             MGBeltBones;        // An array of bone names to attach the belt to
var()   class<ROFPAmmoRound>    BeltBulletClass;    // The class to spawn for each bullet on the ammo belt

//=============================================================================
// Functions
//=============================================================================

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.Netmode != NM_DedicatedServer)
    {
        SpawnAmmoBelt();
    }
}


// Handles making ammo belt bullets disappear
simulated function UpdateAmmoBelt()
{
    local int i;

    if (AmmoAmount(0) > 9)
    {
        return;
    }

    for (i = AmmoAmount(0); i < MGBeltArray.Length; ++i)
    {
        MGBeltArray[i].SetDrawType(DT_none);
    }
}

// Spawn the first person linked ammobelt
simulated function SpawnAmmoBelt()
{
    local int i;

    for (i = 0; i < MGBeltBones.Length; ++i)
    {
        MGBeltArray[i] = Spawn(BeltBulletClass,self);

        AttachToBone(MGBeltArray[i], MGBeltBones[i]);
    }
}

// Make the full ammo belt visible again. Called by anim notifies
simulated function RenewAmmoBelt()
{
    local int i;

    for (i = 0; i < MGBeltArray.Length; ++i)
    {
        MGBeltArray[i].SetDrawType(DT_StaticMesh);
    }
}

function bool IsMGWeapon()
{
    return true;
}

// Implemented in various states to show whether the weapon is busy performing
// some action that normally shouldn't be interuppted. Overriden because we
// have no melee attack
simulated function bool IsBusy()
{
    return false;
}

simulated exec function Deploy()
{
    //Added a check to make sure we're not moving, this should fix a bug
    //that would sometimes allow you deploy, then when you fired no
    //bullets would come out. -Basnett
    if (IsBusy() || Instigator.Velocity != vect(0,0,0))
    {
        return;
    }

    if (Instigator.bBipodDeployed)
    {
        BipodDeploy(false);

        if (Role < ROLE_Authority)
        {
            ServerBipodDeploy(false);
        }
    }
    else if (Instigator.bCanBipodDeploy)
    {
        BipodDeploy(true);

        if (Role < ROLE_Authority)
        {
            ServerBipodDeploy(true);
        }
    }
}

simulated function ROIronSights()
{
    if (Instigator.bBipodDeployed || Instigator.bCanBipodDeploy)
    {
        Deploy();
    }
    else if (bCanFireFromHip)
    {
        super.ROIronSights();
    }
}

simulated function bool StartFire(int Mode)
{
    if (!super.StartFire(Mode))  // returns false when mag is empty
    {
        return false;
    }

    AnimStopLooping();

    if (!FireMode[Mode].IsInState('FireLoop') && (AmmoAmount(0) > 0))
    {
        FireMode[Mode].StartFiring();
    }
    else
    {
        return false;
    }

    return true;
}

simulated function AnimEnd(int channel)
{
    if (!FireMode[0].IsInState('FireLoop'))
    {
        super.AnimEnd(channel);
    }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    if (Role == ROLE_Authority)
    {
        ROPawn(Instigator).bWeaponCanBeResupplied = true;
        ROPawn(Instigator).bWeaponNeedsResupply = CurrentMagCount != (MaxNumPrimaryMags - 1);
    }
}

simulated function bool PutDown()
{
    ROPawn(Instigator).bWeaponCanBeResupplied = false;
    ROPawn(Instigator).bWeaponNeedsResupply = false;

    return super.PutDown();
}

// Overriden to set additional RO Variables when a weapon is given to the player
function GiveTo(Pawn Other, optional Pickup Pickup)
{
    super.GiveTo(Other,Pickup);

    ROPawn(Instigator).bWeaponCanBeResupplied = true;
    ROPawn(Instigator).bWeaponNeedsResupply = CurrentMagCount != (MaxNumPrimaryMags - 1);
}

function DropFrom(vector StartLocation)
{
    if (!bCanThrow)
    {
        return;
    }

    ROPawn(Instigator).bWeaponCanBeResupplied = false;
    ROPawn(Instigator).bWeaponNeedsResupply = false;

    super.DropFrom(StartLocation);
}

simulated function Destroyed()
{
    if (Role == ROLE_Authority && Instigator!= none && ROPawn(Instigator) != none)
    {
        ROPawn(Instigator).bWeaponCanBeResupplied = false;
        ROPawn(Instigator).bWeaponNeedsResupply = false;
    }

    super.Destroyed();
}

simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
    local int i;

    super.DisplayDebug(Canvas, YL, YPos);

    Canvas.SetDrawColor(0, 255, 0);

    // remove and destroy the barrels in the BarrelArray array
    for(i = 0; i < BarrelArray.Length; i++)
    {
        if (BarrelArray[i] != none)
        {
            if (i == ActiveBarrel)
            {
                Canvas.DrawText("Active Barrel Temp: "$BarrelArray[i].DH_MGCelsiusTemp$" State: "$BarrelArray[i].GetStateName());
            }
            else
            {
                Canvas.DrawText("Hidden Barrel Temp: "$BarrelArray[i].DH_MGCelsiusTemp$" State: "$BarrelArray[i].GetStateName());
            }

            YPos += YL;
            Canvas.SetPos(4,YPos);
        }
    }
}

// returns true if this weapon should use free-aim in this particular state
simulated function bool ShouldUseFreeAim()
{
    return bUsesFreeAim && bUsingSights;
}

// Overriden to support using ironsight mode as hipped mode for the MGs
simulated state IronSightZoomIn
{
    simulated function bool ShouldUseFreeAim()
    {
        return true;
    }

    simulated function EndState()
    {
    }
// Do nothing
Begin:
}

// Overriden to support using ironsight mode as hipped mode for the MGs
simulated state IronSightZoomOut
{
    simulated function EndState()
    {
        if (Instigator.bIsCrawling && VSizeSquared(Instigator.Velocity) > 1.0)
        {
            NotifyCrawlMoving();
        }
    }
// Do nothing
Begin:
}

// Overriden to support using ironsight mode as hipped mode for the MGs
simulated state TweenDown
{
Begin:
    if (bUsingSights)
    {
        if (Role == ROLE_Authority)
        {
            ServerZoomOut(false);
        }
        else
        {
            ZoomOut(false);
        }
    }

    if (Instigator.IsLocallyControlled())
    {
        PlayIdle();
    }

    SetTimer(FastTweenTime, false);
}

//=============================================================================
// Rendering
//=============================================================================
// Don't need to do the special rendering for bipod weapons since they won't
// really sway while deployed
simulated event RenderOverlays(Canvas Canvas)
{
    local int m;
    local rotator RollMod;
    local ROPlayer Playa;
    //For lean - Justin
    local ROPawn rpawn;
    local int leanangle;

    if (Instigator == none)
    {
        return;
    }

    // Lets avoid having to do multiple casts every tick - Ramm
    Playa = ROPlayer(Instigator.Controller);

    // draw muzzleflashes/smoke for all fire modes so idle state won't
    // cause emitters to just disappear
    Canvas.DrawActor(none, false, true); // amb: Clear the z-buffer here

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m] != none)
        {
            FireMode[m].DrawMuzzleFlash(Canvas);
        }
    }

    //Adjust weapon position for lean
    rpawn = ROPawn(Instigator);

    if (rpawn != none && rpawn.LeanAmount != 0)
    {
        leanangle += rpawn.LeanAmount;
    }

    SetLocation(Instigator.Location + Instigator.CalcDrawOffset(self));

    // Remove the roll component so the weapon doesn't tilt with the terrain
    RollMod = Instigator.GetViewRotation();

    if (Playa != none)
    {
        RollMod.Pitch += Playa.WeaponBufferRotation.Pitch;
        RollMod.Yaw += Playa.WeaponBufferRotation.Yaw;
    }

    RollMod.Roll += leanangle;

    if (IsCrawling())
    {
        RollMod.Pitch = CrawlWeaponPitch;
    }

    SetRotation(RollMod);

    bDrawingFirstPerson = true;

    Canvas.DrawActor(self, false, false, DisplayFOV);

    bDrawingFirstPerson = false;
}

//=============================================================================
// Sprinting
//=============================================================================
simulated state StartSprinting
{
// Take the player out of iron sights if they are in ironsights
Begin:
    if (bUsingSights)
    {
        if (Role == ROLE_Authority)
        {
            ServerZoomOut(false);
        }
        else
        {
            ZoomOut(false);
        }
    }
    else if (DisplayFOV != default.DisplayFOV && Instigator.IsLocallyControlled())
    {
        SmoothZoom(false);
    }
}

simulated state StartCrawling
{
// Take the player out of iron sights if they are in ironsights
Begin:
    if (bUsingSights)
    {
        if (Role == ROLE_Authority)
        {
            ServerZoomOut(false);
        }
        else
        {
            ZoomOut(false);
        }
    }
    else if (DisplayFOV != default.DisplayFOV && Instigator.IsLocallyControlled())
    {
        SmoothZoom(false);
    }
}

function SetServerOrientation(rotator NewRotation)
{
    local rotator WeaponRotation;

    if (bUsesFreeAim && bUsingSights)
    {
        // Remove the roll component so the weapon doesn't tilt with the terrain
        WeaponRotation = Instigator.GetViewRotation();// + FARotation;

        WeaponRotation.Pitch += NewRotation.Pitch;
        WeaponRotation.Yaw += NewRotation.Yaw;
        WeaponRotation.Roll += ROPawn(Instigator).LeanAmount;

        SetRotation(WeaponRotation);
        SetLocation(Instigator.Location + Instigator.CalcDrawOffset(self));
    }
}

simulated state Reloading
{
    simulated function EndState()
    {
        super.EndState();

        if (Role == ROLE_Authority)
        {
            ROPawn(Instigator).bWeaponNeedsResupply = CurrentMagCount != (MaxNumPrimaryMags - 1);
        }
    }
}

// This MG has been resupplied either by an ammo resupply area or another player
function bool ResupplyAmmo()
{
    local int InitialAmount, i;

    InitialAmount = FireMode[0].AmmoClass.default.InitialAmount;

    for(i = NumMagsToResupply; i > 0; i--)
    {
        if (PrimaryAmmoArray.Length < MaxNumPrimaryMags)
        {
            PrimaryAmmoArray[PrimaryAmmoArray.Length] = InitialAmount;
        }
    }

    CurrentMagCount = PrimaryAmmoArray.Length - 1;
    NetUpdateTime = Level.TimeSeconds - 1;

    if (CurrentMagCount == MaxNumPrimaryMags - 1)
    {
        ROPawn(Instigator).bWeaponNeedsResupply=false;
    }

    return true;
}

// Special ammo handling for MGs
function bool FillAmmo()
{
    return ResupplyAmmo();
}

defaultproperties
{
     bCanFireFromHip=true
     InitialBarrels=2
     ROBarrelSteamEmitterClass=Class'ROEffects.ROMGSteam'
     NumMagsToResupply=2
}


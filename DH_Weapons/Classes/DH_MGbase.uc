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

var		bool				bTrackBarrelHeat;       // We should track barrel heat for this MG
var		bool				bBarrelSteaming;		// barrel is steaming
var		bool				bBarrelDamaged;			// barrel is close to failure, accuracy is VERY BAD
var		bool				bBarrelFailed;			// barrel overheated and can't be used
var		bool				bCanFireFromHip;		// If true this weapon has a hip firing mode

var		byte				ActiveBarrel;			// barrel being used
var		byte				RemainingBarrels;   	// number of barrels still left, INCLUDES the active barrel
var		byte				InitialBarrels;			// barrels initially given

var 	class<DH_MGBarrel> 	ROBarrelClass;			// barrel type we use now
var		array<DH_MGBarrel>	BarrelArray;            // The array of carried MG barrels for this weapon

// Barrel steam info
var 	class<Emitter> 		ROBarrelSteamEmitterClass;
var 	Emitter				ROBarrelSteamEmitter;
var		name				BarrelSteamBone;		// bone we attach the barrel steam emitter too

// MG specific animations
var		name				BarrelChangeAnim;		// anim for bipod barrel changing while deployed

// MG Resupplying
var		int					NumMagsToResupply;		// Number of ammo mags to add when this weapon has been resupplied

//=============================================================================
// Replication
//=============================================================================
replication
{
	// variables replicated to the client from the server
	reliable if (bNetOwner && bNetDirty && (Role == ROLE_Authority))
     	RemainingBarrels, bBarrelSteaming, bBarrelDamaged, bBarrelFailed;

	// functions replicated to client
    reliable if (Role == ROLE_Authority)
     	ToggleBarrelSteam;

    // functions replicated to server by client
	reliable if (Role < ROLE_Authority)
    	ServerSwitchBarrels;
}


//=============================================================================
// Functions
//=============================================================================

function bool IsMGWeapon() { return true; }

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
		return;

	if (Instigator.bBipodDeployed)
	{
		BipodDeploy(false);

		if (Role < ROLE_Authority)
			ServerBipodDeploy(false);
	}
	else if (Instigator.bCanBipodDeploy)
	{
		BipodDeploy(true);

		if (Role < ROLE_Authority)
			ServerBipodDeploy(true);
	}
}

simulated function ROIronSights()
{
	if (Instigator.bBipodDeployed || Instigator.bCanBipodDeploy)
     	Deploy();
    else if (bCanFireFromHip)
    	super.ROIronSights();
}

simulated function bool StartFire(int Mode)
{
	if (!super.StartFire(Mode))  // returns false when mag is empty
	   return false;

	if (AmmoAmount(0) <= 0 || bBarrelFailed)
	{
    	return false;
    }

	AnimStopLooping();

	if (!FireMode[Mode].IsInState('FireLoop') && (AmmoAmount(0) > 0))
	{
		FireMode[Mode].StartFiring();
		return true;
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

		if (CurrentMagCount != (MaxNumPrimaryMags - 1))
		{
			ROPawn(Instigator).bWeaponNeedsResupply = true;
		}
		else
		{
			ROPawn(Instigator).bWeaponNeedsResupply = false;
		}
	}

	if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
	{
		SpawnBarrelSteamEmitter();

		if (bBarrelSteaming)
			ToggleBarrelSteam(true);

	}
}

simulated function bool PutDown()
{
 	ROPawn(Instigator).bWeaponCanBeResupplied = false;
 	ROPawn(Instigator).bWeaponNeedsResupply = false;

	return super.PutDown();
}

//------------------------------------------------------------------------------
// SpawnBarrelSteamEmitter(RO) - spawns barrel steam emitter
//------------------------------------------------------------------------------
simulated function SpawnBarrelSteamEmitter()
{
	if (Level.NetMode != NM_DedicatedServer)
	{
		if (ROBarrelSteamEmitterClass != none)
		{
			ROBarrelSteamEmitter = Spawn(ROBarrelSteamEmitterClass, self);

			if (ROBarrelSteamEmitter != none)
				AttachToBone(ROBarrelSteamEmitter, BarrelSteamBone);
		}
	}
}

// Overriden to support empty put away anims
simulated state LoweringWeapon
{
    simulated function EndState()
    {
    	super.EndState();

		if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
		{
			// destroy the barrel steam emitter
			if (ROBarrelSteamEmitter != none)
			{
				ROBarrelSteamEmitter.Destroy();
			}
		}
    }
}

simulated exec function ROMGOperation()
{
	if (!AllowBarrelChange())
		return;

	if (Level.Netmode == NM_Client)
	{
		GotoState('ChangingBarrels');
	}

	ServerSwitchBarrels();
}

function ServerSwitchBarrels()
{
	GotoState('ChangingBarrels');
}

simulated function bool AllowBarrelChange()
{
    if (IsFiring() || IsBusy())
		return false;

	// Can't reload if we don't have a mag to put in
	if (RemainingBarrels < 2 || !bTrackBarrelHeat || IsInState('ChangingBarrels'))
		return false;

    return Instigator.bBipodDeployed;
}

// State where we are changing the barrel out for our MG
simulated state ChangingBarrels extends Busy
{
	simulated function bool ReadyToFire(int Mode)
	{
		return false;
	}

	simulated function bool ShouldUseFreeAim()
	{
		return false;
	}

	simulated function bool WeaponAllowSprint()
	{
		return false;
	}

	simulated function bool WeaponAllowProneChange()
	{
		return false;
	}

    simulated function bool WeaponAllowCrouchChange()
    {
        return false;
    }

    simulated function Timer()
    {
    	GotoState('Idle');
    }

    simulated function BeginState()
    {
		PlayBarrelChange();
		PerformBarrelChange();

		if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
			ResetPlayerFOV();
    }

    simulated function EndState()
    {
		if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
			SetPlayerFOV(PlayerDeployFOV);

    }

// Take the player out of zoom and then zoom them back in
Begin:
	if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
    {
		if (DisplayFOV != default.DisplayFOV)
		{
		 	SmoothZoom(false);
		}

		Sleep((GetAnimDuration(BarrelChangeAnim, 1.0)) - (default.ZoomInTime + default.ZoomOutTime));

		SetPlayerFOV(PlayerDeployFOV);

		SmoothZoom(true);
	}
}

simulated function PlayBarrelChange()
{
	local float AnimTimer;

    AnimTimer = GetAnimDuration(BarrelChangeAnim, 1.0) + FastTweenTime;

	if (Level.NetMode == NM_DedicatedServer || (Level.NetMode == NM_ListenServer && !Instigator.IsLocallyControlled()))
		SetTimer(AnimTimer - (AnimTimer * 0.1),false);
	else
		SetTimer(AnimTimer,false);

	if (Instigator.IsLocallyControlled())
	{
		PlayAnim(BarrelChangeAnim, 1.0, FastTweenTime);
	}
}

function PerformBarrelChange()
{
	// we only have the 1 barrel in our weapon, don't do anything
	if (RemainingBarrels == 1)
	{
		return;
	}

	// if the barrel has failed, we're going to toss it, so remove it from the barrel array
	if (BarrelArray[ActiveBarrel].bBarrelFailed
		&& (BarrelArray[ActiveBarrel] != none))
	{
		BarrelArray[ActiveBarrel].Destroy();
		BarrelArray.Remove(ActiveBarrel,1);
		RemainingBarrels = byte(BarrelArray.Length);
	}

	// we only have one barrel left now
	if (RemainingBarrels == 1)
	{
		if ((ActiveBarrel >= (BarrelArray.Length - 1)) || (BarrelArray.Length == 1))
		{
     		ActiveBarrel = 0;
		}

		else
		{
			ActiveBarrel++;
		}

		// put the new barrel in the use state for heat increments and steaming
		if (BarrelArray[ActiveBarrel] != none)
			BarrelArray[ActiveBarrel].GotoState('BarrelInUse');
	}
	else
	{
		// At this point, we have more than 1 barrel, and the one being replaced
		// hasn't failed, so we'll switch the ActiveBarrel tracker and also place
		// the barrels in new states for whether they're on or off

		// first place the current ActiveBarrel in the BarrelOff state
		BarrelArray[ActiveBarrel].GotoState('BarrelOff');

		if ((ActiveBarrel >= (BarrelArray.Length - 1)) || (BarrelArray.Length == 1))
		{
     		ActiveBarrel = 0;
		}

		else
		{
			ActiveBarrel++;
		}

		// put the new barrel in the use state for heat increments and steaming
		if (BarrelArray[ActiveBarrel] != none)
			BarrelArray[ActiveBarrel].GotoState('BarrelInUse');
	}

	ResetBarrelProperties();
	//Level.Game.Broadcast(self, "Active barrel is now "@ActiveBarrel);
	//Level.Game.Broadcast(self, "Active barrel temp is "@BarrelArray[ActiveBarrel].DH_MGCelsiusTemp);
}

// Overriden to set additional RO Variables when a weapon is given to the player
function GiveTo(Pawn Other, optional Pickup Pickup)
{
	super.GiveTo(Other,Pickup);

	ROPawn(Instigator).bWeaponCanBeResupplied = true;

	if (CurrentMagCount != (MaxNumPrimaryMags - 1))
	{
		ROPawn(Instigator).bWeaponNeedsResupply = true;
	}
	else
	{
		ROPawn(Instigator).bWeaponNeedsResupply = false;
	}

	GiveBarrels(Pickup);
}

function DropFrom(vector StartLocation)
{
    if (!bCanThrow)
        return;

 	ROPawn(Instigator).bWeaponCanBeResupplied = false;
 	ROPawn(Instigator).bWeaponNeedsResupply = false;

 	super.DropFrom(StartLocation);
}


simulated function Destroyed()
{
	local	int		i;

	// remove and destroy the barrels in the BarrelArray array
	for(i = 0; i < BarrelArray.Length; i++)
	{
		if (BarrelArray[i] != none)
		{
			BarrelArray[i].Destroy();
			BarrelArray[i] = none;
		}
	}

	// destroy the barrel steam emitter
	if (ROBarrelSteamEmitter != none)
	{
		ROBarrelSteamEmitter.Destroy();
	}

	BarrelArray.Remove(0, BarrelArray.Length);

	if (Role == ROLE_Authority && Instigator!= none && ROPawn(Instigator) != none)
	{
	 	ROPawn(Instigator).bWeaponCanBeResupplied = false;
	 	ROPawn(Instigator).bWeaponNeedsResupply = false;
 	}

    Super.Destroyed();
}


//------------------------------------------------------------------------------
// ResetBarrelProperties(RO) - Called when we change barrels, this updates the
//	weapon's barrel properties for the new barrel that's being swapped in
//------------------------------------------------------------------------------
function ResetBarrelProperties()
{
	bBarrelFailed = BarrelArray[ActiveBarrel].bBarrelFailed;
	bBarrelSteaming = BarrelArray[ActiveBarrel].bBarrelSteaming;
	bBarrelDamaged = BarrelArray[ActiveBarrel].bBarrelDamaged;

	if (DHWeaponAttachment(ThirdPersonActor) != none && DHWeaponAttachment(ThirdPersonActor).SoundPitch != 64)
			DHWeaponAttachment(ThirdPersonActor).SoundPitch = 64;
}

//------------------------------------------------------------------------------
// ToggleBarrelSteam(RO) - Called when we need to toggle barrel steam on or off
//	depending on the barrel temperature
//------------------------------------------------------------------------------
simulated function ToggleBarrelSteam(bool newState)
{
	bBarrelSteaming = newState;

    if (DHWeaponAttachment(ThirdPersonActor) != none)
	 	DHWeaponAttachment(ThirdPersonActor).bBarrelSteamActive = newState;

	if ((Level.NetMode != NM_DedicatedServer) && (ROBarrelSteamEmitter != none))
	{
		ROBarrelSteamEmitter.Trigger(self, Instigator);
	}
}

// Overriden to support notifying the barrels that we have fired
simulated function bool ConsumeAmmo(int Mode, float load, optional bool bAmountNeededIsMax)
{
	local float SoundModifier;

    if (Role == ROLE_Authority)
		BarrelArray[ActiveBarrel].WeaponFired();

	if (ROWeaponAttachment(ThirdPersonActor) != none)
	{
        if (bBarrelDamaged && BarrelArray[ActiveBarrel] != none)
		{
			SoundModifier = FMax(52, 64 - ((BarrelArray[ActiveBarrel].DH_MGCelsiusTemp - BarrelArray[ActiveBarrel].DH_MGCriticalTemp)/(BarrelArray[ActiveBarrel].DH_MGFailTemp - BarrelArray[ActiveBarrel].DH_MGCriticalTemp) * 52));
			ROWeaponAttachment(ThirdPersonActor).SoundPitch = SoundModifier;
		}
		else if (ROWeaponAttachment(ThirdPersonActor).SoundPitch != 64)
		{
			ROWeaponAttachment(ThirdPersonActor).SoundPitch = 64;
		}
	}

	return super.ConsumeAmmo(Mode, load, bAmountNeededIsMax);
}

//------------------------------------------------------------------------------
// GiveBarrels(RO) - Spawns barrels for MG's on Authority
//------------------------------------------------------------------------------
function GiveBarrels(optional Pickup Pickup)
{
	local 	int 		i;
	local	DH_MGBarrel	tempBarrel, tempBarrel2;

	if (ROBarrelClass != none && (Role == ROLE_Authority))
	{
		if (Pickup == none)
		{
			// give the barrels to the players
			for(i = 0; i < InitialBarrels; i++)
			{
				tempBarrel = Spawn(ROBarrelClass, self);

				BarrelArray[i] = tempBarrel;
				if (i == 0)
				{
					BarrelArray[i].GotoState('BarrelInUse');
				}
				else
				{
					BarrelArray[i].GotoState('BarrelOff');
				}
			}
		}
		else if (DH_MGWeaponPickup(Pickup) != none)
		{
          	tempBarrel = Spawn(ROBarrelClass, self);

			BarrelArray[0] = tempBarrel;
			BarrelArray[0].GotoState('BarrelInUse');

          	BarrelArray[0].DH_MGCelsiusTemp = DH_MGWeaponPickup(Pickup).DH_MGCelsiusTemp;
          	BarrelArray[0].bBarrelFailed = DH_MGWeaponPickup(Pickup).bBarrelFailed;
            BarrelArray[0].UpdateBarrelStatus();		// update the barrel for the weapon we just picked up

            //Level.Game.Broadcast(self, "Main temp is "@BarrelArray[0].DH_MGCelsiusTemp);

          	if (DH_MGWeaponPickup(Pickup).bHasSpareBarrel)
          	{
                 tempBarrel2 = Spawn(ROBarrelClass, self);

                 BarrelArray[1] = tempBarrel2;
			     BarrelArray[1].GotoState('BarrelOff');

			     BarrelArray[1].DH_MGCelsiusTemp = DH_MGWeaponPickup(Pickup).DH_MGCelsiusTemp2;
          	     BarrelArray[1].UpdateSpareBarrelStatus();

          	     //Level.Game.Broadcast(self, "Spare temp is "@BarrelArray[1].DH_MGCelsiusTemp);
  	        }
		}
		ActiveBarrel = 0;
		RemainingBarrels = byte(BarrelArray.Length);
	}
}

simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	local	int		i;

	super.DisplayDebug(Canvas, YL, YPos);

	Canvas.SetDrawColor(0,255,0);

	// remove and destroy the barrels in the BarrelArray array
	for(i = 0; i < BarrelArray.Length; i++)
	{
		if (BarrelArray[i] != none)
		{
	    	if (i == ActiveBarrel)
			{
				Canvas.DrawText("Active Barrel Temp: "$BarrelArray[i].DH_MGCelsiusTemp$" State: "$BarrelArray[i].GetStateName());
		    	YPos += YL;
		    	Canvas.SetPos(4,YPos);
			}
			else
			{
				Canvas.DrawText("Hidden Barrel Temp: "$BarrelArray[i].DH_MGCelsiusTemp$" State: "$BarrelArray[i].GetStateName());
		    	YPos += YL;
		    	Canvas.SetPos(4,YPos);
		    }
		}
	}
}

// returns true if this weapon should use free-aim in this particular state
simulated function bool ShouldUseFreeAim()
{
	if (bUsesFreeAim && bUsingSights)
		return true;

	return false;
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
			NotifyCrawlMoving();
	}
// DO nothing
Begin:
}

// Overriden to support using ironsight mode as hipped mode for the MGs
simulated state TweenDown
{
Begin:
	if (bUsingSights)
    {
		if (Role == ROLE_Authority)
			ServerZoomOut(false);
		else
			ZoomOut(false);
	}

	if (Instigator.IsLocallyControlled())
	{
    	PlayIdle();
	}

    SetTimer(FastTweenTime,false);
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
    	return;

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
			ServerZoomOut(false);
		else
			ZoomOut(false);
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
			ServerZoomOut(false);
		else
			ZoomOut(false);
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
			if (CurrentMagCount != (MaxNumPrimaryMags - 1))
				ROPawn(Instigator).bWeaponNeedsResupply = true;
			else
				ROPawn(Instigator).bWeaponNeedsResupply = false;
		}
    }
}

// This MG has been resupplied either by an ammo resupply area or another player
function bool ResupplyAmmo()
{
	local int InitialAmount, i;

    InitialAmount = FireMode[0].AmmoClass.Default.InitialAmount;

	for(i = NumMagsToResupply; i > 0; i--)
	{
		if (PrimaryAmmoArray.Length < MaxNumPrimaryMags)
			PrimaryAmmoArray[PrimaryAmmoArray.Length] = InitialAmount;
	}

	CurrentMagCount = PrimaryAmmoArray.Length - 1;
	NetUpdateTime = Level.TimeSeconds - 1;

	if (CurrentMagCount == MaxNumPrimaryMags - 1)
		ROPawn(Instigator).bWeaponNeedsResupply=false;

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

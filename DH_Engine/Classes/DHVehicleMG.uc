//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHVehicleMG extends DHVehicleWeapon
    abstract;

var     bool    bMatchSkinToVehicle; // option to automatically match MG skin zero to vehicle skin zero (e.g. for gunshield), avoiding need for separate MG pawn & MG classes

///////////////////////////////////////////////////////////////////////////////////////
//  ***************************** KEY ENGINE EVENTS  ******************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Multi-stage MG reload similar to a tank cannon, but implemented differently to optimise
simulated function Timer()
{
    // If already reached final reload stage, always complete reload, regardless of circumstances
    // Reason: final reload sound will have played, so may be confusing if player cannot fire, especially if would need to unbutton to complete an apparently completed reload
    if (ReloadState == ReloadStages.Length)
    {
        ReloadState = RL_ReadyToFire;
        bReloadPaused = false;

        if (Role == ROLE_Authority)
        {
            MainAmmoCharge[0] = InitialPrimaryAmmo;
        }
    }
    else if (ReloadState < ReloadStages.Length)
    {
        // For earlier reload stages, we only proceed if we have a player in a position where he can reload
        if (!bReloadPaused && PlayerCanReload() && WeaponPawn.Occupied())
        {
            // Play reloading sound for this stage, if there is one (if MG uses a HUD reload animation, it will usually play its own sound through animation notifies)
            // Only played locally & not broadcast by server to other players, as is not worth the network load just for a reload sound
            if (ReloadStages[ReloadState].Sound != none && WeaponPawn.IsLocallyControlled())
            {
                PlaySound(ReloadStages[ReloadState].Sound, SLOT_Misc, 2.0);
            }

            // Set next timer based on duration of current reload sound (use reload duration if specified, otherwise try & get the sound duration)
            if (ReloadStages[ReloadState].Duration > 0.0)
            {
                SetTimer(ReloadStages[ReloadState].Duration, false);
            }
            else
            {
                SetTimer(FMax(0.1, GetSoundDuration(ReloadStages[ReloadState].Sound)), false); // FMax is just a fail-safe in case GetSoundDuration somehow returns zero
            }

            // Move to next reload state
            ReloadState = EReloadState(ReloadState + 1);
        }
        // Otherwise pause the reload, including stopping any HUD reload animation
        else
        {
            bReloadPaused = true;

            if (WeaponPawn != none && WeaponPawn.HUDOverlay != none)
            {
                WeaponPawn.HUDOverlay.StopAnimating();
            }
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ***************************** FIRING & RELOADING ******************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to incrementally resupply MG mags (only resupplies spare mags; doesn't reload the MG)
function bool ResupplyAmmo()
{
    if (NumMGMags < default.NumMGMags)
    {
        ++NumMGMags;

        // If MG is out of ammo & waiting to reload & we have a player, try to start a reload
        if (!HasAmmo(0) && ReloadState == RL_Waiting && WeaponPawn != none && WeaponPawn.Occupied())
        {
            AttemptReload();
        }

        return true;
    }

    return false;
}

// Modified to start a reload or resume a previously paused MG reload
simulated function AttemptReload()
{
    local EReloadState OldState;

    // Need to start a new reload (authority role only)
    if (ReloadState >= RL_ReadyToFire)
    {
        if (Role == ROLE_Authority)
        {
            OldState = ReloadState;

            // Start a reload if we have a spare mag & a player in a position where he can reload
            if (NumMGMags > 0 && PlayerCanReload())
            {
                NumMGMags--;
                ReloadState = RL_Empty;
                StartReloading();
            }
            // Otherwise make sure loading state is waiting (for a player in reloading position or a resupply) & give player a hint
            else
            {
                ReloadState = RL_Waiting;

                if (!PlayerCanReload() && Instigator != none && Instigator.IsLocallyControlled() && DHPlayer(Instigator.Controller) != none)
                {
                    DHPlayer(Instigator.Controller).QueueHint(48, true); // need to unbutton to reload externally mounted MG (for single player or owning listen server)
                }
            }

            // If flagged replicate reload state to net client
            if (ReloadState != OldState)
            {
                ClientSetReloadState(ReloadState);
            }
        }
    }
    // Resume a paused reload (note owning net client gets this independently from server)
    else if (bReloadPaused && PlayerCanReload())
    {
        StartReloading();
    }
}

// Modified to handle pause/resume reload system, including hint if player is in a position where can't reload
simulated function ClientSetReloadState(EReloadState NewState)
{
    if (Role < ROLE_Authority)
    {
        ReloadState = NewState;

        // MG is reloading
        if (ReloadState < RL_ReadyToFire)
        {
            // Start/resume reloading, as we have a player in a position to reload
            // If server starts new reload on unbuttoning, may be possible that net client is still in state ViewTransition when it receives this replicated function call
            // If so, PlayerCanReload() would return false & reload would pause on client, but a split second later client would leave ViewTransition & reload would be resumed
            if (PlayerCanReload())
            {
                StartReloading();
            }
            // Otherwise the reload is paused
            else
            {
                bReloadPaused = true;
            }
        }
        // If MG is waiting to start a reload, but player isn't in a position where he can reload, show a hint that he needs to unbutton
        // Player will get this if he is firing the MG, runs out of ammo, but isn't in a valid reload position, e.g. buttoned up on remote controlled MG
        else if (ReloadState == RL_Waiting && !PlayerCanReload() && Instigator != none && DHPlayer(Instigator.Controller) != none)
        {
            DHPlayer(Instigator.Controller).QueueHint(48, true); // need to unbutton to reload externally mounted MG
        }
    }
}

// New function to start or resume a reload, including playing any HUD overlay reload animation (this function avoids repeated functionality elsewhere)
simulated function StartReloading()
{
    local float ReloadSecondsElapsed, TotalReloadDuration;
    local int   i;

    // Make sure reload isn't set to paused & start a reload timer
    bReloadPaused = false;
    SetTimer(0.01, false);

    // If MG uses a HUD reload animation, play it
    if (WeaponPawn != none && WeaponPawn.HUDOverlay != none && WeaponPawn.HUDOverlay.HasAnim(HUDOverlayReloadAnim))
    {
        WeaponPawn.HUDOverlay.PlayAnim(HUDOverlayReloadAnim);

        // If we're resuming a paused reload, move the animation to where it left off (add up the previous stage durations)
        if (ReloadState > RL_Empty)
        {
            for (i = 0; i < ReloadStages.Length; ++i)
            {
                if (i < ReloadState)
                {
                    ReloadSecondsElapsed += ReloadStages[i].Duration;
                }

                TotalReloadDuration += ReloadStages[i].Duration;
            }

            if (ReloadSecondsElapsed > 0.0)
            {
                WeaponPawn.HUDOverlay.SetAnimFrame(ReloadSecondsElapsed / TotalReloadDuration);
            }
        }
    }
}

// New helper function to determine whether player is in a position where he can reload (just to shorten other functions & improve readability)
simulated function bool PlayerCanReload()
{
    return DHVehicleMGPawn(WeaponPawn) != none && DHVehicleMGPawn(WeaponPawn).CanReload();
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************  SETUP, UPDATE, CLEAN UP, MISCELLANEOUS  *******************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to add option to automatically match MG skin to vehicle skin, e.g. for gunshield, avoiding need for separate MG pawn & MG classes just for camo variants
// Also to give Vehicle an 'MGun' reference to this actor
simulated function InitializeVehicleBase()
{
    if (DHVehicle(Base) != none)
    {
        DHVehicle(Base).MGun = self;
    }

    if (bMatchSkinToVehicle)
    {
        Skins[0] = Base.Skins[0];
    }

    super.InitializeVehicleBase();
}

defaultproperties
{
    // Movement
    bInstantRotation=true
    RotationsPerSecond=0.25
    YawBone="mg_yaw"
    bLimitYaw=true
    PitchBone="mg_pitch"

    // Ammo & weapon fire
    bUsesMags=true
    DamageType=class'ROVehMountedMGDamType'
    Spread=0.002
    bUsesTracers=true
    WeaponFireAttachmentBone="mg_yaw"
    bDoOffsetTrace=true
    HudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    AIInfo(0)=(bFireOnRelease=true,AimError=750.0,RefireRate=0.99)

    // Firing effects
    AmbientEffectEmitterClass=class'ROVehicles.TankMGEmitter'
    bAmbientFireSound=true
    AmbientSoundScaling=3.0
    SoundVolume=255
    FireForce="minifireb"
    bIsRepeatingFF=true

    // Reload
    ReloadStages(0)=(Sound=sound'DH_Vehicle_Reloads.Reloads.MG34_ReloadHidden01',Duration=1.105) // default is MG34 reload sounds, as is used by most vehicles, even allies
    ReloadStages(1)=(Sound=sound'DH_Vehicle_Reloads.Reloads.MG34_ReloadHidden02',Duration=2.413)
    ReloadStages(2)=(Sound=sound'DH_Vehicle_Reloads.Reloads.MG34_ReloadHidden03',Duration=1.843)
    ReloadStages(3)=(Sound=sound'DH_Vehicle_Reloads.Reloads.MG34_ReloadHidden04',Duration=1.314)

    // Screen shake
    ShakeOffsetMag=(X=1.0,Y=1.0,Z=1.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=2.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=50.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=2.0
}

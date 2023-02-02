//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVehicleMG extends DHVehicleWeapon
    abstract;

var     bool    bMatchSkinToVehicle;  // option to automatically match MG skin zero to vehicle skin zero (e.g. for gunshield), avoiding need for separate MG pawn & MG classes
var     name    HUDOverlayReloadAnim; // reload animation to play if the MG uses a HUDOverlay

// Modified to incrementally resupply MG mags (only resupplies spare mags; doesn't reload the MG)
function bool ResupplyAmmo()
{
    if (Level.TimeSeconds > LastResupplyTimestamp + ResupplyInterval && NumMGMags < default.NumMGMags)
    {
        ++NumMGMags;

        // If MG is out of ammo & waiting to reload & we have a player, try to start a reload
        if (ReloadState == RL_Waiting && !HasAmmo(0) && WeaponPawn != none && WeaponPawn.Occupied())
        {
            AttemptReload();
        }
        LastResupplyTimestamp = Level.TimeSeconds;
        return true;
    }

    return false;
}

// Modified to give player a hint if he needs to unbutton to reload an externally mounted MG
simulated function AttemptReload()
{
    super.AttemptReload();

    if ((ReloadState == RL_Waiting || (bReloadPaused && ReloadState < RL_ReadyToFire)) && DHVehicleMGPawn(WeaponPawn) != none && WeaponPawn.IsLocallyControlled()
        && DHVehicleMGPawn(WeaponPawn).bMustUnbuttonToReload && !WeaponPawn.CanReload() && DHPlayer(WeaponPawn.Controller) != none)
    {
        DHPlayer(WeaponPawn.Controller).QueueHint(48, true);
    }
}

// Modified to play any HUD overlay reload animation, if necessary starting from the point where it was previously paused
simulated function StartReload(optional bool bResumingPausedReload)
{
    local float ReloadSecondsElapsed, TotalReloadDuration;
    local int   i;

    super.StartReload(bResumingPausedReload);

    // If weapon uses a HUD reload animation, play it
    if (WeaponPawn != none && WeaponPawn.HUDOverlay != none && WeaponPawn.HUDOverlay.HasAnim(HUDOverlayReloadAnim))
    {
        WeaponPawn.HUDOverlay.PlayAnim(HUDOverlayReloadAnim);

        // If we're resuming a paused reload that was part way through, move the animation to where it left off (add up previous stage durations)
        if (ReloadState > RL_ReloadingPart1)
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

// Modified to to stop any HUD reload animation
simulated function PauseReload()
{
    super.PauseReload();

    if (HUDOverlayReloadAnim != '' && WeaponPawn != none && WeaponPawn.HUDOverlay != none)
    {
        WeaponPawn.HUDOverlay.StopAnimating();
    }
}

// Modified to give net client player a hint if he needs to unbutton to start a new reload of an externally mounted MG
// Have to add this here as won't get this hint from AttemptReload() as client won't call that function if MG is waiting to start a reload
simulated function ClientSetReloadState(byte NewState)
{
    super.ClientSetReloadState(NewState);

    if (ReloadState == RL_Waiting && DHVehicleMGPawn(WeaponPawn) != none && DHVehicleMGPawn(WeaponPawn).bMustUnbuttonToReload
        && !WeaponPawn.CanReload() && DHPlayer(WeaponPawn.Controller) != none)
    {
        DHPlayer(WeaponPawn.Controller).QueueHint(48, true);
    }
}

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
    Spread=0.002
    bUsesTracers=true
    WeaponFireAttachmentBone="mg_yaw"
    bDoOffsetTrace=true
    HudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.mg42_ammo'
    AIInfo(0)=(bFireOnRelease=true,AimError=750.0,RefireRate=0.99)

    // Firing effects
    AmbientEffectEmitterClass=class'ROVehicles.TankMGEmitter'
    bAmbientFireSound=true
    AmbientSoundScaling=2.75
    FireForce="minifireb"
    bIsRepeatingFF=true

    // Reload (default is MG34 reload sounds as is used by most vehicles, even allies)
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.MG34_ReloadHidden01',Duration=1.105)
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.MG34_ReloadHidden02',Duration=2.413,HUDProportion=0.75)
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.MG34_ReloadHidden03',Duration=1.843,HUDProportion=0.5)
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.MG34_ReloadHidden04',Duration=1.314,HUDProportion=0.25)

    // Screen shake
    ShakeOffsetMag=(X=1.0,Y=1.0,Z=1.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=2.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=50.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=2.0
}

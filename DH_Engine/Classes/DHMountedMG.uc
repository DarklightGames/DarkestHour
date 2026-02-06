//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMountedMG extends DHVehicleWeapon
    abstract;

var DHWeaponRangeParams     RangeParams;
var int                     RangeIndex;

// Reload
var()   name                ReloadSequence;

// TODO: many of these systems should be componentized.

// Firing Animation
var int                     FiringChannel;
var name                    FiringBone;
var name                    FiringAnim;
var name                    FiringIdleAnim;

// Belt Animations
var int                     BeltChannel;
var name                    BeltBone;
var name                    BeltIdleAnimation;
var name                    BeltFireLoopAnimation;
var name                    BeltFireEndAnimation;

// Clip Animation
var name                    ClipBone;
var name                    ClipAnim;
var int                     ClipChannel;

// Shell Ejection
var()   class<RO3rdShellEject>  ShellEjectClass;
var()   name                    ShellEjectBone;
var()   Rotator                 ShellEjectRotationOffset;

// Ammo Round
var array<ROFPAmmoRound>    AmmoRounds;
var StaticMesh              AmmoRoundStaticMesh;
var array<name>             AmmoRoundBones;
var Rotator                 AmmoRoundRelativeRotation;

// Empty Ammo Rounds
// This is used for things like the Fiat 14/35 where the empty belt links stay attached to the rest of the belt.
var array<ROFPAmmoRound>    EmptyAmmoRounds;
var StaticMesh              EmptyAmmoRoundStaticMesh;
var array<name>             EmptyAmmoRoundBones;
var() Rotator               EmptyAmmoRoundRelativeRotation;

var int                     NumRoundsInStaticMesh; // The number of rounds depicted in the static mesh.

// Barrels (STATIC)
var int                             BarrelCount;
var class<DHWeaponBarrel>           BarrelClass;
var class<ROMGSteam>                BarrelSteamEmitterClass;
var name                            BarrelSteamBone;
var name                            BarrelChangeSequence;

// Barrels (RUNTIME)
var int                             BarrelIndex;
var ROMGSteam                       BarrelSteamEmitter;
var array<DHWeaponBarrel>           Barrels;
var DHWeaponBarrel.EBarrelCondition BarrelCondition;
var float                           BarrelTemperature;
var bool                            bBarrelIsSteamActive, bOldBarrelIsSteamActive;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        RangeIndex;
    unreliable if (bNetDirty && Role == ROLE_Authority)
        BarrelCondition, BarrelTemperature, bBarrelIsSteamActive;
}

private function SpawnBarrels()
{
    local int i;
    local DHWeaponBarrel Barrel;

    Barrels.Length = 0;

    for (i = 0; i < BarrelCount; ++i)
    {
        Barrel = Spawn(BarrelClass, self);
        Barrel.OnTemperatureChanged = OnBarrelTemperatureChanged;
        Barrel.OnConditionChanged = OnBarrelConditionChanged;
        Barrel.OnIsSteamActiveChanged = OnBarrelSteamIsActiveChanged;
        Barrels[i] = Barrel;
    }

    if (Barrels.Length > 0)
    {
        // Set the first barrel is being active.
        Barrels[0].SetCurrentBarrel(true);
    }
}

simulated function bool IsChangingBarrels();

function OnBarrelTemperatureChanged(DHWeaponBarrel Barrel, float Temperature)
{
    BarrelTemperature = Temperature;
}

function OnBarrelSteamIsActiveChanged(DHWeaponBarrel Barrel, bool bIsSteamActive)
{
    // Sets the variable here on the server. The client will then have this variable replicated to them.
    bBarrelIsSteamActive = bIsSteamActive;

    if (Level.NetMode == NM_Standalone)
    {
        // In a standalone game there is no PostNetReceive, so we must trigger the steam update immediately.
        SetBarrelSteamActive(bIsSteamActive);
    }
}

simulated function SetBarrelSteamActive(bool bIsSteamActive)
{
    if (Level.NetMode == NM_DedicatedServer)
    {
        return;
    }

    if (bIsSteamActive)
    {
        if (BarrelSteamEmitter == none)
        {
            BarrelSteamEmitter = Spawn(BarrelSteamEmitterClass, self);
            AttachToBone(BarrelSteamEmitter, BarrelSteamBone);
        }
    }

    if (BarrelSteamEmitter == none)
    {
        return;
    }

    if (bIsSteamActive)
    {
        BarrelSteamEmitter.StartSteam();
    }
    else
    {
        BarrelSteamEmitter.StopSteam();
    }
}

function OnBarrelConditionChanged(DHWeaponBarrel Barrel, DHWeaponBarrel.EBarrelCondition Condition)
{
    BarrelCondition = Condition;

    // If the barrel has failed, stop firing (this stops the sounds and effects).
    if (BarrelCondition == BC_Failed && WeaponPawn != none)
    {
        CeaseFire(WeaponPawn.Controller, false);
    }
}

simulated function PostNetReceive()
{
    super.PostNetReceive();

    if (bOldBarrelIsSteamActive != bBarrelIsSteamActive)
    {
        // TODO: turn on or off the steam emitter.
        SetBarrelSteamActive(bBarrelIsSteamActive);
    }
}

simulated function OnSwitchMesh()
{
    super.OnSwitchMesh();
    
    SetupAnimationDrivers();
    InitializeAmmoRounds();
    UpdateClip();
    UpdateRangeDriverFrameTarget(true);
}

simulated function DestroyAmmoRounds()
{
    local int i;

    for (i = 0; i < AmmoRounds.Length; i++)
    {
        if (AmmoRounds[i] != none)
        {
            AmmoRounds[i].Destroy();
        }
    }

    AmmoRounds.Length = 0;

    for (i = 0; i < EmptyAmmoRounds.Length; i++)
    {
        if (EmptyAmmoRounds[i] != none)
        {
            EmptyAmmoRounds[i].Destroy();
        }
    }

    EmptyAmmoRounds.Length = 0;
}

simulated function InitializeAmmoRounds()
{
    local int i;

    DestroyAmmoRounds();

    for (i = 0; i < AmmoRoundBones.Length; i++)
    {
        AmmoRounds[i] = Spawn(Class'ROFPAmmoRound', self);

        if (AmmoRounds[i] == none)
        {
            continue;
        }

        AmmoRounds[i].bOwnerNoSee = false;

        AttachToBone(AmmoRounds[i], AmmoRoundBones[i]);
        AmmoRounds[i].SetStaticMesh(AmmoRoundStaticMesh);
        AmmoRounds[i].SetRelativeRotation(AmmoRoundRelativeRotation);
    }

    for (i = 0; i < EmptyAmmoRoundBones.Length; i++)
    {
        EmptyAmmoRounds[i] = Spawn(Class'ROFPAmmoRound', self);

        if (EmptyAmmoRounds[i] == none)
        {
            continue;
        }

        EmptyAmmoRounds[i].bOwnerNoSee = false;

        AttachToBone(EmptyAmmoRounds[i], EmptyAmmoRoundBones[i]);

        EmptyAmmoRounds[i].SetStaticMesh(EmptyAmmoRoundStaticMesh);
        EmptyAmmoRounds[i].SetRelativeRotation(EmptyAmmoRoundRelativeRotation);
    }
}

// TODO: would be neat to display the barrel damage on the HUD!
event bool AttemptFire(Controller C, bool bAltFire)
{
    if (BarrelCondition == BC_Failed)
    {
        // Do not allow fire if the barrel has failed.
        return false;
    }

    super.AttemptFire(C, bAltFire);
}

function Fire(Controller C)
{
    local DHMountedMGPawn MGP;
    local Coords ShellEjectCoords;
    local Actor ShellEjectActor;

    super.Fire(C);
    
    StartFiringAnimation();

    // TODO: make sure this will work in multiplayer; only have this run on the client. server doesn't care.
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (ShellEjectClass != none && ShellEjectBone != '')
        {
            ShellEjectCoords = GetBoneCoords(ShellEjectBone);

            ShellEjectActor = Spawn(ShellEjectClass, self,, ShellEjectCoords.Origin, GetBoneRotation(ShellEjectBone));
            ShellEjectActor.SetRotation(ShellEjectActor.Rotation + ShellEjectRotationOffset);

            // The class defines bOwnerNoSee as true since this is meant only for third person, but we want to just
            // reuse the same class for first person as well.
            ShellEjectActor.bOwnerNoSee = false;
        }
    }

    if (Role == ROLE_Authority)
    {
        if (BarrelIndex >= 0 && BarrelIndex < Barrels.Length)
        {
            Barrels[BarrelIndex].WeaponFired();
        }
    }
    
    UpdateClip();

    MGP = DHMountedMGPawn(WeaponPawn);

    if (MGP != none)
    {
        MGP.OnFire();
    }
}

function StartFiringAnimation()
{
    if (FiringChannel != 0 && HasAnim(FiringAnim))
    {
        LoopAnim(FiringAnim, 1.0, 0.0, FiringChannel);
    }

    if (BeltChannel != 0 && HasAnim(BeltFireLoopAnimation))
    {
        LoopAnim(BeltFireLoopAnimation, 1.0, 0.0, BeltChannel);
    }
}

function StopFiringAnimation()
{
    if (FiringChannel != 0 && HasAnim(FiringIdleAnim))
    {
        PlayAnim(FiringIdleAnim, 1.0, 0.0, FiringChannel);
    }

    if (BeltChannel != 0 && HasAnim(BeltIdleAnimation))
    {
        PlayAnim(BeltIdleAnimation, 1.0, 0.125, BeltChannel);
    }
}

function CeaseFire(Controller C, Bool bWasAltFire)
{
    super.CeaseFire(C, bWasAltFire);

    StopFiringAnimation();
}

simulated function bool IsBusy()
{
    return false;
}

simulated state Busy
{
    // Don't allow the player to change the range while busy.
    simulated function DecrementRange() {}
    simulated function IncrementRange() {}

    simulated function bool IsBusy()
    {
        return true;
    }

    event bool AttemptFire(Controller C, bool bAltFire)
    {
        return false;
    }
}

simulated state Reloading extends Busy
{    
    simulated function BeginState()
    {
        local DHMountedMGPawn MGPawn;

        MGPawn = DHMountedMGPawn(WeaponPawn);

        // Disable the clip driver.
        if (ClipChannel != 0)
        {
            AnimBlendParams(ClipChannel, 0.0,,, ClipBone);
        }

        // Disable the firing driver (since this controls the bolt and we animate the bolt in the reload animation).
        if (FiringChannel != 0)
        {
            AnimBlendParams(FiringChannel, 0.0,,, FiringBone);
        }

        PlayAnim(ReloadSequence, 1.0, 0.0, 0.0);

        // Zoom out.
        if (MGPawn != none)
        {
            MGPawn.PlayReloadAnim(GetAnimDuration(ReloadSequence));
            MGPawn.SetIsZoomed(false);
        }
    }

    simulated function EndState()
    {
        // Enable the clip driver.
        if (ClipChannel != 0)
        {
            AnimBlendParams(ClipChannel, 1.0,,, ClipBone);

            // Force the clip into the "full" position.
            FreezeAnimAt(0.0, ClipChannel);
        }

        // Enable the firing driver.
        if (FiringChannel != 0)
        {
            AnimBlendParams(FiringChannel, 1.0,,, FiringBone);
        }
    }

    simulated function Tick(float DeltaTime)
    {
        super.Tick(DeltaTime);

        // TODO: for animation purposes we probably want to center the gun quickly as the reload starts.
        // how to do this?
    }

Begin:
    //Sleep(GetAnimDuration(ReloadSequence));
    Sleep(5.0); // For now, just a fixed time until we have proper reload animations.
    GotoState('');
}

// Returns the index of the next best barrel to switch to, sorting first by condition and then by temperature.
// Returns -1 if there are no barrels that can be changed to.
private simulated function int GetNextBestBarrelIndex()
{
    local int i;
    local UComparator Comparator;
    local array<DHWeaponBarrel> SortedBarrels;

    // Copy the barrels to a new list to be sorted.
    SortedBarrels = Barrels;

    // Remove the current barrel and any failed barrels from the list to be sorted.
    SortedBarrels.Remove(BarrelIndex, 1);

    for (i = SortedBarrels.Length - 1; i >= 0; --i)
    {
        if (SortedBarrels[i].Condition == BC_Failed)
        {
            SortedBarrels.Remove(i, 1);
        }
    }

    if (SortedBarrels.Length == 0)
    {
        return -1;
    }

    // Sort in order of condition and temperature.
    Comparator = new Class'UComparator';
    Comparator.CompareFunction = Class'DHWeaponBarrel'.static.SortFunction;
    Class'USort'.static.Sort(SortedBarrels, Comparator);
    return Class'UArray'.static.IndexOf(Barrels, SortedBarrels[0]);
}

simulated function bool CanChangeBarrels()
{
    if (IsBusy() || GetNextBestBarrelIndex() == -1)
    {
        return false;
    }

    return true;
}

// Attempt to change barrels. Returns true if the gun is now in the changing barrel state.
simulated function bool TryChangeBarrels()
{
    if (!CanChangeBarrels())
    {
        return false;
    }

    // TODO: handle different paths for client and server.
    GotoState('ChangingBarrels');

    return true;
}

simulated state ChangingBarrels extends Busy
{
    simulated function BeginState()
    {
        local int NextBarrelIndex;
        local DHMountedMGPawn MGPawn;

        super.BeginState();

        if (BarrelChangeSequence != '')
        {
            PlayAnim(BarrelChangeSequence, 1.0, 0.0, 0.0);
        }

        NextBarrelIndex = GetNextBestBarrelIndex();

        if (NextBarrelIndex == -1)
        {
            // Avoid out-of-bounds errors in case the function above returns -1 somehow.
            return;
        }

        Level.Game.Broadcast(self, "Changing barrels from barrel" @ BarrelIndex @ "to barrel" @ NextBarrelIndex);

        Barrels[BarrelIndex].SetCurrentBarrel(false);
        Barrels[NextBarrelIndex].SetCurrentBarrel(true);

        // TODO: some sort of mechanism to only do the actual swap mid-animation (a notify on the animation, perhaps?)
        BarrelIndex = NextBarrelIndex;

        MGPawn = DHMountedMGPawn(WeaponPawn);

        if (MGPawn != none)
        {
            MGPawn.PlayerBarrelChangeAnim(GetAnimDuration(BarrelChangeSequence));
            // Zoom out.
            MGPawn.SetIsZoomed(false);
        }
    }

    simulated function EndState()
    {
        Level.Game.Broadcast(self, "Barrel changed");
    }

    simulated function bool IsChangingBarrels()
    {
        return true;
    }

Begin:
    Sleep(GetAnimDuration(BarrelChangeSequence));
    GotoState('');
}

simulated function Tick(float DeltaTime)
{
    // Update the range driver if the pawn is locally controlled.
    if (RangeParams != none && WeaponPawn != none && WeaponPawn.IsLocallyControlled())
    {
        if (RangeParams.GetAnimFrameTarget() != RangeParams.GetAnimFrame())
        {
            RangeParams.Tick(Level.TimeSeconds);

            UpdateRangeDriver();
        }
    }
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    PlayAnim('IDLE');

    SetupAnimationDrivers();

    if (Role == ROLE_Authority)
    {
        SpawnBarrels();
    }
}

simulated function SetupAnimationDrivers()
{
    if (FiringChannel != 0)
    {
        AnimBlendParams(FiringChannel, 1.0,,, FiringBone);
        PlayAnim(FiringIdleAnim, 0.0, 0.0, FiringChannel);
    }

    if (RangeParams != none)
    {
        AnimBlendParams(RangeParams.Channel, 1.0,,, RangeParams.Bone);
        PlayAnim(RangeParams.Anim, 0.0, 0.0, RangeParams.Channel);
        UpdateRangeDriverFrameTarget(true);
        UpdateRangeDriver();
    }

    if (ClipChannel != 0)
    {
        AnimBlendParams(ClipChannel, 1.0,,, ClipBone);
        PlayAnim(ClipAnim, 0.0, 0.0, ClipChannel);
        UpdateClipDriver(MainAmmoCharge[0]);
    }

    if (BeltChannel != 0)
    {
        AnimBlendParams(BeltChannel, 1.0,,, BeltBone);
        PlayAnim(BeltIdleAnimation, 0.0, 0.0, BeltChannel);
    }

    super.SetupAnimationDrivers();
}

simulated function UpdateRangeDriver()
{
    if (RangeParams != none)
    {
        FreezeAnimAt(RangeParams.GetAnimFrame(), RangeParams.Channel);
    }
}

simulated function UpdateAmmoRounds(int Ammo)
{
    local int i;
    local int VisibleCount, ExpendedCount;

    VisibleCount = Ceil(float(Ammo) / NumRoundsInStaticMesh);

    for (i = AmmoRounds.Length - 1; i >= 0; --i)
    {
        if (AmmoRounds[i] != none)
        {
            AmmoRounds[i].bHidden = i >= VisibleCount;
        }
    }

    ExpendedCount = InitialPrimaryAmmo - Ammo;

    for (i = 0; i < EmptyAmmoRounds.Length; i++)
    {
        if (EmptyAmmoRounds[i] != none)
        {
            EmptyAmmoRounds[i].bHidden = i >= ExpendedCount;
        }
    }
}

simulated function UpdateClipWithAmmo(int Ammo)
{
    UpdateAmmoRounds(Ammo);
    UpdateClipDriver(Ammo);
}

simulated function UpdateClip()
{
    UpdateClipWithAmmo(MainAmmoCharge[0]);
}

simulated function UpdateClipDriver(int Ammo)
{
    const CLIP_PER_MAG = 10;
    const CLIP_DRIVER_FRAMES = 11;

    local float ClipFrame;
    local int ClipsVisible;

    if (ClipChannel == 0)
    {
        return;
    }

    ClipsVisible = Ceil(float(Ammo) / NumRoundsInStaticMesh);
    ClipFrame = CLIP_DRIVER_FRAMES - (ClipsVisible + 1);

    FreezeAnimAt(ClipFrame, ClipChannel);
}

simulated private function SendRangeMessage()
{
    if (WeaponPawn == none || !WeaponPawn.IsLocallyControlled())
    {
        return;
    }

    // Send a message to the player's HUD.
    WeaponPawn.ReceiveLocalizedMessage(Class'DHWeaponRangeMessage', Class'UInteger'.static.FromShorts(RangeParams.RangeTable[RangeIndex].Range, int(RangeParams.DistanceUnit)));
}

simulated function RangeIndexChanged()
{
    UpdateRangeDriverFrameTarget();
}

simulated function UpdateRangeDriverFrameTarget(optional bool bNoInterpolation)
{
    if (RangeParams != none)
    {
        RangeParams.SetRangeDriverFrameTarget(Level.TimeSeconds, RangeIndex, bNoInterpolation);
    }
}

simulated function DecrementRange()
{
    super.DecrementRange();

    if (RangeIndex > 0)
    {
        RangeIndex--;
        RangeIndexChanged();
    }

    SendRangeMessage();
}

simulated function IncrementRange()
{
    super.IncrementRange();

    if (RangeParams != none)
    {
        if (RangeIndex < RangeParams.RangeTable.Length - 1)
        {
            RangeIndex++;
            RangeIndexChanged();
        }

        SendRangeMessage();
    }
}

simulated function StartReload(optional bool bResumingPausedReload)
{
    super.StartReload(bResumingPausedReload);

    // TODO: only do this if we're locally controlled.
    GotoState('Reloading');
}

// Called from animation when the clip goes out of view.
simulated event ClipFill()
{
    UpdateClipWithAmmo(InitialPrimaryAmmo);
}

simulated function float GetFireSoundPitch()
{
    if (BarrelClass != none)
    {
        return BarrelClass.static.GetFiringSoundPitch(BarrelTemperature);
    }

    return super.GetFireSoundPitch();
}

simulated function InitializeVehicleBase()
{
    super.InitializeVehicleBase();

    if (DHVehicle(Base) != none)
    {
        DHVehicle(Base).MountedMG = self;
    }
}

// Modified to handle resupply MG ammunition.
function bool ResupplyAmmo()
{
    local bool bDidResupply;

    if (NumMGMags < default.NumMGMags)
    {
        ++NumMGMags;
        bDidResupply = true;
    }

    // TODO: not sure if this works; double check it.
    // If weapon is waiting to reload & we have a player who doesn't use manual reloading (so must be out of ammo), then try to start a reload
    if (ReloadState == RL_Waiting && WeaponPawn != none && WeaponPawn.Occupied() && !PlayerUsesManualReloading() && bDidResupply)
    {
        AttemptReload();
    }
    
    return bDidResupply;
}

defaultproperties
{
    ReloadCameraTweenTime=0.5

    YawBone="MG_YAW"
    PitchBone="MG_PITCH"

    bLimitYaw=true
    MaxNegativeYaw=-2184    // -12 degrees
    MaxPositiveYaw=2184     // +12 degrees
    CustomPitchUpLimit=3640     // +20 degrees
    CustomPitchDownLimit=61895  // -20 degrees

    // Ammo
    FireInterval=0.1    // 600rpm
    Spread=0.002
    TracerFrequency=7

    // Weapon fire
    FireSoundClass=SoundGroup'DH_MN_InfantryWeapons_sound.Breda38FireLoop'
    FireEndSound=SoundGroup'DH_MN_InfantryWeapons_sound.Breda38FireLoopEnd'

    FiringAnim="BOLT_FIRING"
    FiringIdleAnim="BOLT_IDLE"
    FiringChannel=2
    FiringBone="FIRING_ROOT"

    ShellEjectBone="EJECTOR"
    ShellEjectClass=Class'RO3rdShellEject762x54mm'
    ShellEjectRotationOffset=(Pitch=-16384,Yaw=16384)

    // Regular MGs do not have collision on because it's assumed that they're a small part
    // mounted on a larger vehicle. In this case, we want to have collision on because it's
    // a standalone weapon.
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockNonZeroExtentTraces=true
    bBlockZeroExtentTraces=true

    NumRoundsInStaticMesh=1

    // BELOW COPIED STRAIGHT FROM VEHICLEMG, DELETE WHATEVER IS NOT NECESSARY!

    // Movement
    bInstantRotation=true
    RotationsPerSecond=0.125

    // Ammo & weapon fire
    bUsesMags=true
    bUsesTracers=true
    WeaponFireAttachmentBone="MUZZLE"
    bDoOffsetTrace=true
    HudAltAmmoIcon=Texture'InterfaceArt_tex.mg42_ammo'

    // Firing effects
    AmbientEffectEmitterClass=Class'TankMGEmitter'
    bAmbientFireSound=true
    AmbientSoundScaling=2.75

    // Reload (default is MG34 reload sounds as is used by most vehicles, even allies)
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.MG34_ReloadHidden01',Duration=1.105)
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.MG34_ReloadHidden02',Duration=2.413,HUDProportion=0.75)
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.MG34_ReloadHidden03',Duration=1.843,HUDProportion=0.5)
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.MG34_ReloadHidden04',Duration=1.314,HUDProportion=0.25)

    // Screen shake
    ShakeOffsetMag=(X=0.125,Y=0.125,Z=0.125)
    ShakeOffsetRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeOffsetTime=4.0
    ShakeRotMag=(X=16.0,Y=16.0,Z=16.0)
    ShakeRotRate=(X=50000.0,Y=50000.0,Z=50000.0)
    ShakeRotTime=4.0

    ProjectileRotationMode=PRM_MuzzleBone

    BarrelSteamEmitterClass=Class'DHMGSteam'
    BarrelSteamBone="MUZZLE"
}

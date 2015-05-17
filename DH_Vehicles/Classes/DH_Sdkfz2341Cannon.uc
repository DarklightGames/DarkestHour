//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Sdkfz2341Cannon extends DHTankCannon;

var     byte    NumMags;         // using bytes for more efficient replication
var     byte    NumSecMags;
var     byte    NumTertMags;
var     bool    bMixedMagFireAP; // flags that a mixed AP/HE mag is due to fire an AP round

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        NumMags, NumSecMags, NumTertMags;
}

// Modified as this is an auto-cannon firing from a magazine
event bool AttemptFire(Controller C, bool bAltFire)
{
    local int   FireMode;
    local float ProjectileSpread;

    // Check that cannon/coaxial MG is ready to fire & that we're an authority role (234/1 adds FireCountdown check on cannon fire, not just alt fire)
    if (FireCountdown <= 0.0 && ((CannonReloadState == CR_ReadyToFire && bClientCanFireCannon) || bAltFire) && Role == ROLE_Authority)
    {
        // Calculate the starting WeaponFireRotation
        CalcWeaponFire(bAltFire);

        if (bCorrectAim)
        {
            WeaponFireRotation = AdjustAim(bAltFire);
        }

        // Calculate any random spread & record the FireMode to simplify things later
        if (bAltFire)
        {
            ProjectileSpread = AltFireSpread;
        }
        else
        {
            if (Spread > 0.0)
            {
                ProjectileSpread = Spread; // a starting point for spread, using any primary round spread
            }

            if (ProjectileClass == PrimaryProjectileClass || !bMultipleRoundTypes)
            {
                FireMode = 0;
            }
            else if (ProjectileClass == SecondaryProjectileClass)
            {
                FireMode = 1;

                if (bUsesSecondarySpread && SecondarySpread > 0.0)
                {
                    ProjectileSpread = SecondarySpread;
                }
            }
            else if (ProjectileClass == TertiaryProjectileClass)
            {
                FireMode = 2;

                if (bUsesTertiarySpread && TertiarySpread > 0.0)
                {
                    ProjectileSpread = TertiarySpread;
                }
            }

            // Now apply any random spread
            if (ProjectileSpread > 0.0)
            {
                WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand() * FRand() * ProjectileSpread);

                if (!bAltFire)
                {
                    WeaponFireRotation += rot(1, 6, 0);
                }
            }
        }

        Instigator.MakeNoise(1.0);

        // Coaxial MG fire - check we have ammo & fire the MG
        if (bAltFire)
        {
            // If MG is empty we can't fire - start a reload
            if (!ConsumeAmmo(3))
            {
                CannonPawn.ClientVehicleCeaseFire(bAltFire);
                HandleReload();

                return false;
            }

            // Fire
            AltFire(C);
            FireCountdown = AltFireInterval;

            // If we just fired our last MG round, start an MG reload
            if (!HasAmmo(3))
            {
                HandleReload();
            }
        }
        // Cannon fire - check we have ammo & fire the current round
        else
        {
            // If cannon is empty we can't fire
            if (!ConsumeAmmo(FireMode))
            {
                CannonPawn.ClientVehicleCeaseFire(bAltFire);
                HandleCannonReload(); // added to 234/1

                return false;
            }

            // Fire
            Fire(C);
//          bClientCanFireCannon = false; // removed from 234/1
            FireCountdown = FireInterval; // added to 234/1

            // If cannon is now empty, after firing our last round, start a magazine reload (this replaces setting reload state & timer & possible round type switch)
            if (!HasAmmo(FireMode))
            {
                HandleCannonReload();
            }
        }

        AimLockReleaseTime = Level.TimeSeconds + FireCountdown * FireIntervalAimLock; // moved back down here in 234/1, as potentially relevant to cannon & MG as both use FireCountdown

        return true;
    }

    return false;
}

// Modified to alternate between AP & HE rounds if firing a mixed mag (the tertiary ammo type)
state ProjectileFireMode
{
    function Fire(Controller C)
    {
        if (ProjectileClass == PrimaryProjectileClass)
        {
            if (bMixedMagFireAP)
            {
                SpawnProjectile(SecondaryProjectileClass, false);
            }
            else
            {
                SpawnProjectile(TertiaryProjectileClass, false);
            }

            bMixedMagFireAP = !bMixedMagFireAP;
        }
        else
        {
            SpawnProjectile(ProjectileClass, false);
        }
    }
}

// Modified to remove switch to PendingProjectileClass after firing, as this cannon uses a magazine
function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile P;
    local vector     StartLocation, HitLocation, HitNormal, Extent;
    local rotator    FireRot;

    // Calculate projectile's starting rotation
    FireRot = WeaponFireRotation;

    if (Instigator != none && Instigator.IsHumanControlled())
    {
        FireRot.Pitch += AddedPitch; // used only for human players - lets cannons with non-centered aim points have a different aiming location
    }

    if (!bAltFire && RangeSettings.Length > 0)
    {
        FireRot.Pitch += ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
    }

    if (bCannonShellDebugging && RangeSettings.Length > 0)
    {
        Log("GetPitchForRange for" @ CurrentRangeIndex @ " = " @ ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]));
    }

    // Calculate projectile's starting location - bDoOffsetTrace means we trace from outside vehicle's collision back towards weapon to determine firing offset
    if (bDoOffsetTrace)
    {
        Extent = ProjClass.default.CollisionRadius * vect(1.0, 1.0, 0.0);
        Extent.Z = ProjClass.default.CollisionHeight;

        if (CannonPawn != none && CannonPawn.VehicleBase != none)
        {
            if (!CannonPawn.VehicleBase.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation,
                WeaponFireLocation + vector(WeaponFireRotation) * (CannonPawn.VehicleBase.CollisionRadius * 1.5), Extent))
            {
                StartLocation = HitLocation;
            }
            else
            {
                StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
            }
        }
        else
        {
            if (!Owner.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, WeaponFireLocation + vector(WeaponFireRotation) * (Owner.CollisionRadius * 1.5), Extent))
            {
                StartLocation = HitLocation;
            }
            else
            {
                StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
            }
        }
    }
    else
    {
        StartLocation = WeaponFireLocation;
    }

    if (bCannonShellDebugging)
    {
        Trace(TraceHitLocation, HitNormal, WeaponFireLocation + 65355.0 * vector(WeaponFireRotation), WeaponFireLocation, false);
    }

    // Now spawn the projectile
    P = Spawn(ProjClass, none,, StartLocation, FireRot);

    // If pending round type is different, switch round type // note this 'if' is removed & is the only change in this override
//  if (PendingProjectileClass != none && ProjClass == ProjectileClass && ProjectileClass != PendingProjectileClass && !bCanisterIsFiring)
//  {
//      ProjectileClass = PendingProjectileClass;
//  }

    if (P != none)
    {
        if (bInheritVelocity)
        {
            P.Velocity = Instigator.Velocity;
        }

        // Play firing effects (unless it's canister in the process of spawning separate projectiles - only do it once at the end)
        if (!bCanisterIsFiring)
        {
            FlashMuzzleFlash(bAltFire);

            if (bAltFire)
            {
                if (bAmbientAltFireSound)
                {
                    AmbientSound = AltFireSoundClass;
                    SoundVolume = AltFireSoundVolume;
                    SoundRadius = AltFireSoundRadius;
                    AmbientSoundScaling = AltFireSoundScaling;
                }
                else
                {
                    PlayOwnedSound(AltFireSoundClass, SLOT_None, FireSoundVolume / 255.0,, AltFireSoundRadius,, false);
                }
            }
            else
            {
                if (bAmbientFireSound)
                {
                    AmbientSound = FireSoundClass;
                }
                else
                {
                    PlayOwnedSound(CannonFireSound[Rand(3)], SLOT_None, FireSoundVolume / 255.0,, FireSoundRadius,, false);
                }
            }
        }
    }

    return P;
}

// Modified to add FireCountDown check to cannon fire mode, not just alt fire
simulated function ClientStartFire(Controller C, bool bAltFire)
{
    bIsAltFire = bAltFire;

    if (FireCountDown <= 0.0 && ((CannonReloadState == CR_ReadyToFire && bClientCanFireCannon) || bIsAltFire))
    {
        if (bIsRepeatingFF)
        {
            if (bIsAltFire)
            {
                ClientPlayForceFeedback(AltFireForce);
            }
            else
            {
                ClientPlayForceFeedback(FireForce);
            }
        }

        OwnerEffects();
    }
}

// Modified to reinstate use of FireCountDown for cannon as well as coaxial MG, & to prevent reload after each individual shot
simulated event OwnerEffects()
{
    // Stop the firing effects it we shouldn't be able to fire
    if (Role < ROLE_Authority && !ReadyToFire(bIsAltFire))
    {
        VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bIsAltFire);

        return;
    }

    if (!bIsRepeatingFF)
    {
        if (bIsAltFire)
        {
            ClientPlayForceFeedback(AltFireForce);
        }
        else
        {
            ClientPlayForceFeedback(FireForce);
        }
    }

    ShakeView(bIsAltFire);

    if (bIsAltFire && Level.NetMode == NM_Standalone && AmbientEffectEmitter != none)
    {
        AmbientEffectEmitter.SetEmitterStatus(true);
    }

    if (Role < ROLE_Authority)
    {
        if (bIsAltFire)
        {
            FireCountdown = AltFireInterval;
        }
        else // adds back this 'else' (commented out in Super), as we use FireCountDown for auto fire interval
        {
            FireCountdown = FireInterval;
        }

//      if (!bIsAltFire) // note this 'if' is removed in 234/1
//      {
//          if (Instigator != none && ROPlayer(Instigator.Controller) != none && ROPlayer(Instigator.Controller).bManualTankShellReloading)
//          {
//              CannonReloadState = CR_Waiting;
//          }
//          else
//          {
//              CannonReloadState = CR_Empty;
//              SetTimer(0.01, false);
//          }
//
//          bClientCanFireCannon = false;
//      }

        AimLockReleaseTime = Level.TimeSeconds + FireCountdown * FireIntervalAimLock;

        FlashMuzzleFlash(bIsAltFire);

        if (bIsAltFire)
        {
            if (AmbientEffectEmitter != none) // moved under this 'if' to optimise
            {
                AmbientEffectEmitter.SetEmitterStatus(true);
            }

            if (!bAmbientAltFireSound)
            {
                PlaySound(AltFireSoundClass, SLOT_None, FireSoundVolume / 255.0,, AltFireSoundRadius,, false);
            }
            else
            {
                SoundVolume = AltFireSoundVolume;
                SoundRadius = AltFireSoundRadius;
                AmbientSoundScaling = AltFireSoundScaling;
            }
        }
        else if (!bAmbientFireSound)
        {
            PlaySound(CannonFireSound[Rand(3)], SLOT_None, FireSoundVolume / 255.0,, FireSoundRadius,, false);
        }
    }
}

// Modified to handle our modified reload process for players who manually reload
function ServerManualReload()
{
    if (CannonReloadState == CR_Waiting)
    {
        HandleCannonReload(true); // true flags that this is a manually-triggered reload
    }
}

// New function that handles all 3 round types, trying all the alternatives if we're out of some types of ammo
function HandleCannonReload(optional bool bIsManualReload)
{
    if (Role != ROLE_Authority)
    {
        return;
    }

    bClientCanFireCannon = false;

    // If player uses manual reloading & this isn't a manually-triggered reload, then just go to reload state waiting
    if (!bIsManualReload && Instigator != none && ROPlayer(Instigator.Controller) != none && ROPlayer(Instigator.Controller).bManualTankShellReloading)
    {
        CannonReloadState = CR_Waiting;
        ClientSetReloadState(CannonReloadState); // primarily so client's HUD can display ammo icon in red to show it needs a reload
    }
    // Otherwise check ammo & proceed with reload if we have some
    else if (CannonReloadState == CR_ReadyToFire || CannonReloadState == CR_Waiting)
    {
        // If we don't have a spare mag for the pending round type, try to switch to another round type (unless player reloads & switches manually)
        if (!HasMagazines(GetPendingRoundIndex()))
        {
            if (!bIsManualReload)
            {
                ToggleRoundType();
            }

            // Abort reload if we still don't have a spare mag (so must be completely out of cannon ammo) or if player reloads/switches manually
            if (bIsManualReload || !HasMagazines(GetPendingRoundIndex()))
            {
                CannonReloadState = CR_Waiting;
                ClientSetReloadState(CannonReloadState);

                return;
            }
        }

        // Switch round type if pending round is different
        if (ProjectileClass != PendingProjectileClass && PendingProjectileClass != none)
        {
            ProjectileClass = PendingProjectileClass;
        }

        // Remove 1 spare mag & also 're-charge' the cannon (seems premature but it's easier to do it here & cannon won't be able to fire until reload completes)
        if (ProjectileClass == PrimaryProjectileClass)
        {
            NumMags--;
            MainAmmoChargeExtra[0] = InitialPrimaryAmmo;
            bMixedMagFireAP = default.bMixedMagFireAP;
        }
        else if (ProjectileClass == SecondaryProjectileClass)
        {
            NumSecMags--;
            MainAmmoChargeExtra[1] = InitialSecondaryAmmo;
        }
        else if (ProjectileClass == TertiaryProjectileClass)
        {
            NumTertMags--;
            MainAmmoChargeExtra[2] = InitialTertiaryAmmo;
        }

        // Start reload on both client & server
        NetUpdateTime = Level.TimeSeconds - 1.0;
        CannonReloadState = CR_Empty;
        ClientSetReloadState(CannonReloadState);
        SetTimer(0.01, false);
    }
}

// Modified to remove requirement for PrimaryAmmoCount > 0, which for autocannon means has at least 1 magazines, as last mag may just have been used to start this reload
simulated function Timer()
{
    // Do not proceed with reload if no player in cannon position - set a repeating timer to keep checking
    if (CannonPawn == none || CannonPawn.Controller == none)
    {
        SetTimer(0.5, true);
    }
    else if (CannonReloadState == CR_Empty)
    {
        PlayOwnedSound(ReloadSoundOne, SLOT_Misc, FireSoundVolume / 255.0,, 150.0,, false);
        CannonReloadState = CR_ReloadedPart1;
        SetTimer(GetSoundDuration(ReloadSoundOne), false);
    }
    else if (CannonReloadState == CR_ReloadedPart1)
    {
        PlayOwnedSound(ReloadSoundTwo, SLOT_Misc, FireSoundVolume / 255.0,, 150.0,, false);
        CannonReloadState = CR_ReloadedPart2;
        SetTimer(GetSoundDuration(ReloadSoundTwo), false);
    }
    else if (CannonReloadState == CR_ReloadedPart2)
    {
        PlayOwnedSound(ReloadSoundThree, SLOT_Misc, FireSoundVolume / 255.0,, 150.0,, false);
        CannonReloadState = CR_ReloadedPart3;
        SetTimer(GetSoundDuration(ReloadSoundThree), false);
    }
    else if (CannonReloadState == CR_ReloadedPart3)
    {
        PlayOwnedSound(ReloadSoundFour, SLOT_Misc, FireSoundVolume / 255.0,, 150.0,, false);
        CannonReloadState = CR_ReloadedPart4;
        SetTimer(GetSoundDuration(ReloadSoundFour), false);
    }
    else if (CannonReloadState == CR_ReloadedPart4)
    {
        if (Role == ROLE_Authority)
        {
            bClientCanFireCannon = true;
        }

        CannonReloadState = CR_ReadyToFire;
        SetTimer(0.0, false);
    }
}

// Modified as this cannon uses magazines
function ToggleRoundType()
{
    if (PendingProjectileClass == PrimaryProjectileClass)
    {
        if (HasMagazines(1))
        {
            PendingProjectileClass = SecondaryProjectileClass;
        }
        else if (HasMagazines(2))
        {
            PendingProjectileClass = TertiaryProjectileClass;
        }
    }
    else if (PendingProjectileClass == SecondaryProjectileClass)
    {
        if (HasMagazines(2))
        {
            PendingProjectileClass = TertiaryProjectileClass;
        }
        else if (HasMagazines(0))
        {
            PendingProjectileClass = PrimaryProjectileClass;
        }
    }
    else if (PendingProjectileClass == TertiaryProjectileClass)
    {
        if (HasMagazines(0))
        {
            PendingProjectileClass = PrimaryProjectileClass;
        }
        else if (HasMagazines(1))
        {
            PendingProjectileClass = SecondaryProjectileClass;
        }
    }
    else
    {
        if (HasMagazines(0))
        {
            PendingProjectileClass = PrimaryProjectileClass;
        }
        else if (HasMagazines(1))
        {
            PendingProjectileClass = SecondaryProjectileClass;
        }
        else if (HasMagazines(2))
        {
            PendingProjectileClass = TertiaryProjectileClass;
        }
    }
}

// New function to return whether we have any magazines for the given firing mode
simulated function bool HasMagazines(int Mode)
{
    switch (Mode)
    {
        case 0:
            return NumMags > 0;
        case 1:
            return NumSecMags > 0;
        case 2:
            return NumTertMags > 0;
        default:
            return false;
    }
}

// Modified as this cannon uses magazines
simulated function int PrimaryAmmoCount()
{
    if (ProjectileClass == PrimaryProjectileClass || !bMultipleRoundTypes)
    {
        return NumMags;
    }
    else if (ProjectileClass == SecondaryProjectileClass)
    {
        return NumSecMags;
    }
    else if (ProjectileClass == TertiaryProjectileClass)
    {
        return NumTertMags;
    }
}

// Modified as this cannon uses magazines
function bool GiveInitialAmmo()
{
    if (MainAmmoChargeExtra[0] != InitialPrimaryAmmo || MainAmmoChargeExtra[1] != InitialSecondaryAmmo || MainAmmoChargeExtra[2] != InitialTertiaryAmmo ||
        AltAmmoCharge != InitialAltAmmo || NumMags != default.NumMags || NumSecMags != default.NumSecMags || NumTertMags != default.NumTertMags || NumAltMags != default.NumAltMags)
    {
        MainAmmoChargeExtra[0] = InitialPrimaryAmmo;
        bMixedMagFireAP = default.bMixedMagFireAP;
        MainAmmoChargeExtra[1] = InitialSecondaryAmmo;
        MainAmmoChargeExtra[2] = InitialTertiaryAmmo;
        AltAmmoCharge = InitialAltAmmo;
        NumMags = default.NumMags;
        NumSecMags = default.NumSecMags;
        NumTertMags = default.NumTertMags;
        NumAltMags = default.NumAltMags;

        return true;
    }

    return false;
}

// Modified to work all 3 mag types into new ammo resupply system
function bool ResupplyAmmo()
{
    local bool bDidResupply;

    if (NumMags < default.NumMags)
    {
        ++NumMags;
        bDidResupply = true;
    }

    if (NumSecMags < default.NumSecMags)
    {
        ++NumSecMags;
        bDidResupply = true;
    }

    if (NumTertMags < default.NumTertMags)
    {
        ++NumTertMags;
        bDidResupply = true;
    }

    if (NumAltMags < default.NumAltMags)
    {
        ++NumAltMags;
        bDidResupply = true;

        // If coaxial MG is out of ammo, start an MG reload, but only if there is a player in the cannon position
        if (!HasAmmo(3) && Instigator.Controller != none && Role == ROLE_Authority)
        {
            HandleReload();
        }
    }

    return bDidResupply;
}

defaultproperties
{
    FrontArmorFactor=0.8
    RightArmorFactor=0.8
    LeftArmorFactor=0.8
    RearArmorFactor=0.8
    FrontArmorSlope=30.0
    RightArmorSlope=30.0
    LeftArmorSlope=30.0
    RearArmorSlope=30.0
    FrontLeftAngle=306.0
    FrontRightAngle=54.0
    RearRightAngle=130.0
    RearLeftAngle=230.0
    NumMags=15
    NumSecMags=15
    NumTertMags=15
    ReloadSoundOne=sound'Vehicle_reloads.Reloads.T60_reload_01'
    ReloadSoundTwo=sound'DH_GerVehicleSounds2.Reloads.234_reload_02'
    ReloadSoundThree=sound'DH_GerVehicleSounds2.Reloads.234_reload_03'
    ReloadSoundFour=sound'Vehicle_reloads.Reloads.T60_reload_04'
    CannonFireSound(0)=SoundGroup'DH_GerVehicleSounds.20mm.DH20mmFire01G'
    CannonFireSound(1)=SoundGroup'DH_GerVehicleSounds.20mm.DH20mmFire02G'
    CannonFireSound(2)=SoundGroup'DH_GerVehicleSounds.20mm.DH20mmFire03G'
    ProjectileDescriptions(0)="Mixed"
    ProjectileDescriptions(1)="AP"
    ProjectileDescriptions(2)="HE-T"
    RangeSettings(1)=100
    RangeSettings(2)=200
    RangeSettings(3)=300
    RangeSettings(4)=400
    RangeSettings(5)=500
    RangeSettings(6)=600
    RangeSettings(7)=700
    RangeSettings(8)=800
    RangeSettings(9)=900
    RangeSettings(10)=1000
    RangeSettings(11)=1100
    RangeSettings(12)=1200
    ReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    NumAltMags=12
    AltTracerProjectileClass=class'DH_MG42VehicleTracerBullet'
    AltFireTracerFrequency=7
    bUsesTracers=true
    bAltFireTracersOnly=true
    MinCommanderHitHeight=21.0
    VehHitpoints(0)=(PointRadius=9.0,PointScale=1.0,PointBone="com_attachment",PointOffset=(X=12.0,Y=4.0,Z=34.0))
    VehHitpoints(1)=(PointRadius=15.0,PointScale=1.0,PointBone="com_attachment",PointOffset=(X=12.0,Y=4.0,Z=12.0))
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="Turret"
    PitchBone="Gun"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="Barrel"
    GunnerAttachmentBone="com_attachment"
    WeaponFireOffset=5.0
    AltFireOffset=(X=-54.0,Y=-24.0,Z=-3.0)
    ManualRotationsPerSecond=0.04
    bAmbientAltFireSound=true
    Spread=0.003
    bUsesSecondarySpread=false
    bUsesTertiarySpread=false
    FireInterval=0.2
    AltFireInterval=0.05
    FlashEmitterClass=class'ROEffects.MuzzleFlash3rdSTG'
    EffectEmitterClass=none
    CannonDustEmitterClass=none // avoids having to override FlashMuzzleFlash function
    FireEffectOffset=(X=20.0,Y=-5.0,Z=20.0)
    FireSoundVolume=512.0
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireLoop01'
    AltFireSoundScaling=3.0
    AltFireEndSound=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireEnd01'
    FireForce="Explosion05"
    bIsRepeatingFF=true // added, as strongly suspect this should be true, like a tank mounted MG
    ProjectileClass=class'DH_Vehicles.DH_Sdkfz2341CannonShellMixed'
    AltFireProjectileClass=class'DH_Vehicles.DH_MG42VehicleBullet'
    ShakeRotMag=(Z=5.0)
    ShakeRotRate=(Z=100.0)
    ShakeRotTime=2.0
    ShakeOffsetMag=(Z=0.5)
    ShakeOffsetRate=(Z=10.0)
    ShakeOffsetTime=2.0
    AltShakeRotMag=(X=0.01,Y=0.01,Z=0.01)
    AltShakeRotRate=(X=1000.0,Y=1000.0,Z=1000.0)
    AltShakeRotTime=2.0
    AltShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
    AltShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    AltShakeOffsetTime=2.0
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.5)
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.75,RefireRate=0.015)
    CustomPitchUpLimit=12743
    CustomPitchDownLimit=64443
    BeginningIdleAnim="com_idle_close"
    InitialPrimaryAmmo=10
    InitialSecondaryAmmo=10
    InitialTertiaryAmmo=10
    InitialAltAmmo=150
    PrimaryProjectileClass=class'DH_Vehicles.DH_Sdkfz2341CannonShellMixed'
    SecondaryProjectileClass=class'DH_Vehicles.DH_Sdkfz2341CannonShell'
    TertiaryProjectileClass=class'DH_Vehicles.DH_Sdkfz2341CannonShellHE'
    Mesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext'
    Skins(0)=texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_dunk'
    Skins(1)=texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_dunk'
    Skins(2)=texture'Weapons1st_tex.MG.mg42_barrel'
    Skins(3)=texture'Weapons1st_tex.MG.mg42'
    SoundVolume=100
    SoundRadius=256.0
}

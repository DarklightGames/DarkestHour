//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Sdkfz2341Cannon extends DH_ROTankCannon;

var()   int     NumMags;
var()   int     NumSecMags;
var()   int     NumTertMags;
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
    local float FireSpread;

    if (Role != ROLE_Authority || bForceCenterAim)
    {
        return false;
    }

    // Check that can fire (adds FireCountdown check on cannon fire, not just alt fire)
    if (FireCountdown <= 0.0 && ((CannonReloadState == CR_ReadyToFire && bClientCanFireCannon) || bAltFire))
    {
        // Set fire rotation, including any random spread (record FireMode to simplify things later)
        CalcWeaponFire(bAltFire);

        if (bCorrectAim)
        {
            WeaponFireRotation = AdjustAim(bAltFire);
        }

        if (bAltFire)
        {
            if (AltFireSpread > 0.0)
            {
                WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand() * FRand() * AltFireSpread);
            }
        }
        else
        {
            if (ProjectileClass == PrimaryProjectileClass || !bMultipleRoundTypes)
            {
                FireMode = 0;
                FireSpread = Spread;
            }
            else if (ProjectileClass == SecondaryProjectileClass)
            {
                FireMode = 1;
                
                if (bUsesSecondarySpread && SecondarySpread > 0.0)
                {
                    FireSpread = SecondarySpread;
                }
            }
            else if (ProjectileClass == TertiaryProjectileClass)
            {
                FireMode = 2;

                if (bUsesTertiarySpread && TertiarySpread > 0.0)
                {
                    FireSpread = TertiarySpread;
                }
            }
            
            if (FireSpread > 0)
            {
                WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand() * FRand() * FireSpread);
                WeaponFireRotation += rot(1, 6, 0); // correction to the aim point and to center the spread pattern
            }
        }

        DualFireOffset *= -1;

        Instigator.MakeNoise(1.0);

        // Alt fire is coaxial MG - check we have ammo & fire the MG
        if (bAltFire)
        {
            // If MG is empty so we can't fire
            if (!ConsumeAmmo(3))
            {
                VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
                HandleReload();

                return false;
            }

            AltFire(C);
            FireCountdown = AltFireInterval;

            // If we just fired our last round, start a reload
            if (!HasAmmo(3))
            {
                HandleReload();
            }
        }
        // Cannon - check we have ammo & fire the current round
        else
        {
            // If cannon is empty so we can't fire
            if (!ConsumeAmmo(FireMode))
            {
                VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
                HandleCannonReload();

                return false;
            }

            Fire(C);
            FireCountdown = FireInterval;

            // If cannon is now empty, after firing our last round
            if (!HasAmmo(FireMode))
            {
                HandleCannonReload();
            }
        }

        AimLockReleaseTime = Level.TimeSeconds + FireCountdown * FireIntervalAimLock;

        return true;
    }

    return false;
}

// Matt: modified to alternate between AP & HE rounds if firing a mixed mag (the tertiary ammo type)
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
    local Projectile        P;
    local VehicleWeaponPawn WeaponPawn;
    local vector            StartLocation, HitLocation, HitNormal, Extent;
    local rotator           FireRot;

    FireRot = WeaponFireRotation;

    // Used only for human players - lets cannons with non-centered aim points have a different aiming location
    if (Instigator != none && Instigator.IsHumanControlled())
    {
        FireRot.Pitch += AddedPitch;
    }

    if (!bAltFire && RangeSettings.Length > 0)
    {
        FireRot.Pitch += ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);
    }

    if (bCannonShellDebugging && RangeSettings.Length > 0)
    {
        Log("GetPitchForRange for" @ CurrentRangeIndex @ "=" @ ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]));
    }

    if (bDoOffsetTrace)
    {
        Extent = ProjClass.default.CollisionRadius * vect(1.0, 1.0, 0.0);
        Extent.Z = ProjClass.default.CollisionHeight;
        WeaponPawn = VehicleWeaponPawn(Owner);

        if (WeaponPawn != none && WeaponPawn.VehicleBase != none)
        {
            if (!WeaponPawn.VehicleBase.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, 
                WeaponFireLocation + vector(WeaponFireRotation) * (WeaponPawn.VehicleBase.CollisionRadius * 1.5), Extent))
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

    P = Spawn(ProjClass, none, , StartLocation, FireRot);

    // Swap to the next round type after firing // note this 'if' is removed & is the only change in this override
//  if (PendingProjectileClass != none && ProjClass == ProjectileClass && ProjectileClass != PendingProjectileClass)
//  {
//      ProjectileClass = PendingProjectileClass;
//  }

    if (P != none)
    {
        if (bInheritVelocity)
        {
            P.Velocity = Instigator.Velocity;
        }

        FlashMuzzleFlash(bAltFire);

        // Play firing noise
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
                PlayOwnedSound(AltFireSoundClass, SLOT_None, FireSoundVolume/255.0, , AltFireSoundRadius,, false);
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
                PlayOwnedSound(CannonFireSound[Rand(3)], SLOT_None, FireSoundVolume / 255.0, , FireSoundRadius,, false);
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

// Matt: modified slightly but no significant changes
simulated event OwnerEffects()
{
    // Stop the firing effects it we shouldn't be able to fire
    if (Role < ROLE_Authority && !ReadyToFire(bIsAltFire))
    {
        VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bIsAltFire);

        return; // Matt: originally removed in 234/1, suggesting fire effects would happen if weapon can't fire - doesn't seem to matter either way but have reinstated as seems more logical
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
/*
        if (!bIsAltFire) // note this 'if' is removed in 234/1
        {
            if (Instigator != none && ROPlayer(Instigator.Controller) != none && ROPlayer(Instigator.Controller).bManualTankShellReloading)
            {
                CannonReloadState = CR_Waiting;
            }
            else
            {
                CannonReloadState = CR_Empty;
                SetTimer(0.01, false);
            }

            bClientCanFireCannon = false;
        }
*/
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
                PlaySound(AltFireSoundClass, SLOT_None, FireSoundVolume / 255.0, , AltFireSoundRadius, , false);
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
            PlaySound(CannonFireSound[Rand(3)], SLOT_None, FireSoundVolume / 255.0, , FireSoundRadius, , false);
        }
    }
}

// Matt: modified to handle our modified reload process for players who manually reload
function ServerManualReload()
{
    if (Role == ROLE_Authority && CannonReloadState == CR_Waiting)
    {
        HandleCannonReload(true); // true flags that this is a manually-triggered reload
    }
}

// Matt: new function that handles all 3 round types, trying all the alternatives if we're out of some types of ammo
function HandleCannonReload(optional bool bIsManualReload)
{
    bClientCanFireCannon = false;

    // If player uses manual reloading & this isn't a manually-triggered reload, then just go to reload state waiting
    if (Instigator != none && ROPlayer(Instigator.Controller) != none && ROPlayer(Instigator.Controller).bManualTankShellReloading && !bIsManualReload)
    {
        CannonReloadState = CR_Waiting;
        ClientSetReloadState(CannonReloadState); // primarily so client's HUD can display ammo icon in red to show it needs a reload
    }
    // Otherwise check ammo & proceed with reload if we have some
    else if (CannonReloadState != CR_Empty)
    {
        // If we don't have a spare mag for the pending round type, try to switch to another round type (but not if player reloads manually)
        if (!HasMagazines(GetPendingRoundIndex()))
        {
            if (!bIsManualReload)
            {
                ToggleRoundType();
            }

            // Abort reload if we still don't have a spare mag (so must be completely out of cannon ammo) or if player reloads manually
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

// Modified as this cannon uses magazines
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
    if (ProjectileClass == PrimaryProjectileClass || bMultipleRoundTypes)
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

    if (MainAmmoChargeExtra[0] < InitialPrimaryAmmo)
    {
        MainAmmoChargeExtra[0] = InitialPrimaryAmmo;
        bMixedMagFireAP = default.bMixedMagFireAP;

        bDidResupply = true;
    }

    if (MainAmmoChargeExtra[1] < InitialSecondaryAmmo)
    {
        MainAmmoChargeExtra[1] = InitialSecondaryAmmo;

        bDidResupply = true;
    }

    if (MainAmmoChargeExtra[2] < InitialTertiaryAmmo)
    {
        MainAmmoChargeExtra[2] = InitialTertiaryAmmo;

        bDidResupply = true;
    }

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
    VehHitpoints(0)=(PointRadius=9.000000,PointScale=1.000000,PointBone="com_attachment",PointOffset=(X=12.000000,Y=4.000000,Z=34.000000))
    VehHitpoints(1)=(PointRadius=15.000000,PointScale=1.000000,PointBone="com_attachment",PointOffset=(X=12.000000,Y=4.000000,Z=12.000000))
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="Turret"
    PitchBone="Gun"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="Barrel"
    GunnerAttachmentBone="com_attachment"
    WeaponFireOffset=5.000000
    AltFireOffset=(X=-54.000000,Y=-24.000000,Z=-3.000000)
    ManualRotationsPerSecond=0.04
    PoweredRotationsPerSecond=0.04
    bAmbientAltFireSound=true
    Spread=0.003000
    bUsesSecondarySpread=false
    bUsesTertiarySpread=false
    FireInterval=0.200000
    AltFireInterval=0.050000
    FlashEmitterClass=class'ROEffects.MuzzleFlash3rdSTG'
    AmbientEffectEmitterClass=class'ROVehicles.TankMGEmitter'
    bAmbientEmitterAltFireOnly=true
    CannonDustEmitterClass=none // Matt: avoids having to override FlashMuzzleFlash function
    FireEffectOffset=(X=20.0,Y=-5.0,Z=20.0)
    FireSoundVolume=512.000000
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireLoop01'
    AltFireSoundScaling=3.000000
    RotateSound=sound'Vehicle_Weapons.Turret.manual_turret_traverse2'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireEnd01'
    FireForce="Explosion05"
    bIsRepeatingFF=true // Matt: added, as strongly suspect this should be true, like a tank mounted MG
    ProjectileClass=class'DH_Vehicles.DH_Sdkfz2341CannonShellMixed'
    AltFireProjectileClass=class'DH_Vehicles.DH_MG42VehicleBullet'
    ShakeRotMag=(Z=5.000000)
    ShakeRotRate=(Z=100.000000)
    ShakeRotTime=2.000000
    ShakeOffsetMag=(Z=0.500000)
    ShakeOffsetRate=(Z=10.000000)
    ShakeOffsetTime=2.000000
    AltShakeRotMag=(X=0.010000,Y=0.010000,Z=0.010000)
    AltShakeRotRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    AltShakeRotTime=2.000000
    AltShakeOffsetMag=(X=0.010000,Y=0.010000,Z=0.010000)
    AltShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    AltShakeOffsetTime=2.000000
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.500000)
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.015000)
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
    SoundRadius=256.000000
}

//==============================================================================
// DH_Sdkfz2342Cannon
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German Sdkfz 234/1 Armored Car cannon
//==============================================================================
class DH_Sdkfz2341Cannon extends ROTankCannon;

var     int   NumMags;  // Number of mags carried for the Coax MG;
var     int   NumSecMags;

replication
{
    reliable if (bNetDirty && bNetOwner && Role == ROLE_Authority)
        NumMags, NumSecMags;

    // Functions the server calls on the client side.
    reliable if (Role==ROLE_Authority)
        ClientDoCannonReload;
}

simulated function int PrimaryAmmoCount()
{
    if (bMultipleRoundTypes)
    {
        if (ProjectileClass == PrimaryProjectileClass)
            return NumMags;
        else if (ProjectileClass == SecondaryProjectileClass)
            return NumSecMags;
    }
    else
    {
        return NumMags;
    }
}

function HandlePrimaryCannonReload()
{

    if (NumMags > 0 && CannonReloadState != CR_Empty)
    {
        ClientDoCannonReload();
        NumMags--;
        MainAmmoCharge[0] = InitialPrimaryAmmo;
        NetUpdateTime = Level.TimeSeconds - 1;

        if (PendingProjectileClass == none)
            PendingProjectileClass = PrimaryProjectileClass;

        ProjectileClass = PendingProjectileClass;

        CannonReloadState = CR_Empty;
        SetTimer(0.01, false);
    }
}

function HandleSecondaryCannonReload()
{
    if (NumSecMags > 0 && CannonReloadState != CR_Empty)
    {
        ClientDoCannonReload();
        NumSecMags--;
        MainAmmoCharge[1] = InitialSecondaryAmmo;
        NetUpdateTime = Level.TimeSeconds - 1;

        if (PendingProjectileClass == none)
            PendingProjectileClass = SecondaryProjectileClass;

        ProjectileClass = PendingProjectileClass;

        CannonReloadState = CR_Empty;
        SetTimer(0.01, false);
    }
}

function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile P;
    local VehicleWeaponPawn WeaponPawn;
    local vector StartLocation, HitLocation, HitNormal, Extent;
    local rotator FireRot;

    FireRot = WeaponFireRotation;

    // used only for Human players. Lets cannons with non centered aim points have a different aiming location
    if (Instigator != none && Instigator.IsHumanControlled())
    {
        FireRot.Pitch += AddedPitch;
    }

    if (!bAltFire)
        FireRot.Pitch += ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]);

    if (bCannonShellDebugging)
        log("GetPitchForRange for "$CurrentRangeIndex$" = "$ProjClass.static.GetPitchForRange(RangeSettings[CurrentRangeIndex]));

    if (bDoOffsetTrace)
    {
        Extent = ProjClass.default.CollisionRadius * vect(1,1,0);
        Extent.Z = ProjClass.default.CollisionHeight;
        WeaponPawn = VehicleWeaponPawn(Owner);
        if (WeaponPawn != none && WeaponPawn.VehicleBase != none)
        {
            if (!WeaponPawn.VehicleBase.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, WeaponFireLocation + vector(WeaponFireRotation) * (WeaponPawn.VehicleBase.CollisionRadius * 1.5), Extent))
            StartLocation = HitLocation;
        else
            StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
    }
    else
    {
        if (!Owner.TraceThisActor(HitLocation, HitNormal, WeaponFireLocation, WeaponFireLocation + vector(WeaponFireRotation) * (Owner.CollisionRadius * 1.5), Extent))
            StartLocation = HitLocation;
        else
            StartLocation = WeaponFireLocation + vector(WeaponFireRotation) * (ProjClass.default.CollisionRadius * 1.1);
    }
    }
    else
        StartLocation = WeaponFireLocation;

    if (bCannonShellDebugging)
        Trace(TraceHitLocation, HitNormal, WeaponFireLocation + 65355 * vector(WeaponFireRotation), WeaponFireLocation, false);

    //Level.Game.Broadcast(self, ProjClass);

    P = spawn(ProjClass, none, , StartLocation, FireRot); //self

    //log("WeaponFireRotation = "$WeaponFireRotation);

    if (P != none)
    {
        if (bInheritVelocity)
            P.Velocity = Instigator.Velocity;

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
                PlayOwnedSound(AltFireSoundClass, SLOT_none, FireSoundVolume/255.0,, AltFireSoundRadius,, false);
        }
        else
        {
            if (bAmbientFireSound)
                AmbientSound = FireSoundClass;
            else
            {
                PlayOwnedSound(CannonFireSound[Rand(3)], SLOT_none, FireSoundVolume/255.0,, FireSoundRadius,, false);
            }
        }
    }

    return P;
}

// Set the fire countdown client side
simulated function ClientDoCannonReload()
{
    CannonReloadState = CR_Empty;
    SetTimer(0.01, false);
}

// Returns true if this weapon is ready to fire
simulated function bool ReadyToFire(bool bAltFire)
{
    local int Mode;
    /*
    if (CannonReloadState != CR_ReadyToFire)
    {
        return false;
    }
    */
    if (    bAltFire)
        Mode = 2;
    else if (ProjectileClass == PrimaryProjectileClass)
        Mode = 0;
    else if (ProjectileClass == SecondaryProjectileClass)
        Mode = 1;


    if (!bAltFire && (CannonReloadState != CR_ReadyToFire || !bClientCanFireCannon))
        return false;

    //Level.Game.Broadcast(self, "ReadyToFire?" @ bAltFire @ Mode @ HasAmmo(Mode));

    if (HasAmmo(Mode))
        return true;

    return false;
}


//do effects (muzzle flash, force feedback, etc) immediately for the weapon's owner (don't wait for replication)
simulated event OwnerEffects()
{
    // Stop the firing effects it we shouldn't be able to fire
    if ((Role < ROLE_Authority) && !ReadyToFire(bIsAltFire))
    {
        VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bIsAltFire);
    }

    if (!bIsRepeatingFF)
    {
        if (bIsAltFire)
            ClientPlayForceFeedback(AltFireForce);
        else
            ClientPlayForceFeedback(FireForce);
    }
    ShakeView(bIsAltFire);

    if (Level.NetMode == NM_Standalone && bIsAltFire)
    {
        if (AmbientEffectEmitter != none)
            AmbientEffectEmitter.SetEmitterStatus(true);
    }

    if (Role < ROLE_Authority)
    {
        if (bIsAltFire)
            FireCountdown = AltFireInterval;
        else
            FireCountdown = FireInterval;

        AimLockReleaseTime = Level.TimeSeconds + FireCountdown * FireIntervalAimLock;

        FlashMuzzleFlash(bIsAltFire);

        if (AmbientEffectEmitter != none && bIsAltFire)
            AmbientEffectEmitter.SetEmitterStatus(true);

        if (bIsAltFire)
        {
            if (!bAmbientAltFireSound)
                PlaySound(AltFireSoundClass, SLOT_none, FireSoundVolume/255.0,, AltFireSoundRadius,, false);
            else
            {
                SoundVolume = AltFireSoundVolume;
                SoundRadius = AltFireSoundRadius;
                AmbientSoundScaling = AltFireSoundScaling;
            }
        }
        else if (!bAmbientFireSound)
        {
            PlaySound(CannonFireSound[Rand(3)], SLOT_none, FireSoundVolume/255.0,, FireSoundRadius,, false);
        }
    }
}

//ClientStartFire() and ClientStopFire() are only called for the client that owns the weapon (and not at all for bots)
simulated function ClientStartFire(Controller C, bool bAltFire)
{
    bIsAltFire = bAltFire;

    //Level.Game.Broadcast(self, "ClientStartFire" @ CannonReloadState);

    if ((!bIsAltFire && CannonReloadState == CR_ReadyToFire && FireCountDown <= 0) || (bIsAltFire && FireCountdown <= 0))
    {
        if (bIsRepeatingFF)
        {
            if (bIsAltFire)
                ClientPlayForceFeedback(AltFireForce);
            else
                ClientPlayForceFeedback(FireForce);
        }
        OwnerEffects();
    }
}

event bool AttemptFire(Controller C, bool bAltFire)
{
    //Level.Game.Broadcast(self, "AttemptFire" @ bAltFire);

    if (Role != ROLE_Authority || bForceCenterAim)
        return false;

    if ((!bAltFire && CannonReloadState == CR_ReadyToFire && FireCountdown <= 0) || (bAltFire && FireCountdown <= 0))
    {
        CalcWeaponFire(bAltFire);

        if (bCorrectAim)
            WeaponFireRotation = AdjustAim(bAltFire);

        if (bAltFire)
        {
            if (AltFireSpread > 0)
                WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand()*FRand()*AltFireSpread);
        }
        else if (Spread > 0)
        {
            WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand()*FRand()*Spread);
        }

        DualFireOffset *= -1;

        Instigator.MakeNoise(1.0);

        if (bAltFire)
        {
            if (!ConsumeAmmo(2))
            {
                VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
                HandleReload();
                return false;
            }

            FireCountdown = AltFireInterval;
            AltFire(C);

            if (AltAmmoCharge < 1)
                HandleReload();
        }
        else
        {
            if (bMultipleRoundTypes)
            {
                if (ProjectileClass == PrimaryProjectileClass)
                {
                    if (!ConsumeAmmo(0))
                    {
                        VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);

                        HandlePrimaryCannonReload();
                        return false;
                    }
                    else
                    {
                        if (!HasMagazines(0) && HasMagazines(1))
                        {
                            ToggleRoundType();
                        }
                    }
                    FireCountdown = FireInterval;
                    Fire(C);

                    if (MainAmmoCharge[0] < 1)
                        HandlePrimaryCannonReload();
                }
                else if (ProjectileClass == SecondaryProjectileClass)
                {
                    if (!ConsumeAmmo(1))
                    {
                        VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);

                        HandleSecondaryCannonReload();
                        return false;
                    }
                    else
                    {
                        if (!HasMagazines(1) && HasMagazines(0))
                        {
                            ToggleRoundType();
                        }
                    }
                    FireCountdown = FireInterval;
                    Fire(C);

                    if (MainAmmoCharge[1] < 1)
                        HandleSecondaryCannonReload();
                }
            }
            else
            {
                if (!ConsumeAmmo(0))
                {
                    VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);

                    HandlePrimaryCannonReload();
                    return false;
                }
                FireCountdown = FireInterval;
                Fire(C);

                if (MainAmmoCharge[0] < 1)
                    HandlePrimaryCannonReload();
            }
        }

        AimLockReleaseTime = Level.TimeSeconds + FireCountdown * FireIntervalAimLock;

        return true;
    }

    return false;
}

simulated event FlashMuzzleFlash(bool bWasAltFire)
{
    local ROVehicleWeaponPawn OwningPawn;

    if (Role == ROLE_Authority)
    {
        if (bWasAltFire)
            FiringMode = 1;
        else
            FiringMode = 0;
        FlashCount++;
        NetUpdateTime = Level.TimeSeconds - 1;
    }
    else
        CalcWeaponFire(bWasAltFire);

    if (bUsesTracers && (!bWasAltFire && !bAltFireTracersOnly || bWasAltFire))
        UpdateTracer();

    if (bWasAltFire)
        return;

    if (FlashEmitter != none)
        FlashEmitter.Trigger(Self, Instigator);

    if ((EffectEmitterClass != none) && EffectIsRelevant(Location,false))
        EffectEmitter = spawn(EffectEmitterClass, self,, WeaponFireLocation, WeaponFireRotation);

    OwningPawn = ROVehicleWeaponPawn(Instigator);

    if (OwningPawn != none && OwningPawn.DriverPositions[OwningPawn.DriverPositionIndex].bExposed)
    {
        if (HasAnim(TankShootOpenAnim))
            PlayAnim(TankShootOpenAnim);
    }
    else if (HasAnim(TankShootClosedAnim))
    {
        PlayAnim(TankShootClosedAnim);
    }
}

simulated function Tick(float Delta)
{
    Super(ROVehicleWeapon).Tick(Delta);
}

function ToggleRoundType()
{
    //Switch to second type.
    if (PendingProjectileClass == PrimaryProjectileClass || PendingProjectileClass == none)
    {
        if (NumSecMags <= 0)
            return;

        PendingProjectileClass = SecondaryProjectileClass;
    }
    //Switch to first type.
    else
    {
        if (NumMags <= 0)
            return;

        PendingProjectileClass = PrimaryProjectileClass;
    }

    //Level.Game.Broadcast(self, "ToggleRoundType" @ PendingProjectileClass);
}

simulated function bool HasMagazines(int Mode)
{
    switch(Mode)
    {
        case 0:
            return NumMags > 0;
        case 1:
            return NumSecMags > 0;
        default:
            return false;
    }

    return false;
}

defaultproperties
{
     NumMags=25
     NumSecMags=20
     ReloadSoundOne=Sound'Vehicle_reloads.Reloads.T60_reload_01'
     ReloadSoundTwo=Sound'DH_GerVehicleSounds2.Reloads.234_reload_02'
     ReloadSoundThree=Sound'DH_GerVehicleSounds2.Reloads.234_reload_03'
     ReloadSoundFour=Sound'Vehicle_reloads.Reloads.T60_reload_04'
     CannonFireSound(0)=SoundGroup'DH_GerVehicleSounds.20mm.DH20mmFire01G'
     CannonFireSound(1)=SoundGroup'DH_GerVehicleSounds.20mm.DH20mmFire02G'
     CannonFireSound(2)=SoundGroup'DH_GerVehicleSounds.20mm.DH20mmFire03G'
     ProjectileDescriptions(1)="HE-T"
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
     ReloadSound=Sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
     NumAltMags=12
     DummyTracerClass=Class'DH_Vehicles.DH_MG42VehicleClientTracer'
     mTracerInterval=0.350000
     bUsesTracers=true
     bAltFireTracersOnly=true
     VehHitpoints(0)=(PointRadius=9.000000,PointScale=1.000000,PointBone="com_attachment",PointOffset=(X=12.000000,Y=4.000000,Z=34.000000))
     VehHitpoints(1)=(PointRadius=15.000000,PointScale=1.000000,PointBone="com_attachment",PointOffset=(X=12.000000,Y=4.000000,Z=12.000000))
     hudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.mg42_ammo'
     YawBone="Turret"
     PitchBone="Gun"
     PitchUpLimit=15000
     PitchDownLimit=45000
     WeaponFireAttachmentBone="Barrel"
     GunnerAttachmentBone="com_attachment"
     WeaponFireOffset=5.000000
     AltFireOffset=(X=-54.000000,Y=-24.000000,Z=-3.000000)
     RotationsPerSecond=0.040000
     bAmbientAltFireSound=true
     Spread=0.002000
     AltFireSpread=0.002000
     FireInterval=0.200000
     AltFireInterval=0.050000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash3rdSTG'
     AmbientEffectEmitterClass=Class'ROVehicles.TankMGEmitter'
     bAmbientEmitterAltFireOnly=true
     FireSoundVolume=512.000000
     AltFireSoundClass=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireLoop01'
     AltFireSoundScaling=3.000000
     RotateSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse2'
     AltFireEndSound=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireEnd01'
     FireForce="Explosion05"
     ProjectileClass=Class'DH_Vehicles.DH_Sdkfz2341CannonShell'
     AltFireProjectileClass=Class'DH_Vehicles.DH_MG42VehicleBullet'
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
     InitialAltAmmo=150
     PrimaryProjectileClass=Class'DH_Vehicles.DH_Sdkfz2341CannonShell'
     SecondaryProjectileClass=Class'DH_Vehicles.DH_Sdkfz2341CannonShellHE'
     Mesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_turret_ext'
     Skins(0)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_dunk'
     Skins(1)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_dunk'
     Skins(2)=Texture'Weapons1st_tex.MG.mg42_barrel'
     Skins(3)=Texture'Weapons1st_tex.MG.mg42'
     SoundVolume=100
     SoundRadius=256.000000
}

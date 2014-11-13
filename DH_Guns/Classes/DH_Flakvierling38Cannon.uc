//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Flakvierling38Cannon extends DH_Sdkfz2341Cannon;

#exec OBJ LOAD FILE=..\Animations\DH_Flakvierling38_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_Flakvierling38_tex.utx

var name                    BarrelBones[4];     // Bone names for each
var byte                    BarrelBoneIndex;    // Bone index for each gun starting with the top 2
var name                    FireAnimations[2];
var byte                    FireAnimationIndex; // 0 - fire top guns, 1 - fire bottom guns
var Emitter                 FlashEmitters[4];   // We will have a separate flash emitter for each barrel.
var name                    SightBone;
var name                    TraverseWheelBone;
var name                    ElevationWheelBone;

replication
{
    reliable if (Role == ROLE_Authority)
        FireAnimationIndex;
}

simulated event Tick(float DeltaTime)
{
    local rotator SightRotation;
    local rotator ElevationWheelRotation;
    local rotator TraverseWheelRotation;

    //sight
    SightRotation.Pitch = -CurrentAim.Pitch;
    SetBoneRotation(SightBone, SightRotation, 1);

    //elevation wheel
    ElevationWheelRotation.Roll = -CurrentAim.Pitch * 32;
    SetBoneRotation(ElevationWheelBone, ElevationWheelRotation, 1);

    //traverse wheel
    TraverseWheelRotation.Pitch = CurrentAim.Yaw * 32;
    SetBoneRotation(TraverseWheelBone, TraverseWheelRotation, 1);

    super.Tick(DeltaTime);
}

state ProjectileFireMode
{
    function Fire(Controller C)
    {
        SpawnProjectile(ProjectileClass, false);

        // Swap animation index
        if(FireAnimationIndex == 0)
        {
            FireAnimationIndex = 1;
        }
        else
        {
            FireAnimationIndex = 0;
        }
    }

    function AltFire(Controller C)
    {
    }
}

event bool AttemptFire(Controller C, bool bAltFire)
{
    if (bAltFire)
    {
        return false;
    }

    if (Role != ROLE_Authority || bForceCenterAim)
    {
        return false;
    }

    if ((!bAltFire && CannonReloadState == CR_ReadyToFire && FireCountdown <= 0) || (bAltFire && FireCountdown <= 0))
    {
        CalcWeaponFire(bAltFire);

        if (bCorrectAim)
        {
            WeaponFireRotation = AdjustAim(bAltFire);
        }

        if (Spread > 0)
        {
            WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand() * FRand() * Spread);
        }

        DualFireOffset *= -1;

        Instigator.MakeNoise(1.0);

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
                if (MainAmmoCharge[0] == 0 && !HasMagazines(0) && HasMagazines(1))
                {
                    ToggleRoundType();
                    HandleSecondaryCannonReload();
                }
            }

            FireCountdown = FireInterval;

            Fire(C);

            if (MainAmmoCharge[0] < 1)
            {
                HandlePrimaryCannonReload();
            }
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
                if (MainAmmoCharge[1] == 0 && !HasMagazines(1) && HasMagazines(0))
                {
                    ToggleRoundType();
                    HandlePrimaryCannonReload();
                }
            }

            FireCountdown = FireInterval;

            Fire(C);

            if (MainAmmoCharge[1] < 1)
            {
                HandleSecondaryCannonReload();
            }
        }

        AimLockReleaseTime = Level.TimeSeconds + FireCountdown * FireIntervalAimLock;

        return true;
    }

    return false;
}

function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local int i;
    local Projectile P;
    local vector StartLocation, HitLocation, HitNormal, Extent;
    local rotator FireRot;
    local vector BarrelLocation[2];
    local rotator BarrelRotation[2];

    if (FireAnimationIndex == 0)
    {
        GetBarrelLocationAndRotation(0, BarrelLocation[0], BarrelRotation[0]);
        GetBarrelLocationAndRotation(3, BarrelLocation[1], BarrelRotation[1]);
    }
    else
    {
        GetBarrelLocationAndRotation(1, BarrelLocation[0], BarrelRotation[0]);
        GetBarrelLocationAndRotation(2, BarrelLocation[1], BarrelRotation[1]);
    }

    for(i = 0; i < 2; i++)
    {
        FireRot = BarrelRotation[i];

        // used only for Human players. Lets cannons with non centered aim points have a different aiming location
        if (Instigator != none && Instigator.IsHumanControlled())
        {
            FireRot.Pitch += AddedPitch;
        }

        if (!Owner.TraceThisActor(HitLocation, HitNormal, BarrelLocation[i], WeaponFireLocation + vector(BarrelRotation[i]) * (Owner.CollisionRadius * 1.5), Extent))
        {
            StartLocation = HitLocation;
        }
        else
        {
            StartLocation = BarrelLocation[i] + vector(BarrelRotation[i]) * (ProjClass.default.CollisionRadius * 1.1);
        }

        P = spawn(ProjClass, none, , StartLocation, FireRot); //self

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
                    PlayOwnedSound(AltFireSoundClass, SLOT_None, FireSoundVolume / 255.0,, AltFireSoundRadius,, false);
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

simulated function GetBarrelLocationAndRotation(int Index, out vector BarrelLocation, out rotator BarrelRotation)
{
    local coords BarrelBoneCoords;
    local vector CurrentFireOffset;

    if (Index < 0 || Index >= ArrayCount(BarrelBones))
    {
        return;
    }

    BarrelBoneCoords = GetBoneCoords(BarrelBones[Index]);

    CurrentFireOffset = (WeaponFireOffset * vect(1, 0, 0)) + (DualFireOffset * vect(0, 1, 0));

    BarrelRotation = rotator(vector(CurrentAim) >> Rotation);
    BarrelLocation = BarrelBoneCoords.Origin + (CurrentFireOffset >> BarrelRotation);
}

simulated function CalcWeaponFire(bool bWasAltFire)
{
    local coords WeaponBoneCoords;
    local vector CurrentFireOffset;

    // Calculate fire offset in world space
    WeaponBoneCoords = GetBoneCoords(BarrelBones[BarrelBoneIndex++]);

    BarrelBoneIndex = Clamp(BarrelBoneIndex, 0, 4);

    if (bWasAltFire)
    {
        CurrentFireOffset = AltFireOffset + (WeaponFireOffset * vect(1, 0, 0));
    }
    else
    {
        CurrentFireOffset = (WeaponFireOffset * vect(1, 0, 0)) + (DualFireOffset * vect(0, 1, 0));
    }

    // Calculate rotation of the gun
    WeaponFireRotation = rotator(vector(CurrentAim) >> Rotation);

    // Calculate exact fire location
    WeaponFireLocation = WeaponBoneCoords.Origin + (CurrentFireOffset >> WeaponFireRotation);

    // Adjust fire rotation taking dual offset into account
    if (bDualIndependantTargeting)
    {
        WeaponFireRotation = rotator(CurrentHitLocation - WeaponFireLocation);
    }
}

simulated event FlashMuzzleFlash(bool bWasAltFire)
{
    local ROVehicleWeaponPawn OwningPawn;

    if (Role == ROLE_Authority)
    {
        if (bWasAltFire)
        {
            FiringMode = 1;
        }
        else
        {
            FiringMode = 0;
        }

        FlashCount++;

        NetUpdateTime = Level.TimeSeconds - 1;
    }
    else
    {
        CalcWeaponFire(bWasAltFire);
    }

    if (HasAnim(FireAnimations[FireAnimationIndex]))
    {
        PlayAnim(FireAnimations[FireAnimationIndex]);
    }

    if (FireAnimationIndex == 0)
    {
        FlashEmitters[0].Trigger(Self, Instigator);
        FlashEmitters[3].Trigger(Self, Instigator);
    }
    else
    {
        FlashEmitters[1].Trigger(Self, Instigator);
        FlashEmitters[2].Trigger(Self, Instigator);
    }

    OwningPawn = ROVehicleWeaponPawn(Instigator);
}

simulated function InitEffects()
{
    local int i;

    // don't even spawn on server
    if (Level.NetMode == NM_DedicatedServer)
    {
        return;
    }

    for(i = 0; i < 4; i++)
    {
        if (FlashEmitterClass != none && FlashEmitters[i] == none)
        {
            FlashEmitters[i] = Spawn(FlashEmitterClass);
            FlashEmitters[i].SetDrawScale(DrawScale);

            AttachToBone(FlashEmitters[i], BarrelBones[i]);

            FlashEmitters[i].SetRelativeLocation(WeaponFireOffset * vect(1,0,0));
        }
    }
}

function ToggleRoundType()
{
    if (!HasMagazines(0) && !HasMagazines(1))
    {
        return;
    }

    if ((PendingProjectileClass == PrimaryProjectileClass || PendingProjectileClass == none) && HasMagazines(1))
    {
        PendingProjectileClass = SecondaryProjectileClass;
    }
    else if (PendingProjectileClass == SecondaryProjectileClass && HasMagazines(0))
    {
        PendingProjectileClass = PrimaryProjectileClass;
    }
}

simulated function bool HasAmmo(int Mode)
{
    switch(Mode)
    {
        case 0:
            return (MainAmmoCharge[0] > 0 || NumMags > 0);
        case 1:
            return (MainAmmoCharge[1] > 0 || NumSecMags > 0);
    }

    return false;
}

defaultproperties
{
     BarrelBones(0)="g1"
     BarrelBones(1)="G2"
     BarrelBones(2)="g3"
     BarrelBones(3)="g4"
     FireAnimations(0)="shoot_open"
     FireAnimations(1)="Shoot_open2"
     SightBone="Object002"
     TraverseWheelBone="yaw_w"
     ElevationWheelBone="pitch_w"
     NumMags=16
     NumSecMags=4
     AddedPitch=50
     WeaponFireOffset=64.000000
     RotationsPerSecond=0.050000
     FireInterval=0.150000
     FlashEmitterClass=class'DH_Guns.DH_Flakvierling38MuzzleFlash'
     ProjectileClass=class'DH_Guns.DH_Flakvierling38CannonShellAP'
     AltFireProjectileClass=none
     CustomPitchUpLimit=15474
     CustomPitchDownLimit=64990
     InitialPrimaryAmmo=40
     InitialSecondaryAmmo=40
     PrimaryProjectileClass=class'DH_Guns.DH_Flakvierling38CannonShellAP'
     SecondaryProjectileClass=class'DH_Guns.DH_Flakvierling38CannonShellHE'
     Mesh=SkeletalMesh'DH_Flakvierling38_anm.flak_turret'
     Skins(0)=Texture'DH_Flakvierling38_tex.flak.FlakVeirling'
}

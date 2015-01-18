//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Flakvierling38Cannon extends DH_Sdkfz2341Cannon;

#exec OBJ LOAD FILE=..\Animations\DH_Flakvierling38_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_Flakvierling38_tex.utx

var name                    BarrelBones[4];     // bone names for each
var byte                    BarrelBoneIndex;    // bone index for each gun starting with the top 2
var name                    FireAnimations[2];
var byte                    FireAnimationIndex; // 0 - fire top guns, 1 - fire bottom guns
var Emitter                 FlashEmitters[4];   // we will have a separate flash emitter for each barrel
var name                    SightBone;
var name                    TraverseWheelBone;
var name                    ElevationWheelBone;

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        FireAnimationIndex;
}

simulated function Tick(float DeltaTime)
{
    local rotator SightRotation;
    local rotator ElevationWheelRotation;
    local rotator TraverseWheelRotation;

    // Sight
    SightRotation.Pitch = -CurrentAim.Pitch;
    SetBoneRotation(SightBone, SightRotation, 1);

    // Elevation wheel
    ElevationWheelRotation.Roll = -CurrentAim.Pitch * 32;
    SetBoneRotation(ElevationWheelBone, ElevationWheelRotation, 1);

    // Traverse wheel
    TraverseWheelRotation.Pitch = CurrentAim.Yaw * 32;
    SetBoneRotation(TraverseWheelBone, TraverseWheelRotation, 1);
}

state ProjectileFireMode
{
    function Fire(Controller C)
    {
        SpawnProjectile(ProjectileClass, false);

        // Swap animation index
        if (FireAnimationIndex == 0)
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

function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local vector     BarrelLocation[2], StartLocation, HitLocation, HitNormal, Extent;
    local rotator    BarrelRotation[2], FireRot;
    local Projectile P;
    local int        i;

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

    for (i = 0; i < 2; i++)
    {
        if (ProjectileClass == PrimaryProjectileClass)
        {
            if (bMixedMagFireAP)
            {
                ProjClass = SecondaryProjectileClass;
            }
            else
            {
                ProjClass = TertiaryProjectileClass;
            }

            bMixedMagFireAP = !bMixedMagFireAP;
        }

        FireRot = BarrelRotation[i];

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

        P = Spawn(ProjClass, none, , StartLocation, FireRot);

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

simulated function GetBarrelLocationAndRotation(int Index, out vector BarrelLocation, out rotator BarrelRotation)
{
    local coords BarrelBoneCoords;
    local vector CurrentFireOffset;

    if (Index < 0 || Index >= arraycount(BarrelBones))
    {
        return;
    }

    BarrelBoneCoords = GetBoneCoords(BarrelBones[Index]);

    CurrentFireOffset = (WeaponFireOffset * vect(1.0, 0.0, 0.0)) + (DualFireOffset * vect(0.0, 1.0, 0.0));

    BarrelRotation = rotator(vector(CurrentAim) >> Rotation);
    BarrelLocation = BarrelBoneCoords.Origin + (CurrentFireOffset >> BarrelRotation);
}

simulated function CalcWeaponFire(bool bWasAltFire)
{
    local coords WeaponBoneCoords;
    local vector CurrentFireOffset;

    // Calculate fire offset in world space
    WeaponBoneCoords = GetBoneCoords(BarrelBones[BarrelBoneIndex++]);

    BarrelBoneIndex = Clamp(BarrelBoneIndex, 0, 3);

    if (bWasAltFire)
    {
        CurrentFireOffset = AltFireOffset + (WeaponFireOffset * vect(1.0, 0.0, 0.0));
    }
    else
    {
        CurrentFireOffset = (WeaponFireOffset * vect(1.0, 0.0, 0.0)) + (DualFireOffset * vect(0.0, 1.0, 0.0));
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
        if (FlashEmitters[0] != none)
        {
            FlashEmitters[0].Trigger(self, Instigator);
        }

        if (FlashEmitters[3] != none)
        {
            FlashEmitters[3].Trigger(self, Instigator);
        }
    }
    else
    {
        if (FlashEmitters[1] != none)
        {
            FlashEmitters[1].Trigger(self, Instigator);
        }

        if (FlashEmitters[2] != none)
        {
            FlashEmitters[2].Trigger(self, Instigator);
        }
    }
}

simulated function InitEffects()
{
    local int i;

    if (Level.NetMode == NM_DedicatedServer)
    {
        return;
    }

    for (i = 0; i < 4; i++)
    {
        if (FlashEmitterClass != none && FlashEmitters[i] == none)
        {
            FlashEmitters[i] = Spawn(FlashEmitterClass);
            FlashEmitters[i].SetDrawScale(DrawScale);

            AttachToBone(FlashEmitters[i], BarrelBones[i]);

            FlashEmitters[i].SetRelativeLocation(WeaponFireOffset * vect(1.0, 0.0, 0.0));
        }
    }
}

// Matt: added from DH_ATGunCannon, as parent 234/1 cannon now extends DH_ROTankCannon, which will run armor checks
simulated function bool DHShouldPenetrate(class<DH_ROAntiVehicleProjectile> P, vector HitLocation, vector HitRotation, float PenetrationNumber)
{
   return true;
}

simulated function bool BelowDriverAngle(vector loc, vector ray)
{
    return false; // there aren't any angles that are below the driver angle for an AT Gun cannon
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
    NumMags=12
    NumSecMags=4
    NumTertMags=4
    AddedPitch=50
    WeaponFireOffset=64.0
    RotationsPerSecond=0.05
    ManualRotationsPerSecond=0.05
    PoweredRotationsPerSecond=0.05
    FireInterval=0.15
    FlashEmitterClass=class'DH_Guns.DH_Flakvierling38MuzzleFlash'
    ProjectileClass=class'DH_Guns.DH_Flakvierling38CannonShellMixed'
    AltFireProjectileClass=none
    CustomPitchUpLimit=15474
    CustomPitchDownLimit=64990
    InitialPrimaryAmmo=40
    InitialSecondaryAmmo=40
    InitialTertiaryAmmo=40
    PrimaryProjectileClass=class'DH_Guns.DH_Flakvierling38CannonShellMixed'
    SecondaryProjectileClass=class'DH_Guns.DH_Flakvierling38CannonShellAP'
    TertiaryProjectileClass=class'DH_Guns.DH_Flakvierling38CannonShellHE'
    Mesh=SkeletalMesh'DH_Flakvierling38_anm.flak_turret'
    Skins(0)=texture'DH_Flakvierling38_tex.flak.FlakVeirling'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flakvierling38Cannon extends DH_Sdkfz2341Cannon;

var     name        BarrelBones[4];       // bone names for each
var     byte        BarrelBoneIndex;      // bone index for each gun starting with the top 2
var     name        FireAnimations[4];    // alternating shoot anims for both 'open' & 'closed' positions, i.e. on the sights or with gunner's head raised
var     bool        bSecondGunPairFiring; // false = fire top right & bottom left guns, true = fire top left & bottom right guns
var     Emitter     FlashEmitters[4];     // we will have a separate flash emitter for each barrel
var     name        SightBone;
var     name        TraverseWheelBone;
var     name        ElevationWheelBone;

replication
{
    // Variables the server will replicate to clients when this actor is 1st replicated
    reliable if (bNetInitial && bNetDirty && Role == ROLE_Authority)
        bSecondGunPairFiring; // after initial replication, the client should be able to keep track itself
}

// Modified to skip over the Super in DH_Sdkfz2341Cannon, which attaches extra collision static meshes specifically for that vehicle's turret mesh covers
simulated function PostBeginPlay()
{
    super(DHVehicleCannon).PostBeginPlay();
}

// Modified to remove handling of mixed mag (instead is handled in SpawnProjectile() as that now fires two projectiles), to toggle bSecondGunPairFiring & to remove AltFire
state ProjectileFireMode
{
    function Fire(Controller C)
    {
        SpawnProjectile(ProjectileClass, false);

        bSecondGunPairFiring = !bSecondGunPairFiring; // toggle on server or single player
    }

    function AltFire(Controller C)
    {
    }
}

// Modified to fire two projectiles from a pair of alternating barrels & to handle alternating AP/HE rounds if a mixed mag is loaded
function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local vector     BarrelLocation[2], StartLocation, HitLocation, HitNormal, Extent;
    local rotator    BarrelRotation[2], FireRot;
    local Projectile P;
    local bool       bMixedMag;
    local int        i;

    if (!bSecondGunPairFiring)
    {
        GetBarrelLocationAndRotation(0, BarrelLocation[0], BarrelRotation[0]);
        GetBarrelLocationAndRotation(3, BarrelLocation[1], BarrelRotation[1]);
    }
    else
    {
        GetBarrelLocationAndRotation(1, BarrelLocation[0], BarrelRotation[0]);
        GetBarrelLocationAndRotation(2, BarrelLocation[1], BarrelRotation[1]);
    }

    if (ProjClass == PrimaryProjectileClass)
    {
        bMixedMag = true;
    }

    for (i = 0; i < 2; ++i)
    {
        if (bMixedMag)
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

        if (bDoOffsetTrace)
        {
            Extent = ProjClass.default.CollisionRadius * vect(1.0, 1.0, 0.0);
            Extent.Z = ProjClass.default.CollisionHeight;

            if (!Owner.TraceThisActor(HitLocation, HitNormal, BarrelLocation[i], BarrelLocation[i] + vector(BarrelRotation[i]) * (Owner.CollisionRadius * 1.5), Extent))
            {
                StartLocation = HitLocation;
            }
            else
            {
                StartLocation = BarrelLocation[i] + vector(BarrelRotation[i]) * (ProjClass.default.CollisionRadius * 1.1);
            }
        }
        else
        {
            StartLocation = BarrelLocation[i];
        }

        P = Spawn(ProjClass, none,, StartLocation, FireRot);

        if (P != none)
        {
            if (bInheritVelocity)
            {
                P.Velocity = Instigator.Velocity;
            }

            FlashMuzzleFlash(bAltFire);

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

    return P;
}

// New function to get the location & rotation of barrel that is firing
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

// Modified to get WeaponFireLocation for the barrel that is currently firing
simulated function CalcWeaponFire(bool bWasAltFire)
{
    local coords WeaponBoneCoords;
    local vector CurrentFireOffset;

    // Calculate fire offset in world space
    WeaponBoneCoords = GetBoneCoords(BarrelBones[BarrelBoneIndex++]);
    BarrelBoneIndex = Clamp(BarrelBoneIndex, 0, 3);
    CurrentFireOffset = (WeaponFireOffset * vect(1.0, 0.0, 0.0)) + (DualFireOffset * vect(0.0, 1.0, 0.0));

    // Calculate rotation of the gun
    WeaponFireRotation = rotator(vector(CurrentAim) >> Rotation);

    // Calculate exact fire location
    WeaponFireLocation = WeaponBoneCoords.Origin + (CurrentFireOffset >> WeaponFireRotation);
}

// Modified to handle fire effects & animations from alternating pairs of barrels
simulated function FlashMuzzleFlash(bool bWasAltFire)
{
    local int FireAnimationIndex;

    if (Role == ROLE_Authority)
    {
        FiringMode = byte(bWasAltFire);
        FlashCount++;
        NetUpdateTime = Level.TimeSeconds - 1.0;
    }
    else
    {
        CalcWeaponFire(bWasAltFire);
    }

    if (Level.NetMode != NM_DedicatedServer && !bWasAltFire)
    {
        if (!bSecondGunPairFiring)
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

        if (CannonPawn != none && CannonPawn.DriverPositionIndex >= CannonPawn.RaisedPositionIndex)
        {
            FireAnimationIndex = int(bSecondGunPairFiring) + 2;
        }
        else
        {
            FireAnimationIndex = int(bSecondGunPairFiring);
        }

        if (HasAnim(FireAnimations[FireAnimationIndex]))
        {
            PlayAnim(FireAnimations[FireAnimationIndex]);
        }

        if (Role < ROLE_Authority)
        {
            bSecondGunPairFiring = !bSecondGunPairFiring; // toggle on net client
        }
    }
}

// Modified to handle four barrels
simulated function InitEffects()
{
    local int i;

    if (Level.NetMode == NM_DedicatedServer)
    {
        return;
    }

    for (i = 0; i < 4; ++i)
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

// New function to update sight & aiming wheel rotation, called by cannon pawn when gun moves
simulated function UpdateSightAndWheelRotation()
{
    local rotator SightRotation, ElevationWheelRotation, TraverseWheelRotation;

    SightRotation.Pitch = -CurrentAim.Pitch;
    SetBoneRotation(SightBone, SightRotation, 1);

    ElevationWheelRotation.Pitch = -CurrentAim.Pitch * 32;
    SetBoneRotation(ElevationWheelBone, ElevationWheelRotation, 1);

    TraverseWheelRotation.Roll = -CurrentAim.Yaw * 32;
    SetBoneRotation(TraverseWheelBone, TraverseWheelRotation, 1);
}

// Added the following functions from DHATGunCannon, as parent Sd.Kfz.234/1 armoured car cannon extends DHVehicleCannon:
simulated function bool DHShouldPenetrate(DHAntiVehicleProjectile P, vector HitLocation, vector HitRotation, float PenetrationNumber)
{
   return true;
}

defaultproperties
{
    BarrelBones(0)="g1" // top right barrel
    BarrelBones(1)="G2" // top left
    BarrelBones(2)="g3" // bottom right
    BarrelBones(3)="g4" // bottom left
    FireAnimations(0)="shoot_open"        // on sights, 1st gun pair
    FireAnimations(1)="Shoot_open2"       // on sights, 2nd gun pair
    FireAnimations(2)="shoot_unbuttoned"  // raised head, 1st gun pair
    FireAnimations(3)="shoot_unbuttoned2" // raised head, 2nd gun pair
    SightBone="Object002"
    TraverseWheelBone="pitch_w" // these are the wrong way round in the model - "pitch_w" is actually the traversing wheel & "yaw_w" is the elevating wheel
    ElevationWheelBone="yaw_w"
    NumMags=12
    NumSecMags=4
    NumTertMags=4
    AddedPitch=50
    WeaponFireOffset=64.0
    RotationsPerSecond=0.05
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
    Mesh=SkeletalMesh'DH_Flak38_anm.flakvierling_turret'
    Skins(0)=texture'DH_Artillery_tex.flakvierling.FlakVeirling38'
    CollisionStaticMesh=none
}

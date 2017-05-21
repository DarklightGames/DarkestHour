//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_Flakvierling38Cannon extends DH_Flak38Cannon;

var     name        BarrelBones[4];       // bone names for each
var     Emitter     FlashEmitters[4];     // we will have a separate flash emitter for each barrel
var     name        FireAnimations[6];    // alternating shoot anims for both 'open' & 'closed' positions, i.e. on the sights or with gunner's head raised
var     bool        bSecondGunPairFiring; // false = fire top right & bottom left guns, true = fire top left & bottom right guns

replication
{
    // Variables the server will replicate to clients when this actor is 1st replicated
    reliable if (bNetInitial && bNetDirty && Role == ROLE_Authority)
        bSecondGunPairFiring; // after initial replication, the client should be able to keep track itself
}

// Modified to skip over Super in DH_Sdkfz2341Cannon, as handling of mixed mag is instead handled in SpawnProjectile, which now fires two projectiles
function Fire(Controller C)
{
    super(DHVehicleCannon).Fire(C);
}

// Modified to fire two projectiles from a pair of alternating barrels & to handle alternating AP/HE rounds if a mixed mag is loaded
function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile P, LastProjectile;
    local vector     StartLocation, FireOffset;
    local rotator    FireRot;
    local bool       bMixedMag;
    local int        FirstBarrelIndex, i;

    // Barrels 0 & 1 fire first; 2nd pair is barrels 2 & 3
    if (bSecondGunPairFiring)
    {
        FirstBarrelIndex = 2;
    }

    if (ProjClass == PrimaryProjectileClass)
    {
        bMixedMag = true;
    }

    FireRot = WeaponFireRotation;
    FireOffset = (WeaponFireOffset * vect(1.0, 0.0, 0.0)) >> WeaponFireRotation;

    // Spawn a projectile from each firing barrel
    for (i = FirstBarrelIndex; i < (FirstBarrelIndex + 2); ++i)
    {
        StartLocation = GetBoneCoords(BarrelBones[i]).Origin + FireOffset;

        if (Instigator != none && Instigator.IsHumanControlled())
        {
            FireRot.Pitch += AddedPitch;
        }

        if (bMixedMag)
        {
            if (i == FirstBarrelIndex)
            {
                ProjClass = SecondaryProjectileClass;
            }
            else
            {
                ProjClass = TertiaryProjectileClass;
            }
        }

        P = Spawn(ProjClass, none,, StartLocation, FireRot);

        if (P != none)
        {
            LastProjectile = P;
        }
    }

    // Play fire effects if we spawned a projectile (only play fire effects once)
    if (LastProjectile != none)
    {
        FlashMuzzleFlash(bAltFire);
        PlayOwnedSound(CannonFireSound[Rand(3)], SLOT_None, FireSoundVolume / 255.0,, FireSoundRadius,, false);
    }

    return LastProjectile;
}

// Modified to handle fire effects & animations from alternating pairs of barrels
simulated function FlashMuzzleFlash(bool bWasAltFire)
{
    local DHVehicleCannonPawn CannonPawn;
    local int FirstBarrelIndex, FireAnimationIndex, i;

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
        // Barrels 0 & 1 fire first; 2nd pair is barrels 2 & 3
        if (bSecondGunPairFiring)
        {
            FirstBarrelIndex = 2;
        }

        // Trigger a flash from each firing barrel
        for (i = FirstBarrelIndex; i < (FirstBarrelIndex + 2); ++i)
        {
            if (FlashEmitters[i] != none)
            {
                FlashEmitters[i].Trigger(self, Instigator);
            }
        }

        CannonPawn = DHVehicleCannonPawn(WeaponPawn);

        // Work out which cannon firing animation we need & play it (no. 0/1 if on optics, 2/3 if on open sight, 4/5 if head raised)
        if (CannonPawn != none)
        {
            if (CannonPawn.DriverPositionIndex >= CannonPawn.RaisedPositionIndex)
            {
                FireAnimationIndex = 4;
            }
            else if (CannonPawn.DriverPositionIndex == CannonPawn.IntermediatePositionIndex)
            {
                FireAnimationIndex = 2;
            }
        }

        if (bSecondGunPairFiring)
        {
            ++FireAnimationIndex; // no. 1/3/5 if 2nd pair firing
        }

        if (FireAnimationIndex >= 0 && FireAnimationIndex < arraycount(FireAnimations) && HasAnim(FireAnimations[FireAnimationIndex]))
        {
            PlayAnim(FireAnimations[FireAnimationIndex]);
        }
    }

    bSecondGunPairFiring = !bSecondGunPairFiring; // toggle for next time (all net modes)
}

// Modified to handle four barrels
simulated function InitEffects()
{
    local int i;

    if (Level.NetMode != NM_DedicatedServer && FlashEmitterClass != none)
    {
        for (i = 0; i < 4; ++i)
        {
            if (FlashEmitters[i] == none)
            {
                FlashEmitters[i] = Spawn(FlashEmitterClass);

                if (FlashEmitters[i] != none)
                {
                    FlashEmitters[i].SetDrawScale(DrawScale);
                    AttachToBone(FlashEmitters[i], BarrelBones[i]);
                    FlashEmitters[i].SetRelativeLocation(WeaponFireOffset * vect(1.0, 0.0, 0.0));
                }
            }
        }
    }
}

defaultproperties
{
    Mesh=SkeletalMesh'DH_Flak38_anm.flakvierling_turret'
    Skins(0)=texture'DH_Artillery_tex.flakvierling.FlakVeirling38'
    CollisionStaticMesh=StaticMesh'DH_Artillery_stc.flakvierling.Flakvierling_turret_coll'
    InitialPrimaryAmmo=40 // actually represents 80 rounds (4 magazines of 20 rounds each), but every time we fire we use 2 rounds (so think of it as 40 double shots)
    InitialSecondaryAmmo=40
    InitialTertiaryAmmo=40
    BarrelBones(0)="Barrel_TR"
    BarrelBones(1)="Barrel_BL"
    BarrelBones(2)="Barrel_TL"
    BarrelBones(3)="Barrel_BR"
    WeaponFireAttachmentBone="Barrel_TR" // a dummy really, replaced by individual BarrelBones - only used in CalcWeaponFire() to calc a nominal WeaponFireLocation
    WeaponFireOffset=0.0
    FireAnimations(0)="shoot_opticA"     // on gun optics, 1st gun pair
    FireAnimations(1)="shoot_opticB"     // on gun optics, 2nd gun pair
    FireAnimations(2)="shoot_opensightA" // on open sight, 1st gun pair
    FireAnimations(3)="shoot_opensightB" // on open sight, 2nd gun pair
    FireAnimations(4)="shoot_lookoverA"  // raised head, 1st gun pair
    FireAnimations(5)="shoot_lookoverB"  // raised head, 2nd gun pair
    SightBone="Sight_pivot"
}

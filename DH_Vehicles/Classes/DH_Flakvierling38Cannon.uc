//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Flakvierling38Cannon extends DH_Flak38Cannon;

var     byte        NextFiringBarrelIndex; // barrel no. that is due to fire next, so SpawnProjectile() can get location of barrel bone
var     name        BarrelBones[4];        // bone names for each
var     Emitter     FlashEmitters[4];      // we will have a separate flash emitter for each barrel
var     name        FireAnimations[6];     // alternating shoot anims for both 'open' & 'closed' positions, i.e. on the sights or with gunner's head raised

replication
{
    // Variables the server will replicate to clients when this actor is 1st replicated
    reliable if (bNetInitial && bNetDirty && Role == ROLE_Authority)
        NextFiringBarrelIndex; // after initial replication, the client should be able to keep track itself
}

// Modified to fire two projectiles from a pair of alternating barrels
function Fire(Controller C)
{
    local class<Projectile> ProjClass;

    // Spawn a projectile from the 1st barrel in the firing pair
    if (ProjectileClass == class'DHCannonShell_MixedMag')
    {
        ProjClass = SecondaryProjectileClass;
    }
    else
    {
        ProjClass = ProjectileClass;
    }

    SpawnProjectile(ProjClass, false);
    IncrementNextFiringBarrelIndex();

    // Spawn a projectile from the 2nd paired barrel, but this time skipping firing effects so we don't repeat them
    if (ProjectileClass == class'DHCannonShell_MixedMag')
    {
        ProjClass = TertiaryProjectileClass;
    }

    bSkipFiringEffects = true;
    SpawnProjectile(ProjClass, false);
    bSkipFiringEffects = false; // reset
    IncrementNextFiringBarrelIndex();
}

// Modified to get the firing location for the barrel that is next to fire
function vector GetProjectileFireLocation(class<Projectile> ProjClass)
{
    return GetBoneCoords(BarrelBones[NextFiringBarrelIndex]).Origin + ((WeaponFireOffset * vect(1.0, 0.0, 0.0)) >> WeaponFireRotation);
}

// Modified to handle fire effects & animations from alternating pairs of barrels (& EffectEmitter & CannonDustEmitterClass stuff omitted as not relevant to weapon)
simulated function FlashMuzzleFlash(bool bWasAltFire)
{
    local DHVehicleCannonPawn CannonPawn;
    local int                 FireAnimationIndex;

    if (Role == ROLE_Authority)
    {
        FiringMode = byte(bWasAltFire);
        ++FlashCount;
        NetUpdateTime = Level.TimeSeconds - 1.0;
    }
    else
    {
        CalcWeaponFire(bWasAltFire); // doubt net client needs this as only gets used to spawn EffectEmitter, which flakvierling doesn't have
    }

    if (Level.NetMode != NM_DedicatedServer && !bWasAltFire)
    {
        // Trigger a flash from both firing barrels
        if (FlashEmitters[NextFiringBarrelIndex] != none)
        {
            FlashEmitters[NextFiringBarrelIndex].Trigger(self, Instigator);
        }

        if (FlashEmitters[NextFiringBarrelIndex + 1] != none)
        {
            FlashEmitters[NextFiringBarrelIndex + 1].Trigger(self, Instigator);
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

        if (NextFiringBarrelIndex >= 2)
        {
            ++FireAnimationIndex; // shift anim index to no. 1/3/5 if 2nd barrel pair (barrels 2 & 3) are firing
        }

        if (FireAnimationIndex >= 0 && FireAnimationIndex < arraycount(FireAnimations) && HasAnim(FireAnimations[FireAnimationIndex]))
        {
            PlayAnim(FireAnimations[FireAnimationIndex]);
        }

        // Net client switches to the next barrel pair due to fire
        if (Role < ROLE_Authority)
        {
            if (NextFiringBarrelIndex < 2)
            {
                NextFiringBarrelIndex = 2;
            }
            else
            {
                NextFiringBarrelIndex = 0;
            }
        }
    }
}

// Modified to spawn a FlashEmitters for each of the barrels (& AmbientEffectEmitter stuff omitted as not relevant to weapon)
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

// New helper function to cycle to the next barrel number
function IncrementNextFiringBarrelIndex()
{
    NextFiringBarrelIndex = ++NextFiringBarrelIndex % arraycount(BarrelBones); // loops back to 0 when exceeds last barrel index
}

defaultproperties
{
    Mesh=SkeletalMesh'DH_Flak38_anm.flakvierling_turret'
    Skins(0)=Texture'DH_Artillery_tex.flakvierling.FlakVeirling38'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Artillery_stc.flakvierling.Flakvierling_turret_coll')
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
    GunWheels(2)=(BoneName="Sight_pivot")
}

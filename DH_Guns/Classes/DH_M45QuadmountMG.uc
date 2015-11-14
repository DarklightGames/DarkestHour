//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M45QuadmountMG extends DHVehicleMG;

var     name                        BarrelBones[4];           // bone names for 4 barrels
var     class<WeaponAmbientEmitter> BarrelEffectEmitterClass; // class for the barrel firing effect emitters
var     WeaponAmbientEmitter        BarrelEffectEmitter[4];   // separate emitter for each barrel, for muzzle flash & ejected shell cases

// Modified to ignore the Super in DHVehicleMG, which calculates whether to fire a tracer
// Because we have multiple barrels, we let SpawnProjectile handle tracers
state ProjectileFireMode
{
    function Fire(Controller C)
    {
        SpawnProjectile(ProjectileClass, false);
    }
}

// Modified to handle multiple barrel fire
function Projectile SpawnProjectile(class<Projectile> ProjClass, bool bAltFire)
{
    local Projectile P, LastProjectile;
    local vector     StartLocation, FireOffset, FireRotationVector;
    local rotator    FireRot;
    local int        VolleysFired, TracerIndex, i;

    // Just to avoid multiple calcs
    FireRotationVector = vector(WeaponFireRotation);
    FireOffset = (WeaponFireOffset * vect(1.0, 0.0, 0.0)) >> WeaponFireRotation;

    // Work out which barrel is due to fire a tracer
    // With 4 barrels & 1 in 5 tracer loading, it effectively rotates through each barrel & skips a tracer every 5th volley
    VolleysFired = InitialPrimaryAmmo - MainAmmoCharge[0] - 1;
    TracerIndex = VolleysFired % TracerFrequency;

    // Spawn a projectile from each barrel
    for (i = 0; i < arraycount(BarrelBones); ++i)
    {
        StartLocation = GetBoneCoords(BarrelBones[i]).Origin + FireOffset;
        FireRot = rotator(FireRotationVector + (VRand() * FRand() * Spread));

        // Switch to tracer class if this barrel matches the current TracerIndex for this volley
        if (i == TracerIndex && TracerProjectileClass != none)
        {
            P = Spawn(TracerProjectileClass, none,, StartLocation, FireRot);
        }
        else
        {
            P = Spawn(ProjClass, none,, StartLocation, FireRot);
        }

        if (P != none)
        {
            LastProjectile = P;
        }
    }

    // Play fire effects if we spawned a projectile (only play fire effects once)
    if (LastProjectile != none)
    {
        FlashMuzzleFlash(bAltFire);
        AmbientSound = FireSoundClass;
    }

    return LastProjectile;
}

// Modified so passed damage on to vehicle base, same as a vehicle cannon
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    // Suicide
    if (DamageType == class'Suicided' || DamageType == class'ROSuicided')
    {
        MGPawn.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, class'ROSuicided');
    }
    // Shell's ProcessTouch now calls TD here, but we count this as hit on vehicle itself, so we call TD on that
    else if (MGPawn.VehicleBase != none)
    {
        if (DamageType.default.bDelayedDamage && InstigatedBy != none)
        {
            MGPawn.VehicleBase.SetDelayedDamageInstigatorController(InstigatedBy.Controller);
        }

        MGPawn.VehicleBase.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }
}

// Modified to spawn & set up a separate BarrelEffectEmitter for each barrel
simulated function InitEffects()
{
    local int i;

    if (Level.NetMode != NM_DedicatedServer)
    {
        super.InitEffects();

        for (i = 0; i < arraycount(BarrelBones); ++i)
        {
            if (BarrelEffectEmitter[i] == none && BarrelEffectEmitterClass != none)
            {
                BarrelEffectEmitter[i] = Spawn(BarrelEffectEmitterClass, self);

                if (BarrelEffectEmitter[i] != none)
                {
                    AttachToBone(BarrelEffectEmitter[i], BarrelBones[i]);
                    BarrelEffectEmitter[i].SetRelativeLocation(WeaponFireOffset * vect(1.0, 0.0, 0.0));

                    // Hacky, but set the shell case emitter properties to suit this weapon, avoiding the need for separate classes
                    if (i == 0 || i == 2) // left side guns
                    {
                        BarrelEffectEmitter[i].Emitters[0].StartLocationOffset = vect(-77.0, 4.0, 2.0);
                        BarrelEffectEmitter[i].Emitters[0].StartVelocityRange.Y.Min = 0.0;
                        BarrelEffectEmitter[i].Emitters[0].StartVelocityRange.Y.Max = 10.0;
                    }
                    else // right side guns
                    {
                        BarrelEffectEmitter[i].Emitters[0].StartLocationOffset = vect(-77.0, -4.0, 2.0);
                        BarrelEffectEmitter[i].Emitters[0].StartVelocityRange.Y.Min = -10.0;
                        BarrelEffectEmitter[i].Emitters[0].StartVelocityRange.Y.Max = 0.0;
                    }
                }
            }
        }
    }
}

defaultproperties
{
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update the MG mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh
    bUseTankTurretRotation=true
    bRotateSoundFromPawn=true
    RotateSoundThreshold=750
    ProjectileClass=class'DH_Vehicles.DH_50CalVehicleBullet'
    InitialPrimaryAmmo=200 // 200 rounds in each ammo chest, so 800 rounds loaded in total - each trigger pull fires 4 rounds, 1 from each ammo cheat
    NumMags=2 // means we can reload 4 times & each reload is 4 ammo chests, so really the weapon starts with 20 ammo chests, including the 4 that are loaded
    FireInterval=0.133333 // 450 RPM
    TracerFrequency=5
    TracerProjectileClass=class'DH_Vehicles.DH_50CalVehicleTracerBullet'
    BarrelBones(0)="Barrel_TL"
    BarrelBones(1)="Barrel_TR"
    BarrelBones(2)="Barrel_BL"
    BarrelBones(3)="Barrel_BR"
    WeaponFireAttachmentBone="Barrel_TL" // a dummy really, replaced by individual BarrelBones - only used in CalcWeaponFire() to calc a nominal WeaponFireLocation
    hudAltAmmoIcon=texture'DH_Artillery_tex.ATGun_Hud.m45_ammo'
    bInstantFire=false
    WeaponFireOffset=0.0
    GunnerAttachmentBone="Gun"
    BeginningIdleAnim="idle_sights_in"
    bInstantRotation=true //false
    RotationsPerSecond=0.1667 // 60 degrees per second
    YawBone="Turret"
    PitchBone="Gun"
    CustomPitchUpLimit=9700    // 53 degrees elevation - reduced to stop feet poking through
    CustomPitchDownLimit=63716 // 10 degrees depression
    PitchUpLimit=20000
    PitchDownLimit=45000
    FireSoundClass=SoundGroup'DH_WeaponSounds.50Cal.50Cal_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.50Cal.50Cal_fire_end'
    AmbientSoundScaling=5.0
    AmbientEffectEmitterClass=class'DH_Guns.DH_M45QuadmountEmitterController' // isn't really an emitter; acts as a master controller for the 4 real BarrelEffectEmitters
    BarrelEffectEmitterClass=class'DH_Vehicles.DH_Vehicle50CalMGEmitter'      // this is the real emitter class
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)
    ShakeOffsetMag=(X=0.05,Y=0.0,Z=0.05)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)
    AIInfo(1)=(bLeadTarget=true,bFireOnRelease=true,AimError=800.0,RefireRate=0.133333)
    FireEffectClass=none // no hatch fire effect
    CullDistance=0.0 // override unwanted 8k from ROMountedTankMG
    bDoOffsetTrace=false
    Mesh=SkeletalMesh'DH_M45_anm.m45_turret'
    Skins(0)=texture'DH_Artillery_tex.m45.m45_gun'
    Skins(1)=material'DH_Artillery_tex.m45.m45_sight_s'
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockNonZeroExtentTraces=true
    bBlockZeroExtentTraces=true
}

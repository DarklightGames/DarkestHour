//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M45QuadmountMG extends DHVehicleMG;

var     byte                        FiringBarrelIndex;        // barrel no. that is due to fire next, so SpawnProjectile() can get location of barrel bone
var     name                        BarrelBones[4];           // bone names for 4 barrels
var     WeaponAmbientEmitter        BarrelEffectEmitter[4];   // separate emitter for each barrel, for muzzle flash & ejected shell cases
var     class<WeaponAmbientEmitter> BarrelEffectEmitterClass; // class for the barrel firing effect emitters

// Modified to reduce the allowed gun depression if mounted on an M16 halftrack, to stop it shooting its own vehicle
// Using this little hack just saves having separate M16 MG & MG pawn classes just for this
simulated function InitializeVehicleBase()
{
    super.InitializeVehicleBase();

    if (DH_M16Halftrack(Base) != none)
    {
        CustomPitchDownLimit = 65000;
    }
}

// Modified to handle multiple barrels firing
function Fire(Controller C)
{
    local int VolleysFired, TracerBarrelIndex;

    // Work out which barrel (if any) is due to fire a tracer
    // With 4 barrels & 1 in 5 tracer loading, it effectively rotates through each barrel & skips a tracer every 5th volley
    VolleysFired = InitialPrimaryAmmo - PrimaryAmmoCount() - 1;
    TracerBarrelIndex = VolleysFired % TracerFrequency;

    // Spawn a projectile from each barrel
    for (FiringBarrelIndex = 0; FiringBarrelIndex < arraycount(BarrelBones); ++FiringBarrelIndex)
    {
        if (FiringBarrelIndex == TracerBarrelIndex) // spawn tracer bullet if this barrel is the one that's due to fire a tracer
        {
            SpawnProjectile(TracerProjectileClass, false);
        }
        else
        {
            SpawnProjectile(ProjectileClass, false);
        }

        bSkipFiringEffects = true; // so we don't repeat firing effects after the 1st projectile
    }

    bSkipFiringEffects = false; // reset
}

// Modified to get the firing location for the barrel that is next to fire
function vector GetProjectileFireLocation(class<Projectile> ProjClass)
{
    return GetBoneCoords(BarrelBones[FiringBarrelIndex]).Origin + ((WeaponFireOffset * vect(1.0, 0.0, 0.0)) >> WeaponFireRotation);
}

// Modified to pass damage on to vehicle base, same as a vehicle cannon
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitIndex);

    if (Base != none)
    {
        if (DamageType.default.bDelayedDamage && InstigatedBy != none)
        {
            Base.SetDelayedDamageInstigatorController(InstigatedBy.Controller);
        }

        Base.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }
}

// Modified to spawn & set up a separate BarrelEffectEmitter for each barrel
simulated function InitEffects()
{
    local int i;

    super.InitEffects();

    if (Level.NetMode != NM_DedicatedServer)
    {
        for (i = 0; i < arraycount(BarrelBones); ++i)
        {
            if (BarrelEffectEmitter[i] == none && BarrelEffectEmitterClass != none)
            {
                BarrelEffectEmitter[i] = Spawn(BarrelEffectEmitterClass, self);

                if (BarrelEffectEmitter[i] != none)
                {
                    AttachToBone(BarrelEffectEmitter[i], BarrelBones[i]);
                    BarrelEffectEmitter[i].SetRelativeLocation(WeaponFireOffset * vect(1.0, 0.0, 0.0));

                    // A little hacky, but set the shell case emitter properties to suit this weapon, avoiding the need for separate classes
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

// Modified to destroy BarrelEffectEmitters
simulated function DestroyEffects()
{
    local int i;

    super.DestroyEffects();

    if (Level.NetMode != NM_DedicatedServer)
    {
        for (i = 0; i < arraycount(BarrelEffectEmitter); ++i)
        {
            if (BarrelEffectEmitter[i] != none)
            {
                BarrelEffectEmitter[i].Destroy();
            }
        }
    }
}

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_M45_anm.m45_turret'
    Skins(0)=Texture'DH_Artillery_tex.m45.m45_gun'
    Skins(1)=Material'DH_Artillery_tex.m45.m45_sight_s'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Artillery_stc.m45.m45_turret_coll')
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update the MG mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh
    BeginningIdleAnim="idle_sights_in"
    GunnerAttachmentBone="Gun"
    FireEffectClass=none // no hatch fire effect

    // Collision
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockNonZeroExtentTraces=true
    bBlockZeroExtentTraces=true

    // Movement
    bHasTurret=true
    bUseTankTurretRotation=true
    bRotateSoundFromPawn=true
    RotateSoundThreshold=750
    RotationsPerSecond=0.1667 // 60 degrees per second
    YawBone="Turret"
    bLimitYaw=false
    PitchBone="Gun"
    CustomPitchUpLimit=9700    // 53 degrees elevation - reduced to stop feet poking through
    CustomPitchDownLimit=63716 // 10 degrees depression

    // Ammo
    ProjectileClass=class'DH_Vehicles.DH_50CalVehicleBullet'
    InitialPrimaryAmmo=200 // 200 rounds in each ammo chest, so 800 rounds loaded in total - each trigger pull fires 4 rounds, 1 from each ammo cheat
    NumMGMags=2 // means we can reload 4 times & each reload is 4 ammo chests, so really the weapon starts with 20 ammo chests, including the 4 that are loaded
    FireInterval=0.133333 // 450 RPM
    TracerFrequency=5
    TracerProjectileClass=class'DH_Vehicles.DH_50CalVehicleTracerBullet'
    HudAltAmmoIcon=Texture'DH_Artillery_tex.ATGun_Hud.m45_ammo'

    // Weapon fire
    WeaponFireAttachmentBone="Barrel_TL" // a dummy really, replaced by individual BarrelBones - only used in CalcWeaponFire() to calc a nominal WeaponFireLocation
    BarrelBones(0)="Barrel_TL"
    BarrelBones(1)="Barrel_TR"
    BarrelBones(2)="Barrel_BL"
    BarrelBones(3)="Barrel_BR"
    WeaponFireOffset=0.0
    bDoOffsetTrace=false

    // Firing effects
    AmbientEffectEmitterClass=class'DH_Vehicles.DH_M45QuadmountEmitterController' // isn't really an emitter; acts as a master controller for the 4 real BarrelEffectEmitters
    BarrelEffectEmitterClass=class'DH_Vehicles.DH_Vehicle50CalMGEmitter'      // this is the real emitter class
    FireSoundClass=SoundGroup'DH_WeaponSounds.50Cal.Quad50Cal_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.50Cal.50Cal_fire_end'
    AmbientSoundScaling=5.0
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)
    ShakeOffsetMag=(X=0.05,Y=0.0,Z=0.05)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M45QuadmountMG extends DHVehicleMG;

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

function InitEffects()
{
    local int i;
    local WeaponAmbientEmitter Emitter;
    
    super.InitEffects();

    for (i = 0; i < Barrels.Length; ++i)
    {
        Emitter = Barrels[i].EffectEmitter;

        if (Emitter == none)
        {
            continue;
        }

        // A little hacky, but set the shell case emitter properties to suit this weapon, avoiding the need for separate classes
        if (i == 0 || i == 2) // left side guns
        {
            Emitter.Emitters[0].StartLocationOffset = vect(-77.0, 4.0, 2.0);
            Emitter.Emitters[0].StartVelocityRange.Y.Min = 0.0;
            Emitter.Emitters[0].StartVelocityRange.Y.Max = 10.0;
        }
        else // right side guns
        {
            Emitter.Emitters[0].StartLocationOffset = vect(-77.0, -4.0, 2.0);
            Emitter.Emitters[0].StartVelocityRange.Y.Min = -10.0;
            Emitter.Emitters[0].StartVelocityRange.Y.Max = 0.0;
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
    FireEffectOffset=(X=-25.0,Y=0.0,Z=-10.0)
    FireEffectScale=0.60

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

    bHasMultipleBarrels=true
    Barrels(0)=(MuzzleBone="Barrel_TL",EffectEmitterClass=class'DH_Vehicles.DH_Vehicle50CalMGEmitter')
    Barrels(1)=(MuzzleBone="Barrel_TR",EffectEmitterClass=class'DH_Vehicles.DH_Vehicle50CalMGEmitter')
    Barrels(2)=(MuzzleBone="Barrel_BL",EffectEmitterClass=class'DH_Vehicles.DH_Vehicle50CalMGEmitter')
    Barrels(3)=(MuzzleBone="Barrel_BR",EffectEmitterClass=class'DH_Vehicles.DH_Vehicle50CalMGEmitter')

    WeaponFireOffset=0.0
    bDoOffsetTrace=false

    // Firing effects
    AmbientEffectEmitterClass=class'DH_Vehicles.DH_VehicleMGMultiBarrelEmitterController' // isn't really an emitter; acts as a master controller for the 4 real BarrelEffectEmitters
    FireSoundClass=SoundGroup'DH_WeaponSounds.50Cal.Quad50Cal_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.50Cal.50Cal_fire_end'
    AmbientSoundScaling=5.0
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)
    ShakeOffsetMag=(X=0.05,Y=0.0,Z=0.05)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)

    // Reload
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.M45_reload',Duration=14) 
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.M45_reload',Duration=14)
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.M45_reload',Duration=14)
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.M45_reload',Duration=14)
}
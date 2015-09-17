//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMortarProjectileHE extends DHMortarProjectile
    abstract;

// Sounds
var array<sound> GroundExplosionSounds;
var array<sound> WaterExplosionSounds;
var array<sound> AirExplosionSounds;
var array<sound> SnowExplosionSounds;

// Emitter classes
var class<Emitter> AirExplosionEmitterClass;
var class<Emitter> GroundExplosionEmitterClass;
var class<Emitter> SnowExplosionEmitterClass;
var class<Emitter> WaterExplosionEmitterClass;

// Camera shaking
var vector              ShakeRotMag;      // how far to rot view
var vector              ShakeRotRate;     // how fast to rot view
var float               ShakeRotTime;     // how much time to rot the instigator's view
var vector              ShakeOffsetMag;   // max view offset vertically
var vector              ShakeOffsetRate;  // how fast to offset view vertically
var float               ShakeOffsetTime;  // how much time to offset view
var float               BlurTime;         // How long blur effect should last for this shell
var float               BlurEffectScalar;

simulated function GetExplosionEmitterClass(out class<Emitter> ExplosionEmitterClass, ESurfaceTypes SurfaceType)
{
    switch (SurfaceType)
    {
        case EST_Ice:
            ExplosionEmitterClass = SnowExplosionEmitterClass;
            return;

        case EST_Snow:
            ExplosionEmitterClass = SnowExplosionEmitterClass;
            return;

        case EST_Water:
            ExplosionEmitterClass = WaterExplosionEmitterClass;
            return;

        default:
            ExplosionEmitterClass = GroundExplosionEmitterClass;
            return;
    }
}

simulated function GetExplosionSound(out sound ExplosionSound, ESurfaceTypes SurfaceType)
{
    switch (SurfaceType)
    {
        case EST_Ice:
            ExplosionSound = SnowExplosionSounds[Rand(SnowExplosionSounds.Length)];
            return;

        case EST_Snow:
            ExplosionSound = SnowExplosionSounds[Rand(SnowExplosionSounds.Length)];
            return;

        case EST_Water:
            ExplosionSound = WaterExplosionSounds[Rand(WaterExplosionSounds.Length)];
            return;

        default:
            ExplosionSound = GroundExplosionSounds[Rand(GroundExplosionSounds.Length)];
            return;
    }
}

simulated function GetExplosionDecalClass(out class<Projector> ExplosionDecalClass, ESurfaceTypes SurfaceType)
{
    switch (SurfaceType)
    {
        case EST_Ice:
            ExplosionDecalClass = ExplosionDecalSnow;
            return;

        case EST_Snow:
            ExplosionDecalClass = ExplosionDecalSnow;
            return;

        default:
            ExplosionDecalClass = ExplosionDecal;
            return;
    }
}

simulated function BlowUp(vector HitLocation)
{
    local ESurfaceTypes    HitSurfaceType;
    local class<Emitter>   ExplosionEmitterClass;
    local class<Projector> ExplosionDecalClass;
    local sound            ExplosionSound;

    super.BlowUp(HitLocation);

    GetHitSurfaceType(HitSurfaceType);
    GetExplosionEmitterClass(ExplosionEmitterClass, HitSurfaceType);
    GetExplosionDecalClass(ExplosionDecalClass, HitSurfaceType);
    GetExplosionSound(ExplosionSound, HitSurfaceType);
    Spawn(ExplosionEmitterClass, self,, HitLocation);
    Spawn(ExplosionDecalClass, self,, HitLocation, rotator(vect(0.0, 0.0, -1.0)));
    PlaySound(ExplosionSound,, 6.0 * TransientSoundVolume, false, 5248.0, 1.0, true);
    DoShakeEffect();
}

// Explode in water
simulated function PhysicsVolumeChange(PhysicsVolume NewVolume)
{
    if (NewVolume.bWaterVolume)
    {
        Explode(Location, vect(0.0, 0.0, 1.0));
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    local DHVolumeTest VT;

    VT = Spawn(class'DHVolumeTest',,, HitLocation);

    if (VT.IsInNoArtyVolume())
    {
        bDud = true;
    }

    VT.Destroy();

    if (bDud)
    {
        DoHitEffects(HitLocation, HitNormal);
        Destroy();

        return;
    }

    super.Explode(HitLocation, HitNormal);

    Destroy();
}

simulated function DoShakeEffect()
{
    local PlayerController PC;
    local float Dist, Scale;

    if (Level.NetMode != NM_DedicatedServer)
    {
        PC = Level.GetLocalPlayerController();

        if (PC != none && PC.ViewTarget != none)
        {
            Dist = VSize(Location - PC.ViewTarget.Location);

            if (Dist < DamageRadius * 2.0)
            {
                Scale = (DamageRadius * 2.0  - Dist) / (DamageRadius * 2.0);
                Scale *= BlurEffectScalar;

                PC.ShakeView(ShakeRotMag * Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag * Scale, ShakeOffsetRate, ShakeOffsetTime);

                ROPlayer(PC).AddBlur(BlurTime * Scale, FMin(1.0, Scale));
            }
        }
    }
}

simulated function Destroyed()
{
    if (!bDud && Role == ROLE_Authority)
    {
        DelayedHurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, Location);
    }

    super.Destroyed();
}

defaultproperties
{
    MyDamageType=class'DH_Engine.DHMortarDamageType'
    AirExplosionEmitterClass=class'DH_Effects.DH_MortarImpact60mm'
    GroundExplosionEmitterClass=class'DH_Effects.DH_MortarImpact60mm'
    SnowExplosionEmitterClass=class'DH_Effects.DH_MortarImpact60mm'
    WaterExplosionEmitterClass=class'ROEffects.ROArtilleryWaterEmitter'
    ExplosionDecal=class'ROEffects.ArtilleryMarkDirt'
    ExplosionDecalSnow=class'ROEffects.ArtilleryMarkSnow'
    MomentumTransfer=75000.0
    ShakeRotMag=(Z=100.0)
    ShakeRotRate=(Z=2500.0)
    ShakeRotTime=3.0
    ShakeOffsetMag=(Z=5.0)
    ShakeOffsetRate=(Z=200.0)
    ShakeOffsetTime=5.0
}

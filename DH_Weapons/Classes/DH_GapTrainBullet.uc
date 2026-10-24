//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_GapTrainBullet extends DHCannonShell;

defaultproperties
{
    CollisionRadius=90.000000    
    CollisionHeight=90.000000    

    bCollideActors=True
    bCollideWorld=True
    
    bBlockActors=False
    bBlockPlayers=False

    Speed=4550.0 
    MaxSpeed=6220.0
    ShellDiameter=355.2
    BallisticCoefficient=0.1 
    SpeedFudgeScale=0.8

    //Damage
    ImpactDamage=30000
    Damage=2200.0
    DamageRadius=1100.0
    MyDamageType=Class'DHShellHE105mmDamageType' 
    PenetrationMag=1500.0
    HullFireChance=1.0
    EngineFireChance=1.0

    //Effects
    DrawScale=1.0
    StaticMesh=StaticMesh'DH_UFO_stc.Train.et165_shell'
    CoronaClass=none
    ShellTrailClass=none
    ShellDeflectEffectClass=Class'ROArtilleryDirtEmitter'
    ShellHitDirtEffectClass=Class'ROArtilleryDirtEmitter'
    ShellHitSnowEffectClass=Class'ROArtillerySnowEmitter'
    ShellHitWoodEffectClass=Class'ROArtilleryDirtEmitter'
    ShellHitRockEffectClass=Class'ROArtilleryDirtEmitter'
    ShellHitWaterEffectClass=Class'ROArtilleryWaterEmitter'

    ExplosionDecal=Class'ArtilleryMarkDirt'
    ExplosionDecalSnow=Class'ArtilleryMarkSnow'

    BlurEffectScalar=3.0 // gives this large HE shell more screen blur

    //Sound
    TransientSoundRadius=3000.0
    ExplosionSound(0)=Sound'ProjectileSounds.cannon_rounds.vehicle_explode011'
    ExplosionSound(1)=Sound'ProjectileSounds.cannon_rounds.vehicle_explode021'
    ExplosionSound(2)=Sound'ProjectileSounds.cannon_rounds.vehicle_explode031'
    ExplosionSound(3)=Sound'ProjectileSounds.cannon_rounds.vehicle_explode041'

    //Sound
    AmbientSound=Sound'DH_UFO_snd.UFO.Train'
    AmbientVolumeScale=5.0 //5.0
    SoundVolume=255 // full volume
    SoundRadius=250.0 // about 300m - was SoundRadius=700 or about 1,1 km
    TransientSoundVolume=1.0 //Explosion Sound - full volume
    ExplosionSoundVolume=1.0 //full volume

    bDebugInImperial=false

    //Penetration
    DHPenetrationTable(0)=90.0  // 100m
    DHPenetrationTable(1)=80.4  // 250m
    DHPenetrationTable(2)=70.9  // 500m
    DHPenetrationTable(3)=70.4
    DHPenetrationTable(4)=70.0  // 1000m
    DHPenetrationTable(5)=60.6
    DHPenetrationTable(6)=60.2  // 1500m
    DHPenetrationTable(7)=50.8
    DHPenetrationTable(8)=50.2  // 2000m
    DHPenetrationTable(9)=40.6
    DHPenetrationTable(10)=40.0 // 3000m


}

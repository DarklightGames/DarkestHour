//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVehicleDamagedEffect extends VehicleDamagedEffect;

//Overriden to add cook-off sparks (DH)
simulated event UpdateDamagedEffect(bool bFlame, float VelMag, bool bMediumSmoke, bool bHeavySmoke)
{
    if (bFlame)
    {
        //fire
        Emitters[1].ParticlesPerSecond = default.Emitters[1].ParticlesPerSecond;
        Emitters[1].InitialParticlesPerSecond = default.Emitters[1].InitialParticlesPerSecond;
        Emitters[1].AllParticlesDead = false;

        //smoke
        Emitters[2].ParticlesPerSecond = 4;
        Emitters[2].InitialParticlesPerSecond = 4;
        Emitters[2].LifetimeRange.Min = 8.0;
        Emitters[2].LifetimeRange.Max = 8.0;
        Emitters[2].AllParticlesDead = false;

        //kill any light smoke
        Emitters[0].ParticlesPerSecond = 0;
        Emitters[0].InitialParticlesPerSecond = 0;

        //sparks
        Emitters[3].ParticlesPerSecond = default.Emitters[3].ParticlesPerSecond;
        Emitters[3].InitialParticlesPerSecond = default.Emitters[3].InitialParticlesPerSecond;
        Emitters[3].AllParticlesDead = false;
    }
    else if (bHeavySmoke)
    {
        Emitters[2].ParticlesPerSecond = 2;
        Emitters[2].InitialParticlesPerSecond = 2;
        Emitters[2].LifetimeRange.Min = 6.0;
        Emitters[2].LifetimeRange.Max = 6.0;
        Emitters[2].AllParticlesDead = false;

        Emitters[0].ParticlesPerSecond = 0;
        Emitters[0].InitialParticlesPerSecond = 0;
    }
    else if (bMediumSmoke)
    {
        Emitters[0].ParticlesPerSecond = 3;
        Emitters[0].InitialParticlesPerSecond = 3;
        Emitters[0].LifetimeRange.Min = 6.0;
        Emitters[0].LifetimeRange.Max = 6.0;
        Emitters[0].AllParticlesDead = false;
    }
    else
    {
        Emitters[0].ParticlesPerSecond = 1;
        Emitters[0].InitialParticlesPerSecond = 1;
        Emitters[0].LifetimeRange.Min = 4.0;
        Emitters[0].LifetimeRange.Max = 4.0;
        Emitters[0].AllParticlesDead = false;

        Emitters[1].ParticlesPerSecond = 0;
        Emitters[1].InitialParticlesPerSecond = 0;

        Emitters[2].ParticlesPerSecond = 0;
        Emitters[2].InitialParticlesPerSecond = 0;
    }
}

defaultproperties
{
    Begin Object Class=SparkEmitter Name=SparkEmitter0
        LineSegmentsRange=(Min=1.000000,Max=2.000000)
        TimeBeforeVisibleRange=(Min=1.000000,Max=10.000000)
        TimeBetweenSegmentsRange=(Min=0.050000,Max=0.050000)
        FadeOut=True
        AutomaticInitialSpawning=False
        //Acceleration=(Z=-200.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.5
        MaxParticles=30
        StartLocationOffset=(Z=2.000000)
        InitialParticlesPerSecond=5.000000
        Texture=Texture'Effects_Tex.explosions.fire_quad'
        LifetimeRange=(Min=1.000000,Max=2.0)
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=50.000000,Max=100.000000))
    End Object
    Emitters(3)=SparkEmitter'SparkEmitter0'
}

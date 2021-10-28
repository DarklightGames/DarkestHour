class DHMuzzleFlash3rdPistol extends ROMuzzleFlash3rd;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    if (FRand() < 0.5)
    {
        Emitters[1].Opacity = 0.0;
        Emitters[4].Opacity = 0.0;
    }
    else
    {
        Emitters[1].Opacity= 0.35;
        Emitters[4].Opacity= 0.35;
    }

    Emitters[0].SpawnParticle(1);
    Emitters[1].SpawnParticle(1);
    Emitters[2].SpawnParticle(8);
    Emitters[2].InitialParticlesPerSecond=100;
    Emitters[3].SpawnParticle(6);
    Emitters[4].SpawnParticle(1);
}

defaultproperties
{
   Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        RespawnDeadParticles=False
        SpinParticles=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        CoordinateSystem=PTCS_Relative
        MaxParticles=1
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        StartSizeRange=(X=(Min=1.0000,Max=1.500))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        SubdivisionScale(0)=0.500000
        LifetimeRange=(Min=0.200000,Max=0.200000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=BeamEmitter Name=BeamEmitter1
        FadeOut=true
        BeamDistanceRange=(Min=25.000000,Max=50.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=1
        RespawnDeadParticles=False
        UseSizeScale=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=200,G=200,R=200,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=200,G=200,R=200,A=255))
        FadeOutStartTime=0.150000
        Opacity=0.2
        MaxParticles=1
        name="spike_smoke"
        StartLocationOffset=(X=-4.000000)
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.5000000)
        StartSizeRange=(X=(Min=2.000000,Max=5.000000),Y=(Min=2.000000,Max=5.000000),Z=(Min=25.000000))
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=0.1500000,Max=0.20000)
        StartVelocityRange=(X=(Min=300.000000,Max=500.000000))
    End Object
    Emitters(1)=BeamEmitter'BeamEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter6
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        UseVelocityScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.75
        FadeOutStartTime=0.25
        MaxParticles=64
        Name="gun_smoke"
        StartLocationRange=(X=(Min=-5.0,Max=20.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.500000)
        StartSizeRange=(X=(Min=6.000000,Max=8.000000))
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.metalsmokefinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.55,Max=0.95)
        StartVelocityRange=(X=(Min=50.000000,Max=100.0),Y=(Min=-10.0000,Max=15.000),Z=(Min=-15.000,Max=10.000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.500000,RelativeVelocity=(X=0.200000,Y=0.700000,Z=0.700000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter6'

    Begin Object Class=SparkEmitter Name=SparkEmitter0
        LineSegmentsRange=(Min=0.50000,Max=1.000000)
        TimeBetweenSegmentsRange=(Min=0.050000,Max=0.1000)
        RespawnDeadParticles=False
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=0,G=165,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.5
        MaxParticles=6
        name="sparks"
        StartLocationRange=(X=(Min=0.00000,Max=2.000000))
        UseRotationFrom=PTRS_ACtor
        Texture=Texture'Effects_Tex.explosions.fire_quad'
        LifetimeRange=(Min=0.100000,Max=0.150000)
        StartVelocityRange=(X=(Min=100.000000,Max=150.000000),Y=(Min=-30.000000,Max=35.000000),Z=(Min=-35.000000,Max=25.000000))
    End Object
    Emitters(3)=SparkEmitter'SparkEmitter0'

    Begin Object Class=BeamEmitter Name=BeamEmitter0
        BeamDistanceRange=(Min=5.000000,Max=10.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=3
        RespawnDeadParticles=False
        UseSizeScale=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        CoordinateSystem=PTCS_Relative
        MaxParticles=1
        Name="spike_flash"
        UseRotationFrom=PTRS_Normal
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=5.000000,Max=8.000000),Y=(Min=5.000000,Max=8.000000),Z=(Min=5.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'DH_FX_Tex.weapons.pistolflash'
        LifetimeRange=(Min=0.05,Max=0.10000)
        StartVelocityRange=(X=(Min=25.000000,Max=50.000000))
    End Object
    Emitters(4)=BeamEmitter'BeamEmitter0'
}

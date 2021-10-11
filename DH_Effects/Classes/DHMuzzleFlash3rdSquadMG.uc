class DHMuzzleFlash3rdSquadMG extends ROMuzzleFlash3rd;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    Emitters[0].SpawnParticle(1);
    Emitters[1].SpawnParticle(1);
    Emitters[2].SpawnParticle(1);
    Emitters[3].SpawnParticle(8);
    Emitters[4].SpawnParticle(1);
    Emitters[5].SpawnParticle(6);
}

defaultproperties
{
   Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=False
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        Opacity=0.75
        CoordinateSystem=PTCS_Relative
        Name="muzzle_flash"
        StartLocationOffset=(X=2.000000)
        StartLocationRange=(X=(Min=2.00000,Max=4.000000))
        StartLocationShape=PTLS_Sphere
        UseRotationFrom=PTRS_Normal
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=1.0,Max=3.500000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.STGmuzzleflash_4frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.100000,Max=0.100000)
        End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    //we should replace this with an actual dynamic light flash like the infantry weps
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        RespawnDeadParticles=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Opacity=0.100000
        DrawStyle=PTDS_Brighten
        MaxParticles=30// 1
        Name="strobe"
        UseRotationFrom=PTRS_Actor
        //StartLocationShape=PTLS_Sphere
        StartSizeRange=(X=(Min=5.000000,Max=25.000000))
        Texture=Texture'Effects_Tex.Smoke.MuzzleCorona1stP'
        LifetimeRange=(Min=0.100000,Max=0.100000)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=BeamEmitter Name=BeamEmitter1
        FadeOut=true
        BeamDistanceRange=(Min=0.000000,Max=150.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=2
        RespawnDeadParticles=False
        UseSizeScale=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=200,G=200,R=200,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=200,G=200,R=200,A=255))
        FadeOutStartTime=0.150000
        Opacity=0.35
        MaxParticles=1
        name="spike_smoke"
        StartLocationOffset=(X=-2.000000)
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.5000000)
        StartSizeRange=(X=(Min=10.000000,Max=20.000000),Y=(Min=10.000000,Max=20.000000),Z=(Min=0.000000))
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=0.1500000,Max=0.20000)
        StartVelocityRange=(X=(Min=300.000000,Max=500.000000),Y=(Min=-5.000000,Max=10.000000),Z=(Min=-10.000000,Max=5.000000))
    End Object
    Emitters(2)=BeamEmitter'BeamEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter6
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        //Acceleration=(Z=-50.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.35
        FadeOutStartTime=0.25
        MaxParticles=100//64
        Name="gun_smoke"
        //StartLocationOffset=(X=15.000000)
        StartLocationRange=(X=(Min=-5.0,Max=50.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.500000)
        StartSizeRange=(X=(Min=10.000000,Max=15.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.MP3rdPmuzzle_smoke1frame'
        InitialParticlesPerSecond=100
        LifetimeRange=(Min=0.55,Max=1.2)
        StartVelocityRange=(X=(Min=100.000000,Max=300.0),Y=(Min=-25.0000,Max=20.000),Z=(Min=-20.000,Max=25.000))
        VelocityLossRange=(X=(Max=1.000000)) //2.0
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter6'

    Begin Object Class=BeamEmitter Name=BeamEmitter0
        BeamDistanceRange=(Min=0.000000,Max=150.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=2
        RespawnDeadParticles=False
        UseSizeScale=True
        AutomaticInitialSpawning=False
        //ColorMultiplierRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=0.400000,Max=0.400000),Z=(Min=0.300000,Max=0.300000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.25
        MaxParticles=1
        name="spike_flash"
        StartLocationOffset=(X=2.000000)
        //StartLocationRange=(X=(Min=0.0,Max=5.000000))
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.5000000)
        StartSizeRange=(X=(Min=6.000000,Max=12.000000),Y=(Min=6.000000,Max=12.000000),Z=(Min=0.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.explosions.fire_quad'
        LifetimeRange=(Min=0.05,Max=0.10000)
        StartVelocityRange=(X=(Min=300.000000,Max=500.000000),Y=(Min=-5.000000,Max=8.000000),Z=(Min=-8.000000,Max=5.000000))
    End Object
    Emitters(4)=BeamEmitter'BeamEmitter0'

    Begin Object Class=SparkEmitter Name=SparkEmitter0
        LineSegmentsRange=(Min=0.500000,Max=1.000000)
        TimeBetweenSegmentsRange=(Min=0.030000,Max=0.07000)
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=0,G=165,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.75
        MaxParticles=6
        name="sparks"
        StartLocationRange=(X=(Min=2.00000,Max=4.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.25)
        InitialParticlesPerSecond=1000.000000
        UseRotationFrom=PTRS_Actor
        Texture=Texture'Effects_Tex.explosions.fire_quad'
        LifetimeRange=(Min=0.100000,Max=0.100000)
        StartVelocityRange=(X=(Min=20.000000,Max=100.000000),Y=(Min=-30.000000,Max=35.000000),Z=(Min=-35.000000,Max=25.000000))
    End Object
    Emitters(5)=SparkEmitter'SparkEmitter0'
}

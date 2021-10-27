class DHMuzzleFlash3rdFG42 extends ROMuzzleFlash3rd;

//Special muzzle effect class for FG42 due to misalignment of 'tip' bone

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    if (FRand() < 0.6)
    {
        Emitters[3].Opacity = 0.0;
    }
    else Emitters[3].Opacity= 0.4;

    Emitters[0].SpawnParticle(1);
    Emitters[1].SpawnParticle(1);
    Emitters[2].SpawnParticle(8);
    Emitters[2].InitialParticlesPerSecond=100;
    Emitters[3].SpawnParticle(1);
    Emitters[4].SpawnParticle(6);
    Emitters[5].SpawnParticle(1);
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
        StartLocationRange=(X=(Min=1.00000,Max=3.000000))
        StartLocationShape=PTLS_Sphere
        UseRotationFrom=PTRS_Normal
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=3.0,Max=5.00000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        SubdivisionScale(0)=0.500000
        LifetimeRange=(Min=0.100000,Max=0.100000)
        StartVelocityRange=(X=(Min=10.000000,Max=25.000000))
        End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=BeamEmitter Name=BeamEmitter1
        FadeOut=true
        BeamDistanceRange=(Min=80.000000,Max=120.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=2
        RespawnDeadParticles=False
        UseSizeScale=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=200,G=200,R=200,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=200,G=200,R=200,A=255))
        FadeOutStartTime=0.150000
        Opacity=0.35
        CoordinateSystem=PTCS_Relative
        MaxParticles=1
        name="spike_smoke"
        UseRotationFrom=PTRS_Normal
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.5000000)
        StartSizeRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=80.000000))
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
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.35
        FadeOutStartTime=0.25
        MaxParticles=64
        Name="gun_smoke"
        StartLocationRange=(X=(Min=-15.0,Max=20.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.500000)
        StartSizeRange=(X=(Min=10.000000,Max=15.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.MP3rdPmuzzle_smoke1frame'
        LifetimeRange=(Min=0.55,Max=1.2)
        StartVelocityRange=(X=(Min=100.000000,Max=300.0),Y=(Min=-25.0000,Max=20.000),Z=(Min=-20.000,Max=25.000))
        VelocityLossRange=(X=(Max=1.000000)) //2.0
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter6'

    Begin Object Class=BeamEmitter Name=BeamEmitter0
        BeamDistanceRange=(Min=50.000000,Max=95.000000)
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
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.5000000)
        StartSizeRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=50.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.explosions.fire_quad'
        LifetimeRange=(Min=0.05,Max=0.10000)
        StartVelocityRange=(X=(Min=25.000000,Max=50.000000))
    End Object
    Emitters(3)=BeamEmitter'BeamEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter80
        UseDirectionAs=PTDU_UpAndNormal
        ProjectionNormal=(X=1.000000,Y=0.500000)
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=64,G=128,R=255,A=255))
        ColorScaleRepeats=4
        MaxParticles=64
        name="sparks"
        SpinsPerSecondRange=(X=(Min=5.00000,Max=10.000000))
        StartSpinRange=(X=(Min=-0.500000,Max=1.000000))
        StartSizeRange=(X=(Min=0.55,Max=0.75))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Smoke.Sparks'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.15,Max=0.2)
        StartVelocityRange=(X=(Min=150.000000,Max=250.000000),Y=(Min=-10.000000,Max=15.000000),Z=(Min=-15.000000,Max=10.000000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter80'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter16
        FadeOut=True
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        UseVelocityScale=True
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128))
        Opacity=0.75
        CoordinateSystem=PTCS_Relative
        Name="barrel_puff"
        FadeOutStartTime=0.15
        UseRotationFrom=PTRS_Normal
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=0.200000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=25.000000,Max=50.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.MP3rdPmuzzle_smoke1frame'
        LifetimeRange=(Min=0.35,Max=0.5500000)
        StartVelocityRange=(X=(Min=-15.000000,Max=5.000000))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter16'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBulletHitMudEffectLarge extends emitter;

//particles: 31

var texture Impacts[4];

simulated function PostBeginPlay()
{
    Emitters[0].Texture = Impacts[Rand(4)];
    Super.PostBeginPlay();
}

defaultproperties
{
    Impacts(0)=Texture'DH_FX_Tex.Effects.MudImpact01'
    Impacts(1)=Texture'DH_FX_Tex.Effects.MudImpact02'
    Impacts(2)=Texture'DH_FX_Tex.Effects.MudImpact03'
    Impacts(3)=Texture'DH_FX_Tex.Effects.MudImpact04'

    Begin Object Class=BeamEmitter Name=BeamEmitter4
        FadeOut=true
        BeamDistanceRange=(Min=85.000000,Max=100.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=2
        UseColorScale=True
        RespawnDeadParticles=False
        AutoDestroy=True
        AutomaticInitialSpawning=False
        StartLocationOffset=(X=-4.000000)
        ColorScale(0)=(Color=(B=34,G=46,R=51,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=34,G=46,R=51,A=255))
        Opacity=0.85
        FadeOutStartTime=0.1
        MaxParticles=1
        Name="impact"
        UseRotationFrom=PTRS_Actor
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=30.000000,Max=45.000000),Y=(Min=35.000000,Max=45.000000),Z=(Min=85.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        LifetimeRange=(Min=0.150000,Max=0.250000)
        StartVelocityRange=(X=(Min=300.000000,Max=600.000000),Y=(Min=-75.000000,Max=85.000000),Z=(Min=-85.000000,Max=75.000000))
    End Object
    Emitters(0)=BeamEmitter'BeamEmitter4'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter27
        UseDirectionAs=PTDU_Normal
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-10.000000)
        DampingFactorRange=(X=(Min=0.150000,Max=0.250000),Y=(Min=0.150000,Max=0.250000),Z=(Min=0.150000,Max=0.250000))
        ColorScale(0)=(Color=(B=42,G=54,R=59,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=59,G=76,R=85,A=255))
        MaxParticles=3
        Name="base_chunks"
        //StartLocationOffset=(X=5.000000)
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        RotationNormal=(Z=1.000000)
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=10.000000,Max=12.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.debris.genericchunks'
        LifetimeRange=(Min=0.150000,Max=0.300000)
        StartVelocityRange=(Y=(Min=-10.000000,Max=12.000000),Z=(Min=-10.000000,Max=12.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter27'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter28
        UseCollision=True
        UseMaxCollisions=True
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-800.000000)
        ExtentMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
        DampingFactorRange=(X=(Min=0.150000,Max=0.250000),Y=(Min=0.150000,Max=0.250000),Z=(Min=0.150000,Max=0.250000))
        ColorScale(0)=(Color=(B=42,G=54,R=59,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=59,G=76,R=85,A=255))
        FadeOutStartTime=0.150000
        MaxParticles=7
        Name="random_chunks"
        StartLocationOffset=(X=10.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.150000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.5)
        StartSizeRange=(X=(Min=10.000000,Max=25.000000),Y=(Min=10.000000,Max=25.000000),Z=(Min=300.000000,Max=300.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.debris.genericchunkssparse'
        LifetimeRange=(Min=1.25000,Max=3.00000)
        StartVelocityRange=(X=(Min=275.000000,Max=300.000000),Y=(Min=-95.000000,Max=105.000000),Z=(Min=-110.000000,Max=95.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter28'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter18
        UseColorScale=True
        //FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-400.000000)
        DampingFactorRange=(X=(Min=0.150000,Max=0.250000),Y=(Min=0.150000,Max=0.250000),Z=(Min=0.150000,Max=0.250000))
        ColorScale(0)=(Color=(B=34,G=46,R=51,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=34,G=46,R=51,A=255))
        //FadeOutStartTime=0.150000
        MaxParticles=15
        Name="main_chunks"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.200000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.500000)
        StartSizeRange=(X=(Min=1.000000,Max=3.250000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.snowchunksfinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.50000,Max=0.750000)
        StartVelocityRange=(X=(Min=100.000000,Max=325.000000),Y=(Min=-225.000000,Max=175.000000),Z=(Min=-180.000000,Max=200.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter18'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter10
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-800.0)
        ColorScale(0)=(Color=(B=42,G=54,R=59,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=59,G=76,R=85,A=255))
        FadeOutStartTime=0.10000
        MaxParticles=4
        Name="ground_splash"
        StartLocationRange=(X=(Min=-10.000000,Max=5.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.150000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=15.000000,Max=25.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.snowfinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.150000,Max=0.3500000)
        StartVelocityRange=(X=(Min=5.000000,Max=75.000000),Y=(Min=-35.000000,Max=40.000000),Z=(Min=-35.000000,Max=40.000000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter10'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter30
        UseColorScale=true
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=34,G=46,R=51,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=34,G=46,R=51,A=255))
        //Opacity=0.85
        FadeOutStartTime=0.150000
        MaxParticles=1
        Name="burst"
        UseRotationFrom=PTRS_Actor
        StartLocationOffset=(X=10.000000)
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.10000))
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.00000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.500000)
        StartSizeRange=(X=(Min=45.000000,Max=65.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.blood.blood_spatter1'
        InitialDelayRange=(Min=0.05000,Max=0.100000)
        LifetimeRange=(Min=0.350000,Max=0.450000)
        StartVelocityRange=(X=(Min=5.000000,Max=10.000000))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter30'

    Autodestroy=true
    bnodelete=false
}

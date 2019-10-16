//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHVehicleObliteratedEmitter extends Emitter; // this class is not used (as at December 2016) & vehicles use the 'ROVehicleDestroyedEmitter' effectclass DHVehicleObliteratedEmtter extends Emitter;

defaultproperties
{
    AutoDestroy=true
    bNoDelete=false
    LifeSpan=8.0
    Style=STY_Masked
    bHardAttach=true

    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=false
        UseColorScale=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=false
        Acceleration=(X=-50.000000,Y=0.000000,Z=50.000000) //10
        ColorScale(0)=(Color=(B=75,G=75,R=75,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=51,G=128,R=189,A=255))
        Opacity=0.590000
        name="main_smoke"
        FadeOutStartTime=15.0
        FadeInEndTime=0.32
        MaxParticles=100
        StartLocationOffset=(Z=100.000000)
        StartLocationRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=60.000000,Max=60.000000))
        RotationOffset=(Pitch=5097,Yaw=9102,Roll=13107)
        SpinCCWorCW=(X=1.000000,Y=1.000000,Z=1.000000)
        SpinsPerSecondRange=(X=(Max=0.010000),Y=(Max=0.100000),Z=(Min=1.000000,Max=1.000000))
        StartSpinRange=(X=(Min=8000.000000,Max=12000.000000),Y=(Min=16000.000000,Max=20000.000000),Z=(Min=9000.000000,Max=12000.000000))
        SizeScale(0)=(RelativeSize=0.5)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=4.0)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=6.000000)
        StartSizeRange=(X=(Min=200.000000,Max=250.000000),Y=(Min=200.000000,Max=250.000000),Z=(Min=200.000000,Max=250.000000))
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'SpecialEffects.Smoke.LSmoke2'
        ParticlesPerSecond=3.000000
        InitialParticlesPerSecond=3.000000
        LifetimeRange=(Min=20.000000,Max=20.000000)
        StartVelocityRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=300.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        UseVelocityScale=True
        Acceleration=(X=250.000000,Z=150.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=0.250000,Color=(B=100,G=177,R=230,A=255))
        ColorScale(2)=(RelativeTime=0.750000,Color=(B=5,R=230,A=255))
        ColorScale(3)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.600000
        FadeInEndTime=0.130000
        MaxParticles=20
        name="fire"
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=300.000000,Max=350.000000))
        ParticlesPerSecond=5.000000
        InitialParticlesPerSecond=5.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.explosions.fire_16frame'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=1.000000,Max=1.000000)
        StartVelocityRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000))
        VelocityScale(0)=(RelativeTime=0.100000,RelativeVelocity=(X=0.100000,Y=0.100000,Z=0.100000))
        VelocityScale(1)=(RelativeTime=0.500000,RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        TriggerDisabled=False
        ResetOnTrigger=True
        ColorScale(0)=(Color=(A=255))
        ColorScale(1)=(RelativeTime=0.650000,Color=(B=128,G=128,R=128,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.750000
        FadeOutStartTime=0.500000
        FadeInEndTime=0.200000
        MaxParticles=5
        name="horizontal_cloud"
        StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Max=300.000000))
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=6.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=14.000000)
        StartSizeRange=(X=(Min=50.000000,Max=120.000000),Y=(Min=50.000000,Max=120.000000),Z=(Min=45.000000,Max=50.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke3'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=2.000000)
        StartVelocityRange=(X=(Min=-700.000000,Max=700.000000),Y=(Min=-700.000000,Max=700.000000),Z=(Min=50.000000,Max=50.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=3.000000,Max=3.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseColorScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        TriggerDisabled=False
        ResetOnTrigger=True
        Acceleration=(Y=50.000000,Z=100.000000)
        ColorScale(0)=(Color=(B=75,G=75,R=75,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=51,G=128,R=189,A=255))
        Opacity=0.65
        MaxParticles=12
        Name="Rising_plume"
        StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
        SpinCCWorCW=(X=1.000000)
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=4.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=6.000000)
        StartSizeRange=(X=(Min=100.000000,Max=200.000000),Y=(Min=100.000000,Max=200.000000),Z=(Min=100.000000,Max=150.000000))
        InitialParticlesPerSecond=5000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'SpecialEffects.Smoke.LSmoke2'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=7.000000,Max=8.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=500.000000,Max=1500.000000))
        VelocityLossRange=(Z=(Min=1.000000,Max=1.000000))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter3'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter4
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        Acceleration=(Z=50.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.200000
        FadeInEndTime=0.050000
        MaxParticles=1
        name="initial_explosion"
        StartLocationRange=(Z=(Min=-50.000000,Max=200.000000))
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=300.000000,Max=500.000000),Y=(Min=300.000000,Max=500.000000),Z=(Min=300.000000,Max=500.000000))
        InitialParticlesPerSecond=10.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.explosions.impact_2frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=1
        LifetimeRange=(Min=0.750000,Max=0.750000)
        StartVelocityRange=(Z=(Min=10.000000,Max=10.000000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter4'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        ProjectionNormal=(X=200.000000,Y=200.000000)
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseVelocityScale=True
        Acceleration=(Z=5.000000)
        ColorScale(0)=(Color=(A=255))
        ColorScale(1)=(RelativeTime=0.003571,Color=(B=128,G=128,R=128,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=192,G=192,R=192))
        Opacity=0.450000
        FadeOutStartTime=3.480000
        MaxParticles=40
        name="smoke_puffs"
        StartLocationOffset=(Z=-50.000000)
        UseRotationFrom=PTRS_Offset
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
        SizeScale(0)=(RelativeSize=5.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=10.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=40.000000)
        StartSizeRange=(X=(Min=1.000000,Max=10.000000),Y=(Min=1.000000,Max=10.000000),Z=(Min=1.000000,Max=10.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke1'
        LifetimeRange=(Max=6.000000)
        StartVelocityRange=(X=(Min=-3000.000000,Max=3000.000000),Y=(Min=-3000.000000,Max=3000.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.100000,RelativeVelocity=(X=0.200000,Y=0.200000,Z=1.000000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter5'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter6
        FadeOut=True
        FadeIn=True
        UniformSize=False
        //Sounds(0)=(Sound=Sound'W_GRENADE.EXPLODE',Radius=(Min=100.000000,Max=250.000000),Volume=(Min=255.000000,Max=255.000000),Probability=(Min=1.000000,Max=1.000000))
        UseRegularSizeScale=true
        Acceleration=(X=0.000000,Y=0.000000,Z=0.000000)
        ColorMultiplierRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=0.400000,Max=0.400000),Z=(Min=0.300000,Max=0.300000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=2.7
        FadeInEndTime=0.200000
        MaxParticles=12
        name="rising_embers"
        SpinParticles=true
        StartLocationShape=PTLS_Box
        CoordinateSystem=PTCS_Independent
        EffectAxis=PTEA_NegativeX
        UseDirectionAs=PTDU_UP
        SpinCCWorCW=(X=1.00000,Y=0.500000,Z=0.500000)
        UseRevolution=true
        RevolutionsPerSecondRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.500000))
        StartLocationRange=(X=(Min=-60.000000,Max=60.000000),Y=(Min=-60.000000,Max=60.000000),Z=(Min=5.000000,Max=5.000000))
        StartSizeRange=(X=(Min=2.000000,Max=5.000000),Y=(Min=3.000000,Max=15.000000),Z=(Min=10.000000,Max=10.000000))
        InitialParticlesPerSecond=1.000000
        UseRotationFrom=PTRS_None
        DrawStyle=PTDS_Translucent
        Texture=Texture'DH_FX_Tex.effects.dhweaponspark'
        LifetimeRange=(Min=0.5,Max=2.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=100.000000,Max=600.000000))
        MaxAbsVelocity=(X=10000.000000,Y=10000.000000,Z=10000.000000)
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter6'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter7
        UseCollision=True
        UseMaxCollisions=True
        FadeOut=True
        FadeIn=False
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-300.000000)
        MaxCollisions=(Min=1.000000,Max=1.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=1.2
        FadeInEndTime=0.00000
        name="debris_embers"
        StartLocationRange=(Z=(Min=100.000000,Max=100.000000))
        SizeScale(0)=(RelativeSize=4.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=10.0,Max=15.000000),Y=(Min=10.000000,Max=15.000000),Z=(Min=10.000000,Max=15.000000))
        InitialParticlesPerSecond=50.000000
        UseDirectionAs=PTDU_UP
        DrawStyle=PTDS_Translucent
        Texture=Texture'DH_FX_Tex.effects.dhweaponspark'
        LifetimeRange=(Min=2.0)
        StartVelocityRange=(X=(Min=-600.000000,Max=600.000000),Y=(Min=-600.000000,Max=600.000000),Z=(Min=400.000000,Max=900.000000))
    End Object
    Emitters(7)=SpriteEmitter'SpriteEmitter7'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter8
       UseColorScale=True
        ColorScale(0)=(Color=(B=75,G=75,R=75,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=51,G=128,R=189,A=255))
       Opacity=0.630000
       FadeOutStartTime=0.50 //0.160000
       FadeOut=True
       FadeInEndTime=0.20 //0.080000
       FadeIn=True
       MaxParticles=500 //600
       RespawnDeadParticles=False
       Name="smoke_trails"
       AddLocationFromOtherEmitter=7
       StartLocationShape=PTLS_Sphere
       SphereRadiusRange=(Max=50.000000)
       RevolutionCenterOffsetRange=(Y=(Min=100.000000,Max=100.000000))
       RevolutionsPerSecondRange=(X=(Min=0.100000,Max=0.100000))
       SpinParticles=True
       StartSpinRange=(X=(Min=0.300000,Max=0.700000))
       UseSizeScale=True
       UseRegularSizeScale=False
       SizeScale(0)=(RelativeTime=0.25,RelativeSize=0.5)
       SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.5) //2.0
       StartSizeRange=(X=(Min=60.000000,Max=60.000000),Y=(Min=150.000000,Max=150.000000),Z=(Min=30.000000,Max=50.000000))
       UniformSize=True
       InitialParticlesPerSecond=300.000000
       AutomaticInitialSpawning=False
       DrawStyle=PTDS_AlphaBlend
       Texture=Texture'Effects_Tex.explosions.LSmoke3'
       //TextureUSubdivisions=2
       //TextureVSubdivisions=2
       //UseRandomSubdivision=True
       LifetimeRange=(Min=1.000000,Max=3.000000)
       ResetOnTrigger=True
       SpawnOnTriggerPPS=120.000000
       StartVelocityRange=(Z=(Max=100.000000))
       AddVelocityMultiplierRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
       AutoDestroy=true
   End Object
   Emitters(8)=SpriteEmitter'SpriteEmitter8'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter9
        UseDirectionAs=PTDU_Normal
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=5.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.390000
        FadeOutStartTime=2.400000
        FadeInEndTime=0.080000
        MaxParticles=2
        name="shock_wave"
        StartLocationOffset=(X=-50.000000)
        UseRotationFrom=PTRS_Normal
        RotationNormal=(Z=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=4.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=8.000000)
        StartSizeRange=(X=(Min=500.000000,Max=500.000000),Y=(Min=500.000000,Max=500.000000),Z=(Min=500.000000,Max=500.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.Smoke.grenadesmoke_fill'
        LifetimeRange=(Min=3.000000,Max=3.000000)
        StartVelocityRange=(Z=(Min=10.000000,Max=10.000000))
        StartVelocityRadialRange=(Min=100.000000,Max=100.000000)
    End Object
    Emitters(9)=SpriteEmitter'SpriteEmitter9'
}

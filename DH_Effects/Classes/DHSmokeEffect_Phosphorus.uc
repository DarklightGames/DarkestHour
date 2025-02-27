//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSmokeEffect_Phosphorus extends DHSmokeEffectBase;

defaultproperties
{


    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(X=10.0,Y=10.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.6
        FadeOutStartTime=2.56
        FadeInEndTime=0.48
        MaxParticles=30
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.05))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=3.0)
        StartSizeRange=(X=(Min=50.0,Max=50.0),Y=(Min=50.0,Max=50.0),Z=(Min=50.0,Max=50.0))
        InitialParticlesPerSecond=4.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.Smoke.grenadesmoke'
        LifetimeRange=(Min=3.0)
        StartVelocityRange=(X=(Min=-50.0,Max=50.0),Y=(Min=-50.0,Max=50.0),Z=(Min=15.0,Max=50.0))
        VelocityLossRange=(X=(Min=0.2,Max=0.2),Y=(Min=0.2,Max=0.2),Z=(Min=0.2,Max=0.2))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(Z=-0.2)
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.8
        FadeOutStartTime=40.0
        FadeInEndTime=5.5
        MaxParticles=2
        StartLocationRange=(X=(Min=-200.0,Max=200.0),Y=(Min=-200.0,Max=200.0),Z=(Min=200.0,Max=300.0))
        SpinsPerSecondRange=(X=(Min=0.003,Max=0.004))
        StartSpinRange=(X=(Min=0.05,Max=0.05))
        SizeScale(0)=(RelativeSize=0.25)
        SizeScale(1)=(RelativeTime=0.28,RelativeSize=0.75)
        SizeScale(2)=(RelativeTime=0.87,RelativeSize=1.0)
        StartSizeRange=(X=(Min=300.0,Max=400.0),Y=(Min=300.0,Max=400.0),Z=(Min=300.0,Max=400.0))
        InitialParticlesPerSecond=10.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.Smoke.grenadesmoke'
        LifetimeRange=(Min=45.0,Max=50.0)
        InitialDelayRange=(Min=2.0,Max=2.0)
        StartVelocityRange=(Z=(Min=2.0,Max=5.0))
        VelocityLossRange=(X=(Min=0.5,Max=0.5),Y=(Min=0.5,Max=0.5))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(Z=-0.2)
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.8
        FadeOutStartTime=50.4
        FadeInEndTime=4.8
        StartLocationRange=(X=(Min=-350.0,Max=350.0),Y=(Min=-350.0,Max=350.0),Z=(Max=100.0))
        SpinsPerSecondRange=(X=(Min=0.003,Max=0.004))
        StartSpinRange=(X=(Min=-0.05,Max=0.05))
        SizeScale(0)=(RelativeSize=0.75)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=0.9)
        SizeScale(2)=(RelativeTime=0.87,RelativeSize=1.0)
        StartSizeRange=(X=(Min=300.0,Max=400.0),Y=(Min=300.0,Max=400.0),Z=(Min=300.0,Max=400.0))
        InitialParticlesPerSecond=10.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.Smoke.grenadesmoke'
        LifetimeRange=(Min=55.0,Max=60.0)
        InitialDelayRange=(Min=2.0,Max=2.0)
        StartVelocityRange=(Z=(Min=2.0,Max=5.0))
        VelocityLossRange=(X=(Min=0.5,Max=0.5),Y=(Min=0.5,Max=0.5))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(X=1.0,Y=1.0)
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=128,G=128,R=128,A=255))
        Opacity=0.9
        FadeOutStartTime=6.0
        FadeInEndTime=2.0
        MaxParticles=70
        StartLocationRange=(X=(Min=-300.0,Max=300.0),Y=(Min=-300.0,Max=300.0),Z=(Min=25.0,Max=25.0))
        SpinsPerSecondRange=(X=(Min=0.025,Max=0.05))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=3.0)
        StartSizeRange=(X=(Min=50.0,Max=100.0),Y=(Min=50.0,Max=100.0),Z=(Min=50.0,Max=100.0))
        InitialParticlesPerSecond=1.5
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.Smoke.grenadesmoke_fill'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=8.0,Max=9.0)
        InitialDelayRange=(Min=0.75,Max=0.75)
        StartVelocityRange=(X=(Min=-50.0,Max=50.0),Y=(Min=-50.0,Max=50.0))
        VelocityLossRange=(X=(Min=0.15,Max=0.15),Y=(Min=0.15,Max=0.15),Z=(Min=0.1,Max=0.1))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter3'
    

 //White phosphorus Flares and trails
    //Flares
    Begin Object Class=SpriteEmitter Name=SpriteEmitter4
        FadeOut=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        Acceleration=(Z=50.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.148004
        MaxParticles=1
        StartLocationOffset=(Z=10.000000)
        SizeScale(0)=(RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=4.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=10.000000)
        StartSizeRange=(X=(Min=10.000000,Max=14.000000),Y=(Min=10.000000,Max=15.000000),Z=(Min=10.000000,Max=15.000000))
        InitialParticlesPerSecond=30.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'DH_FX_Tex.Effects.sunflare_danzig'
        LifetimeRange=(Min=0.400000,Max=0.400010)
        InitialDelayRange=(Min=0.050000,Max=0.050000)
        StartVelocityRange=(Z=(Min=10.000000,Max=10.000000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter4'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-5.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.250000
        FadeOutStartTime=4.140000
        FadeInEndTime=0.900000
        MaxParticles=70

        StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=2.000000,Max=25.000000))
        SpinsPerSecondRange=(X=(Min=0.025000,Max=0.050000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=6.000000)
        StartSizeRange=(Z=(Min=5.000000))
        InitialParticlesPerSecond=1.500000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.flak_flash'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=8.000000,Max=9.000000)
        InitialDelayRange=(Min=0.750000,Max=0.750000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000))
        VelocityLossRange=(X=(Min=0.150000,Max=0.150000),Y=(Min=0.150000,Max=0.150000),Z=(Min=0.100000,Max=0.100000))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter5'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter6
        UseCollision=True
        UseMaxCollisions=True
        FadeOut=True
        RespawnDeadParticles=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-300.000000)
        DampingFactorRange=(X=(Min=0.350000,Max=0.50000),Y=(Min=0.350000,Max=0.50000),Z=(Min=0.350000,Max=0.500000))
        MaxCollisions=(Min=2.000000,Max=2.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=25
        StartLocationOffset=(Z=5.000000)
        StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Max=5.000000))
        StartSizeRange=(X=(Min=20.000000,Max=20.000000),Y=(Min=20.000000,Max=20.000000),Z=(Min=20.000000,Max=20.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'SpecialEffects.Flares.Spikeyflare'
        MinSquaredVelocity=1.000000
        LifetimeRange=(Min=3.000000,Max=4.000000)
        StartVelocityRange=(X=(Min=-175.000000,Max=175.000000),Y=(Min=-175.000000,Max=175.000000),Z=(Min=20.000000,Max=300.000000))
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter6'

    //Smoke trails
    Begin Object Class=SpriteEmitter Name=SpriteEmitter7
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        TriggerDisabled=False
        ResetOnTrigger=True
        Acceleration=(Z=-30.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.3
        FadeOutStartTime=1.750000
        MaxParticles=900
        AddLocationFromOtherEmitter=6 //attach small smoke streamers to the flares
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.150000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=3.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=6.000000)
        StartSizeRange=(X=(Min=5.000000,Max=6.000000),Y=(Min=5.000000,Max=6.000000),Z=(Min=5.000000,Max=6.000000))
        InitialParticlesPerSecond=350.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'SpecialEffects.Smoke.MuchSmoke2t'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        SecondsBeforeInactive=0.000000
        MinSquaredVelocity=1.000000
        InitialDelayRange=(Min=0.500000,Max=0.500000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=10.000000,Max=350.000000))
        MaxAbsVelocity=(X=1.000000,Y=1.000000,Z=1.000000)
        VelocityLossRange=(Z=(Min=3.000000,Max=3.000000))
        GetVelocityDirectionFrom=PTVD_OwnerAndStartPosition
    End Object
    Emitters(7)=SpriteEmitter'SpriteEmitter7'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter8
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(Z=-75.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.13
        MaxParticles=2
        StartSpinRange=(X=(Min=0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=0.5)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=4.5)
        StartSizeRange=(X=(Min=32.0,Max=32.0),Y=(Min=32.0,Max=32.0),Z=(Min=32.0,Max=32.0))
        InitialParticlesPerSecond=100.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.explosion_1frame'
        LifetimeRange=(Min=0.4,Max=0.5)
        StartVelocityRange=(Z=(Min=300.0,Max=300.0))
    End Object
    Emitters(8)=SpriteEmitter'SpriteEmitter8'
    
}

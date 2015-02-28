//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Bazooka3rdPersonMuzzleFX extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UseColorScale=true
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(X=50.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=1.0
        StartLocationOffset=(X=25.0)
        StartLocationShape=PTLS_Sphere
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5),Y=(Min=0.5,Max=1.0),Z=(Min=0.5,Max=1.0))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=20.0)
        StartSizeRange=(X=(Min=3.0,Max=5.0),Y=(Min=3.0,Max=5.0),Z=(Min=3.0,Max=5.0))
        InitialParticlesPerSecond=5000.0
        DrawStyle=PTDS_AlphaBlend
        Texture=texture'Effects_Tex.explosions.DSmoke_2'
        LifetimeRange=(Min=1.75,Max=2.0)
        StartVelocityRange=(X=(Max=400.0),Y=(Min=-20.0,Max=20.0),Z=(Min=-20.0,Max=20.0))
    End Object
    Emitters(0)=SpriteEmitter'DH_Effects.DH_Bazooka3rdPersonMuzzleFX.SpriteEmitter0'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseColorScale=true
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        ColorScale(0)=(Color=(B=174,G=228,R=255,A=255))
        ColorScale(1)=(RelativeTime=0.2,Color=(B=255,G=255,R=255,A=255))
        ColorScale(2)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        ColorScale(3)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        ColorScale(4)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.5
        FadeOutStartTime=0.1025
        FadeInEndTime=0.05
        MaxParticles=2
        StartLocationOffset=(X=25.0)
        UseRotationFrom=PTRS_Actor
        SizeScale(1)=(RelativeTime=0.25,RelativeSize=1.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=2.0)
        StartSizeRange=(X=(Min=50.0,Max=50.0),Y=(Min=50.0,Max=50.0),Z=(Min=50.0,Max=50.0))
        InitialParticlesPerSecond=60.0
        DrawStyle=PTDS_AlphaBlend
        Texture=texture'Effects_Tex.explosions.radialexplosion_1frame'
        LifetimeRange=(Min=0.25,Max=0.25)
    End Object
    Emitters(1)=SpriteEmitter'DH_Effects.DH_Bazooka3rdPersonMuzzleFX.SpriteEmitter1'
    AutoDestroy=true
    bLightChanged=true
    bNoDelete=false
    bNetTemporary=true
    RemoteRole=ROLE_SimulatedProxy
    LifeSpan=8.0
    Style=STY_Masked
    bHardAttach=true
    bDirectional=true
    bSelected=true
}

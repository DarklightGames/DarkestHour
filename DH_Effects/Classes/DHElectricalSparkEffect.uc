//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2024
//==============================================================================

class DHElectricalSparkEffect extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        RespawnDeadParticles=False
        SpinParticles=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.600000
        MaxParticles=12
      
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=1.100000)
        StartSizeRange=(X=(Min=0.000000,Max=7.000000),Y=(Min=0.000000,Max=7.000000),Z=(Min=0.000000,Max=7.000000))
        InitialParticlesPerSecond=20.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'DH_FX_Tex.Sparks.ElectricalSparks'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.030000,Max=0.120000)
        InitialDelayRange=(Min=0.100000,Max=0.300000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseDirectionAs=PTDU_Up
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-85.000000)
        ColorScale(0)=(Color=(B=206,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=0.521429,Color=(B=79,G=175,R=240,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=91,G=145,R=255,A=255))
        FadeOutStartTime=1.050000
        MaxParticles=3
      
        StartSizeRange=(X=(Min=0.800000,Max=2.000000),Y=(Min=0.800000,Max=2.000000),Z=(Min=0.800000,Max=2.000000))
        InitialParticlesPerSecond=5.000000
        Texture=Texture'DH_FX_Tex.Effects.dhweaponspark'
        LifetimeRange=(Min=1.500000,Max=1.500000)
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=20.000000,Max=80.000000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        UseRandomSubdivision=True
        Acceleration=(Z=-1.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.400000
        FadeOutStartTime=0.080000
        MaxParticles=6
      
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=2.000000,Max=4.000000),Y=(Min=2.000000,Max=4.000000),Z=(Min=2.000000,Max=4.000000))
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.papersmoke'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.000000,Max=2.000000)
        InitialDelayRange=(Max=0.100000)
        StartVelocityRange=(Z=(Min=4.000000,Max=8.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'

    AutoReset=True
   
    bNoDelete=False
        
    DrawScale3D=(X=0.200000,Y=0.200000)
}
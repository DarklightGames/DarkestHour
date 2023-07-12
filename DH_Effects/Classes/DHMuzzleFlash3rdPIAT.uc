//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMuzzleFlash3rdPIAT extends ROMuzzleFlash3rd;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    Emitters[0].SpawnParticle(2);
    Emitters[1].SpawnParticle(2);
    Emitters[2].SpawnParticle(2);
    Emitters[3].SpawnParticle(1);
    Emitters[4].SpawnParticle(3);
    Emitters[5].SpawnParticle(3);
}

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.750000
        FadeOutStartTime=0.080000
        CoordinateSystem=PTCS_Relative
        MaxParticles=3
        Name="SpriteEmitter1"
        StartLocationRange=(X=(Max=10.000000))
        StartLocationOffset=(X=2.000000)
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.500000)
        SizeScale(2)=(RelativeTime=1.000000)
        StartSizeRange=(X=(Min=10.000000,Max=10.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.MP3rdPmuzzle_smoke1frame'
        SubdivisionScale(0)=0.500000
        LifetimeRange=(Min=0.200000,Max=0.200000)
        StartVelocityRange=(X=(Min=10.000000,Max=30.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.600000
        FadeOutStartTime=0.094000
        FadeInEndTime=0.092000
        CoordinateSystem=PTCS_Relative
        MaxParticles=3
        Name="SpriteEmitter2"
        StartLocationOffset=(X=17.000000)
        StartLocationRange=(X=(Max=5.000000))
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000)
        StartSizeRange=(X=(Min=10.000000,Max=10.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.MP3rdPmuzzle_smoke1frame'
        SubdivisionScale(0)=0.500000
        LifetimeRange=(Min=0.200000,Max=0.200000)
        InitialDelayRange=(Min=0.050000,Max=0.050000)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.750000
        FadeOutStartTime=0.040000
        FadeInEndTime=0.040000
        CoordinateSystem=PTCS_Relative
        MaxParticles=3
        Name="SpriteEmitter3"
        StartLocationOffset=(X=7.000000)
        StartLocationRange=(X=(Max=10.000000))
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000)
        StartSizeRange=(X=(Min=10.000000,Max=10.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.MP3rdPmuzzle_smoke1frame'
        SubdivisionScale(0)=0.500000
        LifetimeRange=(Min=0.200000,Max=0.200000)
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter3'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        RespawnDeadParticles=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.200000
        MaxParticles=1
        Name="SpriteEmitter5"
        StartSizeRange=(X=(Min=50.000000,Max=50.000000))
        Texture=Texture'Effects_Tex.Smoke.glowfinal'
        LifetimeRange=(Min=0.100000,Max=0.100000)
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter5'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter6
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
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.200000
        MaxParticles=64
        Name="SpriteEmitter6"
        StartLocationOffset=(X=5.000000)
        StartLocationRange=(X=(Max=10.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.500000)
        StartSizeRange=(X=(Min=5.000000,Max=10.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.MP3rdPmuzzle_smoke1frame'
        LifetimeRange=(Min=1.200000,Max=1.200000)
        StartVelocityRange=(X=(Max=40.000000),Z=(Min=10.000000,Max=20.000000))
        VelocityLossRange=(X=(Max=2.000000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter6'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter7
        UseColorScale=True
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
        Opacity=0.200000
        MaxParticles=64
        Name="SpriteEmitter52"
        StartLocationOffset=(X=5.000000)
        StartLocationRange=(X=(Max=10.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=25.000000,Max=50.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.MP3rdPmuzzle_smoke1frame'
        LifetimeRange=(Min=1.500000,Max=3.000000)
        StartVelocityRange=(X=(Min=50.000000,Max=75.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.500000,RelativeVelocity=(X=0.200000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter7'
}

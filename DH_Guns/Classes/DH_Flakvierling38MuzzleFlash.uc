//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Flakvierling38MuzzleFlash extends ROMuzzleFlash3rd;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    Emitters[0].SpawnParticle(2);
    Emitters[1].SpawnParticle(2);
    Emitters[2].SpawnParticle(2);
    Emitters[3].SpawnParticle(2);
    Emitters[4].SpawnParticle(2);
    Emitters[5].SpawnParticle(1);
}

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        BlendBetweenSubdivisions=true
        UseRandomSubdivision=true
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        CoordinateSystem=PTCS_Relative
        MaxParticles=3
        StartLocationOffset=(X=2.0)
        StartLocationRange=(X=(Max=2.0))
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=-0.5,Max=0.5),Y=(Min=-0.5,Max=0.5),Z=(Min=-0.5,Max=0.5))
        StartSpinRange=(X=(Min=-1.0,Max=1.0),Y=(Min=-1.0,Max=1.0),Z=(Min=-1.0,Max=1.0))
        SizeScale(0)=(RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=4.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=2.0)
        StartSizeRange=(X=(Min=16.0,Max=16.0),Y=(Min=32.0,Max=32.0))
        DrawStyle=PTDS_Brighten
        Texture=texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        SubdivisionScale(0)=0.5
        LifetimeRange=(Min=0.2,Max=0.2)
        StartVelocityRange=(X=(Min=10.0,Max=30.0))
    End Object
    Emitters(0)=SpriteEmitter'DH_Guns.DH_Flakvierling38MuzzleFlash.SpriteEmitter0'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        UseRandomSubdivision=true
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.75
        FadeOutStartTime=0.08
        CoordinateSystem=PTCS_Relative
        MaxParticles=3
        StartLocationOffset=(X=2.0)
        StartLocationRange=(X=(Max=10.0))
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=-0.5,Max=0.5),Y=(Min=-0.5,Max=0.5),Z=(Min=-0.5,Max=0.5))
        StartSpinRange=(X=(Min=-1.0,Max=1.0),Y=(Min=-1.0,Max=1.0),Z=(Min=-1.0,Max=1.0))
        SizeScale(0)=(RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=1.5)
        SizeScale(2)=(RelativeTime=1.0)
        StartSizeRange=(X=(Min=80.0,Max=80.0))
        DrawStyle=PTDS_Brighten
        Texture=texture'Effects_Tex.Weapons.MP3rdPmuzzle_smoke1frame'
        SubdivisionScale(0)=0.5
        LifetimeRange=(Min=0.2,Max=0.2)
        StartVelocityRange=(X=(Min=10.0,Max=30.0))
    End Object
    Emitters(1)=SpriteEmitter'DH_Guns.DH_Flakvierling38MuzzleFlash.SpriteEmitter1'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        UseRandomSubdivision=true
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.6
        FadeOutStartTime=0.094
        FadeInEndTime=0.092
        CoordinateSystem=PTCS_Relative
        MaxParticles=3
        StartLocationOffset=(X=17.0)
        StartLocationRange=(X=(Max=5.0))
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=-0.5,Max=0.5),Y=(Min=-0.5,Max=0.5),Z=(Min=-0.5,Max=0.5))
        StartSpinRange=(X=(Min=-1.0,Max=1.0),Y=(Min=-1.0,Max=1.0),Z=(Min=-1.0,Max=1.0))
        SizeScale(0)=(RelativeSize=0.5)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=1.0)
        SizeScale(2)=(RelativeTime=1.0)
        StartSizeRange=(X=(Min=80.0,Max=80.0))
        DrawStyle=PTDS_Brighten
        Texture=texture'Effects_Tex.Weapons.MP3rdPmuzzle_smoke1frame'
        SubdivisionScale(0)=0.5
        LifetimeRange=(Min=0.2,Max=0.2)
        InitialDelayRange=(Min=0.05,Max=0.05)
    End Object
    Emitters(2)=SpriteEmitter'DH_Guns.DH_Flakvierling38MuzzleFlash.SpriteEmitter2'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        UseRandomSubdivision=true
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.75
        FadeOutStartTime=0.04
        FadeInEndTime=0.04
        CoordinateSystem=PTCS_Relative
        MaxParticles=3
        StartLocationOffset=(X=7.0)
        StartLocationRange=(X=(Max=10.0))
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=-0.5,Max=0.5),Y=(Min=-0.5,Max=0.5),Z=(Min=-0.5,Max=0.5))
        StartSpinRange=(X=(Min=-1.0,Max=1.0),Y=(Min=-1.0,Max=1.0),Z=(Min=-1.0,Max=1.0))
        SizeScale(0)=(RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=1.0)
        SizeScale(2)=(RelativeTime=1.0)
        StartSizeRange=(X=(Min=80.0,Max=80.0))
        DrawStyle=PTDS_Brighten
        Texture=texture'Effects_Tex.Weapons.MP3rdPmuzzle_smoke1frame'
        SubdivisionScale(0)=0.5
        LifetimeRange=(Min=0.2,Max=0.2)
    End Object
    Emitters(3)=SpriteEmitter'DH_Guns.DH_Flakvierling38MuzzleFlash.SpriteEmitter3'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter4
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        BlendBetweenSubdivisions=true
        UseRandomSubdivision=true
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.12
        CoordinateSystem=PTCS_Relative
        MaxParticles=3
        StartLocationOffset=(X=7.0)
        StartLocationRange=(X=(Max=2.0))
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=-0.5,Max=0.5),Y=(Min=-0.5,Max=0.5),Z=(Min=-0.5,Max=0.5))
        StartSpinRange=(X=(Min=-1.0,Max=1.0),Y=(Min=-1.0,Max=1.0),Z=(Min=-1.0,Max=1.0))
        SizeScale(0)=(RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=3.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=1.0)
        StartSizeRange=(X=(Min=12.0,Max=12.0),Y=(Min=24.0,Max=24.0))
        DrawStyle=PTDS_Brighten
        Texture=texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        SubdivisionScale(0)=0.5
        LifetimeRange=(Min=0.2,Max=0.2)
        StartVelocityRange=(X=(Min=10.0,Max=30.0))
    End Object
    Emitters(4)=SpriteEmitter'DH_Guns.DH_Flakvierling38MuzzleFlash.SpriteEmitter4'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        RespawnDeadParticles=false
        UniformSize=true
        AutomaticInitialSpawning=false
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.2
        MaxParticles=1
        StartSizeRange=(X=(Min=400.0,Max=400.0))
        Texture=texture'Effects_Tex.BulletHits.glowfinal'
        LifetimeRange=(Min=0.1,Max=0.1)
    End Object
    Emitters(5)=SpriteEmitter'DH_Guns.DH_Flakvierling38MuzzleFlash.SpriteEmitter5'
}

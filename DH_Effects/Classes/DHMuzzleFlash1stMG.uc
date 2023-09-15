//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMuzzleFlash1stMG extends ROMuzzleFlash1st;

var int RandFlashCount;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    if (FRand()< 0.15)
    {
        RandFlashCount=2;
    }
    else
    {
        RandFlashCount=0;
    } 

    Emitters[0].SpawnParticle(RandFlashCount);
	Emitters[1].SpawnParticle(4);
    Emitters[2].SpawnParticle(RandFlashCount);
    Emitters[3].SpawnParticle(1);
}

defaultproperties
{   
    Begin Object Class=SpriteEmitter Name=SpriteEmitter38
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        UseSubdivisionScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=255,A=255))
        Opacity=0.6
        CoordinateSystem=PTCS_Relative
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.000000)
        SizeScale(2)=(RelativeTime=1.000000)
        StartSizeRange=(X=(Min=8.000000,Max=12.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'DH_FX_Tex.Weapons.mgmuzzleflash_4frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        SubdivisionScale(0)=0.500000
        LifetimeRange=(Min=0.115000,Max=0.115000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter38'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        UseDirectionAs=PTDU_Up
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.15
        FadeOut=True
        RespawnDeadParticles=False
        AutoDestroy=false
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=1.00000,Max=2.00000),Y=(Min=1.00000,Max=2.00000),Z=(Min=1.00000,Max=2.000000))
        SizeScale(0)=(RelativeSize=1.5)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=3.00000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.50000)
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Brighten
        Texture=Texture'DH_FX_Tex.effects.dhweaponspark'
        LifetimeRange=(Min=0.10000,Max=0.15) //(Min=0.010000,Max=0.15000)
        StartVelocityRange=(X=(Min=80.000000,Max=120.000000),Y=(Min=-45.000000,Max=45.000000),Z=(Min=-45.000000,Max=55.000000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        UniformSize=True
        SpinParticles=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(G=128,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(G=128,R=255,A=255))
        StartLocationOffset=(X=-5.000000)
        Opacity=0.15
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        MaxParticles=1
        Name="SpriteEmitter5"
        StartSizeRange=(X=(Min=65.000000,Max=85.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'SpecialEffects.Flares.SoftFlare'
        LifetimeRange=(Min=0.35000,Max=0.350000)
        End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter5'


    Begin Object Class=BeamEmitter Name=BeamEmitter14
        UseColorScale=false   
        BeamDistanceRange=(Min=80.000000,Max=100.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=3
        RespawnDeadParticles=False
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(G=128,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=64,G=128,R=255,A=255))
        Opacity=0.1
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=8.000000,Max=10.000000),Y=(Min=8.000000,Max=10.000000),Z=(Min=60.000000,Max=100.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'DH_FX_Tex.Effects.Impact01'
        LifetimeRange=(Min=0.1150000,Max=0.1150000)
        StartVelocityRange=(X=(Min=100.000000,Max=250.000000))
    End Object
    Emitters(3)=BeamEmitter'BeamEmitter14'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMuzzleFlash1stShotgun extends ROMuzzleFlash1st;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    if (FRand()< 0.5)
    {
        Emitters[0].SpawnParticle(2);
        Emitters[1].SpawnParticle(1);    
        Emitters[2].SpawnParticle(10);
    }
    else
    {
        Emitters[0].SpawnParticle(0);
        Emitters[1].SpawnParticle(0);    
        Emitters[2].SpawnParticle(10);
    } 
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
        //UseRandomSubdivision=True
        UseSubdivisionScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=255,A=255))
        Opacity=0.35
        CoordinateSystem=PTCS_Relative
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.000000)
        SizeScale(2)=(RelativeTime=1.000000)
        StartSizeRange=(X=(Min=12.000000,Max=20.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'DH_FX_Tex.Weapons.riflemuzzleflash_4frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        //SubdivisionScale(0)=0.500000
        LifetimeRange=(Min=0.115000,Max=0.115000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter38'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
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
        Name="SpriteEmitter2"
        StartSizeRange=(X=(Min=65.000000,Max=85.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'SpecialEffects.Flares.SoftFlare'
        LifetimeRange=(Min=0.1,Max=0.1)
        End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        UseDirectionAs=PTDU_Up
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        RespawnDeadParticles=False
        AutomaticInitialSpawning=False
        UseRotationFrom=PTRS_Actor
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Max=5.000000)
        StartSizeRange=(X=(Min=0.50000,Max=0.75000),Y=(Min=0.50000,Max=0.750000),Z=(Min=0.50000,Max=0.750000))
        SizeScale(0)=(RelativeSize=1.5)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=3.00000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.50000)
        DrawStyle=PTDS_Brighten
        Texture=Texture'DH_FX_Tex.effects.dhweaponspark'
        LifetimeRange=(Min=0.05,Max=0.15) //(Min=0.010000,Max=0.15000)
        StartVelocityRange=(X=(Min=80.000000,Max=120.000000),Y=(Min=-95.000000,Max=90.000000),Z=(Min=-90.000000,Max=95.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter1'
}

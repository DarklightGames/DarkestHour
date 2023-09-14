//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMuzzleFlash1stPanzerschreck extends ROMuzzleFlash1st;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    Emitters[0].SpawnParticle(2);
    Emitters[1].SpawnParticle(25);
    //Emitters[2].SpawnParticle(20);
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
        UseSubdivisionScale=True
        UseRandomSubdivision=True
        Opacity=0.25 //0.45
        CoordinateSystem=PTCS_Relative
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.5)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=5.0000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.50000)
        StartSizeRange=(X=(Min=10.000000,Max=11.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.explosions.impact_2frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=1
        LifetimeRange=(Min=0.100000,Max=0.100000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        UseDirectionAs=PTDU_Up
        Acceleration=(X=50.000000,Y=-50.000000,Z=1.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.056000
        FadeOut=True
        RespawnDeadParticles=False
        AutoDestroy=false
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Max=2.000000) //2.0
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=0.500000,Max=1.500000),Y=(Min=0.500000,Max=1.500000),Z=(Min=0.500000,Max=1.500000))
        SizeScale(0)=(RelativeSize=1.5)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=3.00000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.50000)
        //InitialParticlesPerSecond=100.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Brighten
        Texture=Texture'DH_FX_Tex.effects.dhweaponspark'
        MaxParticles=500
        LifetimeRange=(Min=0.150000,Max=0.4000) //(Min=0.010000,Max=0.15000)
        StartVelocityRange=(X=(Min=0.000000,Max=30.000000),Y=(Min=-350.000000,Max=300.000000),Z=(Min=-100.000000,Max=200.000000))
        //ResetOnTrigger=true
        //TriggerDisabled=false
        //MustTickOnce=true
        CoordinateSystem=PTCS_Relative
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'
}

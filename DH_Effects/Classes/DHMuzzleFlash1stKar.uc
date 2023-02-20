//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMuzzleFlash1stKar extends ROMuzzleFlash1st;

defaultproperties
{   
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UseColorScale=true
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        Opacity=0.35
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseSubdivisionScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=0,G=0,R=255,A=255))
        CoordinateSystem=PTCS_Relative
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.000000)
        StartSizeRange=(X=(Min=4.000000,Max=8.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.Karmuzzle_2frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=1
        SubdivisionScale(0)=0.500000
        LifetimeRange=(Min=0.115000,Max=0.115000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseDirectionAs=PTDU_UpAndNormal
        ProjectionNormal=(X=1.000000,Y=0.500000)
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=64,G=128,R=255,A=255))
        ColorScaleRepeats=4
        MaxParticles=64
        name="sparks"
        StartLocationRange=(X=(Min=-5.0,Max=5.000000))
        //CoordinateSystem=PTCS_Relative
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=5.00000,Max=10.000000))
        StartSpinRange=(X=(Min=-0.500000,Max=1.000000))
        StartSizeRange=(X=(Min=0.95,Max=1.25))
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Smoke.Sparks'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.15,Max=0.2)
        StartVelocityRange=(X=(Min=100.000000,Max=125.000000),Y=(Min=-85.000000,Max=85.000000),Z=(Min=-75.000000,Max=95.000000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'
}

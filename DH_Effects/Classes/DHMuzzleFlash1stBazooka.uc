//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMuzzleFlash1stBazooka extends ROMuzzleFlash1st;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    Emitters[0].SpawnParticle(2);
    Emitters[1].SpawnParticle(10);

    if (!Level.bDropDetail)
    {
        bDynamicLight = true;
        SetTimer(0.15, false);
    }

    LightBrightness = RandRange(96, 150);
}

simulated function Timer()
{
    bDynamicLight = false;
}

defaultproperties
{
    //bDynamicLight=true
    bMovable=true

    LightEffect=LE_NonIncidence
    LightType=LT_Steady
    //LightBrightness = 96.0
    LightRadius = 6.0
    LightHue = 20
    LightSaturation = 28
    AmbientGlow = 254
    LightCone = 8

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

    Begin Object Class=SpriteEmitter Name=SpriteEmitter24
        UseDirectionAs=PTDU_UpAndNormal
        ProjectionNormal=(X=1.000000,Y=0.500000)
        UseCollision=True
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Y=10.000000,Z=-100.000000)
        DampingFactorRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=64,G=128,R=255,A=255))
        ColorScaleRepeats=4.000000
        FadeOutStartTime=2.75000
        Name="sparks"
        StartLocationOffset=(Z=20.000000)
        SphereRadiusRange=(Min=20.000000,Max=50.000000)
        SpinsPerSecondRange=(X=(Min=0.500000,Max=4.000000))
        StartSpinRange=(X=(Min=-0.500000,Max=1.000000))
        StartSizeRange=(X=(Min=1.2500000,Max=2.500000))
        //InitialParticlesPerSecond=1000.000000
        Texture=Texture'Effects_Tex.Smoke.Sparks'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=4.000000,Max=4.500000)
        InitialDelayRange=(Min=0.300000,Max=0.450000)
        StartVelocityRange=(X=(Min=150.000000,Max=250.000000),Y=(Min=-75.000000,Max=65.000000),Z=(Min=-85.000000,Max=75.000000))
        VelocityLossRange=(Z=(Min=1.000000,Max=3.000000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter24'
}

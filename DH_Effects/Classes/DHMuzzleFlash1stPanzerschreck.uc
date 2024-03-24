//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMuzzleFlash1stPanzerschreck extends ROMuzzleFlash1st;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    Emitters[0].SpawnParticle(2);
    Emitters[1].SpawnParticle(10);
    Emitters[2].SpawnParticle(2);

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

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        UseDirectionAs=PTDU_Up
        Acceleration=(X=0.000000,Y=0.000000,Z=-200.000000)
        ColorMultiplierRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=0.400000,Max=0.400000),Z=(Min=0.300000,Max=0.300000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.75
        FadeOut=True
        RespawnDeadParticles=False
        AutoDestroy=false
        UseRotationFrom=PTRS_Actor
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Max=10.000000)
        StartSizeRange=(X=(Min=5.50000,Max=10.75000),Y=(Min=5.50000,Max=10.750000),Z=(Min=5.50000,Max=10.750000))
        SizeScale(0)=(RelativeSize=1.5)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=3.00000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.50000)
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Brighten
        Texture=Texture'DH_FX_Tex.effects.dhweaponspark'
        LifetimeRange=(Min=1.50000,Max=2.500) //(Min=0.010000,Max=0.15000)
        StartVelocityRange=(X=(Min=300.000000,Max=1200.000000),Y=(Min=-145.000000,Max=145.000000),Z=(Min=-145.000000,Max=300.000000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Y=100.000000)
        ColorScale(0)=(Color=(B=95,G=95,R=95,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=150,G=150,R=150))
        Opacity=0.750000
        FadeOutStartTime=0.975000
        Name="muzzle_smoke"
        //StartLocationOffset=(X=-56.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Max=0.050000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        //InitialParticlesPerSecond=50000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        LifetimeRange=(Min=2.00000,Max=2.500000)
        StartVelocityRange=(X=(Min=300.000000,Max=1500.000000),Y=(Min=-150.000000,Max=250.000000),Z=(Min=-200.000000,Max=250.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=3.000000),Y=(Min=1.000000,Max=3.000000),Z=(Min=1.000000,Max=3.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.125000,RelativeVelocity=(X=0.200000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'
}

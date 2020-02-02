//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHMolotovCoctailProjectile extends Emitter;

defaultproperties
{
    bDynamicLight=true
    LightType=LT_Flicker
    LightHue=30
    LightSaturation=100
    LightBrightness=100.0
    LightRadius=1.3

    bNoDelete=false
    bOnlyDrawIfAttached=false

    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=true
        FadeIn=true
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        UseRandomSubdivision=true
        Acceleration=(Z=150.0)
        ColorScale(1)=(RelativeTime=0.3,Color=(B=255,G=255,R=255))
        ColorScale(2)=(RelativeTime=0.667857,Color=(B=89,G=172,R=247,A=255))
        ColorScale(3)=(RelativeTime=1.0,Color=(B=128,G=128,R=128,A=255))
        ColorScale(4)=(RelativeTime=1.0)
        ColorScale(5)=(RelativeTime=1.0)
        FadeOutStartTime = 0.1//0.4
        FadeInEndTime = 0.1//0.14
        // StartLocationOffset=(Z=-34.0)
        StartLocationShape=PTLS_Sphere
        // SphereRadiusRange = (Max=20.0)
        StartSpinRange=(X=(Min=-0.1,Max=0.1))
        StartSizeRange=(X=(Min=16.0,Max=25.0),Y=(Min=0.0,Max=0.0),Z=(Min=0.0,Max=0.0))
        SpinsPerSecondRange=(X=(Max=0.075))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=0.6)
        ScaleSizeByVelocityMultiplier=(X=0.0,Y=0.0,Z=0.0)
        ScaleSizeByVelocityMax=0.0
        RelativeBoneIndexRange=(Min=0.9)
        ParticlesPerSecond=10.0
        InitialParticlesPerSecond=10.0
        DrawStyle=PTDS_Brighten
        Texture=Texture'DH_FX_Tex.Fire.FireAnim16F'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        SecondsBeforeInactive=30.0
        LifetimeRange=(Min=0.5,Max=1.75)
        StartVelocityRange=(X=(Min=-3.0,Max=5.0),Y=(Min=-3.0,Max=5.0),Z=(Min=5.0,Max=10.0))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'
    
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGrenadeEffect_Generic extends Emitter;

var bool bUseFlash;

// Parent class for all mortar explosions - add flash of light upon impact
simulated function PostBeginPlay()
{
    if (Level.NetMode != NM_DedicatedServer && bUseFlash)
    {
        bDynamicLight = true;
        SetTimer(0.1, false);
    }

    Super.PostBeginPlay();
}

simulated function Timer()
{
    bDynamicLight = false;
}

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0        //horizontal smoke
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        AlphaTest=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(X=-50.000000,Z=-5.000000)
        DampingFactorRange=(X=(Min=100.000000,Max=100.000000),Y=(Min=100.000000,Max=100.000000),Z=(Min=100.000000,Max=100.000000))
        MaxCollisions=(Min=1.000000,Max=1.000000)
        ColorScale(0)=(Color=(B=60,G=60,R=60,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=160,G=160,R=160,A=255))
        Opacity=0.700000
        FadeOutStartTime=1.50000 // was 1.38
        MaxParticles=12
      
        StartLocationOffset=(X=10.000000,Y=10.000000,Z=-0.300000)
        StartLocationRange=(Z=(Max=15.000000))
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.500000)
        StartSizeRange=(X=(Min=40.000000,Max=60.000000),Y=(Min=40.000000,Max=60.000000),Z=(Min=40.000000,Max=60.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Smoke.grenadesmoke'
        MinSquaredVelocity=150.000000
        LifetimeRange=(Min=2.200000,Max=3.300000)
        InitialDelayRange=(Min=0.000000,Max=0.000000) // Was 0.2
        StartVelocityRange=(X=(Min=-1500.000000,Max=1500.000000),Y=(Min=-1500.000000,Max=1500.000000),Z=(Max=15.000000))
        StartVelocityRadialRange=(Min=50.000000,Max=50.000000)
        VelocityLossRange=(X=(Min=5.700000,Max=5.700000),Y=(Min=5.700000,Max=5.700000),Z=(Min=5.700000,Max=5.700000))
        AddVelocityMultiplierRange=(Z=(Min=-50.000000,Max=-50.000000))
        GetVelocityDirectionFrom=PTVD_StartPositionAndOwner
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1         //vertical smoke
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        AlphaTest=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(X=-35.000000,Z=200.000000)
        DampingFactorRange=(X=(Min=100.000000,Max=100.000000),Y=(Min=100.000000,Max=100.000000),Z=(Min=100.000000,Max=100.000000))
        ColorScale(0)=(Color=(B=60,G=60,R=60,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=160,G=160,R=160,A=255))
        Opacity=0.700000
        FadeOutStartTime=1.30000 // was 1.38
        MaxParticles=12 // was 9
      
        StartLocationRange=(X=(Min=-30.000000,Max=30.000000),Y=(Min=-30.000000,Max=30.000000),Z=(Min=0.000000,Max=0.000000)) //Start Z set to 0, instead of -200
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=4.500000)
        StartSizeRange=(X=(Min=20.000000,Max=40.000000),Y=(Min=20.000000,Max=40.000000),Z=(Min=20.000000,Max=40.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Smoke.grenadesmoke'
        MinSquaredVelocity=150.000000
        LifetimeRange=(Min=2.00000,Max=2.5000000) //decreased with 0.5 s
        InitialDelayRange=(Min=0.000000,Max=0.000000) //Was 0.1
        StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=400.000000,Max=1000.000000)) //z min-max set to 400-1000, was 1300-1700
        VelocityLossRange=(Z=(Min=6.00000,Max=7.00000)) // Was 4.5
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter3         //dirt projectiles
        UseDirectionAs=PTDU_Up
        UseCollision=True
        UseMaxCollisions=True
        UseSpawnedVelocityScale=True
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-1000.000000)
        DampingFactorRange=(X=(Min=0.600000,Max=0.600000),Y=(Min=0.600000,Max=0.600000),Z=(Min=0.600000,Max=0.600000))
        MaxCollisions=(Min=1.000000,Max=1.000000)
        SpawnAmount=1
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128,A=255))
        FadeOutStartTime=0.025000
        MaxParticles=15 // was 8
      
        StartSizeRange=(X=(Min=1.3,Max=2.8),Y=(Min=1.3,Max=2.8),Z=(Min=5.000000,Max=6.000000)) //increased size 
        InitialParticlesPerSecond=64.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.stonechunksfinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=3.000000,Max=3.000000)
        InitialDelayRange=(Min=0.200000,Max=0.200000)
        StartVelocityRange=(X=(Min=-250.000000,Max=250.000000),Y=(Min=-250.000000,Max=250.000000),Z=(Min=800.000000,Max=1000.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter3'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter8         //lingering smoke after explosion
        UseCollision=True
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(X=-5.000000,Z=-5.000000)
        DampingFactorRange=(X=(Min=100.000000,Max=100.000000),Y=(Min=100.000000,Max=100.000000),Z=(Min=100.000000,Max=100.000000))
        ColorScale(0)=(Color=(B=200,G=200,R=200,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=223,G=223,R=223,A=255))
        Opacity=0.200000 // was 0.3
        FadeOutStartTime=1.320000
        FadeInEndTime=0.360000
        CoordinateSystem=PTCS_Relative
        MaxParticles=5
      
        StartLocationRange=(X=(Min=-30.000000,Max=30.000000),Y=(Min=-30.000000,Max=30.000000))
        StartLocationShape=PTLS_Sphere
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=5.000000)
        StartSizeRange=(X=(Min=12.000000,Max=20.000000),Y=(Min=12.000000,Max=20.000000),Z=(Min=12.000000,Max=20.000000))
        InitialParticlesPerSecond=2.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.snowfinal2'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        MinSquaredVelocity=50.000000
        LifetimeRange=(Min=1.2000000) //was 2
        InitialDelayRange=(Min=1.000000,Max=1.000000)
        StartVelocityRange=(Z=(Min=25.000000,Max=30.000000))
        MaxAbsVelocity=(X=100.000000,Y=100.000000)
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter8'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5         //Expanding explosion taken from ROEffects and adjusted
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-75.000000)
        ColorScale(0)=(Color=(B=60,G=60,R=60,A=255)) //was 255
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=160,G=160,R=160,A=255)) //was 255
        FadeOutStartTime=0.100000 // was 0.13
        MaxParticles=2
        Name="SpriteEmitter23"
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.500000)
        StartSizeRange=(X=(Min=50.000000,Max=50.000000),Y=(Min=50.000000,Max=50.000000),Z=(Min=50.000000,Max=50.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.explosion_1frame'
        LifetimeRange=(Min=0.200000,Max=0.300000) //was 0.4 to 0.5
        StartVelocityRange=(Z=(Min=200.000000,Max=200.000000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter5'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter6         //invisible shrapnel projectiles
        UseCollision=True
        UseCollisionPlanes=True
        UseMaxCollisions=True
        UseSpawnedVelocityScale=True
        RespawnDeadParticles=False
        UniformSize=True
        Acceleration=(Z=-1000.000000)
        MaxCollisions=(Min=1.000000,Max=2.000000)
        SpawnFromOtherEmitter=6
        SpawnAmount=1
        SpawnedVelocityScaleRange=(X=(Min=-7.000000,Max=7.000000),Y=(Min=-7.000000,Max=7.000000),Z=(Min=-7.000000,Max=7.000000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=20 //Was 12
      
        StartLocationRange=(Z=(Min=100.000000,Max=200.000000))
        StartSizeRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        LifetimeRange=(Min=0.500000,Max=0.70000) // was 0.2
        StartVelocityRange=(X=(Min=-3000.000000,Max=3000.000000),Y=(Min=-3000.000000,Max=3000.000000),Z=(Min=-3000.000000,Max=3000.000000))
        VelocityLossRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=3.000000,Max=3.000000),Z=(Min=3.000000,Max=3.000000))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter6'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter7         //Shrapnel hit effects
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.450000
        FadeOutStartTime=0.285000
        MaxParticles=20 //Was 12
      
        SpinsPerSecondRange=(X=(Max=0.050000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=15.000000)
        StartSizeRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=1.000000,Max=2.000000),Z=(Min=1.000000,Max=2.000000))
        InitialParticlesPerSecond=0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke1'
        LifetimeRange=(Min=1.500000,Max=1.500000)
        InitialDelayRange=(Min=0.0,Max=0.0) // was 0.3 to 0.4
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter7'

    AutoDestroy=True
    bNoDelete=False
   
   // Light Flash
   bUseFlash=true

   bDynamicLight=false

   LightEffect=LE_NonIncidence
   LightType=LT_Steady
   LightBrightness = 128.0 //64
   LightRadius = 16.0 //16
   LightHue = 20
   LightSaturation = 28
   AmbientGlow = 254
   LightCone = 8
}

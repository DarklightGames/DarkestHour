//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHBulletHitFleshEffect extends emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter31
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=1
        name="flash"
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=4.000000,Max=8.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.100000,Max=0.100000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter31'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter98
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(R=49,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=239,A=255))
        FadeOutStartTime=0.100000
        MaxParticles=1
        name="initial_spray"
        UseRotationFrom=PTRS_Actor
        StartLocationOffset=(X=10.000000)
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=10.000000,Max=15.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.radialexplosion_1frame'
        LifetimeRange=(Min=0.150000,Max=0.250000)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter98'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter30
        UseColorScale=true
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(R=79,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=79,A=255))
        Opacity=0.75
        FadeOutStartTime=0.100000
        MaxParticles=2
        name="2nd_spray"
        UseRotationFrom=PTRS_Actor
        //StartLocationOffset=(X=10.000000)
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.10000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.500000)
        StartSizeRange=(X=(Min=15.000000,Max=30.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.blood.blood_spatter1'
        InitialDelayRange=(Min=0.05000,Max=0.100000)
        LifetimeRange=(Min=0.250000,Max=0.350000)
        StartVelocityRange=(X=(Min=5.000000,Max=10.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter30'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter26
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-300.000000)
        DampingFactorRange=(X=(Min=0.150000,Max=0.250000),Y=(Min=0.150000,Max=0.250000),Z=(Min=0.150000,Max=0.250000))
        ColorScale(0)=(Color=(R=59,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=59,A=255))
        FadeOutStartTime=0.150000
        MaxParticles=8 // 25
        name="bloody_chunks"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.200000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.100000)
        StartSizeRange=(X=(Min=1.000000,Max=1.50000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.snowchunksfinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.550000,Max=0.750000)
        InitialDelayRange=(Min=0.05000,Max=0.100000)
        StartVelocityRange=(X=(Min=50.000000,Max=325.000000),Y=(Min=-150.000000,Max=100.000000),Z=(Min=-150.000000,Max=200.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter26'

    Autodestroy=true
    bnodelete=false
}

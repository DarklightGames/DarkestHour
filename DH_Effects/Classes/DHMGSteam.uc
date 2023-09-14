//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMGSteam extends ROMGSteam;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=true
        FadeIn=true
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(Z=25.0) // different
        FadeOutStartTime=1.0
        FadeInEndTime=0.2
        MaxParticles=64
        Name="SpriteEmitter2"
        SpinsPerSecondRange=(X=(Min=0.1,Max=0.2))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=16.0) // different
        StartSizeRange=(X=(Min=1.5,Max=4.0),Y=(Min=1.5,Max=4.0),Z=(Min=1.5,Max=4.0)) // different
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        SecondsBeforeInactive=0.0
        LifetimeRange=(Min=2.0)
        StartVelocityRange=(Z=(Min=8.0,Max=12.0)) // added
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHWakeEmitter extends Emitter;

function PostBeginPlay()
{
    local float F;
    super.PostBeginPlay();

    if (Instigator != none)
    {
        F = (70 + 30*FRand()) * sqrt(Instigator.CollisionRadius/25);
        Emitters[0].StartSizeRange.X.Min = F;
        Emitters[0].StartSizeRange.X.Max = F;
        Emitters[0].StartSizeRange.Y.Min = F;
        Emitters[0].StartSizeRange.Y.Max = F;
        Emitters[0].StartSizeRange.Z.Min = F;
        Emitters[0].StartSizeRange.Z.Max = F;
    }
}

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UseDirectionAs=PTDU_Normal
        ProjectionNormal=(X=1.0,Z=0.0)
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        DampRotation=true
        UseSizeScale=true
        UseRegularSizeScale=false
        AutomaticInitialSpawning=false
        BlendBetweenSubdivisions=true
        UseSubdivisionScale=true
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=195))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=195))
        MaxParticles=1
        UseRotationFrom=PTRS_Actor
        SpinCCWorCW=(X=0.0,Y=0.0,Z=0.0)
        SpinsPerSecondRange=(X=(Min=-0.1,Max=0.1))
        SizeScale(0)=(RelativeSize=3.0)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=7.5)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=12.0)
        StartSizeRange=(X=(Min=20.0,Max=25.0),Y=(Min=20.0,Max=25.0),Z=(Min=20.0,Max=25.0))
        InitialParticlesPerSecond=150.0
        DrawStyle=PTDS_AlphaBlend
        Texture=texture'DH_FX_Tex.Wake.wake4'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        SubdivisionScale(0)=0.5
        LifetimeRange=(Min=2.0,Max=3.5)
    End Object
    Emitters(0)=SpriteEmitter'DH_Game.DHWakeEmitter.SpriteEmitter0'
    AutoDestroy=true
    bNoDelete=false
    bHighDetail=true
}

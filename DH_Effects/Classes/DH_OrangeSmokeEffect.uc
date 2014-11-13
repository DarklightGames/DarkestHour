//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_OrangeSmokeEffect extends Emitter;

simulated function PostBeginPlay()
{
    SetTimer(20,false);
}

simulated function Timer()
{
    //Level.Game.Broadcast(self,"Timer ticking");
    Emitters[0].StartVelocityRange.X.Min += 1;
    Emitters[0].StartVelocityRange.X.Max -= 0.5;
    Emitters[0].StartVelocityRange.Y.Min += 1;
    Emitters[0].StartVelocityRange.Y.Max -= 1;
    Emitters[0].StartVelocityRange.Z.Min -= 3.5;
    Emitters[0].StartVelocityRange.Z.Max -= 5;
    Emitters[0].StartSizeRange.X.Min -= 2.5;
    Emitters[0].StartSizeRange.X.Max -= 2.5;
    Emitters[0].StartSizeRange.Y.Min -= 2.5;
    Emitters[0].StartSizeRange.Y.Max -= 2.5;
    Emitters[0].StartSizeRange.Z.Min -= 2.5;
    Emitters[0].StartSizeRange.Z.Max -= 2.5;
    Emitters[0].LifetimeRange.Min -= 1;
    Emitters[0].LifetimeRange.Max -= 1;
    Emitters[0].FadeOutStartTime -= 1;

    if (Emitters[0].StartVelocityRange.X.Min < 0)
        SetTimer(1,false);
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=true
         FadeIn=true
         RespawnDeadParticles=false
         SpinParticles=true
         UseSizeScale=true
         UseRegularSizeScale=false
         UniformSize=true
         AutomaticInitialSpawning=false
         Acceleration=(X=7.000000)
         ColorScale(0)=(Color=(G=155,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(G=155,R=255,A=255))
         Opacity=0.600000
         FadeOutStartTime=18.000000
         FadeInEndTime=0.500000
         MaxParticles=160
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.050000))
         StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(RelativeTime=0.050000,RelativeSize=0.500000)
         SizeScale(2)=(RelativeTime=0.100000,RelativeSize=1.000000)
         SizeScale(3)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=50.000000,Max=50.000000),Y=(Min=50.000000,Max=50.000000),Z=(Min=50.000000,Max=50.000000))
         InitialParticlesPerSecond=5.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'DH_FX_Tex.Smoke.grenadesmokeOrange'
         LifetimeRange=(Min=25.000000,Max=30.000000)
         StartVelocityRange=(X=(Min=-15.000000,Max=15.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=40.000000,Max=70.000000))
         VelocityLossRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.050000,Max=0.050000),Z=(Min=0.100000,Max=0.100000))
     End Object
     Emitters(0)=SpriteEmitter'DH_Effects.DH_OrangeSmokeEffect.SpriteEmitter0'

     AutoDestroy=true
     bNoDelete=false
     bNetTemporary=true
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=80.000000
     Style=STY_Masked
     bHardAttach=true
     bDirectional=true
}

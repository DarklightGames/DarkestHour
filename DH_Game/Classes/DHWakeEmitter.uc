//=============================================================================
// 	DHWakeEmitter 
//=============================================================================

class DHWakeEmitter extends Emitter;

function PostBeginPlay()
{
	local float F;
	Super.PostBeginPlay();

	if ( Instigator != None )
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
         ProjectionNormal=(X=1.000000,Z=0.000000)
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         DampRotation=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         UseSubdivisionScale=True
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=195))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=195))
         MaxParticles=1
         UseRotationFrom=PTRS_Actor
         SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         SizeScale(0)=(RelativeSize=3.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=7.500000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=12.000000)
         StartSizeRange=(X=(Min=20.000000,Max=25.000000),Y=(Min=20.000000,Max=25.000000),Z=(Min=20.000000,Max=25.000000))
         InitialParticlesPerSecond=150.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'DH_FX_Tex.Wake.wake4'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         SubdivisionScale(0)=0.500000
         LifetimeRange=(Min=2.000000,Max=3.500000)
     End Object
     Emitters(0)=SpriteEmitter'DH_Game.DHWakeEmitter.SpriteEmitter0'

     AutoDestroy=True
     bNoDelete=False
     bHighDetail=True
}

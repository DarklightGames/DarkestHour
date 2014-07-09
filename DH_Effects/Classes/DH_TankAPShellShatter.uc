class DH_TankAPShellShatter extends Emitter;

defaultproperties
{
     Begin Object Class=SparkEmitter Name=SparkEmitter0
         LineSegmentsRange=(Min=1.000000,Max=3.000000)
         TimeBetweenSegmentsRange=(Min=0.100000,Max=0.300000)
         FadeOut=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         Acceleration=(Z=-10.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.250000
         FadeInEndTime=0.250000
         MaxParticles=512
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=1.000000)
         UseRotationFrom=PTRS_Actor
         StartSizeRange=(X=(Min=200.000000,Max=200.000000),Y=(Min=200.000000,Max=200.000000),Z=(Min=200.000000,Max=200.000000))
         InitialParticlesPerSecond=65536.000000
         Texture=Texture'Effects_Tex.BulletHits.sparkfinal2'
         LifetimeRange=(Min=0.200000,Max=0.500000)
         StartVelocityRange=(X=(Min=-256.000000,Max=256.000000),Y=(Min=-1024.000000,Max=1024.000000),Z=(Min=-256.000000,Max=256.000000))
     End Object
     Emitters(1)=SparkEmitter'DH_Effects.DH_TankAPShellShatter.SparkEmitter0'

     AutoDestroy=True
     bLightChanged=True
     bNoDelete=False
     bNetTemporary=True
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=4.000000
     Style=STY_Masked
     bHardAttach=True
     bDirectional=True
     bSelected=True
}

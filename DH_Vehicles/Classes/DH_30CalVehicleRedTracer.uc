//=============================================================================
// DH_AmericanRedTracer
//=============================================================================
class DH_30CalVehicleRedTracer extends Emitter;

defaultproperties
{
     Begin Object Class=TrailEmitter Name=TrailEmitter0
         TrailShadeType=PTTST_PointLife
         TrailLocation=PTTL_FollowEmitter
         MaxPointsPerTrail=150
         DistanceThreshold=80.000000
         UseCrossedSheets=True
         PointLifeTime=0.200000
         UseColorScale=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(R=255))
         Opacity=0.650000
         MaxParticles=1
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=2.000000,Max=2.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'Effects_Tex.Weapons.trailblur'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.500000,Max=2.500000)
     End Object
     Emitters(0)=TrailEmitter'DH_Vehicles.DH_30CalVehicleRedTracer.TrailEmitter0'

     AutoDestroy=True
     bNoDelete=False
     Physics=PHYS_Trailer
     bHardAttach=True
}

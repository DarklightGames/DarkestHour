//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Flakvierling38CannonPawn extends DH_Flak38CannonPawn;

defaultproperties
{
    IntermediatePositionIndex=-1 // remove 'intermediate' position inherited from FlaK 38 (at least until a real 'closed' firing anim is added for the optics position)
    DriverPositions(0)=(ViewLocation=(X=30.0,Y=0.0,Z=0.0),PositionMesh=SkeletalMesh'DH_Flak38_anm.flakvierling_turret')
    DriverPositions(1)=(ViewLocation=(X=0.0,Y=0.0,Z=0.0),PositionMesh=SkeletalMesh'DH_Flak38_anm.flakvierling_turret')
    DriverPositions(2)=(ViewLocation=(X=0.0,Y=0.0,Z=0.0),PositionMesh=SkeletalMesh'DH_Flak38_anm.flakvierling_turret')
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Flak38_anm.flakvierling_turret')
    GunClass=class'DH_Guns.DH_Flakvierling38Cannon'
    DrivePos=(X=3.0,Y=0.0,Z=4.0)
}

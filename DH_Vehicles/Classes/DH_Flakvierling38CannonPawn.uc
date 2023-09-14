//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Flakvierling38CannonPawn extends DH_Flak38CannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_Flakvierling38Cannon'
    DriverPositions(0)=(ViewLocation=(X=30.0,Y=0.0,Z=0.0),PositionMesh=SkeletalMesh'DH_Flak38_anm.flakvierling_turret')
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Flak38_anm.flakvierling_turret')
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Flak38_anm.flakvierling_turret')
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Flak38_anm.flakvierling_turret')
    DrivePos=(X=-80.0,Y=-2.5,Z=34.0)
    DriveAnim="VUC_driver_idle_open"
}

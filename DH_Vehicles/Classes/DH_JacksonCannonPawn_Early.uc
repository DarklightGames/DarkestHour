//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JacksonCannonPawn_Early extends DH_JacksonCannonPawn;

defaultproperties
{
    DriverPositions(0)=(ViewLocation=(Z=6.0),PositionMesh=SkeletalMesh'DH_Jackson_anm.jackson_turret_extB',ViewPitchUpLimit=5461)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Jackson_anm.jackson_turret_extB',ViewPitchDownLimit=60000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Jackson_anm.jackson_turret_extB',ViewPitchDownLimit=60000)
    GunClass=class'DH_Vehicles.DH_JacksonCannon_Early'
}

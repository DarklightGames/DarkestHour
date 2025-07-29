//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Cannone4732NoWheelsCannonPawn extends DH_Cannone4732CannonPawn;

defaultproperties
{
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Cannone4732_anm.cannone4732_turret',ViewFOV=28.33,TransitionUpAnim="com_sight_out",bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Cannone4732_anm.cannone4732_turret',TransitionUpAnim="com_stand_in",TransitionDownAnim="com_sight_in",DriverTransitionAnim="cannone4732_nw_gunner_close",ViewPitchUpLimit=16384,ViewPitchDownLimit=57344,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Cannone4732_anm.cannone4732_turret',TransitionDownAnim="com_stand_out",DriverTransitionAnim="cannone4732_nw_gunner_open",ViewPitchUpLimit=16384,ViewPitchDownLimit=57344,bDrawOverlays=true,bExposed=true)
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Cannone4732_anm.cannone4732_turret',DriverTransitionAnim="cannone4732_nw_gunner_binocs",ViewPitchUpLimit=16384,ViewPitchDownLimit=57344,bDrawOverlays=true,bExposed=true)
    DriveAnim="cannone4732_nw_gunner_closed"
}

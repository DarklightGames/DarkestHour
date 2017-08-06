//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_M16Halftrack extends DH_M3Halftrack;

#exec OBJ LOAD FILE=..\Animations\DH_M3Halftrack_anm.ukx

defaultproperties
{
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_M3Halftrack_anm.m16_body')
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_M3Halftrack_anm.m16_body')
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_M3Halftrack_anm.m16_body')

    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_M45QuadmountMGPawn',WeaponBone="turret_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=40,Y=35,Z=75),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-10,Y=-30,Z=85),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-45,Y=-30,Z=85),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-10,Y=30,Z=85),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(4)=(AttachBone="body",DrivePos=(X=-45,Y=30,Z=85),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider5_idle")
    VehicleHudImage=texture'DH_M3Halftrack_tex.hud.m16_body'
    VehicleHudTurret=TexRotator'DH_M3Halftrack_tex.hud.m16_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_M3Halftrack_tex.hud.m16_turret_look'

    VehicleHudOccupantsX(0)=0.45    // driver
    VehicleHudOccupantsY(0)=0.45
    VehicleHudOccupantsX(1)=0.50    // gunner
    VehicleHudOccupantsY(1)=0.72
    VehicleHudOccupantsX(2)=0.55    // front passenger
    VehicleHudOccupantsY(2)=0.45

    VehicleHudOccupantsX(3)=0.45
    VehicleHudOccupantsY(3)=0.55
    VehicleHudOccupantsX(4)=0.45
    VehicleHudOccupantsY(4)=0.6125
    VehicleHudOccupantsX(5)=0.55
    VehicleHudOccupantsY(5)=0.55
    VehicleHudOccupantsX(6)=0.55
    VehicleHudOccupantsY(6)=0.6125

    VehicleNameString="M16 Halftrack"
    Mesh=SkeletalMesh'DH_M3Halftrack_anm.m16_body'
    SpawnOverlay(0)=material'DH_M3Halftrack_tex.hud.m16_menu'
}


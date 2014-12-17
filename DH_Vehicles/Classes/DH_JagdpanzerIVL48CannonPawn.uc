//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JagdpanzerIVL48CannonPawn extends DH_JagdpanzerIVCannonPawn;

defaultproperties
{
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'
    DriverPositions(0)=(ViewLocation=(X=-20.000000,Y=-30.000000,Z=25.000000),ViewFOV=14.400000,PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L48_turret_int',TransitionUpAnim="Overlay_In",ViewPitchUpLimit=2731,ViewPitchDownLimit=64653,ViewPositiveYawLimit=1820,ViewNegativeYawLimit=-1820,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L48_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VStug3_com_close",ViewPitchUpLimit=1,ViewPitchDownLimit=65300,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L48_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VStug3_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L48_turret_int',ViewPitchUpLimit=10000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Vehicles.DH_JagdpanzerIVL48Cannon'
    VehiclePositionString="in a Jagdpanzer IV/48 cannon"
    VehicleNameString="Jagdpanzer IV/48 cannon"
}


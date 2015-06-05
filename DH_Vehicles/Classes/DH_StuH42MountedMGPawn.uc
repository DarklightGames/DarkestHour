//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_StuH42MountedMGPawn extends DHVehicleMGPawn;

#exec OBJ LOAD FILE=..\Textures\DH_VehicleOptics_tex.utx

// Can't fire unless buttoned up & controlling the remote MG
function bool CanFire()
{
    return DriverPositionIndex < UnbuttonedPositionIndex && !IsInState('ViewTransition');
}

// Modified so if player buttons up & is now on the gun, rotation is set to match the direction MG is facing (after looking around while unbuttoned)
simulated state ViewTransition
{
    simulated function EndState()
    {
        super.EndState();

        if (DriverPositionIndex < UnbuttonedPositionIndex)
        {
            MatchRotationToGunAim();
        }
    }
}

defaultproperties
{
    bKeepDriverAuxCollision=true
    OverlayCenterSize=0.7
    MGOverlay=texture'DH_VehicleOptics_tex.German.KZF2_MGSight'
    FirstPersonGunShakeScale=0.85
    WeaponFOV=41.0
    DriverPositions(0)=(ViewFOV=41.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.StuH_mg_remote',TransitionUpAnim="com_open",DriverTransitionAnim="VPanzer3_com_close",ViewPitchUpLimit=4500,ViewPitchDownLimit=64500,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.StuH_mg_remote',TransitionDownAnim="com_close",DriverTransitionAnim="VPanzer3_com_open",ViewPitchUpLimit=4500,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bExposed=true)
    bMultiPosition=true
    GunClass=class'DH_Vehicles.DH_StuH42MountedMG'
    bHasAltFire=false
    CameraBone="loader_cam"
    GunsightCameraBone="Gun"
    DrivePos=(Z=-9.0)
    DriveAnim="VPanzer3_com_idle_close"
    EntryRadius=130.0
    PitchUpLimit=6000
    PitchDownLimit=63500
}

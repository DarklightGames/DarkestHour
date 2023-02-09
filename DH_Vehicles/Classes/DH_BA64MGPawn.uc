//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BA64MGPawn extends DHVehicleMGPawn;

// Can't fire if using binoculars
function bool CanFire()
{
    return DriverPositionIndex != BinocPositionIndex || !IsHumanControlled();
}

// Modified so if player moves off binoculars (where he could look around) & back onto the MG, we match rotation back to the direction MG is facing
// Otherwise rotation becomes de-synced & he can have the wrong view rotation if he moves back onto binocs or exits
// Note we do this from state LeavingViewTransition instead of ViewTransition so that a CanFire() check in SetInitialViewRotation() works properly
simulated state LeavingViewTransition
{
    simulated function EndState()
    {
        super.EndState();

        if (LastPositionIndex == BinocPositionIndex && IsFirstPerson())
        {
            SetInitialViewRotation();
        }
    }
}

defaultproperties
{
    //Gun Class
    GunClass=class'DH_Vehicles.DH_BA64MG'
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn

    //Driver's positions and anims
    DriverPositions(0)=(ViewLocation=(X=0,Y=0,Z=0),ViewFOV=72.0,PositionMesh=Mesh'DH_BA64_anm.BA64_turret_int',DriverTransitionAnim=VBA64_com_close,TransitionUpAnim=com_open,ViewPitchUpLimit=3500,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewLocation=(X=0,Y=0,Z=0),PositionMesh=Mesh'DH_BA64_anm.BA64_turret_int',DriverTransitionAnim=VBA64_com_open,TransitionDownAnim=com_close,ViewPitchUpLimit=3500,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    DriverPositions(2)=(ViewLocation=(X=0,Y=0,Z=0),ViewFOV=12.0,PositionMesh=Mesh'DH_BA64_anm.BA64_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63000,bDrawOverlays=true,bExposed=true)

    PositionInArray=0
    UnbuttonedPositionIndex=0
    BinocPositionIndex=2
    bDrawDriverInTP=true
    DrivePos=(X=-5.0,Y=0,Z=-1.0)
    DriveRot=(Pitch=0,Roll=0,Yaw=0)
    CameraBone="Camera_com"
    DriveAnim="VBA64_com_idle_close"

    //HUD
    HUDOverlayClass=class'ROVehicles.ROVehDTOverlay'
    HUDOverlayOffset=(X=-30.0,Y=0.0,Z=0.0)
    HUDOverlayFOV=45.0
    VehicleMGReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.DT_ammo_reload'

    bMultiPosition=true
    bMustBeTankCrew=false
    bCustomAiming = true

    FirstPersonGunRefBone="1stperson_wep"
    FirstPersonGunShakeScale=3.0
    FirstPersonOffsetZScale=3.0
    bHideMuzzleFlashAboveSights=true
}

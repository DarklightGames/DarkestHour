//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_HigginsBoatMGPawn extends DH_M3A1HalftrackMGPawn;

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
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_M3A1Halftrack_anm.m3halftrack_gun_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5300,ViewPitchDownLimit=63000,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true,bExposed=true)
    BinocPositionIndex=2
    BinocsOverlay=texture'DH_VehicleOptics_tex.Allied.BINOC_overlay_7x50Allied'
}

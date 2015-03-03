//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_HetzerCannonPawn extends DH_AssaultGunCannonPawn;

// Modified to play idle animation on server as workaround to stop collision box glitch on the roof
function bool KDriverLeave(bool bForceLeave)
{
    if (super.KDriverLeave(bForceLeave))
    {
        if (Gun != none && Gun.HasAnim(Gun.BeginningIdleAnim))
        {
            Gun.PlayAnim(Gun.BeginningIdleAnim);
        }

        return true;
    }

    return false;
}

// Modified to run state 'ViewTransition' on server when buttoning up, so transition down anim plays on server & puts commander's collision box in correct position
function ServerChangeViewPoint(bool bForward)
{
    if (bForward)
    {
        if (DriverPositionIndex < (DriverPositions.Length - 1))
        {
            LastPositionIndex = DriverPositionIndex;
            DriverPositionIndex++;

            if (Level.NetMode == NM_Standalone  || Level.NetMode == NM_ListenServer)
            {
                NextViewPoint();
            }
            else if (Level.NetMode == NM_DedicatedServer)
            {
                // Run the state on the server whenever we're unbuttoning in order to prevent early exit
                if (DriverPositionIndex == UnbuttonedPositionIndex)
                {
                    GoToState('ViewTransition');
                }
            }
        }
    }
    else
    {
        if (DriverPositionIndex > 0)
        {
            LastPositionIndex = DriverPositionIndex;
            DriverPositionIndex--;

            if (Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
            {
                NextViewPoint();
            }
            else if (Level.NetMode == NM_DedicatedServer) // added this section to run the state 'ViewTransition' on the server when buttoning up
            {
                if (LastPositionIndex == UnbuttonedPositionIndex)
                {
                    GoToState('ViewTransition');
                }
            }
        }
    }
}

// Modified so ViewLocation & FOV are only changed after transition animation finishes, when moving to the (zoomed) periscope position
simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        StoredVehicleRotation = VehicleBase.Rotation;

        if (Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone  || Level.NetMode == NM_ListenServer)
        {
            if (DriverPositions[DriverPositionIndex].PositionMesh != none && Gun != none)
            {
                Gun.LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
            }
        }

        if (Driver != none && Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim) && Driver.HasAnim(DriverPositions[LastPositionIndex].DriverTransitionAnim))
        {
            Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
        }

        WeaponFOV = DriverPositions[DriverPositionIndex].ViewFOV;

//      FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation; // moved this to 'if' section below so FPCamPos isn't set yet

        // Included periscope position in the exception (was != 0) so FOV isn't set yet if moving to peri position (we do it after transition anim finishes)
        if (DriverPositionIndex > PeriscopePositionIndex)
        {
            // Moved this here so FPCamPos isn't set now if transitioning down to periscope position (instead do it after transition anim finishes)
            FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;

            if (DriverPositions[DriverPositionIndex].bDrawOverlays)
            {
                PlayerController(Controller).SetFOV(WeaponFOV);
            }
            else
            {
                PlayerController(Controller).DesiredFOV = WeaponFOV;
            }
        }

        if (LastPositionIndex < DriverPositionIndex)
        {
            if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionUpAnim))
            {
                Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionUpAnim);
                SetTimer(Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionUpAnim, 1.0), false);
            }
            else
            {
                GotoState('');
            }
        }
        else if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionDownAnim))
        {
            Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionDownAnim);
            SetTimer(Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionDownAnim, 1.0), false);
        }
        else
        {
            GotoState('');
        }
    }

    simulated function EndState()
    {
        if (PlayerController(Controller) != none)
        {
            PlayerController(Controller).SetFOV(WeaponFOV); // was SetFOV(DriverPositions[DriverPositionIndex].ViewFOV) but WeaponFOV has already been set to that

            if (DriverPositionIndex <= PeriscopePositionIndex) // added so ViewLocation is set only after transition anim completes, if moving to periscope position
            {
                FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
            }
        }
    }
}

defaultproperties
{
    OverlayCenterSize=0.555
    PeriscopePositionIndex=1
    bManualTraverseOnly=true
    ManualRotateSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    ManualRotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.German.stug3_SflZF1a_sight'
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.stug3_SflZF1a_destroyed'
    WeaponFOV=14.4
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'
    DriverPositions(0)=(ViewLocation=(X=-50.0,Y=-29.2,Z=34.4),ViewFOV=14.4,PositionMesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_turret',ViewPitchUpLimit=2185,ViewPitchDownLimit=64444,ViewPositiveYawLimit=2000,ViewNegativeYawLimit=-910,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(Z=10.0),ViewFOV=7.2,PositionMesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_turret',TransitionUpAnim="com_open",DriverTransitionAnim="VStug3_com_close",ViewPitchUpLimit=1200,ViewPitchDownLimit=64500,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=80.0,PositionMesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_turret',TransitionDownAnim="com_close",DriverTransitionAnim="VStug3_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_turret',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Vehicles.DH_HetzerCannon'
    bHasAltFire=false
    CameraBone="Turret"
    ManualMinRotateThreshold=0.5
    ManualMaxRotateThreshold=3.0
    DrivePos=(X=6.0,Z=-35.0)
    DriveAnim="VStug3_com_idle_close"
    EntryRadius=130.0
    TPCamDistance=300.0
    TPCamLookat=(X=-25.0,Z=0.0)
    TPCamWorldOffset=(Z=120.0)
    SoundVolume=130
}

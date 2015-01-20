//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_HetzerCannonPawn extends DH_AssaultGunCannonPawn;

// Cheating here to always spawn exiting players above their exit hatch, regardless of tank, without having to set it individually
simulated function PostBeginPlay() // Matt: modified to lower the commander's exit position above the roof
{
    local vector Offset;
    local vector Loc;

    super(Vehicle).PostBeginPlay(); // Matt: skipping over the super in DH_ROTankCannonPawn

    Offset.Z += 165; // Matt: this was 250 but the exit was a long way above the roof
    Loc = GetBoneCoords('com_player').ZAxis;

    ExitPositions[0] = Loc + Offset;
    ExitPositions[1] = ExitPositions[0];

    bTurretRingDamaged = false;
    bGunPivotDamaged = false;
}

// Matt: modified to prevent tank crew from switching to rider positions unless unbuttoned
function ServerChangeDriverPosition(byte F)
{
    // Matt: if trying to switch to vehicle position 4 or 5, which are the rider positions, and player is buttoned up or in the process of buttoning/ubuttoning
    if (F > 3 && (DriverPositionIndex < UnbuttonedPositionIndex || IsInState('ViewTransition')))
    {
        Instigator.ReceiveLocalizedMessage(class'DH_VehicleMessage', 4); // "You Must Unbutton the Hatch to Exit"
        return;
    }

    super.ServerChangeDriverPosition(F);
}

// Matt: modified to play idle animation on the server as a workaround to stop the collision box glitch on the roof
function bool KDriverLeave(bool bForceLeave)
{
    local bool bSuperDriverLeave;

    if (!bForceLeave && (DriverPositionIndex < UnbuttonedPositionIndex || Instigator.IsInState('ViewTransition')))
    {
        Instigator.ReceiveLocalizedMessage(class'DH_VehicleMessage', 4); // "You Must Unbutton the Hatch to Exit"
        return false;
    }
    else
    {
        DriverPositionIndex=InitialPositionIndex;
        LastPositionIndex=InitialPositionIndex;

        bSuperDriverLeave = super(VehicleWeaponPawn).KDriverLeave(bForceLeave);

        DH_ROTreadCraft(GetVehicleBase()).MaybeDestroyVehicle();

        // Matt: added to play idle animation on the server to stop the collision box glitch on the roof
        if (bSuperDriverLeave && Gun.HasAnim(Gun.BeginningIdleAnim))
            Gun.PlayAnim(Gun.BeginningIdleAnim);

        return bSuperDriverLeave;
    }
}

// Matt: modified to run the state 'ViewTransition' on the server when buttoning up, so the transition down anim plays on the server & puts the commander's collision box in the correct position
function ServerChangeViewPoint(bool bForward)
{
    if (bForward)
    {
        if (DriverPositionIndex < (DriverPositions.Length - 1))
        {
            LastPositionIndex = DriverPositionIndex;
            DriverPositionIndex++;

            if (Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer)
            {
                NextViewPoint();
            }

            if (Level.NetMode == NM_DedicatedServer)
            {
                // Run the state on the server whenever we're unbuttoning in order to prevent early exit
                if (DriverPositionIndex == UnbuttonedPositionIndex)
                    GoToState('ViewTransition');
            }
        }
    }
    else
    {
        if (DriverPositionIndex > 0)
        {
            LastPositionIndex = DriverPositionIndex;
            DriverPositionIndex--;

            if (Level.Netmode == NM_Standalone || Level.Netmode == NM_ListenServer)
            {
                NextViewPoint();
            }

            if (Level.NetMode == NM_DedicatedServer) // Matt: added this section to run the state 'ViewTransition' on the server when buttoning up
            {
                if (LastPositionIndex == UnbuttonedPositionIndex)
                    GoToState('ViewTransition');
            }
        }
    }
}

// Matt: overridden so that ViewLocation & FOV are only changed after the transition animation finishes, when moving to the (zoomed) periscope position
simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        StoredVehicleRotation = VehicleBase.Rotation;

        if (Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer)
        {
            if (DriverPositions[DriverPositionIndex].PositionMesh != none && Gun != none)
                Gun.LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
        }

        if (Driver != none && Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim)
            && Driver.HasAnim(DriverPositions[LastPositionIndex].DriverTransitionAnim))
        {
            Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
        }

        WeaponFOV = DriverPositions[DriverPositionIndex].ViewFOV;

//      FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation; // Matt: moved this to 'if' section below so FPCamPos isn't set yet

        // Matt: included periscope position in the exception (was != 0) so FOV isn't set yet if we're moving to the peri position (we do it after the transition anim finishes)
        if (DriverPositionIndex > PeriscopePositionIndex)
        {
            // Matt: moved this here so that FPCamPos isn't set now if we're transitioning down to the periscope position (instead we do it after the transition anim finishes)
            FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;

            if (DriverPositions[DriverPositionIndex].bDrawOverlays)
                PlayerController(Controller).SetFOV(WeaponFOV);
            else
                PlayerController(Controller).DesiredFOV = WeaponFOV;
        }

        if (LastPositionIndex < DriverPositionIndex)
        {
            if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionUpAnim))
            {
                Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionUpAnim);
                SetTimer(Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionUpAnim, 1.0), false);
            }
            else
                GotoState('');
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
            PlayerController(Controller).SetFOV(WeaponFOV); // Matt: was SetFOV(DriverPositions[DriverPositionIndex].ViewFOV) but WeaponFOV has already been set to that so this is simpler

            if (DriverPositionIndex <= PeriscopePositionIndex) // Matt: added so ViewLocation is set only after the transition animation completes, if we're moving to the periscope position
                FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
        }
    }
}

defaultproperties
{
    OverlayCenterSize=0.555000
    PeriscopePositionIndex=1
    bManualTraverseOnly=true
    ManualRotateSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    ManualRotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    PoweredRotateSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    PoweredRotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.German.stug3_SflZF1a_sight'
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.stug3_SflZF1a_destroyed'
    WeaponFOV=14.400000
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'
    DriverPositions(0)=(ViewLocation=(X=-50.000000,Y=-29.200001,Z=34.400002),ViewFOV=14.400000,PositionMesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_turret',ViewPitchUpLimit=2185,ViewPitchDownLimit=64444,ViewPositiveYawLimit=2000,ViewNegativeYawLimit=-910,bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(Z=10.000000),ViewFOV=7.200000,PositionMesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_turret',TransitionUpAnim="com_open",DriverTransitionAnim="VStug3_com_close",ViewPitchUpLimit=1200,ViewPitchDownLimit=64500,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=80.000000,PositionMesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_turret',TransitionDownAnim="com_close",DriverTransitionAnim="VStug3_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_turret',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Vehicles.DH_HetzerCannon'
    bHasAltFire=false
    CameraBone="Turret"
    RotateSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    RotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    ManualMinRotateThreshold=0.500000
    ManualMaxRotateThreshold=3.000000
    DrivePos=(X=6.000000,Z=-35.000000)
    DriveAnim="VStug3_com_idle_close"
    EntryRadius=130.000000
    TPCamDistance=300.000000
    TPCamLookat=(X=-25.000000,Z=0.000000)
    TPCamWorldOffset=(Z=120.000000)
    SoundVolume=130
}

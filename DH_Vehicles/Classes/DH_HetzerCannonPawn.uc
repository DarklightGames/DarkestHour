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

    bTurretRingDamaged=false;
    bGunPivotDamaged=false;
}

// Matt: modified to prevent tank crew from switching to rider positions unless unbuttoned
function ServerChangeDriverPosition(byte F)
{
    // Matt: if trying to switch to vehicle position 4 or 5, which are the rider positions, and player is buttoned up or in the process of buttoning/ubuttoning
    if( F > 3 && (DriverPositionIndex < UnbuttonedPositionIndex || IsInState('ViewTransition')) )
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

    if( !bForceLeave && (DriverPositionIndex < UnbuttonedPositionIndex || Instigator.IsInState('ViewTransition')) )
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
        if( bSuperDriverLeave && Gun.HasAnim(Gun.BeginningIdleAnim))
            Gun.PlayAnim(Gun.BeginningIdleAnim);

        return bSuperDriverLeave;
    }
}

// Matt: modified to run the state 'ViewTransition' on the server when buttoning up, so the transition down anim plays on the server & puts the commander's collision box in the correct position
function ServerChangeViewPoint(bool bForward)
{
    if (bForward)
    {
        if ( DriverPositionIndex < (DriverPositions.Length - 1) )
        {
            LastPositionIndex = DriverPositionIndex;
            DriverPositionIndex++;

            if( Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer )
            {
                NextViewPoint();
            }

            if( Level.NetMode == NM_DedicatedServer )
            {
                // Run the state on the server whenever we're unbuttoning in order to prevent early exit
                if( DriverPositionIndex == UnbuttonedPositionIndex )
                    GoToState('ViewTransition');
            }
        }
    }
    else
    {
        if ( DriverPositionIndex > 0 )
        {
            LastPositionIndex = DriverPositionIndex;
            DriverPositionIndex--;

            if( Level.Netmode == NM_Standalone || Level.Netmode == NM_ListenServer )
            {
                NextViewPoint();
            }

            if( Level.NetMode == NM_DedicatedServer ) // Matt: added this section to run the state 'ViewTransition' on the server when buttoning up
            {
                if( LastPositionIndex == UnbuttonedPositionIndex )
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

        if( Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer )
        {
            if( DriverPositions[DriverPositionIndex].PositionMesh != none && Gun != none)
                Gun.LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
        }

        if(Driver != none && Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim)
            && Driver.HasAnim(DriverPositions[LastPositionIndex].DriverTransitionAnim))
        {
            Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
        }

        WeaponFOV = DriverPositions[DriverPositionIndex].ViewFOV;

//      FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation; // Matt: moved this to 'if' section below so FPCamPos isn't set yet

        // Matt: included periscope position in the exception (was != 0) so FOV isn't set yet if we're moving to the peri position (we do it after the transition anim finishes)
        if( DriverPositionIndex > PeriscopePositionIndex )
        {
            // Matt: moved this here so that FPCamPos isn't set now if we're transitioning down to the periscope position (instead we do it after the transition anim finishes)
            FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;

            if( DriverPositions[DriverPositionIndex].bDrawOverlays )
                PlayerController(Controller).SetFOV( WeaponFOV );
            else
                PlayerController(Controller).DesiredFOV = WeaponFOV;
        }

        if( LastPositionIndex < DriverPositionIndex)
        {
            if( Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionUpAnim) )
            {
                Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionUpAnim);
                SetTimer(Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionUpAnim, 1.0), false);
            }
            else
                GotoState('');
        }
        else if ( Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionDownAnim) )
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
        if( PlayerController(Controller) != none )
        {
            PlayerController(Controller).SetFOV( WeaponFOV ); // Matt: was SetFOV( DriverPositions[DriverPositionIndex].ViewFOV ) but WeaponFOV has already been set to that so this is simpler

            if( DriverPositionIndex <= PeriscopePositionIndex ) // Matt: added so ViewLocation is set only after the transition animation completes, if we're moving to the periscope position
                FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
        }
    }
}

// Matt: redefined in StuH with one modified line that is crucial to camera positioning on the periscope position (would remove this if a proper periscope animamtion was made)
simulated function SpecialCalcFirstPersonView(PlayerController PC, out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
    local vector x, y, z;
    local vector VehicleZ, CamViewOffsetWorld;
    local float CamViewOffsetZAmount;
    local coords CamBoneCoords;
    local rotator WeaponAimRot;
    local quat AQuat, BQuat, CQuat;

    GetAxes(CameraRotation, x, y, z);
    ViewActor = self;

    WeaponAimRot = rotator(vector(Gun.CurrentAim) >> Gun.Rotation);
    WeaponAimRot.Roll =  GetVehicleBase().Rotation.Roll;

    if( ROPlayer(Controller) != none )
    {
        ROPlayer(Controller).WeaponBufferRotation.Yaw = WeaponAimRot.Yaw;
        ROPlayer(Controller).WeaponBufferRotation.Pitch = WeaponAimRot.Pitch;
    }

    // This makes the camera stick to the cannon, but you have no control
    if (DriverPositionIndex < GunsightPositions)
    {
        CameraRotation =  WeaponAimRot;
        // Make the cannon view have no roll
        CameraRotation.Roll = 0;
    }
    else if (bPCRelativeFPRotation)
    {
        //__________________________________________
        // First, Rotate the headbob by the player
        // controllers rotation (looking around) ---
        AQuat = QuatFromRotator(PC.Rotation);
        BQuat = QuatFromRotator(HeadRotationOffset - ShiftHalf);
        CQuat = QuatProduct(AQuat,BQuat);
        //__________________________________________
        // Then, rotate that by the vehicles rotation
        // to get the final rotation ---------------
        AQuat = QuatFromRotator(GetVehicleBase().Rotation);
        BQuat = QuatProduct(CQuat,AQuat);
        //__________________________________________
        // Make it back into a rotator!
        CameraRotation = QuatToRotator(BQuat);
    }
    else
        CameraRotation = PC.Rotation;

    if( IsInState('ViewTransition') && bLockCameraDuringTransition )
    {
        CameraRotation = Gun.GetBoneRotation( 'Camera_com' );
    }

    CamViewOffsetWorld = FPCamViewOffset >> CameraRotation;

    if(CameraBone != '' && Gun != none)
    {
        CamBoneCoords = Gun.GetBoneCoords(CameraBone);

        // Matt: not important but for consistency I've replaced DPI = 0 with DPI < GunsightPositions, as per original DH_ROTankCannonPawn
        if( DriverPositions[DriverPositionIndex].bDrawOverlays && DriverPositionIndex < GunsightPositions && !IsInState('ViewTransition'))
        {
            CameraLocation = CamBoneCoords.Origin + (FPCamPos >> WeaponAimRot) + CamViewOffsetWorld;
        }
        else
        {
//          CameraLocation = Gun.GetBoneCoords('Camera_com').Origin; // Matt: this is the default line from DH_ROTankCannonPawn, replaced by the extended line below, which makes use of the ViewLocation for the periscope position
            CameraLocation = Gun.GetBoneCoords('Camera_com').Origin + (FPCamPos >> WeaponAimRot) + CamViewOffsetWorld;
        }

        if(bFPNoZFromCameraPitch)
        {
            VehicleZ = vect(0,0,1) >> WeaponAimRot;
            CamViewOffsetZAmount = CamViewOffsetWorld dot VehicleZ;
            CameraLocation -= CamViewOffsetZAmount * VehicleZ;
        }
    }
    else
    {
        CameraLocation = GetCameraLocationStart() + (FPCamPos >> Rotation) + CamViewOffsetWorld;

        if(bFPNoZFromCameraPitch)
        {
            VehicleZ = vect(0,0,1) >> Rotation;
            CamViewOffsetZAmount = CamViewOffsetWorld Dot VehicleZ;
            CameraLocation -= CamViewOffsetZAmount * VehicleZ;
        }
    }

    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
    CameraLocation = CameraLocation + PC.ShakeOffset.X * x + PC.ShakeOffset.Y * y + PC.ShakeOffset.Z * z;
}

defaultproperties
{
     OverlayCenterSize=0.555000
     PeriscopePositionIndex=1
     DestroyedScopeOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.stug3_SflZF1a_destroyed'
     bManualTraverseOnly=true
     ManualRotateSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     ManualRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     PoweredRotateSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     CannonScopeOverlay=Texture'DH_VehicleOptics_tex.German.stug3_SflZF1a_sight'
     WeaponFov=14.400000
     AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
     AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'
     DriverPositions(0)=(ViewLocation=(X=-50.000000,Y=-29.200001,Z=34.400002),ViewFOV=14.400000,PositionMesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_turret',ViewPitchUpLimit=2185,ViewPitchDownLimit=64444,ViewPositiveYawLimit=2000,ViewNegativeYawLimit=-910,bDrawOverlays=true)
     DriverPositions(1)=(ViewLocation=(Z=10.000000),ViewFOV=7.200000,PositionMesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_turret',TransitionUpAnim="com_open",DriverTransitionAnim="VStug3_com_close",ViewPitchUpLimit=1200,ViewPitchDownLimit=64500,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true)
     DriverPositions(2)=(ViewFOV=80.000000,PositionMesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_turret',TransitionDownAnim="com_close",DriverTransitionAnim="VStug3_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bExposed=true)
     DriverPositions(3)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_turret',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bDrawOverlays=true,bExposed=true)
     GunClass=class'DH_Vehicles.DH_HetzerCannon'
     bHasAltFire=false
     CameraBone="Turret"
     RotateSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     RotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     MinRotateThreshold=0.500000
     MaxRotateThreshold=3.000000
     bPCRelativeFPRotation=true
     bFPNoZFromCameraPitch=true
     DrivePos=(X=6.000000,Z=-35.000000)
     DriveAnim="VStug3_com_idle_close"
     EntryRadius=130.000000
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a Hetzer cannon"
     VehicleNameString="Hetzer cannon"
     SoundVolume=130
}

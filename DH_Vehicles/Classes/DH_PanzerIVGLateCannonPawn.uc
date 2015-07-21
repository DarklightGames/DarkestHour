//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PanzerIVGLateCannonPawn extends DHGermanCannonPawn;

// TEMP DEBUG (Matt)
simulated function PostNetReceive()
{
    local int i;

    // Player has changed position
    if (DriverPositionIndex != SavedPositionIndex && Gun != none && bMultiPosition)
    {
        LastPositionIndex = SavedPositionIndex;
        SavedPositionIndex = DriverPositionIndex;

        if (Driver != none && bInitializedVehicleGun)
        {
            Log(Tag @ "PostNetReceive: new DPI =" @ DriverPositionIndex @ " SavedPI =" @ SavedPositionIndex @ " Calling NextViewPoint");
            NextViewPoint();
        }
        else Log(Tag @ "PostNetReceive: new DPI =" @ DriverPositionIndex @ " SavedPI =" @ SavedPositionIndex @ " But NOT calling NextViewPoint: have Driver =" @ Driver != none @ "bInitGun =" @ bInitializedVehicleGun);
    }

    if (!bInitializedVehicleGun && Gun != none && VehicleBase != none)
    {
        bInitializedVehicleGun = true;
        InitializeCannon();
    }

    if (!bInitializedVehicleBase && VehicleBase != none)
    {
        bInitializedVehicleBase = true;

        if (VehicleBase.WeaponPawns.Length > 0 && VehicleBase.WeaponPawns.Length > PositionInArray &&
            (VehicleBase.WeaponPawns[PositionInArray] == none || VehicleBase.WeaponPawns[PositionInArray].default.Class == none))
        {
            VehicleBase.WeaponPawns[PositionInArray] = self;

            return;
        }

        for (i = 0; i < VehicleBase.WeaponPawns.Length; ++i)
        {
            if (VehicleBase.WeaponPawns[i] != none && (VehicleBase.WeaponPawns[i] == self || VehicleBase.WeaponPawns[i].Class == class))
            {
                return;
            }
        }

        VehicleBase.WeaponPawns[PositionInArray] = self;
    }

    if (bNeedToInitializeDriver && Driver != none && Gun != none)
    {
        bNeedToInitializeDriver = false;
        SetPlayerPosition();
    }
}

simulated function NextViewPoint()
{
    if (Level.NetMode != NM_DedicatedServer || DriverPositions[DriverPositionIndex].bExposed || DriverPositions[LastPositionIndex].bExposed)
    {
        Log(Tag @ "NextViewPoint going to state ViewTransition: DPI =" @ DriverPositionIndex @ " LastPI =" @ LastPositionIndex);
        GotoState('ViewTransition');
    }
    else Log(Tag @ "NextViewPoint NOT going to state ViewTransition: DPI =" @ DriverPositionIndex @ " LastPI =" @ LastPositionIndex
        @ " DPI.bExposed =" @ DriverPositions[DriverPositionIndex].bExposed @ " LastPI.bExposed =" @ DriverPositions[LastPositionIndex].bExposed);
}

simulated function AnimateTransition()
{
    log(Tag @ "AnimateTransition called - SHOULD NOT HAPPEN");
}

simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        Log(Tag @ "VT.HandleTransition called: DPI =" @ DriverPositionIndex @ " LastPI =" @ LastPositionIndex);

        StoredVehicleRotation = VehicleBase.Rotation;

        if (Level.NetMode != NM_DedicatedServer && IsHumanControlled() && !PlayerController(Controller).bBehindView)
        {
            SwitchMesh(DriverPositionIndex);

            WeaponFOV = DriverPositions[DriverPositionIndex].ViewFOV;

            if (WeaponFOV > DriverPositions[LastPositionIndex].ViewFOV)
            {
                PlayerController(Controller).SetFOV(WeaponFOV);
                FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
            }

            if (LastPositionIndex < GunsightPositions && DriverPositionIndex >= GunsightPositions && !PlayerController(Controller).bBehindView)
            {
                MatchRotationToGunAim();
            }
        }

        if (Driver != none)
        {
            if (DriverPositions[DriverPositionIndex].bExposed && !DriverPositions[LastPositionIndex].bExposed && bKeepDriverAuxCollision && Driver.IsA('ROPawn'))
            {
                ROPawn(Driver).ToggleAuxCollision(true);
            }

            // Play any transition animation for the player
            if (Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim) && Driver.HasAnim(DriverPositions[LastPositionIndex].DriverTransitionAnim))
            {
                Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
            }
        }

        // Play any transition animation for the cannon itself & set a duration to control when we exit this state
        ViewTransitionDuration = 0.0; // start with zero in case we don't have a transition animation

        if (LastPositionIndex < DriverPositionIndex)
        {
            if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionUpAnim))
            {
                Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionUpAnim);
                ViewTransitionDuration = Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionUpAnim);
                Log(Tag @ "VT.HandleTransition: VTDuration =" @ ViewTransitionDuration @ " Played UpAnim" @ DriverPositions[LastPositionIndex].TransitionUpAnim);
            }
            else Log(Tag @ "VT.HandleTransition: doing nothing as has no UpAnim");
        }
        else if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionDownAnim))
        {
            Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionDownAnim);
            ViewTransitionDuration = Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionDownAnim);
            Log(Tag @ "VT.HandleTransition: VTDuration =" @ ViewTransitionDuration @ " Played DownAnim" @ DriverPositions[LastPositionIndex].TransitionDownAnim);
        }
        else Log(Tag @ "VT.HandleTransition: doing nothing as has no DownAnim");
    }

    simulated function AnimEnd(int channel)
    {
    }

    simulated function Timer()
    {
        global.Timer();
    }

    simulated function EndState()
    {
        if (Level.NetMode != NM_DedicatedServer && IsHumanControlled() && !PlayerController(Controller).bBehindView)
        {
            if (WeaponFOV <= DriverPositions[LastPositionIndex].ViewFOV)
            {
                PlayerController(Controller).SetFOV(WeaponFOV);
                FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
            }

            if (bLockCameraDuringTransition && ((DriverPositionIndex == UnbuttonedPositionIndex && LastPositionIndex < UnbuttonedPositionIndex)
                || (LastPositionIndex == UnbuttonedPositionIndex && DriverPositionIndex < UnbuttonedPositionIndex)) && ViewTransitionDuration > 0.0)
            {
                SetRotation(rot(0, 0, 0));
                Controller.SetRotation(Rotation);
            }
        }

        if (!DriverPositions[DriverPositionIndex].bExposed && DriverPositions[LastPositionIndex].bExposed && bKeepDriverAuxCollision && ROPawn(Driver) != none)
        {
            ROPawn(Driver).ToggleAuxCollision(false);
        }
    }

Begin:
    HandleTransition();
    Sleep(ViewTransitionDuration);
    GotoState('');
}
// END TEMP DEBUG //////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
defaultproperties
{
    ScopeCenterScale=0.635
    ScopeCenterRotator=TexRotator'DH_VehicleOptics_tex.German.PZ4_sight_Center'
    CenterRotationFactor=985
    OverlayCenterSize=0.87
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed'
    PoweredRotateSound=sound'Vehicle_Weapons.Turret.electric_turret_traverse'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'Vehicle_Weapons.Turret.electric_turret_traverse'
    CannonScopeCenter=texture'DH_VehicleOptics_tex.German.PZ3_sight_graticule'
    WeaponFOV=28.8
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'
    DriverPositions(0)=(ViewLocation=(X=12.0,Y=-27.0,Z=3.0),ViewFOV=28.8,PositionMesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4Glate_turret_int',ViewPitchUpLimit=3641,ViewPitchDownLimit=64080,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4Glate_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VPanzer4_com_close",ViewPitchUpLimit=4000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4Glate_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VPanzer4_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4Glate_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Vehicles.DH_PanzerIVGLateCannon'
    CameraBone="Gun"
    EntryRadius=130.0
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

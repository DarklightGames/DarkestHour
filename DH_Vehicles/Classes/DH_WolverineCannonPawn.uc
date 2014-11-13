//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WolverineCannonPawn extends DH_AmericanTankCannonPawn;


// Overriden because the animation needs to play on the server for this vehicle for the commanders hit detection
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
                AnimateTransition();

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

            if (Level.NetMode == NM_DedicatedServer)
            {
                AnimateTransition();
            }
        }
     }
}

defaultproperties
{
     OverlayCenterSize=0.972000
     UnbuttonedPositionIndex=0
     DestroyedScopeOverlay=Texture'DH_VehicleOpticsDestroyed_tex.Allied.Wolverine_sight_destroyed'
     bManualTraverseOnly=true
     PoweredRotateSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse2'
     PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
     PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse'
     CannonScopeOverlay=Texture'DH_VehicleOptics_tex.Allied.Wolverine_sight_background'
     BinocPositionIndex=2
     WeaponFov=14.400000
     AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.WolverineShell'
     AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.WolverineShell_reload'
     DriverPositions(0)=(ViewLocation=(X=35.000000,Y=-10.000000,Z=8.000000),ViewFOV=14.400000,PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VSU76_com_close",ViewPitchUpLimit=3641,ViewPitchDownLimit=63351,bDrawOverlays=true)
     DriverPositions(1)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VSU76_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bExposed=true)
     DriverPositions(2)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_turret_ext',ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bDrawOverlays=true,bExposed=true)
     FireImpulse=(X=-100000.000000)
     GunClass=Class'DH_Vehicles.DH_WolverineCannon'
     CameraBone="Gun"
     bPCRelativeFPRotation=true
     bFPNoZFromCameraPitch=true
     DrivePos=(X=7.000000,Y=5.000000,Z=-5.000000)
     DriveAnim="VSU76_com_idle_close"
     EntryRadius=130.000000
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a M10 Wolverine cannon"
     VehicleNameString="M10 Wolverine Cannon"
     PitchUpLimit=6000
     PitchDownLimit=64000
     SoundVolume=130
     SoundRadius=200.000000
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_AchillesCannonPawn extends DH_BritishTankCannonPawn;

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
    ScopeCenterScaleX=0.542000
    ScopeCenterScaleY=0.542000
    OverlayCenterSize=0.542000
    UnbuttonedPositionIndex=0
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.Allied.17pdr_sight_destroyed'
    bManualTraverseOnly=true
    PoweredRotateSound=sound'Vehicle_Weapons.Turret.manual_turret_traverse2'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_traverse'
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.Artillery.17Pdr_sight_background'
    CannonScopeCenter=texture'DH_VehicleOptics_tex.Artillery.17pdr_sight_mover'
    ScopePositionX=0.000000
    ScopePositionY=0.000000
    BinocPositionIndex=2
    WeaponFov=24.000000
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.T3485shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.T3485shell_reload'
    DriverPositions(0)=(ViewLocation=(X=38.000000,Y=-25.000000,Z=8.000000),ViewFOV=24.000000,PositionMesh=SkeletalMesh'DH_Wolverine_anm.Achilles_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VSU76_com_close",ViewPitchUpLimit=3641,ViewPitchDownLimit=64653,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Wolverine_anm.Achilles_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VSU76_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Wolverine_anm.Achilles_turret_ext',ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    FireImpulse=(X=-100000.000000)
    GunClass=class'DH_Vehicles.DH_AchillesCannon'
    CameraBone="Gun"
    bPCRelativeFPRotation=true
    bFPNoZFromCameraPitch=true
    DrivePos=(X=7.000000,Y=5.000000,Z=-6.000000)
    DriveAnim="VSU76_com_idle_close"
    EntryRadius=130.000000
    TPCamDistance=300.000000
    TPCamLookat=(X=-25.000000,Z=0.000000)
    TPCamWorldOffset=(Z=120.000000)
    VehiclePositionString="in an Achilles cannon"
    VehicleNameString="Achilles Cannon"
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Marder3MCannonPawn extends DH_AssaultGunCannonPawn;

// Overridden because the animation needs to play on the server for this vehicle for the commanders hit detection
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

            if (Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
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
    OverlayCenterSize=0.555
    UnbuttonedPositionIndex=0
    bManualTraverseOnly=true
    ManualRotateSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    ManualRotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    CannonScopeOverlay=texture'DH_Artillery_Tex.ATGun_Hud.ZF_II_3x8_Pak'
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.stug3_SflZF1a_destroyed'
    bLockCameraDuringTransition=true
    BinocPositionIndex=2
    WeaponFOV=14.4
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'
    DriverPositions(0)=(ViewLocation=(X=30.0,Y=-26.0,Z=1.0),ViewFOV=14.4,PositionMesh=SkeletalMesh'DH_Marder3M_anm.marder_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VSU76_com_close",ViewPitchUpLimit=2367,ViewPitchDownLimit=64625,ViewPositiveYawLimit=3822,ViewNegativeYawLimit=-3822,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Marder3M_anm.marder_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VSU76_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
    DriverPositions(2)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Marder3M_anm.marder_turret_ext',ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Vehicles.DH_Marder3MCannon'
    bHasAltFire=false
    CameraBone="Gun"
    ManualMinRotateThreshold=0.5
    ManualMaxRotateThreshold=3.0
    DrivePos=(X=-10.0,Z=22.0)
    DriveAnim="VSU76_com_idle_close"
    EntryRadius=130.0
    FPCamPos=(Z=5.0)
    TPCamDistance=300.0
    TPCamLookat=(X=-25.0,Z=0.0)
    TPCamWorldOffset=(Z=120.0)
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}

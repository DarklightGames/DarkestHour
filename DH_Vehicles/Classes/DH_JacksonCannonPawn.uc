//==============================================================================
// DH_JacksonCannon
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M36 American tank destroyer - 90mm cannon pawn class (late)
//==============================================================================
class DH_JacksonCannonPawn extends DH_AmericanTankCannonPawn;

// Overriden because the animation needs to play on the server for this vehicle for the commanders hit detection
function ServerChangeViewPoint(bool bForward)
{
	if (bForward)
	{
		if ( DriverPositionIndex < (DriverPositions.Length - 1) )
		{
			LastPositionIndex = DriverPositionIndex;
			DriverPositionIndex++;

			if(  Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer )
			{
				NextViewPoint();
			}

			if( Level.NetMode == NM_DedicatedServer )
			{
				AnimateTransition();

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

			if(  Level.Netmode == NM_Standalone || Level.Netmode == NM_ListenServer )
			{
				NextViewPoint();
			}

			if( Level.NetMode == NM_DedicatedServer )
			{
				AnimateTransition();
			}
		}
     }
}

defaultproperties
{
     OverlayCenterSize=0.895000
     UnbuttonedPositionIndex=0
     DestroyedScopeOverlay=Texture'DH_VehicleOpticsDestroyed_tex.Allied.Wolverine_sight_destroyed'
     PoweredRotateSound=Sound'Vehicle_Weapons.Turret.hydraul_turret_traverse'
     PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
     PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_traverse'
     CannonScopeOverlay=Texture'DH_VehicleOptics_tex.Allied.Jackson_sight_background'
     BinocPositionIndex=2
     WeaponFov=24.000000
     AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.IS2shell'
     AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.IS2shell_reload'
     DriverPositions(0)=(ViewLocation=(X=12.000000,Y=25.000000,Z=3.000000),ViewFOV=24.000000,PositionMesh=SkeletalMesh'DH_Jackson_anm.Jackson_turret_ext',TransitionUpAnim="com_open",DriverTransitionAnim="VSU76_com_close",ViewPitchUpLimit=3641,ViewPitchDownLimit=63715,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=True)
     DriverPositions(1)=(ViewFOV=85.000000,PositionMesh=SkeletalMesh'DH_Jackson_anm.Jackson_turret_ext',TransitionDownAnim="com_close",DriverTransitionAnim="VSU76_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bExposed=True)
     DriverPositions(2)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Jackson_anm.Jackson_turret_ext',ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=100000,ViewNegativeYawLimit=-100000,bDrawOverlays=True,bExposed=True)
     FireImpulse=(X=-100000.000000)
     GunClass=Class'DH_Vehicles.DH_JacksonCannon'
     CameraBone="Gun"
     bPCRelativeFPRotation=True
     bFPNoZFromCameraPitch=True
     DrivePos=(X=20.000000,Z=10.000000)
     DriveAnim="VSU76_com_idle_close"
     ExitPositions(0)=(Y=-100.000000,Z=186.000000)
     ExitPositions(1)=(Y=100.000000,Z=186.000000)
     EntryRadius=130.000000
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a M36 Jackson cannon"
     VehicleNameString="M36 Jackson Cannon"
     PitchUpLimit=6000
     PitchDownLimit=64000
     SoundVolume=130
}

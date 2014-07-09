//==============================================================================
// DH_Stug3GMountedMGPawn
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German Sturmgeschutze III Ausf.G tank destroyer - MG34 pawn
//==============================================================================
class DH_Stug3GMountedMGPawn extends DH_ROMountedTankMGPawn;


var     int             InitialPositionIndex; // Initial Gunner Position
var     int             UnbuttonedPositionIndex; // Lowest pos number where player is unbuttoned


// Cheating here to always spawn exiting players above their exit hatch, regardless of tank, without having to set it individually
simulated function PostBeginPlay()
{
    local vector Offset;
    local vector Loc;

    Super.PostBeginPlay();

    Offset.Z += 220;
    Loc = GetBoneCoords('loader_player').ZAxis;

    ExitPositions[0] = Loc + Offset;
    ExitPositions[1] = ExitPositions[0];
}

simulated state EnteringVehicle
{
	simulated function HandleEnter()
	{
    		//if( DriverPositions[0].PositionMesh != none)
         	//	LinkMesh(DriverPositions[0].PositionMesh);
		if( Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone ||  Level.Netmode == NM_ListenServer)
		{
 			if( DriverPositions[InitialPositionIndex].PositionMesh != none && Gun != none)
 			{
				Gun.LinkMesh(DriverPositions[InitialPositionIndex].PositionMesh);
			}
		}

		if( Gun.HasAnim(Gun.BeginningIdleAnim))
		{
		    Gun.PlayAnim(Gun.BeginningIdleAnim);
	    }

		WeaponFOV = DriverPositions[InitialPositionIndex].ViewFOV;
		PlayerController(Controller).SetFOV( WeaponFOV );

		FPCamPos = DriverPositions[InitialPositionIndex].ViewLocation;
	}

Begin:
	HandleEnter();
	Sleep(0.2);
	GotoState('');
}

/* PointOfView()
We don't ever want to allow behindview. It doesn't work with our system - Ramm
*/
simulated function bool PointOfView()
{
    return false;
}


// Overriden to handle mesh swapping when entering the vehicle
simulated function ClientKDriverEnter(PlayerController PC)
{
	Gotostate('EnteringVehicle');
    super.ClientKDriverEnter(PC);

//    log("clientK DriverPos "$DriverPositionIndex);
//	log("clientK PendingPos "$PendingPositionIndex);

	PendingPositionIndex = InitialPositionIndex;
	ServerChangeDriverPos();
	HUDOverlayOffset=default.HUDOverlayOffset;
}

simulated function ClientKDriverLeave(PlayerController PC)
{
 	Gotostate('LeavingVehicle');

	Super.ClientKDriverLeave(PC);
}

// Overridden to stop the game dumping players off the tank when they exit while moving
function bool PlaceExitingDriver()
{
	local int i;
	local vector tryPlace, Extent, HitLocation, HitNormal, ZOffset;

	Extent = Driver.default.CollisionRadius * vect(1,1,0);
	Extent.Z = Driver.default.CollisionHeight;
	ZOffset = Driver.default.CollisionHeight * vect(0,0,0.5);

	//avoid running driver over by placing in direction perpendicular to velocity
/*	if (VehicleBase != None && VSize(VehicleBase.Velocity) > 100)
	{
		tryPlace = Normal(VehicleBase.Velocity cross vect(0,0,1)) * (VehicleBase.CollisionRadius * 1.25);
		if (FRand() < 0.5)
			tryPlace *= -1; //randomly prefer other side
		if ( (VehicleBase.Trace(HitLocation, HitNormal, VehicleBase.Location + tryPlace + ZOffset, VehicleBase.Location + ZOffset, false, Extent) == None && Driver.SetLocation(VehicleBase.Location + tryPlace + ZOffset))
		     || (VehicleBase.Trace(HitLocation, HitNormal, VehicleBase.Location - tryPlace + ZOffset, VehicleBase.Location + ZOffset, false, Extent) == None && Driver.SetLocation(VehicleBase.Location - tryPlace + ZOffset)) )
			return true;
	}*/

	for(i=0; i<ExitPositions.Length; i++)
	{
		if ( bRelativeExitPos )
		{
		    if (VehicleBase != None)
		    	tryPlace = VehicleBase.Location + (ExitPositions[i] >> VehicleBase.Rotation) + ZOffset;
        	    else if (Gun != None)
                	tryPlace = Gun.Location + (ExitPositions[i] >> Gun.Rotation) + ZOffset;
	            else
        	        tryPlace = Location + (ExitPositions[i] >> Rotation);
	        }
		else
			tryPlace = ExitPositions[i];

		// First, do a line check (stops us passing through things on exit).
		if ( bRelativeExitPos )
		{
			if (VehicleBase != None)
			{
				if (VehicleBase.Trace(HitLocation, HitNormal, tryPlace, VehicleBase.Location + ZOffset, false, Extent) != None)
					continue;
			}
			else
				if (Trace(HitLocation, HitNormal, tryPlace, Location + ZOffset, false, Extent) != None)
					continue;
		}

		// Then see if we can place the player there.
		if ( !Driver.SetLocation(tryPlace) )
			continue;

		return true;
	}
	return false;
}

function bool KDriverLeave(bool bForceLeave)
{
    local bool bSuperDriverLeave;

	if( !bForceLeave && (DriverPositionIndex < UnbuttonedPositionIndex || Instigator.IsInState('ViewTransition')) )
	{
	    Instigator.ReceiveLocalizedMessage(class'DH_VehicleMessage', 4);
        return false;
 	}
    else
    {
	    DriverPositionIndex=InitialPositionIndex;
	    bSuperDriverLeave = super(VehicleWeaponPawn).KDriverLeave(bForceLeave);

	    ROVehicle(GetVehicleBase()).MaybeDestroyVehicle();
	    return bSuperDriverLeave;
	}
}

function ServerChangeDriverPos()
{
	DriverPositionIndex = InitialPositionIndex;
}

// Overridden here to force the server to go to state "ViewTransition", used to prevent players exiting before the unbutton anim has finished
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
		}
     }
}

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

         // bDrawDriverinTP=true;//Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);

		if(Driver != none && Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim)
			&& Driver.HasAnim(DriverPositions[LastPositionIndex].DriverTransitionAnim))
		{
			Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
		}

        WeaponFOV = DriverPositions[DriverPositionIndex].ViewFOV;

		FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
		//FPCamViewOffset = DriverPositions[DriverPositionIndex].ViewOffset; // depractated

		if( DriverPositionIndex != 0 )
		{
			if( DriverPositions[DriverPositionIndex].bDrawOverlays )
				PlayerController(Controller).SetFOV( WeaponFOV );
			else
				PlayerController(Controller).DesiredFOV = WeaponFOV;
		}

		if( LastPositionIndex < DriverPositionIndex)
		{
			if( Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionUpAnim) )
			{
//           	    if( IsLocallyControlled() )
                    Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionUpAnim);
				SetTimer(Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionUpAnim, 1.0),false);
			}
			else
				GotoState('');
		}
		else if ( Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionDownAnim) )
		{
//           	if( IsLocallyControlled() )
			    Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionDownAnim);
			SetTimer(Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionDownAnim, 1.0),false);
		}
		else
		{
			GotoState('');
		}
	}

	simulated function Timer()
	{
		GotoState('');
	}

	simulated function AnimEnd(int channel)
	{
		if( IsLocallyControlled() )
            GotoState('');
	}

   	simulated function EndState()
	{
		if( PlayerController(Controller) != none )
		{
			PlayerController(Controller).SetFOV( DriverPositions[DriverPositionIndex].ViewFOV );
			//PlayerController(Controller).SetRotation( Gun.GetBoneRotation( 'Camera_com' ));
		}
	}

Begin:
	HandleTransition();
	Sleep(0.2);
}

simulated function SpecialCalcFirstPersonView(PlayerController PC, out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
    local vector x, y, z;
	local vector VehicleZ, CamViewOffsetWorld;
	local float CamViewOffsetZAmount;
	local rotator WeaponAimRot;

    GetAxes(CameraRotation, x, y, z);
	ViewActor = self;

    WeaponAimRot = Gun.GetBoneRotation(CameraBone);

	if( ROPlayer(Controller) != none )
	{
        //limit view of gunner while inside tank
        if(DriverPositionIndex == 0 && !IsInState('ViewTransition'))
        {
            ROPlayer(Controller).WeaponBufferRotation.Yaw = 0;
		    ROPlayer(Controller).WeaponBufferRotation.Pitch = 0;
		}
        else
        {
            ROPlayer(Controller).WeaponBufferRotation.Yaw = WeaponAimRot.Yaw;
		    ROPlayer(Controller).WeaponBufferRotation.Pitch = WeaponAimRot.Pitch;
		}
	}

    CameraRotation = WeaponAimRot;

	CamViewOffsetWorld = FPCamViewOffset >> CameraRotation;

	if(CameraBone != '' && Gun != None)
	{
		CameraLocation = Gun.GetBoneCoords('loader_cam').Origin;

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


function UpdateRocketAcceleration(float deltaTime, float YawChange, float PitchChange)
{
	local rotator NewRotation;

	NewRotation = Rotation;
	NewRotation.Yaw += 32.0 * deltaTime * YawChange;
	NewRotation.Pitch += 32.0 * deltaTime * PitchChange;
	NewRotation.Pitch = LimitPitch(NewRotation.Pitch);

	SetRotation(NewRotation);

	UpdateSpecialCustomAim(DeltaTime, YawChange, PitchChange);

	if( ROPlayer(Controller) != none )
	{
        //limit view of gunner while inside tank
        if(DriverPositionIndex == 0 && !IsInState('ViewTransition'))
        {
            ROPlayer(Controller).WeaponBufferRotation.Yaw = 0;
		    ROPlayer(Controller).WeaponBufferRotation.Pitch = 0;
		}
        else
        {
            ROPlayer(Controller).WeaponBufferRotation.Yaw = CustomAim.Yaw;
		    ROPlayer(Controller).WeaponBufferRotation.Pitch = CustomAim.Pitch;
		}
	}
}


// Gunner cannot fire MG when he is buttoned inside tank (because he's not mounted on the damn gun!)
function Fire(optional float F)
{
	if( DriverPositionIndex == 0 && ROPlayer(Controller) != none )
	{
        return;
	}

	super.Fire(F);
}

simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local vector CameraLocation;
    local rotator CameraRotation;
    local Actor ViewActor;
    local vector GunOffset;

    PC = PlayerController(Controller);

    // Zap the lame crosshair - Ramm
/*	if (IsLocallyControlled() && Gun != None && Gun.bCorrectAim)
	{
		Canvas.DrawColor = CrosshairColor;
		Canvas.DrawColor.A = 255;
		Canvas.Style = ERenderStyle.STY_Alpha;
		Canvas.SetPos(Canvas.SizeX*0.5-CrosshairX, Canvas.SizeY*0.5-CrosshairY);
		Canvas.DrawTile(CrosshairTexture, CrosshairX*2.0, CrosshairY*2.0, 0.0, 0.0, CrosshairTexture.USize, CrosshairTexture.VSize);
	}  */


	if ( PC != None && !PC.bBehindView && HUDOverlay != None)
	{
        if (!Level.IsSoftwareRendering() && DriverPositionIndex > 0)
        {

			CameraRotation = PC.Rotation;
    		SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);
      		CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
    		GunOffset += PC.ShakeOffset * FirstPersonGunShakeScale;

            // Make the first person gun appear lower when your sticking your head up
            GunOffset.z += (((Gun.GetBoneCoords('firstperson_wep').Origin.Z - CameraLocation.Z) * 3));
            GunOffset += HUDOverlayOffset;

            // Not sure if we need this, but the HudOverlay might lose network relevancy if its location doesn't get updated - Ramm
    		HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
            Canvas.DrawBoundActor(HUDOverlay, false, true,HUDOverlayFOV,CameraRotation,PC.ShakeRot*FirstPersonGunShakeScale,GunOffset*-1);
    	 }
	}
	else
        ActivateOverlay(False);

    if (PC != none)
	    // Draw tank, turret, ammo count, passenger list
	    if (ROHud(PC.myHUD) != none && ROVehicle(GetVehicleBase()) != none)
            ROHud(PC.myHUD).DrawVehicleIcon(Canvas, ROVehicle(GetVehicleBase()), self);
}

defaultproperties
{
     UnbuttonedPositionIndex=1
     FirstPersonGunShakeScale=2.000000
     WeaponFov=72.000000
     DriverPositions(0)=(ViewFOV=80.000000,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug_mg34_ext',TransitionUpAnim="loader_unbutton",DriverTransitionAnim="Vhalftrack_com_close",ViewPitchUpLimit=4500,ViewPitchDownLimit=63500,ViewPositiveYawLimit=1,ViewNegativeYawLimit=-1)
     DriverPositions(1)=(ViewFOV=80.000000,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug_mg34_int',TransitionUpAnim="loader_open",TransitionDownAnim="loader_button",DriverTransitionAnim="Vhalftrack_com_open",ViewPitchUpLimit=4500,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bExposed=True)
     DriverPositions(2)=(ViewFOV=80.000000,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug_mg34_int',TransitionDownAnim="loader_close",ViewPitchUpLimit=4500,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bExposed=True)
     bMultiPosition=True
     GunClass=Class'DH_Vehicles.DH_Stug3GMountedMG'
     bCustomAiming=True
     bHasAltFire=False
     CameraBone="loader_cam"
     bPCRelativeFPRotation=True
     bDesiredBehindView=False
     DrivePos=(X=16.000000,Z=20.000000)
     DriveRot=(Yaw=16384)
     DriveAnim="VHalftrack_com_idle"
     ExitPositions(0)=(X=-60.000000,Y=80.000000,Z=100.000000)
     ExitPositions(1)=(X=-60.000000,Y=-80.000000,Z=100.000000)
     EntryRadius=130.000000
     TPCamDistance=300.000000
     TPCamLookat=(X=-50.000000,Y=25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="manning a StuG III Ausf.G MG34"
     VehicleNameString="StuG III Ausf.G MG34"
     HUDOverlayClass=Class'DH_Vehicles.DH_Stug3GOverlayMG'
     HUDOverlayFOV=45.000000
     PitchUpLimit=6000
     PitchDownLimit=63500
}

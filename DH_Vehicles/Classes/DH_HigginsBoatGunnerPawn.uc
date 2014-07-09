//==============================================================================
// DH_HigginsBoatGunnerPawn
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Higgins Boat - Asst. Gunner w/ .30 cal Browning
//==============================================================================
class DH_HigginsBoatGunnerPawn extends DH_ROMountedTankMGPawn;

var     	texture	                      BinocsOverlay;
//var()   	float                   	  BinocsEnlargementFactor;
var         int                           BinocsPositionIndex;

// Engineer cannot fire MG when he is in binocs
function Fire(optional float F)
{
	if( DriverPositionIndex == BinocsPositionIndex && ROPlayer(Controller) != none )
	{
        return;
	}

	super.Fire(F);
}

/* PointOfView()
We don't ever want to allow behindview. It doesn't work with our system - Ramm
*/
simulated function bool PointOfView()
{
    return false;
}

simulated function ClientKDriverEnter(PlayerController PC)
{
	Gotostate('EnteringVehicle');

	Super.ClientKDriverEnter(PC);

    HUDOverlayOffset=default.HUDOverlayOffset;
}

simulated function ClientKDriverLeave(PlayerController PC)
{
    local rotator NewRot;

    NewRot = GetVehicleBase().Rotation;
    NewRot.Pitch = LimitPitch(NewRot.Pitch);
    SetRotation(NewRot);

	Super.ClientKDriverLeave(PC);
}

// Overridden from Vehicle.uc to prevent being spawned outside the boat while moving and
// to allow passengers to exit with correct heights and rotations
function bool PlaceExitingDriver()
{
	local int i;
	local vector tryPlace, Extent, HitLocation, HitNormal, ZOffset;

	Extent = Driver.default.CollisionRadius * vect(1,1,0);
	Extent.Z = Driver.default.CollisionHeight;
	ZOffset = Driver.default.CollisionHeight * vect(0,0,1);

/*	//avoid running driver over by placing in direction perpendicular to velocity
	if (VehicleBase != None && VSize(VehicleBase.Velocity) > 100)
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
		 ROPlayer(Controller).WeaponBufferRotation.Yaw = WeaponAimRot.Yaw;
		 ROPlayer(Controller).WeaponBufferRotation.Pitch = WeaponAimRot.Pitch;
	}

	CameraRotation =  WeaponAimRot;


	CamViewOffsetWorld = FPCamViewOffset >> CameraRotation;

	if(CameraBone != '' && Gun != None)
	{
		CameraLocation = Gun.GetBoneCoords('Camera_com').Origin;

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
         ROPlayer(Controller).WeaponBufferRotation.Yaw = CustomAim.Yaw;
		 ROPlayer(Controller).WeaponBufferRotation.Pitch = CustomAim.Pitch;
	}
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


	if (PC != None && !PC.bBehindView && HUDOverlay != None)
	{
        if (!Level.IsSoftwareRendering() && DriverPositionIndex < 2)
        {

			CameraRotation = PC.Rotation;
    		SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);

    		CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
    		GunOffset += PC.ShakeOffset * FirstPersonGunShakeScale;

            // Make the first person gun appear lower when your sticking your head up
 //           GunOffset.z += (((Gun.GetBoneCoords('1stperson_wep').Origin.Z - CameraLocation.Z) * 3));
            GunOffset.z += (((Gun.GetBoneCoords('1stperson_wep').Origin.Z - CameraLocation.Z) * 1));	//****************************************************
            GunOffset += HUDOverlayOffset;

            // Not sure if we need this, but the HudOverlay might lose network relevancy if its location doesn't get updated - Ramm
    		HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));

    		Canvas.DrawBoundActor(HUDOverlay, false, true,HUDOverlayFOV,CameraRotation,PC.ShakeRot*FirstPersonGunShakeScale,GunOffset*-1);
    	 }
    	 else
    	 {
    	    DrawBinocsOverlay(Canvas);
    	 }
	}
	else
        ActivateOverlay(False);

    if (PC != none)
	    // Draw tank, turret, ammo count, passenger list
	    if (ROHud(PC.myHUD) != none && ROVehicle(GetVehicleBase()) != none)
            ROHud(PC.myHUD).DrawVehicleIcon(Canvas, ROVehicle(GetVehicleBase()), self);
}

// Hack - Turn off the muzzle flash in first person when your head is sticking up since it doesn't look right
simulated state ViewTransition
{
	simulated function BeginState()
	{
		if( Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer )
		{
    		if( DriverPositionIndex > 0 )
    		{
    		  Gun.AmbientEffectEmitter.bHidden = true;
    		}
		}

        super.BeginState();
	}

	simulated function EndState()
	{
		if( Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone  || Level.NetMode == NM_ListenServer )
		{
    		if( DriverPositionIndex == 0 )
    		{
    		  Gun.AmbientEffectEmitter.bHidden = false;
    		}
		}

        super.EndState();
	}
}
/*
simulated function DrawHUD(Canvas Canvas)
{
    	local PlayerController PC;
    	local vector CameraLocation;
    	local rotator CameraRotation;
    	local float  SavedOpacity;
    	local float scale;
    	local Actor ViewActor;

    	PC = PlayerController(Controller);

   		if( PC == none )
        {
		    Super.RenderOverlays(Canvas);
		    //log("PanzerTurret PlayerController was none, returning");
		    return;
	    }
    	else if (!PC.bBehindView)
	    {
		    // store old opacity and set to 1.0 for map overlay rendering
		    SavedOpacity = Canvas.ColorModulate.W;
		    Canvas.ColorModulate.W = 1.0;

		    Canvas.DrawColor.A = 255;
		    Canvas.Style = ERenderStyle.STY_Alpha;

        		scale = Canvas.SizeY / 1200.0;

            if ( DriverPositions[DriverPositionIndex].bDrawOverlays && !IsInState('ViewTransition'))
            {
			   if( DriverPositionIndex == 0 )
			   {
               }
			   else
			   {
                  DrawBinocsOverlay(Canvas);
			   }
	        }
    	   // reset HudOpacity to original value
		   Canvas.ColorModulate.W = SavedOpacity;

           // Draw tank, turret, ammo count, passenger list
	       if (ROHud(PC.myHUD) != none && ROVehicle(GetVehicleBase()) != none)
              ROHud(PC.myHUD).DrawVehicleIcon(Canvas, ROVehicle(GetVehicleBase()), self);
	    }

    // Zap the lame crosshair - Ramm
	if (IsLocallyControlled() && Gun != None && Gun.bCorrectAim && Gun.bShowAimCrosshair)
	{
		Canvas.DrawColor = CrosshairColor;
		Canvas.DrawColor.A = 255;
		Canvas.Style = ERenderStyle.STY_Alpha;
		Canvas.SetPos(Canvas.SizeX*0.5-CrosshairX, Canvas.SizeY*0.5-CrosshairY);
		Canvas.DrawTile(CrosshairTexture, CrosshairX*2.0, CrosshairY*2.0, 0.0, 0.0, CrosshairTexture.USize, CrosshairTexture.VSize);
	}


	if (PC != None && !PC.bBehindView && HUDOverlay != None)
	{
        if (!Level.IsSoftwareRendering())
        {
    		CameraRotation = PC.Rotation;
    		SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);
    		HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
    		HUDOverlay.SetRotation(CameraRotation);
    		Canvas.DrawActor(HUDOverlay, false, false, FClamp(HUDOverlayFOV * (PC.DesiredFOV / PC.DefaultFOV), 1, 170));
    	}
	}
	else
        ActivateOverlay(False);

}
*/
//AB CODE
simulated function DrawBinocsOverlay(Canvas Canvas)
{
    local float ScreenRatio;

    ScreenRatio = float(Canvas.SizeY) / float(Canvas.SizeX);
	Canvas.SetPos(0,0);
	Canvas.DrawTile(BinocsOverlay, Canvas.SizeX, Canvas.SizeY, 0.0 , (1 - ScreenRatio) * float(BinocsOverlay.VSize) / 2, BinocsOverlay.USize, float(BinocsOverlay.VSize) * ScreenRatio );
}

defaultproperties
{
     BinocsOverlay=Texture'DH_VehicleOptics_tex.Allied.BINOC_overlay_7x50Allied'
     BinocsPositionIndex=2
     FirstPersonGunShakeScale=0.750000
     WeaponFov=60.000000
     HudName="Engineer"
     DriverPositions(0)=(ViewFOV=60.000000,PositionMesh=SkeletalMesh'DH_M3A1Halftrack_anm.m3halftrack_gun_int',TransitionUpAnim="com_open",DriverTransitionAnim="Vhalftrack_com_close",ViewPitchUpLimit=7500,ViewPitchDownLimit=63000,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bExposed=True)
     DriverPositions(1)=(ViewFOV=80.000000,PositionMesh=SkeletalMesh'DH_M3A1Halftrack_anm.m3halftrack_gun_int',TransitionDownAnim="com_close",DriverTransitionAnim="Vhalftrack_com_open",ViewPitchUpLimit=7500,ViewPitchDownLimit=63000,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bExposed=True)
     DriverPositions(2)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_M3A1Halftrack_anm.m3halftrack_gun_int',ViewPitchUpLimit=5300,ViewPitchDownLimit=63000,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bExposed=True)
     bMultiPosition=True
     bMustBeTankCrew=False
     GunClass=Class'DH_Vehicles.DH_HigginsBoatGun'
     bCustomAiming=True
     PositionInArray=0
     bHasAltFire=False
     CameraBone="Camera_com"
     bDesiredBehindView=False
     DrivePos=(Y=-5.000000,Z=14.000000)
     DriveRot=(Yaw=16384)
     DriveAnim="VHalftrack_com_idle"
     ExitPositions(0)=(X=-30.000000,Y=38.000000,Z=105.000000)
     ExitPositions(1)=(X=-30.000000,Y=38.000000,Z=105.000000)
     EntryRadius=350.000000
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a Higgins Boat"
     VehicleNameString="Higgins Boat"
     HUDOverlayClass=Class'DH_Vehicles.DH_M3A1HalftrackMGOverlay'
     HUDOverlayOffset=(X=-2.000000)
     HUDOverlayFOV=35.000000
     PitchUpLimit=8000
     PitchDownLimit=60000
}

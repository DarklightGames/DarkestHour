//===================================================================
// ROMountedTankMGPawn
//
// Copyright (C) 2004 John "Ramm-Jaeger"  Gibson
//
// Base class for mounted tank machine guns pawns. Overrides
// onslaught functionality that we don't want/need
//===================================================================
class DH_ROMountedTankMGPawn extends ROMountedTankMGPawn
	  abstract;

#exec OBJ LOAD FILE=..\textures\DH_VehicleOptics_tex.utx

var()   float	OverlayCenterScale;
var()   float	OverlayCenterSize;    // size of the gunsight overlay, 1.0 means full screen width, 0.5 means half screen width

var()   float	OverlayCorrectionX;
var()   float	OverlayCorrectionY;

// Cheating here to always spawn exiting players above their exit hatch, regardless of tank, without having to set it individually
/*simulated function PostBeginPlay()
{
    local vector Offset;

    Super.PostBeginPlay();

    Offset.Z += 200;

    ExitPositions[0]=GetBoneCoords('mg_pitch');// + Offset;
    ExitPositions[1]=GetBoneCoords('mg_pitch');// + Offset;
}
*/

// Overridden to set exit rotation to be the same as when they were in the vehicle - looks a bit silly otherwise
simulated function ClientKDriverLeave(PlayerController PC)
{
    local rotator NewRot;

    NewRot = GetVehicleBase().Rotation;
    NewRot.Pitch = LimitPitch(NewRot.Pitch);
    SetRotation(NewRot);

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
/*	if (VehicleBase != none && VSize(VehicleBase.Velocity) > 100)
	{
		tryPlace = Normal(VehicleBase.Velocity cross vect(0,0,1)) * (VehicleBase.CollisionRadius * 1.25);
		if (FRand() < 0.5)
			tryPlace *= -1; //randomly prefer other side
		if ((VehicleBase.Trace(HitLocation, HitNormal, VehicleBase.Location + tryPlace + ZOffset, VehicleBase.Location + ZOffset, false, Extent) == none && Driver.SetLocation(VehicleBase.Location + tryPlace + ZOffset))
		     || (VehicleBase.Trace(HitLocation, HitNormal, VehicleBase.Location - tryPlace + ZOffset, VehicleBase.Location + ZOffset, false, Extent) == none && Driver.SetLocation(VehicleBase.Location - tryPlace + ZOffset)))
			return true;
	}*/

	for(i=0; i<ExitPositions.Length; i++)
	{
		if (bRelativeExitPos)
		{
		    if (VehicleBase != none)
		    	tryPlace = VehicleBase.Location + (ExitPositions[i] >> VehicleBase.Rotation) + ZOffset;
        	    else if (Gun != none)
                	tryPlace = Gun.Location + (ExitPositions[i] >> Gun.Rotation) + ZOffset;
	            else
        	        tryPlace = Location + (ExitPositions[i] >> Rotation);
	        }
		else
			tryPlace = ExitPositions[i];

		// First, do a line check (stops us passing through things on exit).
		if (bRelativeExitPos)
		{
			if (VehicleBase != none)
			{
				if (VehicleBase.Trace(HitLocation, HitNormal, tryPlace, VehicleBase.Location + ZOffset, false, Extent) != none)
					continue;
			}
			else
				if (Trace(HitLocation, HitNormal, tryPlace, Location + ZOffset, false, Extent) != none)
					continue;
		}

		// Then see if we can place the player there.
		if (!Driver.SetLocation(tryPlace))
			continue;

		return true;
	}
	return false;
}

simulated function DrawHUD(Canvas Canvas)
{
	local PlayerController PC;
	local vector CameraLocation;
	local rotator CameraRotation;
	local Actor ViewActor;
	local float	SavedOpacity;
	local vector x, y, z;

	local float ScreenRatio, OverlayCenterTexStart, OverlayCenterTexSize;

	PC = PlayerController(Controller);
	if (PC == none)
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

        // Draw reticle
        ScreenRatio = float(Canvas.SizeY) / float(Canvas.SizeX);
        OverlayCenterScale = 0.955 / OverlayCenterSize; // 0.955 factor widens visible FOV to full screen width = OverlaySize 1.0
        OverlayCenterTexStart = (1 - OverlayCenterScale) * float(MGOverlay.USize) / 2;
        OverlayCenterTexSize =  float(MGOverlay.USize) * OverlayCenterScale;

        Canvas.SetPos(0, 0);
        Canvas.DrawTile(MGOverlay , Canvas.SizeX , Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX, OverlayCenterTexStart - OverlayCorrectionY + (1 - ScreenRatio) * OverlayCenterTexSize / 2 , OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);

    	// reset HudOpacity to original value
		Canvas.ColorModulate.W = SavedOpacity;
    }

	if (PC != none && !PC.bBehindView && HUDOverlay != none)
	{
		if (!Level.IsSoftwareRendering())
		{
			CameraRotation = PC.Rotation;
			SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);

			CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
			CameraLocation = CameraLocation + PC.ShakeOffset.X * x + PC.ShakeOffset.Y * y + PC.ShakeOffset.Z * z;

			HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
			HUDOverlay.SetRotation(CameraRotation);
			Canvas.DrawActor(HUDOverlay, false, true, HUDOverlayFOV);
		}
	}
	else
		ActivateOverlay(false);

	if (PC != none)
	    // Draw tank, turret, ammo count, passenger list
	    if (ROHud(PC.myHUD) != none && ROVehicle(GetVehicleBase()) != none)
			ROHud(PC.myHUD).DrawVehicleIcon(Canvas, ROVehicle(GetVehicleBase()), self);
}

defaultproperties
{
     OverlayCenterSize=1.000000
}

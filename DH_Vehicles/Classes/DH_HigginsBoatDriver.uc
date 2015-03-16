//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_HigginsBoatDriver extends DH_HigginsPassengerPawn;

var     texture     BinocsOverlay;

// Modified to handle binoculars overlay
simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local float            SavedOpacity;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView)
    {
        // Draw vehicle, passenger list
        if (ROHud(PC.myHUD) != none && VehicleBase != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(Canvas, VehicleBase, self);
        }

        // Draw binoculars overlay
        if (DriverPositionIndex == 1)
        {
            SavedOpacity = Canvas.ColorModulate.W;
            Canvas.ColorModulate.W = 1.0;
            Canvas.DrawColor.A = 255;
            Canvas.Style = ERenderStyle.STY_Alpha;

            DrawBinocsOverlay(Canvas);

            Canvas.ColorModulate.W = SavedOpacity; // reset HudOpacity to original value
        }
    }
}

// New function, same as tank cannon pawn
simulated function DrawBinocsOverlay(Canvas Canvas)
{
    local float ScreenRatio;

    ScreenRatio = float(Canvas.SizeY) / float(Canvas.SizeX);
    Canvas.SetPos(0.0, 0.0);
    Canvas.DrawTile(BinocsOverlay, Canvas.SizeX, Canvas.SizeY, 0.0 , (1.0 - ScreenRatio) * float(BinocsOverlay.VSize) / 2.0, BinocsOverlay.USize, float(BinocsOverlay.VSize) * ScreenRatio);
}

// Limit the left and right movement of the driver
simulated function int LimitYaw(int yaw)
{
    return Clamp(yaw, DriverPositions[DriverPositionIndex].ViewNegativeYawLimit, DriverPositions[DriverPositionIndex].ViewPositiveYawLimit);
}

// Limit the up and down movement of the driver
function int LimitPawnPitch(int pitch)
{
    pitch = pitch & 65535;

    if (pitch > DriverPositions[DriverPositionIndex].ViewPitchUpLimit && pitch < DriverPositions[DriverPositionIndex].ViewPitchDownLimit)
    {
        if (pitch - DriverPositions[DriverPositionIndex].ViewPitchUpLimit < PitchDownLimit - pitch)
        {
            pitch = DriverPositions[DriverPositionIndex].ViewPitchUpLimit;
        }
        else
        {
            pitch = DriverPositions[DriverPositionIndex].ViewPitchDownLimit;
        }
    }

    return pitch;
}

defaultproperties
{
    BinocsOverlay=texture'DH_VehicleOptics_tex.Allied.BINOC_overlay_7x50Allied'
    HudName="Engineer"
    DriverPositions(0)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_HigginsBoat_anm.HigginsBoat',DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000)
    DriverPositions(1)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_HigginsBoat_anm.HigginsBoat',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    bMultiPosition=true
    CameraBone="Camera_com"
    DrivePos=(X=0.0,Y=0.0,Z=-15.0)
    DriveAnim="stand_idlehip_satchel"
}

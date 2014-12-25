//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_HigginsBoatDriver extends DH_HigginsPassengerPawn;

var         texture                       BinocsOverlay;
//var()     float                         BinocsEnlargementFactor;
var()       bool        bLimitYaw;                       // limit panning left or right
var()       bool        bLimitPitch;                    // limit pitching up and down

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        bLimitYaw, bLimitPitch;
}

simulated function DrawHUD(Canvas Canvas)
{
        local PlayerController PC;
        local vector CameraLocation;
        local rotator CameraRotation;
        local float  SavedOpacity;
        local float scale;
        local Actor ViewActor;

        PC = PlayerController(Controller);

        if (PC == none)
        {
            super.RenderOverlays(Canvas);
            //Log("PanzerTurret PlayerController was none, returning");
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

            if (DriverPositions[DriverPositionIndex].bDrawOverlays && !IsInState('ViewTransition'))
            {
               if (DriverPositionIndex == 0)
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
    if (IsLocallyControlled() && Gun != none && Gun.bCorrectAim && Gun.bShowAimCrosshair)
    {
        Canvas.DrawColor = CrosshairColor;
        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;
        Canvas.SetPos(Canvas.SizeX*0.5-CrosshairX, Canvas.SizeY*0.5-CrosshairY);
        Canvas.DrawTile(CrosshairTexture, CrosshairX*2.0, CrosshairY*2.0, 0.0, 0.0, CrosshairTexture.USize, CrosshairTexture.VSize);
    }

    if (PC != none && !PC.bBehindView && HUDOverlay != none)
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
        ActivateOverlay(false);

}

//AB CODE
simulated function DrawBinocsOverlay(Canvas Canvas)
{
    local float ScreenRatio;

    ScreenRatio = float(Canvas.SizeY) / float(Canvas.SizeX);
    Canvas.SetPos(0,0);
    Canvas.DrawTile(BinocsOverlay, Canvas.SizeX, Canvas.SizeY, 0.0 , (1 - ScreenRatio) * float(BinocsOverlay.VSize) / 2, BinocsOverlay.USize, float(BinocsOverlay.VSize) * ScreenRatio);
}

// Limit the left and right movement of the driver
simulated function int LimitYaw(int yaw)
{
    local int NewYaw;

    if (!bLimitYaw)
    {
        return yaw;
    }

    NewYaw = yaw;

    if (yaw > DriverPositions[DriverPositionIndex].ViewPositiveYawLimit)
    {
        NewYaw = DriverPositions[DriverPositionIndex].ViewPositiveYawLimit;
    }
    else if (yaw < DriverPositions[DriverPositionIndex].ViewNegativeYawLimit)
    {
        NewYaw = DriverPositions[DriverPositionIndex].ViewNegativeYawLimit;
    }

    return NewYaw;
}

// Limit the up and down movement of the driver
function int LimitPawnPitch(int pitch)
{
    pitch = pitch & 65535;

    if (!bLimitPitch)
    {
        return pitch;
    }

    if (pitch > DriverPositions[DriverPositionIndex].ViewPitchUpLimit && pitch < DriverPositions[DriverPositionIndex].ViewPitchDownLimit)
    {
        if (pitch - DriverPositions[DriverPositionIndex].ViewPitchUpLimit < PitchDownLimit - pitch)
            pitch = DriverPositions[DriverPositionIndex].ViewPitchUpLimit;
        else
            pitch = DriverPositions[DriverPositionIndex].ViewPitchDownLimit;
    }

    return pitch;
}

defaultproperties
{
    BinocsOverlay=texture'DH_VehicleOptics_tex.Allied.BINOC_overlay_7x50Allied'
    bLimitYaw=true
    bLimitPitch=true
    HudName="Engineer"
    DriverPositions(0)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_HigginsBoat_anm.HigginsBoat',DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000)
    DriverPositions(1)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_HigginsBoat_anm.HigginsBoat',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    bMultiPosition=true
    CameraBone="Camera_com"
    DrivePos=(X=0.000000,Y=0.000000,Z=-15.000000)
    DriveAnim="stand_idlehip_satchel"
    EntryRadius=350.000000
    HUDOverlayFOV=90.000000
}

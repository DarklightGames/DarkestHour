//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_AssaultGunCannonPawn extends DH_ROTankCannonPawn
    abstract;

var  texture  PeriscopeOverlay;

simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local vector  CameraLocation;
    local rotator CameraRotation;
    local Actor   ViewActor;
    local color   SavedColor, WhiteColor;
    local float   SavedOpacity, XL, YL, MapX, MapY, PosX, PosY, ScreenRatio, OverlayCenterTexStart, OverlayCenterTexSize;

    PC = PlayerController(Controller);

    if (PC == none)
    {
        super.RenderOverlays(Canvas);

        return;
    }
    else if (!PC.bBehindView)
    {
        // Store old opacity and set to 1.0 for map overlay rendering
        SavedOpacity = Canvas.ColorModulate.W;
        Canvas.ColorModulate.W = 1.0;

        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;

        if (DriverPositions[DriverPositionIndex].bDrawOverlays && !IsInState('ViewTransition'))
        {
            // Calculate reticle drawing position (and position to draw black bars at)
            if (DriverPositionIndex == 0)
            {
                // Debug - draw cross on the center of the screen
                if (bShowCenter)
                {
                    PosX = Canvas.SizeX / 2.0;
                    PosY = Canvas.SizeY / 2.0;
                    Canvas.SetPos(0.0, 0.0);
                    Canvas.DrawVertical(PosX - 1.0, PosY - 3.0);
                    Canvas.DrawVertical(PosX, PosY - 3.0);
                    Canvas.SetPos(0.0, PosY + 3.0);
                    Canvas.DrawVertical(PosX - 1.0, PosY - 3.0);
                    Canvas.DrawVertical(PosX, PosY - 3.0);
                    Canvas.SetPos(0.0, 0.0);
                    Canvas.DrawHorizontal(PosY - 1.0, PosX - 3.0);
                    Canvas.DrawHorizontal(PosY, PosX - 3.0);
                    Canvas.SetPos(PosX + 3.0, 0.0);
                    Canvas.DrawHorizontal(PosY - 1.0, PosX - 3.0);
                    Canvas.DrawHorizontal(PosY, PosX - 3.0);
                }

                // Draw reticle
                ScreenRatio = float(Canvas.SizeY) / float(Canvas.SizeX);
                OverlayCenterScale = 0.955 / OverlayCenterSize; // 0.955 factor widens visible FOV to full screen width = OverlaySize 1.0
                OverlayCenterTexStart = (1.0 - OverlayCenterScale) * float(CannonScopeOverlay.USize) / 2.0;
                OverlayCenterTexSize =  float(CannonScopeOverlay.USize) * OverlayCenterScale;
                Canvas.SetPos(0.0, 0.0);
                Canvas.DrawTile(CannonScopeOverlay , Canvas.SizeX , Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX, 
                    OverlayCenterTexStart - OverlayCorrectionY + (1.0 - ScreenRatio) * OverlayCenterTexSize / 2.0 , OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);

                // Draw the range setting
                if (Gun != none && bShowRangeText)
                {
                    Canvas.Style = ERenderStyle.STY_Normal;

                    SavedColor = Canvas.DrawColor;
                    WhiteColor =  class'Canvas'.Static.MakeColor(255, 255, 255, 175);
                    Canvas.DrawColor = WhiteColor;
                    MapX = RangePositionX * Canvas.ClipX;
                    MapY = RangePositionY * Canvas.ClipY;
                    Canvas.SetPos(MapX,MapY);
                    Canvas.Font = class'ROHUD'.Static.GetSmallMenuFont(Canvas);
                    Canvas.StrLen(Gun.GetRange() @ RangeText, XL, YL);
                    Canvas.DrawTextJustified(Gun.GetRange()@ RangeText, 2.0, MapX, MapY, MapX + XL, MapY + YL);
                    Canvas.DrawColor = SavedColor;
                }
            }
            else if (DriverPositionIndex == PeriscopePositionIndex)
            {
                DrawPeriscopeOverlay(Canvas);
            }
            else
            {
                DrawBinocsOverlay(Canvas);
            }
        }

        // Reset HudOpacity to original value
        Canvas.ColorModulate.W = SavedOpacity;

        // Draw tank, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none && VehicleBase != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(Canvas, VehicleBase, self);
        }
    }

    // Zap the lame crosshair - Ramm
    if (IsLocallyControlled() && Gun != none && Gun.bCorrectAim && Gun.bShowAimCrosshair)
    {
        Canvas.DrawColor = CrosshairColor;
        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;
        Canvas.SetPos(Canvas.SizeX * 0.5 - CrosshairX, Canvas.SizeY * 0.5 - CrosshairY);
        Canvas.DrawTile(CrosshairTexture, CrosshairX * 2.0, CrosshairY * 2.0, 0.0, 0.0, CrosshairTexture.USize, CrosshairTexture.VSize);
    }

    if (!PC.bBehindView && HUDOverlay != none)
    {
        if (!Level.IsSoftwareRendering())
        {
            CameraRotation = PC.Rotation;
            SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);
            HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
            HUDOverlay.SetRotation(CameraRotation);
            Canvas.DrawActor(HUDOverlay, false, false, FClamp(HUDOverlayFOV * (PC.DesiredFOV / PC.DefaultFOV), 1.0, 170.0));
        }
    }
    else
    {
        ActivateOverlay(false);
    }
}

simulated function DrawPeriscopeOverlay(Canvas Canvas)
{
    local float ScreenRatio;

    ScreenRatio = Float(Canvas.SizeY) / Float(Canvas.SizeX);
    Canvas.SetPos(0.0, 0.0);
    Canvas.DrawTile(PeriscopeOverlay, Canvas.SizeX, Canvas.SizeY, 0.0 , (1.0 - ScreenRatio) * Float(PeriscopeOverlay.VSize) / 2.0, PeriscopeOverlay.USize, Float(PeriscopeOverlay.VSize) * ScreenRatio);
}

defaultproperties
{
    PeriscopeOverlay=texture'DH_VehicleOptics_tex.German.Sf14z_periscope'
    OverlayCenterSize=0.65
    DestroyedScopeOverlay=texture'DH_VehicleOptics_tex.Allied.Destroyed'
    BinocsOverlay=texture'DH_VehicleOptics_tex.German.BINOC_overlay_6x30Germ'
}

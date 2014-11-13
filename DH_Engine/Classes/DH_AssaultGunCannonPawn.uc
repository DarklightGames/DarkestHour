//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_AssaultGunCannonPawn extends DH_ROTankCannonPawn
       abstract;

var     texture                 PeriscopeOverlay;

simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local vector CameraLocation;
    local rotator CameraRotation;
    local Actor ViewActor;
    local float SavedOpacity;
    local float XL, YL, MapX, MapY;
    local color SavedColor, WhiteColor;
    local float posx, posy; //for debug cross

    local float ScreenRatio, OverlayCenterTexStart, OverlayCenterTexSize;

    PC = PlayerController(Controller);
    if (PC == none)
    {
        super.RenderOverlays(Canvas);
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

        if (DriverPositions[DriverPositionIndex].bDrawOverlays && !IsInState('ViewTransition'))
        {
            if (DriverPositionIndex == 0)
            {

            // Calculate reticle drawing position (and position to draw black bars at)

               if (bShowCenter)
               {
                  //debug, draw cross on the center of the screen
                  posx=Canvas.SizeX / 2;
                  posy=Canvas.SizeY / 2;
                  Canvas.SetPos(0, 0);
                  Canvas.DrawVertical(posx-1, posy-3);
                  Canvas.DrawVertical(posx, posy-3);
                  Canvas.SetPos(0, posy+3);
                  Canvas.DrawVertical(posx-1, posy-3);
                  Canvas.DrawVertical(posx, posy-3);
                  Canvas.SetPos(0, 0);
                  Canvas.DrawHorizontal(posy-1, posx-3);
                  Canvas.DrawHorizontal(posy, posx-3);
                  Canvas.SetPos(posx+3, 0);
                  Canvas.DrawHorizontal(posy-1, posx-3);
                  Canvas.DrawHorizontal(posy, posx-3);
               }

              // Draw reticle
              ScreenRatio = float(Canvas.SizeY) / float(Canvas.SizeX);
              OverlayCenterScale = 0.955 / OverlayCenterSize; // 0.955 factor widens visible FOV to full screen width = OverlaySize 1.0
              OverlayCenterTexStart = (1 - OverlayCenterScale) * float(CannonScopeOverlay.USize) / 2;
              OverlayCenterTexSize =  float(CannonScopeOverlay.USize) * OverlayCenterScale;
              Canvas.SetPos(0, 0);
              Canvas.DrawTile(CannonScopeOverlay , Canvas.SizeX , Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX, OverlayCenterTexStart - OverlayCorrectionY + (1 - ScreenRatio) * OverlayCenterTexSize / 2 , OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);

               // Draw the range setting
               if (Gun != none && bShowRangeText)
               {
                  Canvas.Style = ERenderStyle.STY_Normal;

                  SavedColor = Canvas.DrawColor;
                  WhiteColor =  class'Canvas'.Static.MakeColor(255,255,255,175);
                  Canvas.DrawColor = WhiteColor;
                  MapX = RangePositionX * Canvas.ClipX;
                  MapY = RangePositionY * Canvas.ClipY;
                  Canvas.SetPos(MapX,MapY);
                  Canvas.Font = class'ROHUD'.Static.GetSmallMenuFont(Canvas);
                  Canvas.StrLen(Gun.GetRange()$" "$RangeText, XL, YL);
                  Canvas.DrawTextJustified(Gun.GetRange()$" "$RangeText, 2, MapX, MapY, MapX + XL, MapY+YL);
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

simulated function DrawPeriscopeOverlay(Canvas Canvas)
{
    local float ScreenRatio;

    ScreenRatio = float(Canvas.SizeY) / float(Canvas.SizeX);
    Canvas.SetPos(0,0);
    Canvas.DrawTile(PeriscopeOverlay, Canvas.SizeX, Canvas.SizeY, 0.0 , (1 - ScreenRatio) * float(PeriscopeOverlay.VSize) / 2, PeriscopeOverlay.USize, float(PeriscopeOverlay.VSize) * ScreenRatio);
}

defaultproperties
{
     PeriscopeOverlay=Texture'DH_VehicleOptics_tex.German.Sf14z_periscope'
     OverlayCenterSize=0.650000
     DestroyedScopeOverlay=Texture'DH_VehicleOptics_tex.Allied.Destroyed'
     BinocsOverlay=Texture'DH_VehicleOptics_tex.German.BINOC_overlay_6x30Germ'
}

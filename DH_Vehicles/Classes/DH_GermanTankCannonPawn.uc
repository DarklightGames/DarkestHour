//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_GermanTankCannonPawn extends DH_ROTankCannonPawn
     abstract;

var() float ScopeCenterScale;
var         TexRotator ScopeCenterRotator;
var() int   CenterRotationFactor;

var() float ScopeCenterScaleX;
var() float ScopeCenterScaleY;

simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local vector    CameraLocation;
    local rotator   CameraRotation;
    local Actor ViewActor;
    local float SavedOpacity;
    local float scale;
    local int   RotationFactor;
    local float XL, YL, MapX, MapY;
    local color SavedColor, WhiteColor;

    local float ScreenRatio, OverlayCenterTexStart, OverlayCenterTexSize;

    local float posx, posy;

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
            if (DriverPositionIndex < GunsightPositions)
            {

                // Draw Scope Overlay
                ScreenRatio = float(Canvas.SizeY) / float(Canvas.SizeX);
                OverlayCenterScale = 0.955 / OverlayCenterSize; // 0.955 factor widens visible FOV to full screen width = OverlaySize 1.0
                OverlayCenterTexStart = (1 - OverlayCenterScale) * float(CannonScopeOverlay.USize) / 2;
                OverlayCenterTexSize =  float(CannonScopeOverlay.USize) * OverlayCenterScale;
                Canvas.SetPos(0, 0);
                Canvas.DrawTile(CannonScopeOverlay , Canvas.SizeX , Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX, OverlayCenterTexStart - OverlayCorrectionY + (1 - ScreenRatio) * OverlayCenterTexSize / 2 , OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);

                // Draw the moving Aiming Graticule
                if (Gun != none && Gun.ProjectileClass != none)
                    Canvas.SetPos(0, Gun.ProjectileClass.static.GetYAdjustForRange(Gun.GetRange()) * Canvas.ClipY);
                //Canvas.SetPos(ScopePositionX * Canvas.ClipY / ScreenRatio / OverlayCenterScale - (Canvas.ClipX / OverlayCenterScale - Canvas.ClipX) / 2, (Gun.ProjectileClass.static.GetYAdjustForRange(Gun.GetRange()) * Canvas.ClipY / ScreenRatio / OverlayCenterScale) - Canvas.ClipY * (1/ScreenRatio/OverlayCenterScale - 1) / 2);
                else
                    Canvas.SetPos(ScopePositionX * Canvas.ClipY / ScreenRatio / OverlayCenterScale - (Canvas.ClipX / OverlayCenterScale - Canvas.ClipX) / 2, ScopePositionY  * Canvas.ClipY / ScreenRatio / OverlayCenterScale - Canvas.ClipY * (1/ScreenRatio/OverlayCenterScale-1)/2);

                    Canvas.DrawTile(CannonScopeCenter , Canvas.SizeX , Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX, OverlayCenterTexStart - OverlayCorrectionY + (1 - ScreenRatio) * OverlayCenterTexSize / 2 , OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);
                    //Canvas.DrawTileScaled(CannonScopeCenter, scale * ScopeCenterScaleX / ScreenRatio / OverlayCenterScale, scale * ScopeCenterScaleY / ScreenRatio / OverlayCenterScale);

                    // Draw the Range Ring
                    posx = (float(Canvas.SizeX) - float(Canvas.SizeY) * 4/OverlayCenterScale/3) / 2.0;
                    posy = (float(Canvas.SizeY) - float(Canvas.SizeY) * 4/OverlayCenterScale/3) / 2.0;
                    Canvas.SetPos(OverlayCorrectionX + Posx + (Canvas.SizeY * (1.0 - ScopeCenterScale) * 4/OverlayCenterScale/3 / 2.0) , OverlayCorrectionY + Canvas.SizeY * (1.0 - ScopeCenterScale * 4/OverlayCenterScale/3) / 2.0);
                    // to do: above, the OverlayCorrectionX should be recalculated with resolution, it's in overlay pixels not screen pixels

                    RotationFactor = 0;

                    if (Gun != none)
                    {
                        if (Gun.CurrentRangeIndex < 20)  //20
                        {
                           RotationFactor += (Gun.CurrentRangeIndex * CenterRotationFactor);
                        }
                        else
                        {
                           RotationFactor += (CenterRotationFactor * 20) + (((Gun.CurrentRangeIndex - 20) * 2) * CenterRotationFactor);
                        }
                    }

                    ScopeCenterRotator.Rotation.Yaw = RotationFactor;
                    //Canvas.DrawTileScaled(ScopeCenterRotator, Canvas.SizeY / 512.0 * ScopeCenterScale, Canvas.SizeY / 512.0 * ScopeCenterScale);
                    Canvas.DrawTileScaled(ScopeCenterRotator, Canvas.SizeY / 512.0 * ScopeCenterScale * 4/OverlayCenterScale/3, Canvas.SizeY / 512.0 * ScopeCenterScale * 4/OverlayCenterScale/3);

                    // Draw the range setting
                    if (Gun != none && bShowRangeText)
                    {
                       Canvas.Style = ERenderStyle.STY_Normal;
                       SavedColor = Canvas.DrawColor;
                       WhiteColor =  class'Canvas'.Static.MakeColor(255,255,255, 175);
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

defaultproperties
{
    ScopeCenterScale=0.750000
    ScopeCenterScaleX=1.000000
    ScopeCenterScaleY=1.000000
    CannonScopeOverlay=texture'DH_VehicleOptics_tex.German.German_sight_background'
    BinocsOverlay=texture'DH_VehicleOptics_tex.German.BINOC_overlay_6x30Germ'
}

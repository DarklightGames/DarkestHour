//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHSovietCannonPawn extends DHVehicleCannonPawn
    abstract;

var     float   ScopeCenterPositionX; // positioning of CannonScopeCenter overlay (0 to 1, from left of screen)
var     float   ScopeCenterScaleX;    // width & height scaling of CannonScopeCenter overlay
var     float   ScopeCenterScaleY;

// Modified to include different handling for Soviet gunsight & centre overlays, from RO's RussianTankCannonPawn
// TODO: resolve differences & merge unto DHVehicleCannonPawn as a generic function
simulated function DrawHUD(Canvas C)
{
    local PlayerController PC;
    local float            SavedOpacity, PosX, PosY, Scale, XL, YL, MapX, MapY;
    local color            SavedColor, WhiteColor;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView)
    {
        // Player is in a position where an overlay should be drawn
        if (DriverPositions[DriverPositionIndex].bDrawOverlays && (!IsInState('ViewTransition') || DriverPositions[LastPositionIndex].bDrawOverlays))
        {
            if (HUDOverlay == none)
            {
                // Save current HUD opacity & then set up for drawing overlays
                SavedOpacity = C.ColorModulate.W;
                C.ColorModulate.W = 1.0;
                C.DrawColor.A = 255;
                C.Style = ERenderStyle.STY_Alpha;

                // Draw gunsights
                if (DriverPositionIndex < GunsightPositions)
                {
                    // Debug - draw cross on the center of the screen
                    if (bDebugSights)
                    {
                        PosX = C.SizeX / 2.0;
                        PosY = C.SizeY / 2.0;
                        C.SetPos(0.0, 0.0);
                        C.DrawVertical(PosX - 1.0, PosY - 3.0);
                        C.DrawVertical(PosX, PosY - 3.0);
                        C.SetPos(0.0, PosY + 3.0);
                        C.DrawVertical(PosX - 1.0, PosY - 3.0);
                        C.DrawVertical(PosX, PosY - 3.0);
                        C.SetPos(0.0, 0.0);
                        C.DrawHorizontal(PosY - 1.0, PosX - 3.0);
                        C.DrawHorizontal(PosY, PosX - 3.0);
                        C.SetPos(PosX + 3.0, 0.0);
                        C.DrawHorizontal(PosY - 1.0, PosX - 3.0);
                        C.DrawHorizontal(PosY, PosX - 3.0);
                    }

                    if (GunsightOverlay != none && Gun != none)
                    {
                        // Draw the gunsight overlay (different from DHVehicleCannonPawn)
                        PosX = float(C.SizeX - C.SizeY) / 2.0; // calculate drawing position for left side of overlay
                        C.SetPos(PosX, 0.0);

                        C.DrawTile(GunsightOverlay, C.SizeY, C.SizeY, 0.0, 0.0, GunsightOverlay.USize, GunsightOverlay.VSize);

                        // Draw the gunsight aiming reticle (different from DHVehicleCannonPawn)
                        if (CannonScopeCenter != none && Gun.ProjectileClass != none)
                        {
                            Scale = C.SizeY / 1200.0; // 'mover' texture is sized for a 1200 pixel screen height, so adjust scale to suit actual screen height

                            // Position moving range indicator for gunsights with optical (not mechanically linked) range setting
                            C.SetPos(PosX + (ScopeCenterPositionX * C.ClipY), Gun.ProjectileClass.static.GetYAdjustForRange(Gun.GetRange()) * C.ClipY);

                            C.DrawTileScaled(CannonScopeCenter, Scale * ScopeCenterScaleX, Scale * ScopeCenterScaleY);
                        }

                        // Draw black bars to fill in the rest of the screen to the left & right of drawn gunsight overlay
                        C.SetPos(0.0, 0.0);
                        C.DrawTile(texture'Engine.BlackTexture', PosX, C.SizeY, 0.0, 0.0, 8.0, 8.0);
                        C.SetPos(C.SizeX - PosX, 0.0);
                        C.DrawTile(texture'Engine.BlackTexture', PosX, C.SizeY, 0.0, 0.0, 8.0, 8.0);

                        // Draw any range setting
                        if (bShowRangeText)
                        {
                            C.Style = ERenderStyle.STY_Normal;
                            SavedColor = C.DrawColor;
                            WhiteColor = class'Canvas'.static.MakeColor(255, 255, 255, 175);
                            C.DrawColor = WhiteColor;
                            MapX = RangePositionX * C.ClipX;
                            MapY = RangePositionY * C.ClipY;
                            C.SetPos(MapX, MapY);
                            C.Font = class'ROHUD'.static.GetSmallMenuFont(C);
                            C.StrLen(Gun.GetRange() @ RangeText, XL, YL);
                            C.DrawTextJustified(Gun.GetRange() @ RangeText, 2, MapX, MapY, MapX + XL, MapY + YL);
                            C.DrawColor = SavedColor;
                        }
                    }
                }
                // Draw periscope overlay
                else if (DriverPositionIndex == PeriscopePositionIndex)
                {
                    DrawPeriscopeOverlay(C);
                }
                // Draw binoculars overlay
                else if (DriverPositionIndex == BinocPositionIndex)
                {
                    DrawBinocsOverlay(C);
                }

                C.ColorModulate.W = SavedOpacity; // reset HUD opacity to original value
            }
            // Draw any HUD overlay
            else if (!Level.IsSoftwareRendering())
            {
                HUDOverlay.SetLocation(PC.CalcViewLocation + (HUDOverlayOffset >> PC.CalcViewRotation));
                HUDOverlay.SetRotation(PC.CalcViewRotation);
                C.DrawActor(HUDOverlay, false, false, FClamp(HUDOverlayFOV * (PC.DesiredFOV / PC.DefaultFOV), 1.0, 170.0));
            }
        }

        // Draw vehicle, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none && VehicleBase != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(C, VehicleBase, self);
        }
    }
}

defaultproperties
{
    bShowRangeText=true
    RangeText="meters"
    RangePositionX=0.1
    PeriscopeOverlay=texture'DH_VehicleOptics_tex.Allied.PERISCOPE_overlay_Allied'
    BinocsOverlay=texture'DH_VehicleOptics_tex.Allied.BINOC_overlay_7x50Allied'
    ScopeCenterPositionX=0.215
    ScopeCenterScaleX=1.35
    ScopeCenterScaleY=1.35
}

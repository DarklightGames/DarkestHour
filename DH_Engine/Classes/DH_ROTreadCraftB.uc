//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROTreadCraftB extends DH_ROTreadCraft;


simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local vector CameraLocation;
    local rotator CameraRotation;
    local Actor ViewActor;
    local float SavedOpacity;   //to keep players from seeing outside the periscope overlay

    if (IsLocallyControlled() && ActiveWeapon < Weapons.length && Weapons[ActiveWeapon] != none && Weapons[ActiveWeapon].bShowAimCrosshair && Weapons[ActiveWeapon].bCorrectAim)
    {
        Canvas.DrawColor = CrosshairColor;
        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;

        Canvas.SetPos(Canvas.SizeX*0.5-CrosshairX, Canvas.SizeY*0.5-CrosshairY);
        Canvas.DrawTile(CrosshairTexture, CrosshairX*2.0+1, CrosshairY*2.0+1, 0.0, 0.0, CrosshairTexture.USize, CrosshairTexture.VSize);
    }

    PC = PlayerController(Controller);

    if (PC == none)
    {
        super.RenderOverlays(Canvas);
        //log("PanzerTurret PlayerController was none, returning");
        return;
    }
    else if (!PC.bBehindView)
    {

       SavedOpacity = Canvas.ColorModulate.W;
       Canvas.ColorModulate.W = 1.0;

       if (DriverPositions[DriverPositionIndex].bDrawOverlays && HUDOverlay == none && DriverPositionIndex == 0 && !IsInState('ViewTransition'))
       {
           DrawPeriscopeOverlay(Canvas);
       }
        // reset HudOpacity to original value
        Canvas.ColorModulate.W = SavedOpacity;
        DrawVehicle(Canvas);
        DrawPassengers(Canvas);
    }

    if (PC != none && !PC.bBehindView && HUDOverlay != none && DriverPositions[DriverPositionIndex].bDrawOverlays)
    {
        if (!Level.IsSoftwareRendering())
        {
            CameraRotation = PC.Rotation;
            SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);
            HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
            HUDOverlay.SetRotation(CameraRotation);
            Canvas.DrawActor(HUDOverlay, false, true, FClamp(HUDOverlayFOV * (PC.DesiredFOV / PC.DefaultFOV), 1, 170));
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
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_LocustCannonPawn extends DHAmericanCannonPawn;

/**
Locust had a periscopic gunsight, with an M46A2 1.8x magnification telescope mounted vertically inside an M8A1 periscope
The M46A2 telescope only provided a 6 degrees visible FOV, which is only a small very portion of the screen width
But the periscope 'background' view provides unmagnified situational awareness, with a small, magnified telescope view in the centre for closer aiming

This is implemented in game by drawing a standard allied textured periscope overlay on an unmagnified view
Then adding a HUD overlay actor to represent the telescope as in inset magnified view inside the periscope letterbox view
The HUD overlay uses a scripted texture, which natively draws a magnified 'portal' view onto the overlay
The gunsight position, DriverPositions[0], doesn't specify a reduced FOV for magnification as it represents the unmagnified background periscope view
The HUD overlay represents the telescope part and that's where the magnification and visible FOV are specified

The HUDOffset.X value is used to position the drawn HUD overlay so that at full draw scale the telescope lens exactly fills the screen width
Then the usual GunsightSize property is used to scale [its size on screen, by setting the HUD overlay's DrawScale
*/

#exec OBJ LOAD FILE=..\Textures\DH_VehicleOpticsDestroyed_tex.utx

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////// TEMP DEBUG stuff:
var bool bHideGunsightPeriscope;
exec function SetTeleFOV(int NewValue)
{
    Log(Tag @ "TelescopeFOV =" @ NewValue @ "(was" @ DH_LocustGunsightOverlay(HUDOverlay).TelescopeFOV $ ")");
    DH_LocustGunsightOverlay(HUDOverlay).TelescopeFOV = NewValue;
}
exec function SetHUDOffset(string NewX, string NewY, string NewZ)
{
    Log(Tag @ "HUDOverlayOffset =" @ float(NewX) @ float(NewY) @ float(NewZ) @ "(was" @ HUDOverlayOffset $ ")");
    HUDOverlayOffset.X = float(NewX);
    HUDOverlayOffset.Y = float(NewY);
    HUDOverlayOffset.Z = float(NewZ);
}
exec function SetHudFOV(float NewValue)
{
    Log(Tag @ "HUDOverlayFOV =" @ NewValue @ "(was" @ HUDOverlayFOV $ ")");
    HUDOverlayFOV = NewValue;
}
exec function SetMod(optional bool Modulate2X, optional bool Modulate4X)
{
    Combiner(HUDOverlay.Skins[0]).Modulate2X = Modulate2X;
    Combiner(HUDOverlay.Skins[0]).Modulate4X = Modulate4X;
}
exec function HidePeri()
{
    bHideGunsightPeriscope = !bHideGunsightPeriscope;
}
exec function DamageSight()
{
    DamageCannonOverlay();
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

exec function SetTex(int Slot) // TEMP to allow switching between different sized versions of the vehicle skins, to compare them & look for detail loss
{
    DH_LocustTank(VehicleBase).SetTex(Slot);
}

// Modified to draw periscope overlay for gunsight position as well as periscope position (as Locust has a periscopic gunsight)
// And when drawing the gunsight HUD overlay, to make it update its gunsight 'portal' zoomed view
simulated function DrawHUD(Canvas C)
{
    local PlayerController PC;
    local float            SavedOpacity;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView)
    {
        // Player is in a position where an overlay should be drawn
        if (DriverPositions[DriverPositionIndex].bDrawOverlays && !IsInState('ViewTransition'))
        {
            // Save current HUD opacity & then set up for drawing a texture overlay
            SavedOpacity = C.ColorModulate.W;
            C.ColorModulate.W = 1.0;
            C.DrawColor.A = 255;
            C.Style = ERenderStyle.STY_Alpha;

            // If on gunsight, draw HUD overlay to show gunsight telescope (which is mounted within the gunsight periscope)
            if (DriverPositionIndex < GunsightPositions && HUDOverlay != none)
            {
                HUDOverlay.SetLocation(PC.CalcViewLocation + (HUDOverlayOffset >> PC.CalcViewRotation));
                HUDOverlay.SetRotation(PC.CalcViewRotation);
                HUDOverlay.RenderOverlays(C); // added to make the HUD overlay update its gunsight 'portal' zoomed view
                C.DrawActor(HUDOverlay, false, false, HUDOverlayFOV);
            }

            // Draw textured periscope overlay if on gunsight OR commander's periscope
            if (DriverPositionIndex < GunsightPositions || DriverPositionIndex == PeriscopePositionIndex)
            {
                DrawPeriscopeOverlay(C);
            }
            // Draw textured binoculars overlay
            else if (DriverPositionIndex == BinocPositionIndex)
            {
                DrawBinocsOverlay(C);
            }

            C.ColorModulate.W = SavedOpacity; // reset HUD opacity to original value
        }

        // Draw vehicle, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none && VehicleBase != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(C, VehicleBase, self);
        }
    }
}

// Emptied out to emphasise that it isn't used due to changes in DrawHUD()
simulated function DrawGunsightOverlay(Canvas C);

// Modified so if gunsight has been damaged & we're on the sight, switch to a damaged periscope overlay texture
simulated function DrawPeriscopeOverlay(Canvas C)
{
    if (bHideGunsightPeriscope && DriverPositionIndex < GunsightPositions) return; // TEMP debug

    if (bOpticsDamaged && DriverPositionIndex < GunsightPositions)
    {
        PeriscopeOverlay = Texture'DH_VehicleOpticsDestroyed_tex.Allied.Pericope_allied_damaged'; // TODO: get a broken periscope overlay made (this is a crude placeholder)
    }
    else
    {
        PeriscopeOverlay = default.PeriscopeOverlay;
    }

    super.DrawPeriscopeOverlay(C);
}

// Modified to damage the optic in the telescope HUD overlay, & also use a damaged texture for the periscope overlay
simulated function ClientDamageCannonOverlay()
{
    super.ClientDamageCannonOverlay();

    bOpticsDamaged = true; // used here to make DrawPeriscopeOverlay() use a damaged texture (not usually set or used on a net client)

    if (DH_LocustGunsightOverlay(HUDOverlay) != none)
    {
        DH_LocustGunsightOverlay(HUDOverlay).DamageGunsightOverlay(DestroyedGunsightOverlay);
    }
}

// Modified to make this cannon pawn the owner of the spawned HUDOverlay actor, so it can access our GunsightOverlay property when it spawns & initializes
simulated function ActivateOverlay(bool bActive)
{
    if (bActive)
    {
        if (HUDOverlay == none)
        {
            HUDOverlay = Spawn(HUDOverlayClass, self);
        }
    }
    else if (HUDOverlay != none)
    {
        HUDOverlay.Destroy();
    }
}

// Modified so this debug exec changes the size of the gunsight HUD overlay to match our new GunsightSize
exec function SetSightSize(float NewValue)
{
    super.SetSightSize(NewValue);

    if (HUDOverlay != none)
    {
        HUDOverlay.SetDrawScale(GunsightSize);
    }
}

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_LocustCannon'
    // TEMP added ViewLocation to fake camera position changes, until anims are made:
    DriverPositions(0)=(ViewLocation=(X=31.0,Y=-35.0,Z=14.9),ViewFOV=85.0,TransitionUpAnim="gunsight_out",bDrawOverlays=true)
    DriverPositions(1)=(ViewLocation=(X=-5.0,Y=-15.0,Z=0.0),TransitionUpAnim="periscope_in",TransitionDownAnim="gunsight_in",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=32768,ViewNegativeYawLimit=-32768)
    DriverPositions(2)=(ViewLocation=(X=-4.0,Y=0.0,Z=11.0),TransitionUpAnim="com_open",TransitionDownAnim="periscope_out",ViewPitchUpLimit=0,ViewPitchDownLimit=65535,bDrawOverlays=true)
    DriverPositions(3)=(ViewLocation=(X=0.0,Y=0.0,Z=25.0),TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=32768,ViewNegativeYawLimit=-32768,bExposed=true)
    DriverPositions(4)=(ViewLocation=(X=0.0,Y=0.0,Z=25.0),ViewFOV=12.0,DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=32768,ViewNegativeYawLimit=-32768,bDrawOverlays=true,bExposed=true)
    PeriscopePositionIndex=2
    UnbuttonedPositionIndex=3
    BinocPositionIndex=4
    DrivePos=(X=6.0,Y=1.0,Z=-17.0) // TODO: reposition attachment bone to remove need for this offset, then delete this line
    DriveRot=(Yaw=55536) // have to turn commander to the left so he just about squeezes inside the hatch without clipping the turret
    DriveAnim="stand_idlehip_binoc"
    bManualTraverseOnly=true
    GunsightOverlay=Combiner'DH_VehicleOptics_tex.US.Locust_sight_combiner' // combiner used by HUD overlay to draw gunsight telescope 'portal' view
    GunsightSize=0.135 // slightly over 6 degrees visible FOV through sight (should be 0.1271), but gives correct 1.8x magnification with portal FOV, where we have to work with an integer
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.Allied.Stuart_sight_destroyed'
    bIsPeriscopicGunsight=true
    HUDOverlayClass=class'DH_Vehicles.DH_LocustGunsightOverlay'
    HUDOverlayFOV=85.0
    HUDOverlayOffset=(X=5.25,Y=0.0,Z=0.0)
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.StuartShell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.StuartShell_reload'
    FireImpulse=(X=-30000.0)
}

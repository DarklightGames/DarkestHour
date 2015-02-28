//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ATGunTwoCannonPawn extends AssaultGunCannonPawn
    abstract;

// Note to future developers:
//     RAMM created a new class to hold many of these functions called ATGunCannonPawn for the MapPack.
//     I would have extended from that but ATGunCannonPawn itself extends from RussianTankCannonPawn.
//     I needed to create this class because of the optic pattern used.  There is no line to move on certain AT-Guns.
//     So, I copied ATGunCannonPawn and called it ATGunTwoCannonPawn.  This then extends from AssaultGunCannonPawn.
//     Ramm also improved the original AT-Gun code by better handling the player exit for the fixed AT-Gun.

// More debugging stuff
var()   bool    bShowCenter; // shows centering cross in tank sight for testing purposes

// New variables used in subclasses
var()   float   OverlayCenterScale; // scale of the gunsight overlay, 1.0 means full screen width, 0.5 means half screen width
var()   float   OverlayCenterSize;
var()   int     OverlayCorrectionX, OverlayCorrectionY; // scope center correction in pixels, as some overlays are off-center by pixel or two
                                                        // (it's in pixels of overlay bitmap, not pixels of screen, so works for every resolution)

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerToggleExtraRoundType;
}

simulated exec function SwitchFireMode()
{
    if (Gun != none && DH_ATGunCannon(Gun) != none && DH_ATGunCannon(Gun).bMultipleRoundTypes)
    {
        if (Controller != none && ROPlayer(Controller) != none)
        {
            ROPlayer(Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick', false,, SLOT_Interface);
        }

        ServerToggleExtraRoundType();
    }
}

function ServerToggleExtraRoundType()
{
    if (Gun != none && DH_ATGunCannon(Gun) != none)
    {
        DH_ATGunCannon(Gun).ToggleRoundType();
    }
}

simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local vector  CameraLocation;
    local rotator CameraRotation;
    local Actor   ViewActor;
    local float   SavedOpacity, XL, YL, MapX, MapY, ScreenRatio, OverlayCenterTexStart, OverlayCenterTexSize;
    local color   SavedColor, WhiteColor;

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
            if (DriverPositionIndex == 0)
            {
                // Calculate reticle drawing position (& position to draw black bars at) and draw reticle
                ScreenRatio = Float(Canvas.SizeY) / Float(Canvas.SizeX);
                OverlayCenterScale = 0.955 / OverlayCenterSize; // 0.955 factor widens visible FOV to full screen width = OverlaySize 1.0
                OverlayCenterTexStart = (1.0 - OverlayCenterScale) * Float(CannonScopeOverlay.USize) / 2.0;
                OverlayCenterTexSize =  Float(CannonScopeOverlay.USize) * OverlayCenterScale;

                Canvas.SetPos(0.0, 0.0);
                Canvas.DrawTile(CannonScopeOverlay , Canvas.SizeX , Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX, 
                    OverlayCenterTexStart - OverlayCorrectionY + (1.0 - ScreenRatio) * OverlayCenterTexSize / 2.0 , OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);

                // Draw the range setting
                if (Gun != none)
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
                    Canvas.DrawTextJustified(Gun.GetRange() @ RangeText, 2, MapX, MapY, MapX + XL, MapY+YL);

                    Canvas.DrawColor = SavedColor;
                }
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
        Canvas.SetPos(Canvas.SizeX * 0.5-CrosshairX, Canvas.SizeY * 0.5-CrosshairY);
        Canvas.DrawTile(CrosshairTexture, CrosshairX * 2.0, CrosshairY * 2.0, 0.0, 0.0, CrosshairTexture.USize, CrosshairTexture.VSize);
    }

    if (PC != none && !PC.bBehindView && HUDOverlay != none)
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

// Overridden because the animation needs to play on the server for this vehicle for the commanders hit detection
function ServerChangeViewPoint(bool bForward)
{
    if (bForward)
    {
        if (DriverPositionIndex < (DriverPositions.Length - 1))
        {
            LastPositionIndex = DriverPositionIndex;
            DriverPositionIndex++;

            if (Level.NetMode == NM_Standalone  || Level.NetMode == NM_ListenServer)
            {
                NextViewPoint();
            }

            if (Level.NetMode == NM_DedicatedServer)
            {
                AnimateTransition();
            }
        }
     }
     else
     {
        if (DriverPositionIndex > 0)
        {
            LastPositionIndex = DriverPositionIndex;
            DriverPositionIndex--;

            if (Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
            {
                NextViewPoint();
            }

            if (Level.NetMode == NM_DedicatedServer)
            {
                AnimateTransition();
            }
        }
     }
}

// Overridden to set exit rotation to be the same as when they were in the vehicle - looks a bit silly otherwise
simulated function ClientKDriverLeave(PlayerController PC)
{
    local rotator NewRot;

    NewRot = VehicleBase.Rotation;
    NewRot.Pitch = LimitPitch(NewRot.Pitch);
    SetRotation(NewRot);

    super.ClientKDriverLeave(PC);
}

// Overridden to handle vehicle exiting better for fixed AT Cannons
function bool PlaceExitingDriver()
{
    local int    i;
    local vector TryPlace, Extent, ZOffset;

    Extent = Driver.default.CollisionRadius * vect(1.0, 1.0, 0.0);
    Extent.Z = Driver.default.CollisionHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0.0, 0.0, 0.5);

    for (i = 0; i < ExitPositions.Length; i++)
    {
        if (bRelativeExitPos)
        {
            if (VehicleBase != none)
            {
                TryPlace = VehicleBase.Location + (ExitPositions[i] >> VehicleBase.Rotation) + ZOffset;
            }
            else if (Gun != none)
            {
                TryPlace = Gun.Location + (ExitPositions[i] >> Gun.Rotation) + ZOffset;
            }
            else
            {
                TryPlace = Location + (ExitPositions[i] >> Rotation);
            }
        }
        else
        {
            TryPlace = ExitPositions[i];
        }

        // First, do a line check (stops us passing through things on exit)
        // NO, skip line check, sometimes there are close objects that cause this check to fail, even when area that you are trying to place the exiting driver is clear - Ramm

        // Now see if we can place the player there
        if (!Driver.SetLocation(TryPlace))
        {
            continue;
        }

        return true;
    }

    return false;
}

// Options
// 1: Implemented: modified PlaceExitingDriver so that it handles placing the player on exit better - Ramm
// 2: Implemented: keep the player at his current position and send him a msg - if they are smart they can suicide to get off the gun
//
// This is a combination of the KDriverLeave over-rides in VehicleWeaponPawn and ROVehicleWeaponPawn
// When the leaves fails (returns false) it jumps into ServerChangeDriverPosition if there is not a place to put the player, which then puts player in driver's seat
event bool KDriverLeave(bool bForceLeave)
{
    local bool              bSuperDriverLeave;
    local Controller        C;
    local PlayerController  PC;

    C = Controller;

    if (!bForceLeave && !Level.Game.CanLeaveVehicle(self, Driver))
    {
        return false;
    }

    if (PlayerReplicationInfo != none && PlayerReplicationInfo.HasFlag != none)
    {
        Driver.HoldFlag(PlayerReplicationInfo.HasFlag);
    }

    // Do nothing if we're not being driven
    if (Controller == none)
    {
        return false;
    }

    Driver.bHardAttach = false;
    Driver.bCollideWorld = true;
    Driver.SetCollision(true, true);

    // Let's look for an unobstructed exit point - if we find one then we know we can dismount the gun
    if (PlaceExitingDriver())
    {
        DriverPositionIndex = 0;

        bDriving = false;

        // Reconnect Controller to Driver
        if (C.RouteGoal == self)
        {
            C.RouteGoal = none;
        }

        if (C.MoveTarget == self)
        {
            C.MoveTarget = none;
        }

        C.bVehicleTransition = true;
        Controller.UnPossess();

        if (Driver != none && Driver.Health > 0)
        {
            Driver.SetOwner(C);
            C.Possess(Driver);
            PC = PlayerController(C);

            if (PC != none)
            {
                PC.ClientSetViewTarget(Driver); // set PlayerController to view the person that got out
            }

            Driver.StopDriving(self);
        }

        C.bVehicleTransition = false;

        if (C == Controller) // if controller didn't change, clear it
        {
            Controller = none;
        }

        Level.Game.DriverLeftVehicle(self, Driver);

        // Car now has no driver
        Driver = none;
        DriverLeft();

        bSuperDriverLeave = true;
    }
    else
    {
        C.Pawn.ReceiveLocalizedMessage(class'DH_ATCannonMessage', 5);
        bSuperDriverLeave = false;
    }

    return bSuperDriverLeave;
}

// 1.0 = 0% reloaded, 0.0 = 100% reloaded (e.g. finished reloading)
function float GetAmmoReloadState()
{
    local ROTankCannon Cannon;

    Cannon = ROTankCannon(gun);

    if (Cannon != none)
    {
        switch (Cannon.CannonReloadState)
        {
            case CR_ReadyToFire:    return 0.0;
            case CR_Waiting:
            case CR_Empty:
            case CR_ReloadedPart1:  return 1.0;
            case CR_ReloadedPart2:  return 0.66;
            case CR_ReloadedPart3:  return 0.33;
        }
    }

    return 0.0;
}

// Used to debug where the exit positions are. First type "show sky" in console to turn the sky off (debug lines won't render otherwise.
// Then hop in the ATCannon and type "DebugExit" and cylinders will appear showing where the exit positions for the player are.
exec function DebugExit()
{
    local int    i;
    local vector X, Y, Z, TryPlace, ZOffset;

    if (Level.NetMode != NM_Standalone)
    {
        return;
    }

    GetAxes(VehicleBase.Rotation, X, Y, Z);

    ClearStayingDebugLines();

    for (i = 0; i < ExitPositions.Length; i++)
    {
        if (bRelativeExitPos)
        {
            if (VehicleBase != none)
            {
                TryPlace = VehicleBase.Location + (ExitPositions[i] >> VehicleBase.Rotation) + ZOffset;
            }
            else if (Gun != none)
            {
                TryPlace = Gun.Location + (ExitPositions[i] >> Gun.Rotation) + ZOffset;
            }
            else
            {
                TryPlace = Location + (ExitPositions[i] >> Rotation);
            }
        }
        else
        {
            TryPlace = ExitPositions[i];
        }

        DrawStayingDebugLine(VehicleBase.Location, TryPlace, 0, 255, 0);

        DrawDebugCylinder(TryPlace, X, Y, Z, class'ROEngine.ROPawn'.default.CollisionRadius, class'ROEngine.ROPawn'.default.CollisionHeight, 10, 0, 255, 0);
    }
}

// Draws a debugging cylinder out of wireframe lines
simulated function DrawDebugCylinder(vector Base, vector X, vector Y, vector Z, float Radius, float HalfHeight, int NumSides, byte R, byte G, byte B)
{
    local float  AngleDelta;
    local vector LastVertex, Vertex;
    local int    SideIndex;

    AngleDelta = 2.0 * PI / NumSides;
    LastVertex = Base + X * Radius;

    for (SideIndex = 0; SideIndex < NumSides; SideIndex++)
    {
        Vertex = Base + (X * Cos(AngleDelta * (SideIndex + 1.0)) + Y * Sin(AngleDelta * (SideIndex + 1.0))) * Radius;

        DrawStayingDebugLine(LastVertex - Z * HalfHeight, Vertex - Z * HalfHeight, R, G, B);
        DrawStayingDebugLine(LastVertex + Z * HalfHeight, Vertex + Z * HalfHeight, R, G, B);
        DrawStayingDebugLine(LastVertex - Z * HalfHeight, LastVertex + Z * HalfHeight, R, G, B);

        LastVertex = Vertex;
    }
}

// AB CODE
simulated function DrawBinocsOverlay(Canvas Canvas)
{
    local float ScreenRatio;

    ScreenRatio = Float(Canvas.SizeY) / Float(Canvas.SizeX);
    Canvas.SetPos(0.0, 0.0);
    Canvas.DrawTile(BinocsOverlay, Canvas.SizeX, Canvas.SizeY, 0.0 , (1.0 - ScreenRatio) * float(BinocsOverlay.VSize) / 2.0, BinocsOverlay.USize, float(BinocsOverlay.VSize) * ScreenRatio);
}

function Fire(optional float F)
{
    if (IsInState('ViewTransition'))
    {
        return;
    }

    super.Fire(F);
}

defaultproperties
{
    OverlayCenterSize=1.0
    BinocsOverlay=texture'DH_VehicleOptics_tex.German.BINOC_overlay_6x30Germ'
    HudName="Gunner"
    bMustBeTankCrew=false
    FireImpulse=(X=-1000.0)
    bHasFireImpulse=false
    bHasAltFire=false
    bPCRelativeFPRotation=true
    bDesiredBehindView=false
    DriveAnim="crouch_idle_binoc"
    RotateSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    PitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    RotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_gun_traverse'
    ExitPositions(0)=(X=-40.0,Y=-10.0,Z=50.0)
    ExitPositions(1)=(X=-40.0,Y=-10.0,Z=60.0)
    ExitPositions(2)=(X=-40.0,Y=25.0,Z=50.0)
    ExitPositions(3)=(X=-40.0,Y=-25.0,Z=50.0)
    ExitPositions(4)=(Y=68.0,Z=50.0)
    ExitPositions(5)=(Y=-68.0,Z=50.0)
    ExitPositions(6)=(Y=68.0,Z=25.0)
    ExitPositions(7)=(Y=-68.0,Z=25.0)
    ExitPositions(8)=(X=-60.0,Y=-5.0,Z=25.0)
    ExitPositions(9)=(X=-90.0,Z=50.0)
    ExitPositions(10)=(X=-90.0,Y=-45.0,Z=50.0)
    ExitPositions(11)=(X=-90.0,Y=45.0,Z=50.0)
    ExitPositions(12)=(X=-90.0,Z=20.0)
    ExitPositions(13)=(X=-90.0,Z=75.0)
    ExitPositions(14)=(X=-125.0,Z=60.0)
    ExitPositions(15)=(X=-250.0,Z=75.0)
    EntryRadius=130.0
    TPCamDistance=300.0
    TPCamLookat=(X=-25.0,Z=0.0)
    TPCamWorldOffset=(Y=50.0,Z=120.0)
    PitchUpLimit=6000
    PitchDownLimit=64000
}

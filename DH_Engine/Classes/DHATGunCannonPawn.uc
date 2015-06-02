//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHATGunCannonPawn extends DHVehicleCannonPawn
    abstract;

var bool bDebugExit; // records that exit positions are being drawn by DebugExit(), so can be toggled on/off

// Emptied out so we just use plain RO rotate/pitch sounds & ignore DHVehicleCannonPawn's manual/powered sounds
simulated function SetManualTurret(bool bManual)
{
}

// Emptied out as can't switch positions in an AT gun
simulated function SwitchWeapon(byte F)
{
}

// Emptied out as AT gun has no alt fire mode, so just ensures nothing happens
function AltFire(optional float F)
{
}

// Modified to avoid turret damage checks in DHVehicleCannonPawn, just for processing efficiency as this function is called many times per second
function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
{
    super(ROTankCannonPawn).HandleTurretRotation(DeltaTime, YawChange, PitchChange);
}

// Overridden to handle vehicle exiting better for fixed AT guns
function bool PlaceExitingDriver()
{
    local int    i;
    local vector TryPlace, Extent, ZOffset;

    Extent = Driver.default.CollisionRadius * vect(1.0, 1.0, 0.0);
    Extent.Z = Driver.default.CollisionHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0.0, 0.0, 0.5);

    for (i = 0; i < ExitPositions.Length; ++i)
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
// 1: Implemented: modified PlaceExitingDriver so that it handles placing the player on exit better
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
        C.Pawn.ReceiveLocalizedMessage(class'DHATCannonMessage', 4); // no exit can be found
        bSuperDriverLeave = false;
    }

    return bSuperDriverLeave;
}

// Modified to use 3 part reload for AT gun, instead of 4 part reload in tank cannon
function float GetAmmoReloadState()
{
    if (ROTankCannon(Gun) != none)
    {
        switch (ROTankCannon(Gun).CannonReloadState)
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

// New function to debug location of exit positions, which are drawn as green cylinders
exec function DebugExit()
{
    local int    i;
    local vector X, Y, Z, TryPlace, ZOffset;

    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        bDebugExit = !bDebugExit;
        ClearStayingDebugLines();

        if (bDebugExit)
        {
            GetAxes(VehicleBase.Rotation, X, Y, Z);

            for (i = 0; i < ExitPositions.Length; ++i)
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

                DrawDebugCylinder(TryPlace, X, Y, Z, class'DH_Engine.DHPawn'.default.CollisionRadius, class'DH_Engine.DHPawn'.default.CollisionHeight, 10, 0, 255, 0);
            }
        }
    }
}

// Draws a debugging cylinder out of wireframe lines - same as in ROHud but uses DrawStayingDebugLine(), so they stay on the screen
simulated function DrawDebugCylinder(vector Base, vector X, vector Y, vector Z, float Radius, float HalfHeight, int NumSides, byte R, byte G, byte B)
{
    local float  AngleDelta;
    local vector LastVertex, Vertex;
    local int    SideIndex;

    AngleDelta = 2.0 * PI / NumSides;
    LastVertex = Base + X * Radius;

    for (SideIndex = 0; SideIndex < NumSides; ++SideIndex)
    {
        Vertex = Base + (X * Cos(AngleDelta * (SideIndex + 1.0)) + Y * Sin(AngleDelta * (SideIndex + 1.0))) * Radius;

        DrawStayingDebugLine(LastVertex - Z * HalfHeight, Vertex - Z * HalfHeight, R, G, B);
        DrawStayingDebugLine(LastVertex + Z * HalfHeight, Vertex + Z * HalfHeight, R, G, B);
        DrawStayingDebugLine(LastVertex - Z * HalfHeight, LastVertex + Z * HalfHeight, R, G, B);

        LastVertex = Vertex;
    }
}

defaultproperties
{
    bShowRangeText=false
    OverlayCenterSize=1.0
    UnbuttonedPositionIndex=0
    BinocsOverlay=texture'DH_VehicleOptics_tex.German.BINOC_overlay_6x30Germ'
    HudName="Gunner"
    bMustBeTankCrew=false
    FireImpulse=(X=-1000.0)
    bHasFireImpulse=false
    bHasAltFire=false
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
    PitchUpLimit=6000
    PitchDownLimit=64000
}

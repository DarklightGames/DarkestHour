//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROMountedTankMGPawn extends ROMountedTankMGPawn
      abstract;

#exec OBJ LOAD FILE=..\textures\DH_VehicleOptics_tex.utx

var()   float   OverlayCenterScale;
var()   float   OverlayCenterSize;    // size of the gunsight overlay, 1.0 means full screen width, 0.5 means half screen width

var()   float   OverlayCorrectionX;
var()   float   OverlayCorrectionY;

var     texture VehicleMGReloadTexture; // used to show reload progress on the HUD, like a tank cannon reload

struct ExitPositionPair
{
    var int Index;
    var float DistanceSquared;
};

var bool bDebugExitPositions;

replication
{
    reliable if (Role < ROLE_Authority)
        ServerToggleDebugExits; // Matt: added
}

static final operator(24) bool > (ExitPositionPair A, ExitPositionPair B)
{
    return A.DistanceSquared > B.DistanceSquared;
}

//http://wiki.beyondunreal.com/Legacy:Insertion_Sort
static final function InsertSortEPPArray(out array<ExitPositionPair> MyArray, int LowerBound, int UpperBound)
{
    local int InsertIndex, RemovedIndex;

    if (LowerBound < UpperBound)
    {
        for (RemovedIndex = LowerBound + 1; RemovedIndex <= UpperBound; ++RemovedIndex)
        {
            InsertIndex = RemovedIndex;

            while (InsertIndex > LowerBound && MyArray[InsertIndex - 1] > MyArray[RemovedIndex])
            {
                --InsertIndex;
            }

            if ( RemovedIndex != InsertIndex )
            {
                MyArray.Insert(InsertIndex, 1);
                MyArray[InsertIndex] = MyArray[RemovedIndex + 1];
                MyArray.Remove(RemovedIndex + 1, 1);
            }
        }
    }
}

// Overridden to set exit rotation to be the same as when they were in the vehicle - looks a bit silly otherwise
simulated function ClientKDriverLeave(PlayerController PC)
{
    local rotator NewRot;

    NewRot = GetVehicleBase().Rotation;
    NewRot.Pitch = LimitPitch(NewRot.Pitch);
    SetRotation(NewRot);

    super.ClientKDriverLeave(PC);
}

function bool PlaceExitingDriver()
{
    local int i;
    local vector Extent, HitLocation, HitNormal, ZOffset, ExitPosition;
    local array<ExitPositionPair> ExitPositionPairs;

    if (Driver == none)
    {
        return false;
    }

    Extent = Driver.default.CollisionRadius * vect(1, 1, 0);
    Extent.Z = Driver.default.CollisionHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0, 0, 0.5);

    if (VehicleBase == none)
    {
        return false;
    }

    ExitPositionPairs.Length = VehicleBase.ExitPositions.Length;

    for (i = 0; i < VehicleBase.ExitPositions.Length; ++i)
    {
        ExitPositionPairs[i].Index = i;
        ExitPositionPairs[i].DistanceSquared = VSizeSquared(DrivePos - VehicleBase.ExitPositions[i]);
    }

    InsertSortEPPArray(ExitPositionPairs, 0, ExitPositionPairs.Length - 1);

    if (class'DH_ROMountedTankMGPawn'.default.bDebugExitPositions) // Matt: uses abstract class default, allowing bDebugExitPositions to be toggled for all MG pawns
    {
        for (i = 0; i < ExitPositionPairs.Length; ++i)
        {
            ExitPosition = VehicleBase.Location + (VehicleBase.ExitPositions[ExitPositionPairs[i].Index] >> VehicleBase.Rotation) + ZOffset;

            Spawn(class'DH_DebugTracer', , , ExitPosition);
        }
    }

    for (i = 0; i < ExitPositionPairs.Length; ++i)
    {
        ExitPosition = VehicleBase.Location + (VehicleBase.ExitPositions[ExitPositionPairs[i].Index] >> VehicleBase.Rotation) + ZOffset;

        if (Trace(HitLocation, HitNormal, ExitPosition, VehicleBase.Location + ZOffset, false, Extent) != none ||
            Trace(HitLocation, HitNormal, ExitPosition, ExitPosition + ZOffset, false, Extent) != none)
        {
            continue;
        }

        if (Driver.SetLocation(ExitPosition))
        {
            return true;
        }
    }

    return false;
}

simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local vector CameraLocation;
    local rotator CameraRotation;
    local Actor ViewActor;
    local float SavedOpacity;
    local vector x, y, z;

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

        // Draw reticle
        ScreenRatio = float(Canvas.SizeY) / float(Canvas.SizeX);
        OverlayCenterScale = 0.955 / OverlayCenterSize; // 0.955 factor widens visible FOV to full screen width = OverlaySize 1.0
        OverlayCenterTexStart = (1 - OverlayCenterScale) * float(MGOverlay.USize) / 2;
        OverlayCenterTexSize =  float(MGOverlay.USize) * OverlayCenterScale;

        Canvas.SetPos(0, 0);
        Canvas.DrawTile(MGOverlay , Canvas.SizeX , Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX, OverlayCenterTexStart - OverlayCorrectionY + (1 - ScreenRatio) * OverlayCenterTexSize / 2 , OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);

        // reset HudOpacity to original value
        Canvas.ColorModulate.W = SavedOpacity;
    }

    if (PC != none && !PC.bBehindView && HUDOverlay != none)
    {
        if (!Level.IsSoftwareRendering())
        {
            CameraRotation = PC.Rotation;
            SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);

            CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
            CameraLocation = CameraLocation + PC.ShakeOffset.X * x + PC.ShakeOffset.Y * y + PC.ShakeOffset.Z * z;

            HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
            HUDOverlay.SetRotation(CameraRotation);
            Canvas.DrawActor(HUDOverlay, false, true, HUDOverlayFOV);
        }
    }
    else
        ActivateOverlay(false);

    if (PC != none)
        // Draw tank, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none && ROVehicle(GetVehicleBase()) != none)
            ROHud(PC.myHUD).DrawVehicleIcon(Canvas, ROVehicle(GetVehicleBase()), self);
}

function Fire(optional float F)
{
    if(IsInState('ViewTransition'))
    {
        return;
    }

    super.Fire(F);
}

function ServerChangeDriverPosition(byte F)
{
    if (IsInState('ViewTransition'))
    {
        return;
    }

    super.ServerChangeDriverPosition(F);
}

function bool ResupplyAmmo()
{
    local DH_ROMountedTankMG P;

    P = DH_ROMountedTankMG(Gun);

    if (P != none && P.ResupplyAmmo())
    {
        return true;
    }

    return false;
}

// Matt: used by HUD to show coaxial MG reload progress, like the cannon reload
function float GetAmmoReloadState() // TEMP partial demo, pending consolidation & rework of all MG classes - this only works in single player as variables aren't replicated to client
{
    local DH_ROMountedTankMG MG;
    local float ProportionOfReloadRemaining;

    MG = DH_ROMountedTankMG(Gun);

    if (MG != none)
    {
        if (MG.ReadyToFire(false))
        {
            return 0.0;
        }
        else if (Role == ROLE_Authority && MG.bReloading && MG.TimerRate > 0.0)
        {
            ProportionOfReloadRemaining = 1.0 - (MG.TimerCounter / MG.TimerRate);

            if (ProportionOfReloadRemaining >= 0.75)
            {
                return 1.0;
            }
            else if (ProportionOfReloadRemaining >= 0.5)
            {
                return 0.65;
            }
            else if (ProportionOfReloadRemaining >= 0.25)
            {
                return 0.45;
            }
            else
            {
                return 0.25;
            }
        }
        else
        {
            return 1.0; // HUD will draw ammo icon all in red to show can't fire MG - either totally out of ammo or a net client that doesn't have the variables to calculate progress
        }
    }
}

// Matt: added as when player is in a vehicle, the HUD keybinds to GrowHUD & ShrinkHUD will now call these same named functions in the vehicle classes
// When player is in a vehicle, these functions do nothing to the HUD, but they can be used to add useful vehicle functionality in subclasses, especially as keys are -/+ by default
simulated function GrowHUD();
simulated function ShrinkHUD();

// Matt: allows debugging exit positions to be toggled for all MG pawns
exec function ToggleDebugExits()
{
    if (class'DH_LevelInfo'.static.DHDebugMode())
    {
        ServerToggleDebugExits();
    }
}

function ServerToggleDebugExits()
{
    if (class'DH_LevelInfo'.static.DHDebugMode())
    {
        class'DH_ROMountedTankMGPawn'.default.bDebugExitPositions = !class'DH_ROMountedTankMGPawn'.default.bDebugExitPositions;
        Log("DH_ROMountedTankMGPawn.bDebugExitPositions =" @ class'DH_ROMountedTankMGPawn'.default.bDebugExitPositions);
    }
}

defaultproperties
{
    OverlayCenterSize=1.000000
    VehicleMGReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.MG42_ammo_reload'
}

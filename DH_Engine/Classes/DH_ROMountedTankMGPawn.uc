//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ROMountedTankMGPawn extends ROMountedTankMGPawn
    abstract;

#exec OBJ LOAD FILE=..\Textures\DH_VehicleOptics_tex.utx

struct ExitPositionPair
{
    var int Index;
    var float DistanceSquared;
};

var bool bDebugExitPositions;

var()   float   OverlayCenterScale;
var()   float   OverlayCenterSize; // size of the gunsight overlay, 1.0 means full screen width, 0.5 means half screen width
var()   float   OverlayCorrectionX;
var()   float   OverlayCorrectionY;

var     texture VehicleMGReloadTexture; // used to show reload progress on the HUD, like a tank cannon reload

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerToggleDebugExits;
}


static final operator(24) bool > (ExitPositionPair A, ExitPositionPair B)
{
    return A.DistanceSquared > B.DistanceSquared;
}

// http://wiki.beyondunreal.com/Legacy:Insertion_Sort
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

            if (RemovedIndex != InsertIndex)
            {
                MyArray.Insert(InsertIndex, 1);
                MyArray[InsertIndex] = MyArray[RemovedIndex + 1];
                MyArray.Remove(RemovedIndex + 1, 1);
            }
        }
    }
}

// Matt: modified so that if MG is reloading when player enters, we pass the reload start time (indirectly), so client can calculate reload progress to display on HUD
function KDriverEnter(Pawn P)
{
    local DH_ROMountedTankMG MG;
    local float PercentageOfReloadDone;

    MG = DH_ROMountedTankMG(Gun);

    if (MG != none && MG.bReloading)
    {
        PercentageOfReloadDone = Byte(100.0 * (Level.TimeSeconds - MG.ReloadStartTime) / MG.ReloadDuration);
        MG.ClientSetReloadStartTime(PercentageOfReloadDone);
    }

    super.KDriverEnter(P);
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
    local int    i;
    local vector Extent, HitLocation, HitNormal, ZOffset, ExitPosition;
    local array<ExitPositionPair> ExitPositionPairs;

    if (Driver == none)
    {
        return false;
    }

    Extent = Driver.default.CollisionRadius * vect(1.0, 1.0, 0.0);
    Extent.Z = Driver.default.CollisionHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0.0, 0.0, 0.5);

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

    // Debug exits // Matt: uses abstract class default, allowing bDebugExitPositions to be toggled for all MG pawns
    if (class'DH_ROMountedTankMGPawn'.default.bDebugExitPositions)
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
    local Actor            ViewActor;
    local vector           CameraLocation, x, y, z;
    local rotator          CameraRotation;
    local float            SavedOpacity, ScreenRatio, OverlayCenterTexStart, OverlayCenterTexSize;

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

        // Draw reticle
        ScreenRatio = Float(Canvas.SizeY) / Float(Canvas.SizeX);
        OverlayCenterScale = 0.955 / OverlayCenterSize; // 0.955 factor widens visible FOV to full screen width = OverlaySize 1.0
        OverlayCenterTexStart = (1 - OverlayCenterScale) * Float(MGOverlay.USize) / 2;
        OverlayCenterTexSize =  Float(MGOverlay.USize) * OverlayCenterScale;

        Canvas.SetPos(0, 0);
        Canvas.DrawTile(MGOverlay , Canvas.SizeX , Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX, OverlayCenterTexStart - OverlayCorrectionY + (1 - ScreenRatio) * OverlayCenterTexSize / 2 , OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);

        // Reset HudOpacity to original value
        Canvas.ColorModulate.W = SavedOpacity;
    }

    if (!PC.bBehindView && HUDOverlay != none)
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
    {
        ActivateOverlay(false);
    }

    // Draw tank, turret, ammo count, passenger list
    if (ROHud(PC.myHUD) != none && ROVehicle(GetVehicleBase()) != none)
    {
        ROHud(PC.myHUD).DrawVehicleIcon(Canvas, ROVehicle(GetVehicleBase()), self);
    }
}

function Fire(optional float F)
{
    if (IsInState('ViewTransition'))
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
function float GetAmmoReloadState()
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
        else if (MG.bReloading)
        {
            ProportionOfReloadRemaining = 1.0 - ((Level.TimeSeconds - MG.ReloadStartTime) / MG.ReloadDuration);

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

// Matt: modified to switch to external mesh & default FOV for behind view
simulated function POVChanged(PlayerController PC, bool bBehindViewChanged)
{
    local int i;

    if (PC.bBehindView)
    {
        if (bBehindViewChanged)
        {
            if (bPCRelativeFPRotation)
            {
                PC.SetRotation(rotator(vector(PC.Rotation) >> Rotation));
            }

            if (bMultiPosition)
            {
                for (i = 0; i < DriverPositions.Length; i++)
                {
                    DriverPositions[i].PositionMesh = Gun.default.Mesh;
                    DriverPositions[i].ViewFOV = PC.DefaultFOV;
                    DriverPositions[i].ViewPitchUpLimit = 65535;
                    DriverPositions[i].ViewPitchDownLimit = 1;
                }

                if ((Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone || Level.Netmode == NM_ListenServer) 
                    && DriverPositions[DriverPositionIndex].PositionMesh != none && Gun != none)
                {
                    Gun.LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
                }

                PC.SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
            }
            else
            {
                PC.SetFOV(PC.DefaultFOV);
                Gun.PitchUpLimit = 65535;
                Gun.PitchDownLimit = 1;
            }

            Gun.bLimitYaw = false;
        }

        bOwnerNoSee = false;

        if (Driver != none)
        {
            Driver.bOwnerNoSee = !bDrawDriverInTP;
        }

        if (PC == Controller) // no overlays for spectators
        {
            ActivateOverlay(false);
        }
    }
    else
    {
        if (bPCRelativeFPRotation)
        {
            PC.SetRotation(rotator(vector(PC.Rotation) << Rotation));
        }

        if (bBehindViewChanged)
        {
            if (bMultiPosition)
            {
                for (i = 0; i < DriverPositions.Length; i++)
                {
                    DriverPositions[i].PositionMesh = default.DriverPositions[i].PositionMesh;
                    DriverPositions[i].ViewFOV = default.DriverPositions[i].ViewFOV;
                    DriverPositions[i].ViewPitchUpLimit = default.DriverPositions[i].ViewPitchUpLimit;
                    DriverPositions[i].ViewPitchDownLimit = default.DriverPositions[i].ViewPitchDownLimit;            
                }

                if ((Role == ROLE_AutonomousProxy || Level.Netmode == NM_Standalone || Level.Netmode == NM_ListenServer) 
                    && DriverPositions[DriverPositionIndex].PositionMesh != none && Gun != none)
                {
                    Gun.LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
                }

                PC.SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
                FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
            }
            else
            {
                PC.SetFOV(WeaponFOV);
                Gun.PitchUpLimit = Gun.default.PitchUpLimit;
                Gun.PitchDownLimit = Gun.default.PitchDownLimit;
            }

            Gun.bLimitYaw = Gun.default.bLimitYaw;
        }

        bOwnerNoSee = !bDrawMeshInFP;

        if (Driver != none)
        {
            Driver.bOwnerNoSee = Driver.default.bOwnerNoSee;
        }

        if (bDriving && PC == Controller) // no overlays for spectators
        {
            ActivateOverlay(true);
        }
    }
}

// Matt: toggles between external & internal meshes (mostly useful with behind view if want to see internal mesh)
exec function ToggleMesh()
{
    local int i;

    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && bMultiPosition)
    {
        if (Gun.Mesh == default.DriverPositions[DriverPositionIndex].PositionMesh)
        {
            for (i = 0; i < DriverPositions.Length; i++)
            {
                DriverPositions[i].PositionMesh = Gun.default.Mesh;
            }
        }
        else
        {
            for (i = 0; i < DriverPositions.Length; i++)
            {
                DriverPositions[i].PositionMesh = default.DriverPositions[i].PositionMesh;
            }
        }

        Gun.LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
    }
}

// Matt: DH version but keeping it just to view limits & nothing to do with behind view (which is handled by exec functions BehindView & ToggleBehindView)
exec function ToggleViewLimit()
{
    local int i;

    if (class'DH_LevelInfo'.static.DHDebugMode() && Gun != none) // removed requirement to be in single player mode, as valid in multi-player if in DHDebugMode
    {
        if (Gun.bLimitYaw == Gun.default.bLimitYaw && Gun.PitchUpLimit == Gun.default.PitchUpLimit && Gun.PitchDownLimit == Gun.default.PitchDownLimit)
        {
            Gun.bLimitYaw = false;
            Gun.PitchUpLimit = 65535;
            Gun.PitchDownLimit = 1;

            for (i = 0; i < DriverPositions.Length; i++)
            {
                DriverPositions[i].ViewPitchUpLimit = 65535;
                DriverPositions[i].ViewPitchDownLimit = 1;            
            }
        }
        else 
        {
            Gun.bLimitYaw = Gun.default.bLimitYaw;
            Gun.PitchUpLimit = Gun.default.PitchUpLimit;
            Gun.PitchDownLimit = Gun.default.PitchDownLimit;

            for (i = 0; i < DriverPositions.Length; i++)
            {
                DriverPositions[i].ViewPitchUpLimit = default.DriverPositions[i].ViewPitchUpLimit;
                DriverPositions[i].ViewPitchDownLimit = default.DriverPositions[i].ViewPitchDownLimit;            
            }
        }
    }
}
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
    OverlayCenterSize=1.0
    VehicleMGReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.MG42_ammo_reload'
}

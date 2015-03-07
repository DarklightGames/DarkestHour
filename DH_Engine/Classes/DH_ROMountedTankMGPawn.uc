//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ROMountedTankMGPawn extends ROMountedTankMGPawn
    abstract;

#exec OBJ LOAD FILE=..\Textures\DH_VehicleOptics_tex.utx

var     int     UnbuttonedPositionIndex; // lowest position number where player is unbuttoned
var     texture VehicleMGReloadTexture;  // used to show reload progress on the HUD, like a tank cannon reload

var()   float   OverlayCenterScale;
var()   float   OverlayCenterSize;       // size of the gunsight overlay, 1.0 means full screen width, 0.5 means half screen width
var()   float   OverlayCorrectionX;
var()   float   OverlayCorrectionY;

var     bool    bDebugExitPositions;

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerToggleDebugExits;
}

// Matt: modified to call InitializeMG when we've received both the replicated Gun & VehicleBase actors (just after vehicle spawns via replication), which has 2 benefits:
// 1. Do things that need one or both of those actor refs, controlling common problem of unpredictability of timing of receiving replicated actor references
// 2. To do any extra set up in the MG classes, which can easily be subclassed for anything that is vehicle specific
simulated function PostNetReceive()
{
    local int i;

    // Gunner has changed position
    if (DriverPositionIndex != SavedPositionIndex && Gun != none && bMultiPosition)
    {
        if (Driver == none && DriverPositionIndex > 0 && !IsLocallyControlled() && Level.NetMode == NM_Client)
        {
            // do nothing
        }
        else
        {
            LastPositionIndex = SavedPositionIndex;
            SavedPositionIndex = DriverPositionIndex;
            NextViewPoint();
        }
    }

    // Initialize the MG // Matt: added VehicleBase != none, so we guarantee that VB is available to InitializeMG
    if (!bInitializedVehicleGun && Gun != none && VehicleBase != none)
    {
        bInitializedVehicleGun = true;
        InitializeMG();
    }

    // Initialize the vehicle base
    if (!bInitializedVehicleBase && VehicleBase != none)
    {
        bInitializedVehicleBase = true;

        // On client, this actor is destroyed if becomes net irrelevant - when it respawns, empty WeaponPawns array needs filling again or will cause lots of errors
        if (VehicleBase.WeaponPawns.Length > 0 && VehicleBase.WeaponPawns.Length > PositionInArray &&
            (VehicleBase.WeaponPawns[PositionInArray] == none || VehicleBase.WeaponPawns[PositionInArray].default.Class == none))
        {
            VehicleBase.WeaponPawns[PositionInArray] = self;

            return;
        }

        for (i = 0; i < VehicleBase.WeaponPawns.Length; ++i)
        {
            if (VehicleBase.WeaponPawns[i] != none && (VehicleBase.WeaponPawns[i] == self || VehicleBase.WeaponPawns[i].Class == class))
            {
                return;
            }
        }

        VehicleBase.WeaponPawns[PositionInArray] = self;
    }

    // Matt: if this is a single position MG & we've initialized the vehicle weapon & vehicle base, we can now switch off PostNetReceive
    if (!bMultiPosition && bInitializedVehicleGun && bInitializedVehicleBase)
    {
        bNetNotify = false;
    }
}

// Matt: modified to call InitializeMG to do any extra set up in the MG classes
// This is where we do it for standalones or servers (note we can't do it in PostNetBeginPlay because VehicleBase isn't set until this function is called)
function AttachToVehicle(ROVehicle VehiclePawn, name WeaponBone)
{
    super.AttachToVehicle(VehiclePawn, WeaponBone);

    if (Role == ROLE_Authority)
    {
        InitializeMG();
    }
}

// Matt: new function to do any extra set up in the MG classes (called from PostNetReceive on net client or from AttachToVehicle on standalone or server)
// Crucially, we know that we have VehicleBase & Gun when this function gets called, so we can reliably do stuff that needs those actors
simulated function InitializeMG()
{
    if (DH_ROMountedTankMG(Gun) != none)
    {
        DH_ROMountedTankMG(Gun).InitializeMG(self);
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

// Modified to prevent players exiting unless unbuttoned & also so that exit stuff only happens if the Super returns true
function bool KDriverLeave(bool bForceLeave)
{
    if (!bForceLeave && !CanExit()) // bForceLeave means so player is trying to exit not just switch position, so no risk of locking someone in one slot
    {
        return false;
    }

    if (super(VehicleWeaponPawn).KDriverLeave(bForceLeave))
    {
        DriverPositionIndex = 0;
        LastPositionIndex = 0;

        VehicleBase.MaybeDestroyVehicle();

        return true;
    }

    return false;
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

// Modified to remove playing BeginningIdleAnim as that now gets done for all net modes in DrivingStatusChanged()
simulated state LeavingVehicle
{
    simulated function HandleExit()
    {
        Gun.LinkMesh(Gun.default.Mesh);
    }
}

// Modified to call DriverLeft() because player death doesn't trigger KDriverLeave/DriverLeft/DrivingStatusChanged
function DriverDied()
{
    super.DriverDied();

    DriverLeft(); // fix Unreal bug (as done in ROVehicle), as DriverDied should call DriverLeft, the same as KDriverLeave does
}

// Modified to play idle anim on all net modes, to reset visuals like hatches & any moving collision boxes (was only playing on owning net client, not server or other clients)
simulated event DrivingStatusChanged()
{
    super.DrivingStatusChanged();

    if (!bDriving && Gun != none && Gun.HasAnim(Gun.BeginningIdleAnim))
    {
        Gun.PlayAnim(Gun.BeginningIdleAnim);
    }
}

function bool PlaceExitingDriver()
{
    local int    i, StartIndex;
    local vector Extent, HitLocation, HitNormal, ZOffset, ExitPosition;

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

    // Debug exits // Matt: uses abstract class default, allowing bDebugExitPositions to be toggled for all MG pawns
    if (class'DH_ROMountedTankMGPawn'.default.bDebugExitPositions)
    {
        for (i = 0; i < VehicleBase.ExitPositions.Length; ++i)
        {
            ExitPosition = VehicleBase.Location + (VehicleBase.ExitPositions[i] >> VehicleBase.Rotation) + ZOffset;

            Spawn(class'DH_DebugTracer',,, ExitPosition);
        }
    }

    i = Clamp(PositionInArray + 1, 0, VehicleBase.ExitPositions.Length - 1);
    StartIndex = i;

    while (i >= 0 && i < VehicleBase.ExitPositions.Length)
    {
        ExitPosition = VehicleBase.Location + (VehicleBase.ExitPositions[i] >> VehicleBase.Rotation) + ZOffset;

        if (Trace(HitLocation, HitNormal, ExitPosition, VehicleBase.Location + ZOffset, false, Extent) == none &&
            Trace(HitLocation, HitNormal, ExitPosition, ExitPosition + ZOffset, false, Extent) == none &&
            Driver.SetLocation(ExitPosition))
        {
            return true;
        }

        ++i;

        if (i == StartIndex)
        {
            break;
        }
        else if (i == VehicleBase.ExitPositions.Length)
        {
            i = 0;
        }
    }

    return false;
}

// Modified to update custom aim for MGs that use it, but only if the player is actually controlling the MG, i.e. CanFire()
function UpdateRocketAcceleration(float DeltaTime, float YawChange, float PitchChange)
{
    super.UpdateRocketAcceleration(DeltaTime, YawChange, PitchChange);

    if (bCustomAiming && CanFire())
    {
        UpdateSpecialCustomAim(DeltaTime, YawChange, PitchChange);

        if (PlayerController(Controller) != none)
        {
            PlayerController(Controller).WeaponBufferRotation.Yaw = CustomAim.Yaw;
            PlayerController(Controller).WeaponBufferRotation.Pitch = CustomAim.Pitch;
        }
    }
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
        OverlayCenterTexStart = (1.0 - OverlayCenterScale) * Float(MGOverlay.USize) / 2.0;
        OverlayCenterTexSize =  Float(MGOverlay.USize) * OverlayCenterScale;

        Canvas.SetPos(0.0, 0.0);
        Canvas.DrawTile(MGOverlay , Canvas.SizeX , Canvas.SizeY, OverlayCenterTexStart - OverlayCorrectionX,
            OverlayCenterTexStart - OverlayCorrectionY + (1.0 - ScreenRatio) * OverlayCenterTexSize / 2.0, OverlayCenterTexSize, OverlayCenterTexSize * ScreenRatio);

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
    if (ROHud(PC.myHUD) != none && VehicleBase != none)
    {
        ROHud(PC.myHUD).DrawVehicleIcon(Canvas, VehicleBase, self);
    }
}

// New function, checked by Fire() to see if we are in an eligible firing position (subclass as required)
function bool CanFire()
{
    return true;
}

// Modified to check if CanFire()
function Fire(optional float F)
{
    if (!CanFire())
    {
        return;
    }

    super.Fire(F);
}

// Matt: emptied out as MG has no alt fire mode, so just ensures nothing happens
function AltFire(optional float F)
{
}

// Matt: modified to avoid wasting network resources by calling ServerChangeViewPoint on the server when it isn't valid
simulated function NextWeapon()
{
    if (DriverPositionIndex < DriverPositions.Length - 1 && DriverPositionIndex == PendingPositionIndex && !IsInState('ViewTransition') && bMultiPosition)
    {
        PendingPositionIndex = DriverPositionIndex + 1;
        ServerChangeViewPoint(true);
    }
}

simulated function PrevWeapon()
{
    if (DriverPositionIndex > 0 && DriverPositionIndex == PendingPositionIndex && !IsInState('ViewTransition') && bMultiPosition)
    {
        PendingPositionIndex = DriverPositionIndex -1;
        ServerChangeViewPoint(false);
    }
}

// Modified to add clientside checks before sending the function call to the server
simulated function SwitchWeapon(byte F)
{
    local ROVehicleWeaponPawn WeaponPawn;
    local bool                bMustBeTankerToSwitch;
    local byte                ChosenWeaponPawnIndex;

    if (VehicleBase == none)
    {
        return;
    }

    // Trying to switch to driver position
    if (F == 1)
    {
        // Stop call to server as there is already a human driver
        if (VehicleBase.Driver != none && VehicleBase.Driver.IsHumanControlled())
        {
            return;
        }

        if (VehicleBase.bMustBeTankCommander)
        {
            bMustBeTankerToSwitch = true;
        }
    }
    // Trying to switch to non-driver position
    else
    {
        ChosenWeaponPawnIndex = F - 2;

        // Stop call to server if player has selected an invalid weapon position or the current position
        // Note that if player presses 0, which is invalid choice, the byte index will end up as 254 & so will still fail this test (which is what we want)
        if (ChosenWeaponPawnIndex >= VehicleBase.PassengerWeapons.Length || ChosenWeaponPawnIndex == PositionInArray)
        {
            return;
        }

        // Stop call to server if player selected a rider position but is buttoned up (no 'teleporting' outside to external rider position)
        if (StopExitToRiderPosition(ChosenWeaponPawnIndex))
        {
            return;
        }

        // Get weapon pawn
        if (ChosenWeaponPawnIndex < VehicleBase.WeaponPawns.Length)
        {
            WeaponPawn = ROVehicleWeaponPawn(VehicleBase.WeaponPawns[ChosenWeaponPawnIndex]);
        }

        if (WeaponPawn != none)
        {
            // Stop call to server as weapon position already has a human player
            if (WeaponPawn.Driver != none && WeaponPawn.Driver.IsHumanControlled())
            {
                return;
            }

            if (WeaponPawn.bMustBeTankCrew)
            {
                bMustBeTankerToSwitch = true;
            }
        }
        // Stop call to server if weapon pawn doesn't exist, UNLESS PassengerWeapons array lists it as a rider position
        // This is because our new system means rider pawns won't exist on clients unless occupied, so we have to allow this switch through to server
        else if (class<ROPassengerPawn>(VehicleBase.PassengerWeapons[ChosenWeaponPawnIndex].WeaponPawnClass) == none)
        {
            return;
        }
    }

    // Stop call to server if player has selected a tank crew role but isn't a tanker
    if (bMustBeTankerToSwitch && (Controller == none || ROPlayerReplicationInfo(Controller.PlayerReplicationInfo) == none ||
        ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo == none || !ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew))
    {
        ReceiveLocalizedMessage(class'DH_VehicleMessage', 0); // not qualified to operate vehicle

        return;
    }

    ServerChangeDriverPosition(F);
}

// Modified to prevent 'teleporting' outside to external rider position while buttoned up inside vehicle
function ServerChangeDriverPosition(byte F)
{
    if (StopExitToRiderPosition(F - 2))
    {
        return;
    }

    super.ServerChangeDriverPosition(F);
}

// New function to check if player can exit, displaying an "unbutton hatch" message if he can't (just saves repeating code in different functions)
simulated function bool CanExit()
{
    if (DriverPositionIndex < UnbuttonedPositionIndex || (IsInState('ViewTransition') && DriverPositionIndex == UnbuttonedPositionIndex))
    {
        if (DriverPositions.Length > UnbuttonedPositionIndex) // means it is possible to unbutton
        {
            ReceiveLocalizedMessage(class'DH_VehicleMessage', 4); // must unbutton the hatch
        }
        else
        {
            if (DH_ROTreadCraft(VehicleBase) != none && DH_ROTreadCraft(VehicleBase).DriverPositions.Length > DH_ROTreadCraft(VehicleBase).UnbuttonedPositionIndex) // means driver has hatch
            {
                ReceiveLocalizedMessage(class'DH_VehicleMessage', 10); // must exit through driver's or commander's hatch
            }
            else
            {
                ReceiveLocalizedMessage(class'DH_VehicleMessage', 5); // must exit through commander's hatch
            }
        }

        return false;
    }

    return true;
}

// New function to check if player is trying to 'teleport' outside to external rider position while buttoned up (just saves repeating code in different functions)
simulated function bool StopExitToRiderPosition(byte ChosenWeaponPawnIndex)
{
    local DH_ROTreadCraft TreadCraft;

    TreadCraft = DH_ROTreadCraft(VehicleBase);

    return TreadCraft != none && TreadCraft.bMustUnbuttonToSwitchToRider && TreadCraft.bAllowRiders &&
        ChosenWeaponPawnIndex >= TreadCraft.FirstRiderPositionIndex && ChosenWeaponPawnIndex < TreadCraft.PassengerWeapons.Length && !CanExit();
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
                for (i = 0; i < DriverPositions.Length; ++i)
                {
                    DriverPositions[i].PositionMesh = Gun.default.Mesh;
                    DriverPositions[i].ViewFOV = PC.DefaultFOV;
                    DriverPositions[i].ViewPitchUpLimit = 65535;
                    DriverPositions[i].ViewPitchDownLimit = 1;
                }

                if ((Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
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
                for (i = 0; i < DriverPositions.Length; ++i)
                {
                    DriverPositions[i].PositionMesh = default.DriverPositions[i].PositionMesh;
                    DriverPositions[i].ViewFOV = default.DriverPositions[i].ViewFOV;
                    DriverPositions[i].ViewPitchUpLimit = default.DriverPositions[i].ViewPitchUpLimit;
                    DriverPositions[i].ViewPitchDownLimit = default.DriverPositions[i].ViewPitchDownLimit;
                }

                if ((Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
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
            for (i = 0; i < DriverPositions.Length; ++i)
            {
                DriverPositions[i].PositionMesh = Gun.default.Mesh;
            }
        }
        else
        {
            for (i = 0; i < DriverPositions.Length; ++i)
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

            for (i = 0; i < DriverPositions.Length; ++i)
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

            for (i = 0; i < DriverPositions.Length; ++i)
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
    UnbuttonedPositionIndex=1
    OverlayCenterSize=1.0
    VehicleMGReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.MG42_ammo_reload'
}

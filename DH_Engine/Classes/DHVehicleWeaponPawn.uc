//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHVehicleWeaponPawn extends ROVehicleWeaponPawn
    abstract;

var     DHVehicleWeapon     VehWep;              // just a convenient reference to the VehicleWeapon actor

// View positions
var     int         InitialPositionIndex;        // initial player position on entering
var     int         UnbuttonedPositionIndex;     // lowest position number where player is unbuttoned
var     float       ViewTransitionDuration;      // calculated to control the time we stay in state ViewTransition

// Binoculars
var     int         BinocPositionIndex;          // index position when player is using binoculars
var     bool        bPlayerHasBinocs;            // on entering, records whether player has binoculars (necessary to move to binocs position)
var     texture     BinocsOverlay;               // 1st person texture overlay to draw when in binocs position
var     DHDecoAttachment    BinocsAttachment;    // decorative actor spawned locally when player is using binoculars

// Gunsight overlay
var     texture     GunsightOverlay;             // texture overlay for gunsight
var     float       OverlayCenterSize;           // size of the gunsight overlay (1.0 means full screen width, 0.5 means half screen width, etc)
var     float       OverlayCenterScale;          // scale for the gunsight overlay (calculated from OverlayCenterSize)
var     float       OverlayCenterTexStart;       // calculated for use in positioning gunsight overlay
var     float       OverlayCenterTexSize;        // calculated for use in positioning gunsight overlay
var     float       OverlayCorrectionX;          // scope center correction in pixels, in case an overlay is off-center by pixel or two
var     float       OverlayCorrectionY;

// Clientside flags to do certain things when certain actors are received, to fix problems caused by replication timing issues
var     bool        bInitializedVehicleAndGun;   // done some set up when had received both the VehicleBase & Gun actors
var     bool        bNeedToInitializeDriver;     // do some player set up when we receive the Driver actor
var     bool        bNeedToEnterVehicle;         // go to state 'EnteringVehicle' when we receive the Gun actor
var     bool        bNeedToStoreVehicleRotation; // set StoredVehicleRotation when we receive the VehicleBase actor

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        bPlayerHasBinocs;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ************ ACTOR INITIALISATION, DESTRUCTION & KEY ENGINE EVENTS ************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified so if InitialPositionIndex is not zero, we match position indexes now so when a player gets in, we don't trigger an up transition by changing DriverPositionIndex
// Also to calculate & set texture gunsight overlay variables once instead of every DrawHUD
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (InitialPositionIndex > 0 && Role == ROLE_Authority)
    {
        DriverPositionIndex = InitialPositionIndex;
        LastPositionIndex = InitialPositionIndex;
    }

    if (Level.NetMode != NM_DedicatedServer && GunsightOverlay != none)
    {
        OverlayCenterScale = 0.955 / OverlayCenterSize; // 0.955 factor widens visible FOV to full screen width = OverlaySize 1.0
        OverlayCenterTexStart = (1.0 - OverlayCenterScale) * float(GunsightOverlay.USize) / 2.0;
        OverlayCenterTexSize = float(GunsightOverlay.USize) * OverlayCenterScale;
    }
}

// Modified for net client to flag if bNeedToInitializeDriver, & to match clientside position indexes to replicated DriverPositionIndex
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (Role < ROLE_Authority)
    {
        if (bDriving)
        {
            bNeedToInitializeDriver = true;
        }

        if (bMultiPosition)
        {
            SavedPositionIndex = DriverPositionIndex;
            LastPositionIndex = DriverPositionIndex;
            PendingPositionIndex = DriverPositionIndex;
        }
    }
}

// Modified to destroy any binoculars attachment
simulated function Destroyed()
{
    super.Destroyed();

    if (BinocsAttachment != none)
    {
        BinocsAttachment.Destroy();
    }
}

// Matt: modified to call set up functionality that requires the Vehicle, VehicleWeapon and/or player pawn actors (just after vehicle spawns via replication)
// This controls common and sometimes critical problems caused by unpredictability of when & in which order a net client receives replicated actor references
// Functionality is moved to series of Initialize-X functions, for clarity & to allow easy subclassing for anything that is vehicle-specific
simulated function PostNetReceive()
{
    // Player has changed view position
    // Checking bInitializedVehicleGun means we do nothing on the 1st call to this function, which happens before PostNetBeginPlay() has matched position indexes
    // Meaning we leave SetPlayerPosition() to handle any initial anims & don't call NextViewPoint() initially, which would only interfere with SetPlayerPosition()
    if (DriverPositionIndex != SavedPositionIndex && bInitializedVehicleGun && bMultiPosition)
    {
        LastPositionIndex = SavedPositionIndex;
        SavedPositionIndex = DriverPositionIndex;

        if (Driver != none) // no point playing transition anim if there's no 'Driver' (if he's just left, the BeginningIdleAnim will play)
        {
            NextViewPoint();
        }
    }

    // Initialize anything we need to do from the VehicleWeapon actor, or in that actor
    if (!bInitializedVehicleGun)
    {
        if (Gun != none)
        {
            bInitializedVehicleGun = true;
            InitializeVehicleWeapon();
        }
    }
    // Fail-safe so if we somehow lose our Gun reference after initializing, we unset our flags & are then ready to re-initialize when we receive Gun again
    else if (Gun == none)
    {
        bInitializedVehicleGun = false;
        bInitializedVehicleAndGun = false;
    }

    // Initialize anything we need to do from the Vehicle actor, or in that actor
    if (!bInitializedVehicleBase)
    {
        if (VehicleBase != none)
        {
            bInitializedVehicleBase = true;
            InitializeVehicleBase();
        }
    }
    // Fail-safe so if we somehow lose our VehicleBase reference after initializing, we unset our flags & are then ready to re-initialize when we receive VehicleBase again
    else if (VehicleBase == none)
    {
        bInitializedVehicleBase = false;
        bInitializedVehicleAndGun = false;
    }

    // Initialize the 'Driver'
    if (bNeedToInitializeDriver && Driver != none && (Gun != none || (GunClass == none && VehicleBase != none)))
    {
        bNeedToInitializeDriver = false;
        SetPlayerPosition();
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *******************************  VIEW/DISPLAY  ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to simply draw the BinocsOverlay, without additional drawing
simulated function DrawBinocsOverlay(Canvas C)
{
    local float ScreenRatio;

    ScreenRatio = float(C.SizeY) / float(C.SizeX);
    C.SetPos(0.0, 0.0);
    C.DrawTile(BinocsOverlay, C.SizeX, C.SizeY, 0.0, (1.0 - ScreenRatio) * float(BinocsOverlay.VSize) / 2.0, BinocsOverlay.USize, float(BinocsOverlay.VSize) * ScreenRatio);
}

// Modified to switch to external mesh & unzoomed FOV for behind view, plus handling of any relative/non-relative turret rotation
simulated function POVChanged(PlayerController PC, bool bBehindViewChanged)
{
    local rotator ViewRelativeRotation;

    if (PC == none)
    {
        return;
    }

    if (PC.bBehindView)
    {
        if (bBehindViewChanged)
        {
            // Switching to behind view, so make rotation non-relative to vehicle
            FixPCRotation(PC); // orig uses wep pawn's rotation, not vehicle's rotation
            SetRotation(PC.Rotation);

            // Switch to external vehicle mesh & unzoomed view
            SwitchMesh(-1, true); // -1 signifies switch to default external mesh
            PC.SetFOV(PC.DefaultFOV);
        }

        bOwnerNoSee = false;

        if (Driver != none)
        {
            Driver.bOwnerNoSee = !bDrawDriverInTP;
        }

        if (PC == Controller)
        {
            ActivateOverlay(false);
        }
    }
    else
    {
        if (bBehindViewChanged)
        {
            if (VehicleBase != none)
            {
                // Switching back from behind view, so make rotation relative to vehicle again
                ViewRelativeRotation = PC.Rotation;

                // If the vehicle has a turret, remove turret yaw from player's rotation, as SpecialCalcFirstPersonView() adds turret yaw
                if (VehWep != none && VehWep.bHasTurret)
                {
                    ViewRelativeRotation.Yaw -= VehWep.CurrentAim.Yaw;
                }

                PC.SetRotation(rotator(vector(ViewRelativeRotation) << VehicleBase.Rotation));
                SetRotation(PC.Rotation);
            }

            // Switch back to position's normal vehicle mesh, view FOV & 1st person camera offset
            if (DriverPositions.Length > 0)
            {
                SwitchMesh(DriverPositionIndex, true);
                PC.SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
                FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
            }
            else
            {
                PC.SetFOV(WeaponFOV);
            }
        }

        bOwnerNoSee = !bDrawMeshInFP;

        if (Driver != none)
        {
            Driver.bOwnerNoSee = Driver.default.bOwnerNoSee;
        }

        if (bDriving && PC == Controller)
        {
            ActivateOverlay(true);
        }
    }
}

// From deprecated ROTankCannonPawn
simulated function bool PointOfView()
{
    return false;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************* FIRING & AMMO  ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Emptied out so we have no alt fire by default - implement in subclass if has alt fire
function AltFire(optional float F)
{
}

// New function to do what ClientVehicleCeaseFire() does, except skipping the replicated VehicleCeaseFire() function call to a server
// A network optimisation, avoiding replication when it's unnecessary
// Used where we need to cease fire on net client, but no point telling server to do same as it will do it's own cease fire, e.g. when running out of ammo or starting a reload
function ClientOnlyVehicleCeaseFire(bool bWasAltFire)
{

    if (bWasAltFire)
    {
        bWeaponIsAltFiring = false;
    }
    else
    {
        bWeaponIsFiring = false;
    }

    if (Gun != none)
    {
        Gun.ClientStopFire(Controller, bWasAltFire);

        if (!bWasAltFire && bWeaponIsAltFiring)
        {
            Gun.ClientStartFire(Controller, true);
        }
    }
}

// New function to check whether player is in a view position where he can fire the weapon - implement in subclasses
function bool CanFire()
{
    return true;
}

// Re-stated here just to make into simulated functions, so modified LeanLeft & LeanRight exec functions in DHPlayer can call this on the client as a pre-check
simulated function IncrementRange()
{
    if (Gun != none)
    {
        Gun.IncrementRange();
    }
}

simulated function DecrementRange()
{
    if (Gun != none)
    {
        Gun.DecrementRange();
    }
}

// Modified to use new ResupplyAmmo() in the VehicleWeapon classes, instead of GiveInitialAmmo()
function bool ResupplyAmmo()
{
    return VehWep != none && VehWep.ResupplyAmmo();
}

// Modified to make generic, for any vehicle weapon (not just cannon) & returning part reloaded values based on ReloadStages array
function float GetAmmoReloadState()
{
    if (VehWep != none)
    {
        if (VehWep.ReloadState == RL_ReadyToFire)
        {
            return 0.0;
        }
        else if (VehWep.ReloadState == RL_Waiting || VehWep.ReloadState == RL_Empty)
        {
            return 1.0;
        }

        return VehWep.ReloadStages[VehWep.ReloadState - 1].HUDProportion;
    }

    return 0.0;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************** VEHICLE ENTRY  ******************************** //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to remove obsolete stuff & duplication from the Supers, & to use the vehicle's VehicleTeam to determine the team
function bool TryToDrive(Pawn P)
{
    // Deny entry if vehicle has driver or is dead, or if player is crouching or on fire or reloading a weapon (plus several very obscure other reasons)
    if (Driver != none || Health <= 0 || P == none || (DHPawn(P) != none && DHPawn(P).bOnFire) || (P.Weapon != none && P.Weapon.IsInState('Reloading')) ||
        P.Controller == none || !P.Controller.bIsPlayer || P.DrivenVehicle != none || P.IsA('Vehicle') || bNonHumanControl || !Level.Game.CanEnterVehicle(self, P))
    {
        return false;
    }

    if (VehicleBase != none)
    {
        // Trying to enter a vehicle that isn't on our team
        if (P.GetTeamNum() != VehicleBase.VehicleTeam) // VehicleTeam reliably gives the team, even if vehicle hasn't yet been entered
        {
            if (VehicleBase.Driver == none)
            {
                return VehicleBase.TryToDrive(P);
            }

            DisplayVehicleMessage(1, P); // can't use enemy vehicle

            return false;
        }

        // Bot tries to enter the VehicleBase if it has no driver
        if (!P.IsHumanControlled() && VehicleBase.Driver == none)
        {
            return VehicleBase.TryToDrive(P);
        }
    }

    // Deny entry if player is not a tanker role & weapon can only be used by tank crew
    if (bMustBeTankCrew && !(ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo) != none && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo != none
        && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew) && P.IsHumanControlled())
    {
        DisplayVehicleMessage(0, P); // not qualified to operate vehicle

        return false;
    }

    // Passed all checks, so allow player to enter the vehicle
    if (bEnterringUnlocks && bTeamLocked)
    {
        bTeamLocked = false;
    }

    KDriverEnter(P);

    return true;
}

// Modified to try to start a reload or resume any previously paused reload if weapon isn't loaded,
// to use InitialPositionIndex instead of assuming start in position zero, & to record whether player has binoculars
function KDriverEnter(Pawn P)
{
    local byte OldReloadState;

    if (bMultiPosition)
    {
        DriverPositionIndex = InitialPositionIndex;
        LastPositionIndex = InitialPositionIndex;
    }

    super.KDriverEnter(P);

    if (VehWep != none && VehWep.bMultiStageReload)
    {
        OldReloadState = VehWep.ReloadState;

        // Try to resume any paused reload, or start a new reload if in waiting state & the player does not use manual reloading
        if (VehWep.ReloadState < RL_ReadyToFire || (VehWep.ReloadState == RL_Waiting && !VehWep.PlayerUsesManualReloading()))
        {
            VehWep.AttemptReload();
        }

        // Replicate the weapon's current reload state, unless AttemptReload() changed the state, in which case it will have already done this
        if (VehWep.ReloadState == OldReloadState)
        {
            VehWep.ClientSetReloadState(VehWep.ReloadState);
        }
    }

    if (BinocPositionIndex >= 0 && BinocPositionIndex < DriverPositions.Length)
    {
        bPlayerHasBinocs = P.FindInventoryType(class<Inventory>(DynamicLoadObject("DH_Equipment.DHBinocularsItem", class'class'))) != none;
    }
}

// Modified to handle InitialPositionIndex instead of assuming start in position zero, & to consolidate & optimise the Supers
// Matt: also to work around various net client problems caused by replication timing issues, including common problems when deploying into a spawn vehicle:
/** SPAWN VEHICLE PROBLEMS:
    The process of deploying into a spawn vehicle involves spawning a player pawn, possessing it, then entering the vehicle
    Entering results in unpossessing the player pawn, possessing vehicle, moving (effectively teleporting) player pawn to vehicle's location & attaching it as the 'Driver' pawn
    Because vehicle can be on other side of the map & not currently net relevant to the client, the vehicle actors may not exist on the client & have to be spawned locally
    There are a complex series of interactions, which don't always happen in the same order, because actors are not always replicated in the same order

 1. First problem is that the PlayerController is often in state 'Spectating' when the critical PC.ClientRestart() function gets called at the end of vehicle possession
    State 'Spectating' ignores PC.ClientRestart(), most critically resulting in the PC's ViewTarget not being set to the vehicle & POVChanged() not being called on the vehicle
    This gives a completely screwed up camera view, until the player switches to another vehicle position or exits
    After experimenting with various workarounds, I believe the fix below is probably the simplest & cleanest, & it appears to work reliably
    We send the client's PlayerController to state 'PlayerWalking' because that's the normal state a player would be in when entering a vehicle (so it's effectively neutral)
    It is essentially a hack, but it seems to be an effective, safe & minimal hack to achieve a specific & vital purpose (so it's a 'good hack'!)

 2. Second problem affects VehicleWeaponPawns with a VehicleWeapon, i.e. MGs & cannons, where client may not yet have received the VehicleWeapon actor through replication
    Without VW actor, state 'EnteringVehicle' will fail to switch to an interior mesh or play BeginningIdleAnim, which can really screw things up, until player transitions or exits
    Fix is if we don't yet have VW actor, we avoid going into state 'EnteringVehicle' now & instead flag that we need to as soon as PostNetReceive() detects we receive VW actor

 3. Third, lesser problem is that client may not yet have received the VehicleBase actor through replication, in which case we can't set StoredVehicleRotation
    Without StoredVehicleRotation, the player gets an unwanted camera swivelling effect on entering the vehicle
    Fix is if we don't yet have VehicleBase actor, we flag that we need to set StoredVehicleRotatio as soon as PostNetReceive() detects we receive VehicleBase actor */
simulated function ClientKDriverEnter(PlayerController PC)
{
    // Fix possible replication timing problems on a net client
    if (Role < ROLE_Authority && PC != none)
    {
        // Server passed the PC with this function, so we can safely set new Controller here, even though may take a little longer for new Controller value to replicate
        // And we know new Owner will also be the PC & new net Role will AutonomousProxy, so we can set those too, avoiding problems caused by variable replication delay
        // e.g. DrawHUD() can be called before Controller is replicated; SwitchMesh() may fail because new Role isn't received until later
        Controller = PC;
        SetOwner(PC);
        Role = ROLE_AutonomousProxy;

        // Fix for 1st problem described above, where net client may be in state 'Spectating' when deploying into spawn vehicle
        if (PC.IsInState('Spectating'))
        {
            PC.GotoState('PlayerWalking');
        }
    }

    if (bMultiPosition)
    {
        SavedPositionIndex = InitialPositionIndex;
        PendingPositionIndex = InitialPositionIndex;

        if (Gun != none)
        {
            Gotostate('EnteringVehicle');
        }
        else
        {
            bNeedToEnterVehicle = true; // fix for 2nd problem described above, where net client may not yet have VehicleWeapon actor when deploying into spawn vehicle
        }
    }
    else if (PC != none)
    {
        PC.SetFOV(WeaponFOV); // not needed if bMultiPosition, as gets set in EnteringVehicle
    }

    // Matt: StoredVehicleRotation appears redundant as not used anywhere in UScript, but must be used by native code as if removed we get unwanted camera swivelling effect on entering
    // It's also in HandleTransition(), but I can't see it's having an effect there
    if (VehicleBase != none)
    {
        StoredVehicleRotation = VehicleBase.Rotation;
    }
    else
    {
        bNeedToStoreVehicleRotation = true; // fix for problem where net client may not yet have VehicleBase actor when deploying into spawn vehicle
    }

    super(Vehicle).ClientKDriverEnter(PC);
}

// Modified so weapon retains its aimed direction when player enters & may switch to internal mesh, & to handle InitialPositionIndex instead of assuming start in position zero
simulated state EnteringVehicle
{
    simulated function HandleEnter()
    {
        SwitchMesh(InitialPositionIndex);

        if (Gun != none && Gun.HasAnim(Gun.BeginningIdleAnim))
        {
            Gun.PlayAnim(Gun.BeginningIdleAnim); // shouldn't actually be necessary, but a reasonable fail-safe
        }

        FPCamPos = DriverPositions[InitialPositionIndex].ViewLocation;
        WeaponFOV = DriverPositions[InitialPositionIndex].ViewFOV;

        if (IsHumanControlled())
        {
            PlayerController(Controller).SetFOV(WeaponFOV);
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ****************************** PLAYER VIEW POINTS  ***************************** //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to avoid wasting network resources by calling ServerChangeViewPoint on the server when it isn't valid
// Also to prevent player from moving to binoculars position if he doesn't have any binocs
simulated function NextWeapon()
{
    if (DriverPositionIndex < DriverPositions.Length - 1 && DriverPositionIndex == PendingPositionIndex && !IsInState('ViewTransition') && bMultiPosition)
    {
        if ((DriverPositionIndex + 1) == BinocPositionIndex && !bPlayerHasBinocs) // can't go to binocs if don't have them
        {
            return;
        }

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

// Modified to send dedicated server to state ViewTransition if player is moving to or from an exposed position
// New player hit detection system (basically using normal hit detection as for an infantry player pawn) relies on server playing same animations as net clients
// But if player is only moving from one unexposed position to another, the server doesn't need to do this, as player can't be shot & server has no other need to play anims
// Server also needs to be in state ViewTransition when player is unbuttoning to prevent player exiting until fully unbuttoned
// Also to prevent player from moving to binoculars position if he doesn't have any binocs
function ServerChangeViewPoint(bool bForward)
{
    if (bForward)
    {
        if (DriverPositionIndex < (DriverPositions.Length - 1))
        {
            if ((DriverPositionIndex + 1) == BinocPositionIndex && !bPlayerHasBinocs) // can't go to binocs if don't have them
            {
                return;
            }

            LastPositionIndex = DriverPositionIndex;
            DriverPositionIndex++;

            if ((Level.NetMode == NM_DedicatedServer && (DriverPositions[DriverPositionIndex].bExposed || DriverPositions[LastPositionIndex].bExposed))
                || Level.Netmode == NM_Standalone || Level.NetMode == NM_ListenServer)
            {
                GotoState('ViewTransition'); // originally called NextViewPoint(), but for any authority role that just goes to state ViewTransition anyway
            }
        }
    }
    else
    {
        if (DriverPositionIndex > 0)
        {
            LastPositionIndex = DriverPositionIndex;
            DriverPositionIndex--;

            if ((Level.NetMode == NM_DedicatedServer && (DriverPositions[DriverPositionIndex].bExposed || DriverPositions[LastPositionIndex].bExposed))
                || Level.Netmode == NM_Standalone || Level.NetMode == NM_ListenServer)
            {
                GotoState('ViewTransition');
            }
        }
    }
}

// Modified to enable or disable player's hit detection when moving to or from an exposed position, to use Sleep to control exit from state,
// to improve timing of FOV & camera position changes, to avoid switching mesh, FOV & camera position if in behind view,
// to match rotation to gun's aim when coming up off the gunsight, to add better handling of locked camera,
// to spawn or destroy a binoculars attachment, & to add a workaround for an RO bug where player may player wrong animation when moving off binocs
simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        if (VehicleBase != none)
        {
            StoredVehicleRotation = VehicleBase.Rotation;
        }

        if (Level.NetMode != NM_DedicatedServer && IsHumanControlled() && !PlayerController(Controller).bBehindView)
        {
            // Switch to mesh for new position as may be different
            SwitchMesh(DriverPositionIndex);

            // Set any zoom & camera offset for new position - but only if moving to less zoomed position, otherwise we wait until end of transition to do it
            WeaponFOV = DriverPositions[DriverPositionIndex].ViewFOV;

            if (WeaponFOV > DriverPositions[LastPositionIndex].ViewFOV)
            {
                PlayerController(Controller).SetFOV(WeaponFOV);
                FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
            }
        }

        if (Driver != none)
        {
            // If moving to an exposed position, enable the player's hit detection
            if (DriverPositions[DriverPositionIndex].bExposed && !DriverPositions[LastPositionIndex].bExposed && ROPawn(Driver) != none)
            {
                ROPawn(Driver).ToggleAuxCollision(true);
            }

            // Play any transition animation for the player
            if (Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim) && Driver.HasAnim(DriverPositions[LastPositionIndex].DriverTransitionAnim))
            {
                Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);

                // If moved to binocs, spawn binocs attachment & any other setup stuff
                if (DriverPositionIndex == BinocPositionIndex)
                {
                    HandleBinoculars(true);
                }
            }
        }

        // Play any transition animation for the weapon itself & set a duration to control when we exit this state
        ViewTransitionDuration = 0.0; // start with zero in case we don't have a transition animation

        if (Gun != none)
        {
            if (LastPositionIndex < DriverPositionIndex)
            {
                if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionUpAnim))
                {
                    Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionUpAnim);
                    ViewTransitionDuration = Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionUpAnim);
                }
            }
            else if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionDownAnim))
            {
                Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionDownAnim);
                ViewTransitionDuration = Gun.GetAnimDuration(DriverPositions[LastPositionIndex].TransitionDownAnim);
            }
        }
    }

    // Emptied out so that Sleep is the sole timing for exiting this state
    simulated function AnimEnd(int channel)
    {
    }

    // Reverted to global Timer as Sleep is now the sole means of exiting this state
    simulated function Timer()
    {
        global.Timer();
    }

    simulated function EndState()
    {
        if (Level.NetMode != NM_DedicatedServer)
        {
            // Set any zoom & camera offset for new position, if we've moved to a more (or equal) zoomed position (if not, we already did this at start of transition)
            if (WeaponFOV <= DriverPositions[LastPositionIndex].ViewFOV && IsHumanControlled() && !PlayerController(Controller).bBehindView)
            {
                PlayerController(Controller).SetFOV(WeaponFOV);
                FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
            }

            // If moving off binoculars, destroy binocs attachment & any other setup stuff
            if (LastPositionIndex == BinocPositionIndex)
            {
                HandleBinoculars(false);
            }
        }

        // If moving to an unexposed position, disable the player's hit detection
        if (!DriverPositions[DriverPositionIndex].bExposed && DriverPositions[LastPositionIndex].bExposed && ROPawn(Driver) != none)
        {
            ROPawn(Driver).ToggleAuxCollision(false);
        }
    }

Begin:
    HandleTransition();
    Sleep(ViewTransitionDuration);
    GotoState('');
}

// Modified to enable or disable player's hit detection when moving to or from an exposed position
// Also to spawn or destroy a binoculars attachment, & to add a workaround for an RO bug where player may player wrong animation when moving off binocs
simulated function AnimateTransition()
{
    if (Driver != none)
    {
        // Enable/disable the player's hit detection if he is moving to an exposed/unexposed position
        if (ROPawn(Driver) != none)
        {
            if (DriverPositions[DriverPositionIndex].bExposed)
            {
                if (!DriverPositions[LastPositionIndex].bExposed)
                {
                    ROPawn(Driver).ToggleAuxCollision(true);
                }
            }
            else if (DriverPositions[LastPositionIndex].bExposed)
            {
                ROPawn(Driver).ToggleAuxCollision(false);
            }
        }

        // Play any transition animation for the player & handle any moves onto or off binoculars
        if (Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim) && Driver.HasAnim(DriverPositions[LastPositionIndex].DriverTransitionAnim))
        {
            Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);

            if (DriverPositionIndex == BinocPositionIndex)
            {
                HandleBinoculars(true);
            }
            else if (LastPositionIndex == BinocPositionIndex)
            {
                HandleBinoculars(false);
            }
        }
    }

    // Play any transition animation for the weapon itself
    if (Gun != none)
    {
        if (LastPositionIndex < DriverPositionIndex)
        {
            if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionUpAnim))
            {
                Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionUpAnim);
            }
        }
        else if (Gun.HasAnim(DriverPositions[LastPositionIndex].TransitionDownAnim))
        {
            Gun.PlayAnim(DriverPositions[LastPositionIndex].TransitionDownAnim);
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************** VEHICLE EXIT  ********************************* //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to add clientside checks before sending the function call to the server
// Optimises network performance generally & specifically avoids a rider camera bug when unsuccessfully trying to switch to another vehicle position
simulated function SwitchWeapon(byte F)
{
    local bool              bMustBeTankerToSwitch;
    local byte              ChosenWeaponPawnIndex;

    if (Role < ROLE_Authority) // only do these clientside checks on a net client
    {
        if (VehicleBase == none)
        {
            return;
        }

        // Trying to switch to driver position
        if (F == 1)
        {
/*
            // TODO (Matt, June 2016): commented out this section as it doesn't work - it's the VehicleBase that may be IsHumanControlled(), not its Driver
            // But if it were 'corrected' like that it still wouldn't work because Controller is only replicated to owning net client
            // In fact it would cause big problems, because when you exit a Vehicle, you remain referenced as its Controller, as the server doesn't replicate 'none' to you!
            // Also, a hidden Driver, where bDrawDriverInTP is false, won't replicate to other net clients
            // This is a new 'if' check that I intend to use, but no time to test properly before the 7.0.2 release, so leave it until next time - it's trivial:
//          if (VehicleBase.PlayerReplicationInfo != none && !VehicleBase.PlayerReplicationInfo.bBot)

            // Stop call to server as there is already a human driver
            if (VehicleBase.Driver != none && VehicleBase.Driver.IsHumanControlled())
            {
                return;
            }
*/
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
/*
            // Stop call to server if weapon position already has a human player
            // Note we don't try to stop server call if weapon pawn doesn't exist, as it may not on net client, but will get replicated if player enters position on server
            if (ChosenWeaponPawnIndex < VehicleBase.WeaponPawns.Length)
            {
                WeaponPawn = VehicleBase.WeaponPawns[ChosenWeaponPawnIndex];

                // TODO (Matt, June 1016): this line to replace the one below: (see notes above why section commented out)
//              if (WeaponPawn != none && WeaponPawn.PlayerReplicationInfo != none && !WeaponPawn.PlayerReplicationInfo.bBot)
                if (WeaponPawn != none && WeaponPawn.Driver != none && WeaponPawn.Driver.IsHumanControlled())
                {
                    return;
                }
            }
*/
            if (class<ROVehicleWeaponPawn>(VehicleBase.PassengerWeapons[ChosenWeaponPawnIndex].WeaponPawnClass).default.bMustBeTankCrew)
            {
                bMustBeTankerToSwitch = true;
            }
        }

        // Stop call to server if player has selected a tank crew role but isn't a tanker
        if (bMustBeTankerToSwitch && !(Controller != none && ROPlayerReplicationInfo(Controller.PlayerReplicationInfo) != none
            && ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo != none && ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew))
        {
            DisplayVehicleMessage(0); // not qualified to operate vehicle

            return;
        }
    }

    ServerChangeDriverPosition(F);
}

// Modified to prevent 'teleporting' outside to external rider position while buttoned up inside vehicle
function ServerChangeDriverPosition(byte F)
{
    if (!StopExitToRiderPosition(F - 2)) // pressing 1 to switch to driver's position means F-2 becomes 255 (as a byte), which doesn't count as a blocked rider position
    {
        super.ServerChangeDriverPosition(F);
    }
}

// Modified to prevent exit if not unbuttoned & to give player the same momentum as the vehicle when exiting
// Also to remove overlap with DriverDied(), moving common features into DriverLeft(), which gets called by both functions
function bool KDriverLeave(bool bForceLeave)
{
    local vector ExitVelocity;

    if (!bForceLeave)
    {
        if (!CanExit()) // bForceLeave means so player is trying to exit not just switch position, so no risk of locking someone in one slot
        {
            return false;
        }

        ExitVelocity = Velocity;
        ExitVelocity.Z += 60.0; // add a little height kick to allow for hacked in damage system
    }

    if (super(VehicleWeaponPawn).KDriverLeave(bForceLeave))
    {
        if (!bForceLeave)
        {
            Instigator.Velocity = ExitVelocity;
        }

        return true;
    }

    return false;
}

// Matt: modified to fix major bug where player death would mean next player who enters would find weapon rotating wildly to remain facing towards a fixed point
// Also to remove overlap with KDriverLeave(), moving common features into DriverLeft(), which gets called by both functions
function DriverDied()
{
    super(Vehicle).DriverDied(); // need to skip over Super in ROVehicleWeaponPawn (& Super in VehicleWeaponPawn adds nothing)

    // Added to match KDriverLeave() to fix major bug (resetting Gun.bActive is the key)
    if (Gun != none)
    {
        Gun.bActive = false;
        Gun.FlashCount = 0;
        Gun.NetUpdateFrequency = Gun.default.NetUpdateFrequency;
        Gun.NetPriority = Gun.default.NetPriority;
    }

    if (VehicleBase != none && VehicleBase.Health > 0)
    {
        SetRotatingStatus(0); // kill the rotation sound if the driver dies but the vehicle doesn't
    }

    DriverLeft(); // fix Unreal bug (as done in ROVehicle), as DriverDied should call DriverLeft, the same as KDriverLeave does
}

// Modified to add common features from KDriverLeave() & DriverDied(), which both call this function, & to reset to InitialPositionIndex instead of zero
function DriverLeft()
{
    if (bMultiPosition)
    {
        DriverPositionIndex = InitialPositionIndex;
        LastPositionIndex = InitialPositionIndex;
    }

    if (VehicleBase != none)
    {
        VehicleBase.MaybeDestroyVehicle(); // set spiked vehicle timer if it's an empty, disabled vehicle
    }

    DrivingStatusChanged(); // the Super from Vehicle
}

// Modified to remove playing BeginningIdleAnim as that now gets done for all net modes in DrivingStatusChanged()
// Also to use new SwitchMesh() function, including to match mesh rotation in all net modes, not just standalone as in the RO original (not sure why they did that)
simulated state LeavingVehicle
{
    simulated function HandleExit()
    {
        SwitchMesh(-1); // -1 signifies switch to default external mesh
    }
}

// Modified to play idle animation for all modes, so other net players see things like closed hatches & also any collision stuff is re-set (including on server)
// Also to destroy any binoculars attachment when player leaves vehicle
simulated event DrivingStatusChanged()
{
    super.DrivingStatusChanged();

    if (!bDriving)
    {
        if (Gun != none && Gun.HasAnim(Gun.BeginningIdleAnim))
        {
            Gun.PlayAnim(Gun.BeginningIdleAnim);
        }

        if (BinocsAttachment != none)
        {
            BinocsAttachment.Destroy();
        }
    }
}

// New function to check if player can exit, displaying an "unbutton hatch" message if he can't (just saves repeating code in different functions)
simulated function bool CanExit()
{
    if (DriverPositionIndex < UnbuttonedPositionIndex || (IsInState('ViewTransition') && DriverPositionIndex == UnbuttonedPositionIndex))
    {
        if (DriverPositions.Length > UnbuttonedPositionIndex) // means it is possible to unbutton
        {
            DisplayVehicleMessage(4,, true); // must unbutton the hatch
        }

        return false;
    }

    return true;
}

// New function to check if player is trying to 'teleport' outside to external rider position while buttoned up (just saves repeating code in different functions)
simulated function bool StopExitToRiderPosition(byte ChosenWeaponPawnIndex)
{
    local DHArmoredVehicle AV;

    AV = DHArmoredVehicle(VehicleBase);

    return AV != none && ChosenWeaponPawnIndex >= AV.FirstRiderPositionIndex && ChosenWeaponPawnIndex < AV.PassengerWeapons.Length && AV.bMustUnbuttonToSwitchToRider && !CanExit();
}

// Modified to use new, simplified system with exit positions for all vehicle positions included in the vehicle class default properties
// Also to trace from player's actual world location, with a smaller trace extent so player is less likely to snag on objects that wouldn't really block his exit
function bool PlaceExitingDriver()
{
    local vector Extent, ZOffset, ExitPosition, HitLocation, HitNormal;
    local int    StartIndex, i;

    if (Driver == none || VehicleBase == none)
    {
        return false;
    }

    // Set extent & ZOffset, using a smaller extent than original
    Extent.X = Driver.default.DrivingRadius;
    Extent.Y = Driver.default.DrivingRadius ;
    Extent.Z = Driver.default.DrivingHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0.0, 0.0, 0.5);

    // Check whether player can be moved to each exit position & use the 1st valid one we find
    i = Clamp(PositionInArray + 1, 0, VehicleBase.ExitPositions.Length - 1);
    StartIndex = i;

    while (i >= 0 && i < VehicleBase.ExitPositions.Length)
    {
        ExitPosition = VehicleBase.Location + (VehicleBase.ExitPositions[i] >> VehicleBase.Rotation) + ZOffset;

        if (VehicleBase.Trace(HitLocation, HitNormal, ExitPosition, Driver.Location + ZOffset - Driver.default.PrePivot, false, Extent) == none
            && Trace(HitLocation, HitNormal, ExitPosition, ExitPosition + ZOffset, false, Extent) == none
            && Driver.SetLocation(ExitPosition))
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

///////////////////////////////////////////////////////////////////////////////////////
//  *************************  SETUP, UPDATE, CLEAN UP  ***************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to call same function on VehicleWeapon class so it pre-caches its Skins array (the RO class missed calling the Super to do that), & also to add extra material properties
static function StaticPrecache(LevelInfo L)
{
    if (default.GunsightOverlay != none)
    {
        L.AddPrecacheMaterial(default.GunsightOverlay);
    }

    if (default.BinocsOverlay != none)
    {
        L.AddPrecacheMaterial(default.BinocsOverlay);
    }

    if (default.GunClass != none)
    {
        default.GunClass.static.StaticPrecache(L);
    }
}

// Modified to add extra material properties (no need to call the Super, as it's only in Actor & only caches the Skins array, which a weapon pawn doesn't have)
simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(GunsightOverlay);
    Level.AddPrecacheMaterial(BinocsOverlay);
}

// Modified to call Initialize functions to do set up in the related vehicle classes that requires actor references to different vehicle actors
// This is where we do it servers or single player (note we can't do it in PostNetBeginPlay because VehicleBase isn't set until this function is called)
// Also to add Gun != none check so function is more generic & avoids subclassing (e.g. for passenger pawn)
function AttachToVehicle(ROVehicle VehiclePawn, name WeaponBone)
{
    if (Role == ROLE_Authority)
    {
        VehicleBase = VehiclePawn;

        if (Gun != none)
        {
            VehicleBase.AttachToBone(Gun, WeaponBone);
            InitializeVehicleWeapon();
        }

        InitializeVehicleBase();

        if (VehWep != none)
        {
            VehWep.InitializeVehicleBase();
        }
    }
}

// Matt: new function to do set up that requires the 'Gun' reference to the VehicleWeapon actor
// Using it to set a convenient VehWep reference & to send net client to state 'EnteringVehicle' if replication timing issues stopped that happening in ClientKDriverEnter()
simulated function InitializeVehicleWeapon()
{
    VehWep = DHVehicleWeapon(Gun);

    if (VehWep != none)
    {
        VehWep.InitializeWeaponPawn(self);
    }
    else
    {
        Warn("ERROR:" @ Tag @ "somehow spawned without an owned DHVehicleWeapon, so lots of things are not going to work!");
    }

    // We need to go to state 'EnteringVehicle', but were unable to do it from ClientKDriverEnter() because we hadn't then received our Gun reference
    if (bNeedToEnterVehicle)
    {
        bNeedToEnterVehicle = false;
        GotoState('EnteringVehicle');
    }

    // If we also have the Vehicle actor, initialize anything we need to do where we need both actors
    if (VehicleBase != none && !bInitializedVehicleAndGun)
    {
        InitializeVehicleAndWeapon();
    }
}

// Matt: new function to do set up that requires the 'VehicleBase' reference to the Vehicle actor
// Using it to set StoredVehicleRotation on net client if replication timing issues stopped that happening in ClientKDriverEnter()
// And to give the VehicleBase a reference to this actor in its WeaponPawns array, each time we spawn on a net client (previously in PostNetReceive)
simulated function InitializeVehicleBase()
{
    local bool bAddSelfToWeaponPawns;
    local int  i;

    if (Role < ROLE_Authority)
    {
        // We need to set StoredVehicleRotation as were unable to do it from ClientKDriverEnter() because we hadn't then received our VehicleBase reference
        if (bNeedToStoreVehicleRotation)
        {
            StoredVehicleRotation = VehicleBase.Rotation;
        }

        // On client, this actor is destroyed if becomes net irrelevant - when it respawns, empty WeaponPawns array needs filling again or will cause lots of errors
        // First check if our WeaponPawns slot doesn't exist, is empty or has an invalid member
        if (PositionInArray >= VehicleBase.WeaponPawns.Length || VehicleBase.WeaponPawns[PositionInArray] == none || VehicleBase.WeaponPawns[PositionInArray].default.Class == none)
        {
            bAddSelfToWeaponPawns = true;

            // Then make sure that somehow another WeaponPawns slot isn't already occupied by this actor or an actor of the same class
            for (i = 0; i < VehicleBase.WeaponPawns.Length; ++i)
            {
                if (VehicleBase.WeaponPawns[i] != none && (VehicleBase.WeaponPawns[i] == self || VehicleBase.WeaponPawns[i].Class == class))
                {
                    bAddSelfToWeaponPawns = false;
                    break;
                }
            }
        }

        if (bAddSelfToWeaponPawns)
        {
            VehicleBase.WeaponPawns[PositionInArray] = self;
        }
    }

    // If we also have the VehicleWeapon actor, initialize anything we need to do where we need both actors
    if (Gun != none && !bInitializedVehicleAndGun)
    {
        InitializeVehicleAndWeapon();
    }
}

// Matt: new function to do any set up that requires both the 'VehicleBase' & 'Gun' references to the Vehicle & VehicleWeapon actors - implement in subclasses
simulated function InitializeVehicleAndWeapon()
{
    bInitializedVehicleAndGun = true;
}

// New function to set correct initial position of player & weapon on a net client, when this actor is replicated
simulated function SetPlayerPosition()
{
    local name VehicleAnim, PlayerAnim;
    local int  i;

    // Fix driver attachment position - on replication, AttachDriver() only works if client has received Gun actor, which it may not have yet
    // Client then receives Driver attachment and RelativeLocation through replication, but this is unreliable & sometimes gives incorrect positioning
    // As a fix, if player pawn has flagged bNeedToAttachDriver (meaning attach failed), we call AttachDriver() here to make sure client has correct positioning
    if (DHPawn(Driver) != none && DHPawn(Driver).bNeedToAttachDriver)
    {
        DetachDriver(Driver); // just in case Driver is attached at this point, possibly incorrectly
        AttachDriver(Driver);
        DHPawn(Driver).bNeedToAttachDriver = false;
    }

    // Put weapon & player in correct animation pose - if player not in initial position, we need to recreate the up/down anims that will have played to get there
    if (DriverPositionIndex != InitialPositionIndex)
    {
        if (DriverPositionIndex > InitialPositionIndex)
        {
            // Step down through each position until we find the 'most recent' transition up anim & player transition anim (or have reached the initial position)
            for (i = DriverPositionIndex; i > InitialPositionIndex && (VehicleAnim == ''|| PlayerAnim == ''); --i)
            {
                if (VehicleAnim == '' && DriverPositions[i - 1].TransitionUpAnim != '')
                {
                    VehicleAnim = DriverPositions[i - 1].TransitionUpAnim;
                }

                // DriverTransitionAnim only relevant if there is also one in the position below
                if (PlayerAnim == '' && DriverPositions[i].DriverTransitionAnim != '' && DriverPositions[i - 1].DriverTransitionAnim != '')
                {
                    PlayerAnim = DriverPositions[i].DriverTransitionAnim;
                }
            }
        }
        else
        {
            // Step up through each position until we find the 'most recent' transition down anim & player transition anim (or have reached the initial position)
            for (i = DriverPositionIndex; i < InitialPositionIndex && (VehicleAnim == ''|| PlayerAnim == ''); ++i)
            {
                if (VehicleAnim == '' && DriverPositions[i + 1].TransitionDownAnim != '')
                {
                    VehicleAnim = DriverPositions[i + 1].TransitionDownAnim;
                }

                // DriverTransitionAnim only relevant if there is also one in the position above
                if (PlayerAnim == '' && DriverPositions[i].DriverTransitionAnim != '' && DriverPositions[i + 1].DriverTransitionAnim != '')
                {
                    PlayerAnim = DriverPositions[i].DriverTransitionAnim;
                }
            }
        }

        // Play the animations but freeze them at the end of the anim, so they effectively become an idle anim
        // These transitions already happened - we're playing catch up after actor replication, to recreate the position the player & weapon are already in
        if (VehicleAnim != '' && Gun != none && Gun.HasAnim(VehicleAnim))
        {
            Gun.PlayAnim(VehicleAnim);
            Gun.SetAnimFrame(1.0);
        }

        if (PlayerAnim != '' && Driver != none && !bHideRemoteDriver && bDrawDriverinTP && Driver.HasAnim(PlayerAnim))
        {
            // When vehicle replicates to net client, StartDriving() event gets called on player pawn if vehicle has a 'Driver'
            // StartDriving() plays DriveAnim on the driver, which is for the usual initial driver position, but that would override our correct PlayerAnim here
            // So if player pawn hasn't already played DriveAnim, set a flag to stop it playing DriveAnim in StartDriving(), although only this 1st time
            if (DHPawn(Driver) != none && !DHPawn(Driver).bClientPlayedDriveAnim)
            {
                DHPawn(Driver).bClientSkipDriveAnim = true;
            }

            Driver.StopAnimating(true); // stops the player's looping DriveAnim, otherwise it can blend with the new anim
            Driver.PlayAnim(PlayerAnim);
            Driver.SetAnimFrame(1.0);

            if (DriverPositionIndex == BinocPositionIndex)
            {
                HandleBinoculars(true);
            }
        }
    }
}

// Modified so we don't limit view pitch if in behind view
// Also to correct apparent error in ROVehicleWeaponPawn, where PitchDownLimit was being used instead of DriverPositions[x].ViewPitchDownLimit in multi position weapon
function int LocalLimitPitch(int pitch)
{
    pitch = pitch & 65535;

    if (IsHumanControlled() && PlayerController(Controller).bBehindView)
    {
        return pitch;
    }

    if (DriverPositions.Length > 0)
    {
        if (pitch > DriverPositions[DriverPositionIndex].ViewPitchUpLimit && pitch < DriverPositions[DriverPositionIndex].ViewPitchDownLimit)
        {
            if (pitch - DriverPositions[DriverPositionIndex].ViewPitchUpLimit < DriverPositions[DriverPositionIndex].ViewPitchDownLimit - pitch)
            {
                pitch = DriverPositions[DriverPositionIndex].ViewPitchUpLimit;
            }
            else
            {
                pitch = DriverPositions[DriverPositionIndex].ViewPitchDownLimit;
            }
        }
    }
    else
    {
        if (pitch > PitchUpLimit && pitch < PitchDownLimit)
        {
            if (pitch - PitchUpLimit < PitchDownLimit - pitch)
            {
                pitch = PitchUpLimit;
            }
            else
            {
                pitch = PitchDownLimit;
            }
        }
    }

    return pitch;
}

///////////////////////////////////////////////////////////////////////////////////////
//  *******************************  MISCELLANEOUS ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to make simulated, so can be used on a net client
// Especially as simulated function GetTeamNum() relies on this!
simulated function Vehicle GetVehicleBase()
{
    return VehicleBase;
}

// Modified to handle switching between external & internal mesh, including copying weapon's aimed direction to new mesh
simulated function SwitchMesh(int PositionIndex, optional bool bUpdateAnimations)
{
    local mesh    NewMesh;
    local rotator WeaponYaw, WeaponPitch;

    if ((Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer) && Gun != none)
    {
        // If switching to a valid driver position, get its PositionMesh
        if (PositionIndex >= 0 && PositionIndex < DriverPositions.Length)
        {
            NewMesh = DriverPositions[PositionIndex].PositionMesh;
        }
        // Else switch to default external mesh (pass PositionIndex of -1 to signify this, as it's an invalid position)
        else
        {
            NewMesh = Gun.default.Mesh;
        }

        // Only switch mesh if we actually have a different new mesh
        if (NewMesh != Gun.Mesh && NewMesh != none)
        {
            // Switch to the new mesh
            Gun.LinkMesh(NewMesh);

            // Option to play any necessary animations to get the new mesh in the correct position, e.g. with switching to/from behind view
            if (bUpdateAnimations)
            {
                SetPlayerPosition();
            }

            // Now make the new mesh you swap to have the same rotation as the old one
            if (Gun.YawBone == Gun.PitchBone)
            {
                Gun.SetBoneRotation(Gun.YawBone, Gun.CurrentAim * -1.0); // if one bone is used for both yaw & pitch, we just update all rotation for that one bone
            }
            else
            {
                WeaponYaw.Yaw = -Gun.CurrentAim.Yaw;
                WeaponPitch.Pitch = -Gun.CurrentAim.Pitch;
                Gun.SetBoneRotation(Gun.YawBone, WeaponYaw);
                Gun.SetBoneRotation(Gun.PitchBone, WeaponPitch);
            }
        }
    }
}

// Modified so PC's rotation, which was relative to vehicle, gets set to the correct non-relative rotation on exit, for any vehicle, including any turret rotation
// Doing this in a more direct & generic way here avoids previous workarounds in ClientKDriverLeave
simulated function FixPCRotation(PlayerController PC)
{
    local rotator ViewRelativeRotation;

    if (VehicleBase != none && PC != none)
    {
        ViewRelativeRotation = PC.Rotation;

        // If the vehicle has a turret, add turret's yaw to player's relative rotation
        if (VehWep != none && VehWep.bHasTurret)
        {
            ViewRelativeRotation.Yaw += VehWep.CurrentAim.Yaw;
        }

        PC.SetRotation(rotator(vector(ViewRelativeRotation) >> VehicleBase.Rotation));
    }
}

// New function, replacing RO's DenyEntry() function so we use the DH message class (also re-factored slightly to makes passed Pawn optional)
function DisplayVehicleMessage(int MessageNumber, optional Pawn P, optional bool bPassController)
{
    if (P == none)
    {
        P = self;
    }

    if (bPassController) // option to pass pawn's controller as the OptionalObject, so it can be used in building the message
    {
        P.ReceiveLocalizedMessage(class'DHVehicleMessage', MessageNumber,,, Controller);
    }
    else
    {
        P.ReceiveLocalizedMessage(class'DHVehicleMessage', MessageNumber);
    }
}

// New function to spawn or destroy a binoculars attachment (decorative only), & to add workaround for RO bug where player may player wrong animation when moving off binocs
simulated function HandleBinoculars(bool bMovingOntoBinocs)
{
    // Spawn binocs attachment & attach to player
    if (bMovingOntoBinocs)
    {
        if (Level.NetMode != NM_DedicatedServer)
        {
            if (BinocsAttachment == none)
            {
                BinocsAttachment = Spawn(class'DHDecoAttachment');
                BinocsAttachment.SetDrawType(DT_Mesh);
                BinocsAttachment.LinkMesh(SkeletalMesh'Weapons3rd_anm.Binocs_ger');
            }

            Driver.AttachToBone(BinocsAttachment, 'weapon_rhand');
        }
    }
    // Destroy binocs attachment & do workaround for RO bug
    else
    {
        if (BinocsAttachment != none)
        {
            BinocsAttachment.Destroy();
        }

        // Player may do an odd 'arms waving' transition when coming down from the binocs position
        // Caused by the one-way nature of RO's DriverTransitionAnim, resulting in a player unbuttoning anim, as it assumes we are moving UP to the unbuttoned position
        // We jump straight to end of the transition anim, so it effectively become an idle anim for the new position
        Driver.SetAnimFrame(1.0);
    }
}

// Matt: added as when player is in a vehicle, the HUD keybinds to GrowHUD & ShrinkHUD will now call these same named functions in the vehicle classes
// When player is in a vehicle, these functions do nothing to the HUD, but they can be used to add useful vehicle functionality in subclasses, especially as keys are -/+ by default
simulated function GrowHUD();
simulated function ShrinkHUD();

///////////////////////////////////////////////////////////////////////////////////////
//  *************************** DEBUG EXEC FUNCTIONS  *****************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New exec function to toggle between external & internal meshes (mostly useful with behind view if want to see internal mesh)
exec function ToggleMesh()
{
    local int i;

    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && DriverPositions.Length > 0)
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

        SwitchMesh(DriverPositionIndex, true);
    }
}

// Modified to work with DHDebugMode & restricted to changing view limits & nothing to do with behind view (which is handled by exec functions BehindView & ToggleBehindView)
exec function ToggleViewLimit()
{
    local int i;

    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && Gun != none) // removed requirement to be in single player mode, as valid in multi-player if in DHDebugMode
    {
        if (Gun.bLimitYaw == Gun.default.bLimitYaw && PitchUpLimit == default.PitchUpLimit && PitchDownLimit == default.PitchDownLimit)
        {
            Gun.bLimitYaw = false;
            Gun.PitchUpLimit = 65535;
            Gun.PitchDownLimit = 1;
            Gun.CustomPitchUpLimit = 65535;
            Gun.CustomPitchDownLimit = 1;
            PitchUpLimit = 65535;
            PitchDownLimit = 1;

            if (DriverPositions.Length > 0)
            {
                for (i = 0; i < DriverPositions.Length; ++i)
                {
                    DriverPositions[i].ViewPositiveYawLimit = 65535;
                    DriverPositions[i].ViewNegativeYawLimit = -65535;
                    DriverPositions[i].ViewPitchUpLimit = 65535;
                    DriverPositions[i].ViewPitchDownLimit = 1;
                }
            }
        }
        else
        {
            Gun.bLimitYaw = Gun.default.bLimitYaw;
            Gun.PitchUpLimit = Gun.default.PitchUpLimit;
            Gun.PitchDownLimit = Gun.default.PitchDownLimit;
            Gun.CustomPitchUpLimit = Gun.default.CustomPitchUpLimit;
            Gun.CustomPitchDownLimit = Gun.default.CustomPitchDownLimit;
            PitchUpLimit = default.PitchUpLimit;
            PitchDownLimit = default.PitchDownLimit;

            if (DriverPositions.Length > 0)
            {
                for (i = 0; i < DriverPositions.Length; ++i)
                {
                    DriverPositions[i].ViewPositiveYawLimit = default.DriverPositions[i].ViewPositiveYawLimit;
                    DriverPositions[i].ViewNegativeYawLimit = default.DriverPositions[i].ViewNegativeYawLimit;
                    DriverPositions[i].ViewPitchUpLimit = default.DriverPositions[i].ViewPitchUpLimit;
                    DriverPositions[i].ViewPitchDownLimit = default.DriverPositions[i].ViewPitchDownLimit;
                }
            }
        }
    }
}

// New debug exec to toggles showing any collision static mesh actor
exec function ShowColMesh()
{
    if (VehWep != none && VehWep.CollisionMeshActor != none && (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && Level.NetMode != NM_DedicatedServer)
    {
        // If in normal mode, with CSM hidden, we toggle the CSM to be visible
        if (VehWep.CollisionMeshActor.bHidden)
        {
            VehWep.CollisionMeshActor.bHidden = false;
        }
        // Or if CSM has already been made visible & so is the weapon, we next toggle the weapon to be hidden
        else if (VehWep.Skins[0] != texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha')
        {
            VehWep.CollisionMeshActor.HideOwner(true); // can't simply make weapon bHidden, as that also hides all attached actors, including col mesh & player
        }
        // Or if CSM has already been made visible & the weapon has been hidden, we now go back to normal mode, by toggling weapon back to visible & CSM to hidden
        else
        {
            VehWep.CollisionMeshActor.HideOwner(false);
            VehWep.CollisionMeshActor.bHidden = true;
        }
    }
}

// New debug exec to set the projectile's launch position offset in the X axis
exec function SetWeaponFireOffset(float NewValue)
{
    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && Gun != none)
    {
        Log(Gun.Tag @ "WeaponFireOffset =" @ NewValue @ "(was" @ Gun.WeaponFireOffset $ ")");
        Gun.WeaponFireOffset = NewValue;

        if (Gun.FlashEmitter != none)
        {
            Gun.FlashEmitter.SetRelativeLocation(Gun.WeaponFireOffset * vect(1.0, 0.0, 0.0));
        }

        if (Gun.AmbientEffectEmitter != none)
        {
            Gun.AmbientEffectEmitter.SetRelativeLocation(Gun.WeaponFireOffset * vect(1.0, 0.0, 0.0));
        }
    }
}

// New debug exec to adjust WeaponAttachOffset, to reposition weapon's attachment to vehicle base
exec function SetAttachOffset(int NewX, int NewY, int NewZ, optional bool bScaleOneTenth)
{
    local vector OldOffset;

    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && VehWep != none)
    {
        OldOffset = VehWep.WeaponAttachOffset;
        VehWep.WeaponAttachOffset.X = NewX;
        VehWep.WeaponAttachOffset.Y = NewY;
        VehWep.WeaponAttachOffset.Z = NewZ;

        if (bScaleOneTenth) // option allowing accuracy to 0.1 Unreal units, by passing floats as ints scaled by 10 (e.g. pass 55 for 5.5)
        {
            VehWep.WeaponAttachOffset /= 10.0;
        }

        VehWep.SetRelativeLocation(VehWep.WeaponAttachOffset);
        Log(VehWep.Tag @ "WeaponAttachOffset =" @ VehWep.WeaponAttachOffset @ "(was" @ OldOffset $ ")");
    }
}

// New debug exec to adjust location of hatch fire position
exec function SetFEOffset(int NewX, int NewY, int NewZ)
{
    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && VehWep != none)
    {
        if (NewX != 0 || NewY != 0 || NewZ != 0)
        {
            VehWep.FireEffectOffset.X = NewX;
            VehWep.FireEffectOffset.Y = NewY;
            VehWep.FireEffectOffset.Z = NewZ;
        }

        VehWep.StartHatchFire();
        Log(VehWep.Tag @ "FireEffectOffset =" @ VehWep.FireEffectOffset);
    }
}

// New debug exec to adjust ambient sound radius
exec function SetSoundRadius(float NewValue)
{
    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && Gun != none)
    {
        if (bHasAltFire)
        {
            Log(Gun.Tag @ "AltFireSoundRadius =" @ NewValue @ "(was" @ Gun.AltFireSoundRadius $ ")");
            Gun.AltFireSoundRadius = NewValue;
        }
        else
        {
            Log(Gun.Tag @ "SoundRadius =" @ NewValue @ "(was" @ Gun.SoundRadius $ ")");
            Gun.SoundRadius = NewValue;
        }
    }
}

defaultproperties
{
    bCustomAiming=true
    bHasAltFire=false
    BinocPositionIndex=-1 // none by default, so set an invalid position
    DriveAnim=""
    TPCamDistance=300.0
    TPCamLookat=(X=-25.0,Y=0.0,Z=0.0)
    TPCamWorldOffset=(X=0.0,Y=0.0,Z=120.0)

    // These variables are effectively deprecated & should not be used - they are either ignored or values below are assumed & may be hard coded into functionality:
    bPCRelativeFPRotation=true
    bFPNoZFromCameraPitch=false
    FPCamViewOffset=(X=0.0,Y=0.0,Z=0.0) // always use FPCamPos for any camera offset, including for single position weapon pawns
    bAllowViewChange=false
    bDesiredBehindView=false
    bKeepDriverAuxCollision=true // Matt: necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
}

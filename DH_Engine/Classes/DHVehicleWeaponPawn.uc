//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVehicleWeaponPawn extends ROVehicleWeaponPawn
    abstract;

var     DHVehicleWeapon     VehWep;              // just a convenient reference to the VehicleWeapon actor

// View positions
var     int         InitialPositionIndex;       // initial player position on entering
var     int         UnbuttonedPositionIndex;    // lowest position number where player is unbuttoned
var     float       ViewTransitionDuration;     // calculated to control the time we stay in state ViewTransition

// Binoculars
var     int                         BinocPositionIndex; // index position when player is using binoculars
var     class<DHProjectileWeapon>   BinocularsClass;    // on entering, records which class of the binoculars the player has (necessary to move to binocs position)
var     DHDecoAttachment            BinocsAttachment;   // decorative actor spawned locally when player is using binoculars

// Gunsight overlay
var     Material    GunsightOverlay;            // texture overlay for gunsight
var     float       GunsightSize;               // size of the gunsight overlay (1.0 means full screen width, 0.5 means half screen width, etc)
var     float       OverlayCorrectionX;         // scope center correction in pixels, in case an overlay is off-center by pixel or two
var     float       OverlayCorrectionY;

// Spotting scope overlay
var     int                             SpottingScopePositionIndex;
var     class<DHArtillerySpottingScope> ArtillerySpottingScopeClass;
var     DHArtillerySpottingScope        ArtillerySpottingScope;

// Clientside flags to do certain things when certain actors are received, to fix problems caused by replication timing issues
var     bool        bInitializedVehicleAndGun;   // done some set up when had received both the VehicleBase & Gun actors
var     bool        bNeedToInitializeDriver;     // do some player set up when we receive the Driver actor
var     bool        bNeedToEnterVehicle;         // go to state 'EnteringVehicle' when we receive the Gun actor
var     bool        bNeedToStoreVehicleRotation; // set StoredVehicleRotation when we receive the VehicleBase actor

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)  // TODO: why is this necessary???
        BinocularsClass;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerToggleVehicleLock;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ************ ACTOR INITIALISATION, DESTRUCTION & KEY ENGINE EVENTS ************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified so if InitialPositionIndex is not zero, we match position indexes
// now so when a player gets in, we don't trigger an up transition by changing
// DriverPositionIndex
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (InitialPositionIndex > 0 && Role == ROLE_Authority)
    {
        DriverPositionIndex = InitialPositionIndex;
        LastPositionIndex = InitialPositionIndex;
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

// Modified to call set up functionality that requires the Vehicle, VehicleWeapon and/or player pawn actors (just after vehicle spawns via replication)
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

// New helper function to set the player's initial view rotation when entering the vehicle position, allowing easy subclassing
// Default is to make player face forwards on entering (zeroed as PC rotation as now always relative to vehicle or turret)
// Note this differs from what was originally in KDriverEnter() & ClientKDriverEnter(), which matched weapon pawn's rotation to controller
// But in POVChanged() we no longer alter rotation to make it relative to vehicle, so we just set a relative rotation here & no need for adjustment
simulated function SetInitialViewRotation()
{
    SetRotation(rot(0, 0, 0)); // note that an owning net client will update this back to the server
}

// Modified (from deprecated ROTankCannonPawn) to simply draw the BinocsOverlay, without additional drawing
simulated function DrawBinocsOverlay(Canvas C)
{
    local float TextureSize, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight;

    if (BinocularsClass != none)
    {
        // The drawn portion of the gunsight texture is 'zoomed' in or out to suit the desired scaling
        // This is inverse to the specified GunsightSize, i.e. the drawn portion is reduced to 'zoom in', so sight is drawn bigger on screen
        // The draw start position (in the texture, not the screen position) is often negative, meaning it starts drawing from outside of the texture edges
        // Draw areas outside the texture edges are drawn black, so this handily blacks out all the edges around the scaled gunsight, in 1 draw operation
        TextureSize = float(BinocularsClass.default.ScopeOverlay.MaterialUSize());
        TilePixelWidth = TextureSize / BinocularsClass.default.ScopeOverlaySize * 0.955; // width based on vehicle's GunsightSize (0.955 factor widens visible FOV to full screen for 'standard' overlay if GS=1.0)
        TilePixelHeight = TilePixelWidth * float(C.SizeY) / float(C.SizeX); // height proportional to width, maintaining screen aspect ratio
        TileStartPosU = (TextureSize - TilePixelWidth) * 0.5;
        TileStartPosV = (TextureSize - TilePixelHeight) * 0.5;

        // Draw the periscope overlay
        C.SetPos(0.0, 0.0);

        C.DrawTile(BinocularsClass.default.ScopeOverlay, C.SizeX, C.SizeY, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight);
    }
}

simulated function DrawSpottingScopeOverlay(Canvas C)
{
    if (Role == ROLE_Authority && Level.NetMode == NM_DedicatedServer)
    {
        return;
    }

    if (ArtillerySpottingScope == none)
    {
        ArtillerySpottingScope = new ArtillerySpottingScopeClass;
    }

    ArtillerySpottingScope.Draw(DHPlayer(Controller), C, self);
}

// These values are for easily grabbing the range and current value of pitch and yaw values.
// Primarily for use in drawing the spotting scope knobs.
simulated function int GetGunYaw()
{
    local int Yaw;

    Yaw = VehWep.CurrentAim.Yaw;

    if (Yaw >= 32768)
    {
        Yaw -= 65536;
    }

    return Yaw;
}

simulated function int GetGunYawMin()
{
    return VehWep.MaxNegativeYaw;
}

simulated function int GetGunYawMax()
{
    return VehWep.MaxPositiveYaw;
}

simulated function int GetGunPitch()
{
    local int Pitch;

    Pitch = VehWep.CurrentAim.Pitch;

    if (Pitch >= 32768)
    {
        Pitch -= 65536;
    }

    return Pitch;
}

simulated function int GetGunPitchMin()
{
    return VehWep.CustomPitchDownLimit - 65535;
}

simulated function int GetGunPitchMax()
{
    return VehWep.CustomPitchUpLimit;
}
// Modified to switch to external mesh & unzoomed FOV for behind view, plus handling of any relative/non-relative turret rotation
// Also to only adjust PC's rotation to make it relative to vehicle if we've just switched back from behind view into 1st person view
// This is because when we enter a vehicle we now call SetInitialViewRotation(), which is already relative to vehicle
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
            FixPCRotation(PC);
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
                ViewRelativeRotation = PC.Rotation; // make rotation relative to vehicle again (changed so only if switching back from behind view)

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
                PC.SetFOV(GetViewFOV(DriverPositionIndex));
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

// New helper function to get the appropriate ViewFOV for the given position in the DriverPositions array
// If no ViewFOV is specified for the given position it uses the player's default view FOV (i.e. player's normal FOV when on foot)
// This avoids having to hard code the default FOV for most vehicle positions (except gunsights and binoculars)
// It also facilitates the player having a customisable view FOV
simulated function float GetViewFOV(int PositionIndex)
{
    if (PositionIndex >= 0 && PositionIndex < DriverPositions.Length && DriverPositions[PositionIndex].ViewFOV > 0.0)
    {
        return DriverPositions[PositionIndex].ViewFOV;
    }

    if (IsHumanControlled())
    {
        return PlayerController(Controller).DefaultFOV;
    }

    return class'DHPlayer'.default.DefaultFOV;
}

// Modified so when player possesses a weapon pawn, he never starts in behind view (used in PC's Possess/Restart functions)
simulated function bool PointOfView()
{
    return false;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************* FIRING & AMMO  ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to check player is in a valid firing position & his weapons aren't locked due to spawn killing
function Fire(optional float F)
{
    if (CanFire() && !ArePlayersWeaponsLocked())
    {
        super.Fire(F);
    }
}

// Emptied out so we have no alt fire by default - implement functionality in subclass if has alt fire, e.g. cannon with coaxial MG
function AltFire(optional float F)
{
}

// Modified for server verification that player's weapons aren't locked due to spawn killing (belt & braces as similar clientside check stops it reaching this point anyway)
function VehicleFire(bool bWasAltFire)
{
    if (!ArePlayersWeaponsLocked())
    {
        super.VehicleFire(bWasAltFire);
    }
}

// Modified to optimise the network, by avoiding sending the replicated VehicleCeaseFire() function call to a server for single shot weapons
// Normal cannons & mortars will fire one shot & then the server will do its own cease fire process anyway
// But for MGs or autocannons we run the normal function, so when player releases the fire button the client tells the server to stop firing
function ClientVehicleCeaseFire(bool bWasAltFire)
{
    if ((VehWep != none && VehWep.bUsesMags) || bWasAltFire) // MG or autocannon gets the normal function
    {
        super.ClientVehicleCeaseFire(bWasAltFire);
    }
    else // single shot cannons or mortars get the same apart from VehicleCeaseFire()
    {
        ClientOnlyVehicleCeaseFire(bWasAltFire);
    }
}

// New function to do what ClientVehicleCeaseFire() does, except skipping the replicated VehicleCeaseFire() function call to a server
// A network optimisation, avoiding replication when it's unnecessary, when there's no point client telling server to cease fire because server will do it anyway
// Examples are when a single shot weapon fires, or when player/weapon is no longer able to fire (including when an automatic weapon runs out of ammo)
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

// New function to check whether player is in a view position where he can fire the weapon - implement functionality in subclasses as required
function bool CanFire()
{
    return true;
}

// New helper function to check if player's weapons are locked due to spawn killing, by calling similar function on a DHPlayer Controller
// Just improves readability where used in several other functions
function bool ArePlayersWeaponsLocked(optional bool bNoScreenMessage)
{
    return DHPlayer(Controller) != none && DHPlayer(Controller).AreWeaponsLocked(bNoScreenMessage);
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

// New function to try to start a reload or resume any previously paused reload if weapon isn't loaded
function CheckResumeReloadingOnEntry()
{
    local byte OldReloadState;

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
            VehWep.PassReloadStateToClient();
        }
    }
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
        else if (VehWep.ReloadState == RL_Waiting || VehWep.ReloadState == RL_ReloadingPart1)
        {
            return 1.0;
        }

        return VehWep.ReloadStages[VehWep.ReloadState].HUDProportion;
    }

    return 0.0;
}

// New helper function to check whether player is in a position where he can reload the weapon - implement functionality in subclasses as required
simulated function bool CanReload()
{
    return true;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************** VEHICLE ENTRY  ******************************** //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to match entry requirements to the vehicle base, to use vehicle's VehicleTeam for owning team, & to remove obsolete stuff & duplication from the Supers
function bool TryToDrive(Pawn P)
{
    local bool bEnemyVehicle;
    local int  i;

    // Deny entry if vehicle is destroyed, or if player is on fire or reloading a weapon (plus several very obscure other reasons)
    if (Health <= 0 || P == none || (DHPawn(P) != none && DHPawn(P).bOnFire) || (P.Weapon != none && P.Weapon.IsInState('Reloading')) ||
        P.Controller == none || !P.Controller.bIsPlayer || P.DrivenVehicle != none || P.IsA('Vehicle') || bNonHumanControl || !Level.Game.CanEnterVehicle(self, P))
    {
        return false;
    }

    // Check whether trying to enter a vehicle that doesn't belong to our team
    if (VehicleBase != none)
    {
        // If vehicle is team locked, i.e. can only be used by one team (the normal setting), it's a simple check against the VehicleTeam
        if (VehicleBase.bTeamLocked)
        {
            bEnemyVehicle = P.GetTeamNum() != VehicleBase.VehicleTeam;
        }
        // But if vehicle isn't team locked & can be used by either team, we need to check if already has an enemy occupant (enemies can't share!)
        else
        {
            if (VehicleBase.Driver != none && P.GetTeamNum() != VehicleBase.Driver.GetTeamNum())
            {
                bEnemyVehicle = true;
            }
            else
            {
                for (i = 0; i < VehicleBase.WeaponPawns.Length; ++i)
                {
                    if (VehicleBase.WeaponPawns[i] != none && VehicleBase.WeaponPawns[i].Driver != none && P.GetTeamNum() != VehicleBase.WeaponPawns[i].Driver.GetTeamNum())
                    {
                        bEnemyVehicle = true;
                        break;
                    }
                }
            }
        }

        // Deny entry if it's an enemy vehicle
        if (bEnemyVehicle)
        {
            DisplayVehicleMessage(1, P); // can't use enemy vehicle

            return false;
        }
    }

    // TODO: these checks on a tank crew position are perhaps unnecessary duplication, as they will have been reliably checked on the server in earlier functions
    // See notes in same function in DHVehicle for details
    if (bMustBeTankCrew)
    {
        // Deny entry to a tank crew position if player isn't a tank crew role
        if (!class'DHPlayerReplicationInfo'.static.IsPlayerTankCrew(P) && P.IsHumanControlled())
        {
            DisplayVehicleMessage(0, P); // not qualified to operate vehicle

            return false;
        }

        // Deny entry to a tank crew position in an armored vehicle if it's been locked & player isn't an allowed crewman (gives message)
        if (DHArmoredVehicle(VehicleBase) != none && DHArmoredVehicle(VehicleBase).AreCrewPositionsLockedForPlayer(P))
        {
            return false;
        }
    }

    // Deny entry if this position is already occupied
    // Note this comes after other checks because if the player can't enter it anyway (e.g. enemy or locked vehicle or tank crew only),
    // he should get a 'can't use' message regardless of whether it happens to be currently occupied
    if (Driver != none)
    {
        return false;
    }

    // Passed all checks, so allow player to enter this vehicle position
    KDriverEnter(P);

    return true;
}

// Modified to handle passed in pawn being a vehicle, which now happens when player switches vehicle position (no longer briefly repossesses & unpossesses his player pawn)
// Also to try to start a reload or resume any previously paused reload if weapon isn't loaded, to cancel any CheckReset timer as vehicle is no longer empty,
// to use InitialPositionIndex instead of assuming start position zero, to record if player has binoculars,
// And to tell our vehicle base to check & update any vehicle lock settings as a new player has entered
// Generally optimised & re-ordered a little, with some redundancy from the Supers removed
function KDriverEnter(Pawn P)
{
    local Controller C;
    local DHPawn DHP;
    local DHProjectileWeapon BinocularsItem;

    // Get a controller reference
    // If the entering player has a controller we need to save it because the pawn will lose it when unpossessed
    // And if player is switching from another vehicle position, his player pawn will no longer have a controller, so we need to use the new DHPawn.SwitchingController
    if (P != none)
    {
        DHP = DHPawn(P);

        if (P.Controller != none)
        {
            C = P.Controller;
        }

        if (DHP != none && DHP.SwitchingController != none)
        {
            if (C == none)
            {
                C = DHP.SwitchingController;
            }

            DHP.SetSwitchingController(none); // reset this now we've used it
        }
    }

    if (C == none)
    {
        return;
    }

    // Make the player our 'Driver'
    if (bMultiPosition) // added to make sure the driver position is the initial one
    {
        DriverPositionIndex = InitialPositionIndex;
        LastPositionIndex = InitialPositionIndex;
    }

    bDriving = true;
    Driver = P;
    Driver.StartDriving(self);

    // Make the player unpossess its current pawn & possess this vehicle pawn
    if (C.Pawn != none) // added this check because if only switching vehicle position, controller will no longer have any player pawn to Unpossess()
    {
        C.Unpossess();
    }

    Driver.SetOwner(self); // this keeps the driver net relevant
    C.bVehicleTransition = true; // to stop bots from doing Restart() during possession
    C.Possess(self);
    C.bVehicleTransition = false;
    DrivingStatusChanged();
    Level.Game.DriverEnteredVehicle(self, P);
    Driver.bSetPCRotOnPossess = false; // so when player gets out, he'll be facing the same direction as he was in the vehicle

    // No point setting rotation here (as in the Super), because single player mode or a listen server host get it anyway in ClientKDriverEnter()
    // And it's of no relevance to dedicated server or non-owning listen server, which receive rotation from owning player's client (autonomous proxy role)
//  SetInitialViewRotation();

    // Activate vehicle weapon & increase it's network priority
    if (Gun != none)
    {
        Gun.bActive = true;
        Gun.NetPriority = 2.0;
        Gun.NetUpdateFrequency = 10.0;
    }

    // Bot code
    StuckCount = 0;

    if (IsHumanControlled())
    {
        VehicleLostTime = 0.0;
    }

    // Various DH added functionality, with some standard VehicleBase updates because a player has entered
    if (VehicleBase != none)
    {
        VehicleBase.ResetTime = Level.TimeSeconds - 1.0; // cancel any CheckReset timer as vehicle now occupied (same as ROVehicle, was missing in weapon pawn)

        if (VehicleBase.bEnterringUnlocks && VehicleBase.bTeamLocked) // moved here from TryToDrive()
        {
            VehicleBase.bTeamLocked = false;
        }

        if (VehicleBase.IsA('DHVehicle'))
        {
            DHVehicle(VehicleBase).UpdateVehicleLockOnPlayerEntering(self); // tell our vehicle to check & update any vehicle lock settings as new player has entered
        }
    }

    CheckResumeReloadingOnEntry(); // try to start a reload or resume any previously paused reload if weapon isn't loaded

    if (BinocPositionIndex >= 0 && BinocPositionIndex < DriverPositions.Length) // record whether player has binoculars
    {
        BinocularsItem = DHProjectileWeapon(P.FindInventoryType(class<Inventory>(DynamicLoadObject("DH_Equipment.DHBinocularsItem", class'class'))));

        if (BinocularsItem != none)
        {
            BinocularsClass = BinocularsItem.Class;
        }
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

    SetInitialViewRotation(); // new helper function that just allows easy subclassing without needing to re-state this long function

    if (bMultiPosition)
    {
        SavedPositionIndex = InitialPositionIndex;
        PendingPositionIndex = InitialPositionIndex;

        if (Gun != none)
        {
            GotoState('EnteringVehicle');
        }
        else
        {
            bNeedToEnterVehicle = true; // fix for 2nd problem described above, where net client may not yet have VehicleWeapon actor when deploying into spawn vehicle
        }
    }
    else if (PC != none)
    {
        if (default.WeaponFOV <= 0.0) // if no WeaponFOV is set, we just use the player's default view FOV (i.e. player's normal FOV when on foot)
        {
            WeaponFOV = PC.DefaultFOV;
        }

        PC.SetFOV(WeaponFOV); // not needed if bMultiPosition, as gets set in EnteringVehicle
    }

    // StoredVehicleRotation appears redundant as not used anywhere in UScript, but must be used by native code as if removed we get unwanted camera swivelling effect on entering
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
        WeaponFOV = GetViewFOV(InitialPositionIndex);

        if (IsHumanControlled())
        {
            PlayerController(Controller).SetFOV(WeaponFOV);
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ************************** CHANGING 'DRIVER' POSITION ************************** //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to avoid wasting network resources by calling ServerChangeViewPoint on the server when it isn't valid
// Also to prevent player from moving to binoculars position if he doesn't have any binocs
simulated function NextWeapon()
{
    if (DriverPositionIndex < DriverPositions.Length - 1 && DriverPositionIndex == PendingPositionIndex && !IsInState('ViewTransition') && bMultiPosition)
    {
        if ((DriverPositionIndex + 1) == BinocPositionIndex && BinocularsClass == none) // can't go to binocs if don't have them
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
        PendingPositionIndex = DriverPositionIndex - 1;
        ServerChangeViewPoint(false);
    }
}

// Modified to call NextViewPoint() for all modes, including dedicated server
// New player hit detection system (basically using normal hit detection as for an infantry player pawn) relies on server playing same animations as net clients
// Server also needs to be in state ViewTransition if player is unbuttoning to prevent player exiting until fully unbuttoned
// Also to prevent player from moving to binoculars position if he doesn't have any binocs
function ServerChangeViewPoint(bool bForward)
{
    if (bForward)
    {
        if (DriverPositionIndex < (DriverPositions.Length - 1))
        {
            if ((DriverPositionIndex + 1) == BinocPositionIndex && BinocularsClass == none) // can't go to binocs if don't have them
            {
                return;
            }

            LastPositionIndex = DriverPositionIndex;
            DriverPositionIndex++;
            NextViewPoint();
        }
    }
    else
    {
        if (DriverPositionIndex > 0)
        {
            LastPositionIndex = DriverPositionIndex;
            DriverPositionIndex--;
            NextViewPoint();
        }
    }
}

// Modified so dedicated server doesn't go to state ViewTransition if player is only moving between unexposed positions
// This is because player can't be shot & so server doesn't need to play transition anims (note this wouldn't even be called on dedicated server in original RO)
simulated function NextViewPoint()
{
    if (Level.NetMode == NM_Client && !IsLocallyControlled())
    {
        AnimateTransition();
    }
    else if (Level.NetMode != NM_DedicatedServer || DriverPositions[DriverPositionIndex].bExposed || DriverPositions[LastPositionIndex].bExposed)
    {
        GotoState('ViewTransition');
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
        local PlayerController PC;

        if (VehicleBase != none)
        {
            StoredVehicleRotation = VehicleBase.Rotation;
        }

        // Switch to mesh for new position as may be different
        // Note added IsFirstPerson() check stops this on dedicated server or on listen server host that's not controlling this vehicle
        if (IsFirstPerson())
        {
            SwitchMesh(DriverPositionIndex);
            PC = PlayerController(Controller); // having PC reference now serves as a flag that we're locally controlled & in 1st person view
        }

        // If moving away from a position where the camera view snaps, immediately neutralise any zoom or camera offset from the old position
        // Relevant to overlays like gunsight, periscope or binoculars
        if (ShouldViewSnapInPosition(LastPositionIndex))
        {
            if (PC != none)
            {
                PC.SetFOV(PC.DefaultFOV);
            }

            // If moving to another camera snap position (e.g. off gunsight towards periscope), remove any camera offset from old position during the transition
            if (ShouldViewSnapInPosition(DriverPositionIndex))
            {
                FPCamPos = vect(0.0, 0.0, 0.0);
            }
        }

        WeaponFOV = GetViewFOV(DriverPositionIndex);

        // Unless moving onto an camera snap position, apply any zoom & camera offset for the new position now
        // If we are moving onto an camera snap position, we instead leave it to end of the transition
        if (!ShouldViewSnapInPosition(DriverPositionIndex))
        {
            if (PC != none)
            {
                PC.DesiredFOV = WeaponFOV; // set DesiredFOV so any zoom change gets applied smoothly
            }

            FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation; // note we set FPCamPos even in behind view so camera debugging works
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
        // If we've finished moving onto a camera snap position, now snap to any zoom setting or camera offset it has (we avoiding doing this earlier)
        if (ShouldViewSnapInPosition(DriverPositionIndex))
        {
            if (IsFirstPerson())
            {
                PlayerController(Controller).SetFOV(WeaponFOV);
            }

            FPCamPos = DriverPositions[DriverPositionIndex].ViewLocation;
        }

        // If moving off binoculars, destroy binocs attachment & any other setup stuff
        if (LastPositionIndex == BinocPositionIndex)
        {
            HandleBinoculars(false);
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

// New helper function to check whether a view position (i.e. one of the DriverPositions) should apply view 'snap' when moving onto or away from iter_swap
// Used to determine whether any camera view changes (zoom or position offset) should only be applied when actually in the position & not while player is transitioning
// By default in includes a gunsight or binoculars overlay position, but can easily be subclassed
simulated function bool ShouldViewSnapInPosition(byte PositionIndex)
{
    return DriverPositions[PositionIndex].bDrawOverlays && ((GunsightOverlay != none && PositionIndex == 0) || PositionIndex == BinocPositionIndex);
}

/*
// TODO: possibly deprecate this function & always use state ViewTransition for all net modes, same as in the ROVehicle class
// Everything in VT that's relevant to a other 3rd person players gets done here, & everything that's not relevant is excluded in VT anyway
// So this function no longer appears to offer any advantage, while the transition Sleep timer in VT offers better timed handling of player's hit detection & binocs attachments
*/
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

// Modified to add clientside pre-checks before sending the function call to the server
// Optimises network performance generally & specifically avoids a rider camera bug when unsuccessfully trying to switch to another vehicle position
simulated function SwitchWeapon(byte F)
{
    if (Role == ROLE_Authority || CanSwitchToVehiclePosition(F))
    {
        ServerChangeDriverPosition(F);
    }
}

// Modified to add checks before trying to switch position, to make sure the player isn't going to be prevented from entering the new position
// Also to record the controller in the DHPawn (as SwitchingController), which is now now required by the new vehicle position's KDriverEnter()
// Exiting player no longer briefly re-possesses player pawn before trying to enter new vehicle position, so DHPawn passed in to KDriverEnter() has no Controller
// And we now call KDriverEnter() directly, instead of TryToDrive(), as we've already checked & verified the player can switch
// Generally re-factored to avoid repeating any of the same checks & to reduce repetition & make clearer
function ServerChangeDriverPosition(byte F)
{
    local DHPawn  SwitchingPlayer, Bot;
    local Vehicle NewVehiclePosition;

    SwitchingPlayer = DHPawn(Driver);

    if (SwitchingPlayer == none || !CanSwitchToVehiclePosition(F))
    {
        return; // can't switch if fails any of these checks
    }

    if (F == 1)
    {
        NewVehiclePosition = VehicleBase; // switching to driver's position
    }
    else
    {
        NewVehiclePosition = VehicleBase.WeaponPawns[F - 2]; // switching to a vehicle weapon position
    }

    if (NewVehiclePosition != none)
    {
        // If human player wants to switch to a bot's position, make the bot swap with him
        if (AIController(NewVehiclePosition.Controller) != none)
        {
            Bot = DHPawn(NewVehiclePosition.Driver);

            if (Bot != none)
            {
                Bot.SetSwitchingController(NewVehiclePosition.Controller);
                NewVehiclePosition.KDriverLeave(true); // kicks bot out
            }
        }

        // Switch player to new vehicle position
        // We record our controller as the SwitchingController, which is now required by the new vehicle position's KDriverEnter()
        // And we now call KDriverEnter() directly, instead of TryToDrive(), as we've already checked & verified the player can switch
        SwitchingPlayer.SetSwitchingController(Controller);
        KDriverLeave(true);
        NewVehiclePosition.KDriverEnter(SwitchingPlayer);

        if (Bot != none)
        {
            KDriverEnter(Bot); // if we kicked a bot out of the target position, now switch it into this position
        }
    }
}

// New helper function to check whether player is able to switch to new vehicle position
// Avoids (1) net client sending unnecessary replicated function calls to server, & (2) player exiting current position to unsuccessfully try to enter new position
// We make sure player isn't trying to 'teleport' outside to external rider position while buttoned up,
// or to enter a tank crew position he can't use (including in an armored vehicle that he's locked out of), or any position already occupied by another human player
simulated function bool CanSwitchToVehiclePosition(byte F)
{
    local DHArmoredVehicle AV;
    local Vehicle          NewVehiclePosition;
    local bool             bMustBeTankerToSwitch;

    if (F == 0 || DHVehicle(VehicleBase) == none) // pressing zero is an invalid switch choice
    {
        return false;
    }

    // Trying to switch to driver position (for now just get vehicle variables for later checks)
    if (F == 1)
    {
        NewVehiclePosition = VehicleBase;
        bMustBeTankerToSwitch = VehicleBase.bMustBeTankCommander;

        if (DHVehicle(VehicleBase).default.bRequiresDriverLicense && !class'DHPlayerReplicationInfo'.static.IsPlayerLicensedToDrive(DHPlayer(Self.Controller)) && IsHumanControlled())
        {
            DisplayVehicleMessage(0); // not qualified to operate vehicle
            return false;
        }
    }
    // Trying to switch to non-driver position
    else
    {
        F -= 2; // adjust passed F to selected weapon pawn index (e.g. pressing 2 for turret position ends up with F=0 for weapon pawn no.0)

        // Can't switch if player has selected an invalid weapon pawn position or the current position
        if (F >= VehicleBase.WeaponPawns.Length || F == PositionInArray)
        {
            return false;
        }

        // Can't switch if player selected a rider position on an armored vehicle, but is buttoned up (no 'teleporting' outside to external rider position) - gives message
        if (GetArmoredVehicleBase(AV) && F >= AV.FirstRiderPositionIndex && !CanExit())
        {
            return false;
        }

        // Get weapon pawn variables for later checks
        // Note on a net client we probably won't get a weapon pawn reference for an unoccupied rider pawn, as actor doesn't usually exist on a client
        // But that's fine because there's nothing we need to check for an unoccupied rider pawn & we can always switch to it if we got here
        // If we let the switch go ahead, the rider pawn will get replicated to the owning net client as the player enters it on the server
        NewVehiclePosition = VehicleBase.WeaponPawns[F];
        bMustBeTankerToSwitch = ROVehicleWeaponPawn(NewVehiclePosition) != none && ROVehicleWeaponPawn(NewVehiclePosition).bMustBeTankCrew;
    }

    if (bMustBeTankerToSwitch)
    {
        // Can't switch if player has selected a tank crew position but isn't a tank crew role
        if (!class'DHPlayerReplicationInfo'.static.IsPlayerTankCrew(self) && IsHumanControlled())
        {
            DisplayVehicleMessage(0); // not qualified to operate vehicle

            return false;
        }

        // Can't switch to a tank crew position in an armored vehicle if it's been locked & player isn't an allowed crewman (gives message)
        // We DO NOT apply this check to a net client, as it doesn't have the required variables (bVehicleLocked & CrewedLockedVehicle)
        if (Role == ROLE_Authority && (AV != none || GetArmoredVehicleBase(AV)) && AV.AreCrewPositionsLockedForPlayer(self))
        {
            return false;
        }
    }

    // Can't switch if new vehicle position already has a human occupant
    // bDriving check is there to also catch 'LeaveBody' debug pawns, which won't have a PRI, stopping player switching into same position as one
    if (NewVehiclePosition != none && NewVehiclePosition.bDriving && !(NewVehiclePosition.PlayerReplicationInfo != none && NewVehiclePosition.PlayerReplicationInfo.bBot))
    {
        return false;
    }

    return true;
}

// Modified so if player is only switching vehicle positions, he no longer briefly re-possesses his player pawn before trying to enter the new vehicle position
// And to remove overlap with DriverDied(), moving common features into DriverLeft(), which gets called by both functions, & to remove some redundancy
// Also to prevent exit if player is buttoned up, to show a message if no valid exit can be found, & to give player the same momentum as the vehicle when exiting
// And so if an 'allowed' crewman exits a locked armored vehicle, we check whether we need to set an unlock timer
function bool KDriverLeave(bool bForceLeave)
{
    local DHArmoredVehicle AV;
    local Controller       SavedController;
    local vector           ExitVelocity;
    local bool             bSwitchingVehiclePosition, bAllowedCrewmanExitingLockedVehicle;

    // Prevent exit if player is buttoned up (or if game type or mutator prevents exit)
    if (!bForceLeave && (!CanExit() || (Level.Game != none && !Level.Game.CanLeaveVehicle(self, Driver))))
    {
        return false;
    }

    bSwitchingVehiclePosition = bForceLeave && DHPawn(Driver) != none && DHPawn(Driver).SwitchingController != none;

    // Find an exit location for the player & try to move him there, unless we're only switching vehicle position
    if (!bSwitchingVehiclePosition && Driver != none && (!bRemoteControlled || bHideRemoteDriver))
    {
        Driver.bHardAttach = false;
        Driver.bCollideWorld = true;
        Driver.SetCollision(true, true);

        // If we couldn't move player to an exit location & we're not forcing exit, leave him inside (restoring his attachment & collision properties)
        if (!PlaceExitingDriver() && !bForceLeave)
        {
            Driver.bHardAttach = true;
            Driver.bCollideWorld = false;
            Driver.SetCollision(false, false);
            DisplayVehicleMessage(13); // no exit can be found (added)

            return false;
        }
    }

    // Stop controlling this vehicle pawn
    if (Controller != none)
    {
        if (Controller.RouteGoal == self)
        {
            Controller.RouteGoal = none;
        }

        if (Controller.MoveTarget == self)
        {
            Controller.MoveTarget = none;
        }

        SavedController = Controller; // save because Unpossess() will clear our reference
        Controller.UnPossess();

        // If player is actually exiting the vehicle, not just switching positions, take control of the exiting player pawn
        // We now skip this block if only switching, so we no longer briefly re-possess the player pawn
        if (!bSwitchingVehiclePosition && Driver != none && Driver.Health > 0)
        {
//          Driver.SetOwner(SavedController); // removed as gets set anyway in the possession process
            SavedController.bVehicleTransition = true; // to stop bots from doing Restart() during possession
            SavedController.Possess(Driver);
            SavedController.bVehicleTransition = false; // reset

            if (SavedController.IsA('PlayerController'))
            {
                PlayerController(SavedController).ClientSetViewTarget(Driver); // set PlayerController to view the person that got out
            }
        }

        if (Controller == SavedController) // if our Controller somehow didn't change, clear it
        {
            Controller = none;
        }

        if (SavedController.IsA('Bot'))
        {
            Bot(SavedController).ClearTemporaryOrders(); // note this is added in VWPawn, it's not in Vehicle
        }
    }

    if (Driver != none)
    {
        // Update exiting player pawn if he has actually left the vehicle
        if (!bSwitchingVehiclePosition)
        {
            Driver.bSetPCRotOnPossess = Driver.default.bSetPCRotOnPossess; // undo temporary change made when entering vehicle
            Driver.StopDriving(self);

            // Give a player exiting the vehicle the same momentum as vehicle, with a little added height kick
            if (VehicleBase != none)
            {
                ExitVelocity = VehicleBase.Velocity;
                ExitVelocity.Z += 60.0;
                Driver.Velocity = ExitVelocity;
            }
        }
        // Or if human player has only switched vehicle position, we just set PlayerStartTime, telling bots not to enter this vehicle position for a little while
        // This is the only line that's relevant from StopDriving(), as we're no longer calling that if only switching position
        else if (PlayerController(SavedController) != none)
        {
            PlayerStartTime = Level.TimeSeconds + 12.0;
        }
    }

    // If an an 'allowed' crewman is exiting a locked armored vehicle, check whether need to set an unlock timer
    bAllowedCrewmanExitingLockedVehicle = !bSwitchingVehiclePosition && GetArmoredVehicleBase(AV) && AV.bVehicleLocked && AV.IsAnAllowedCrewman(Driver);

    DriverLeft();

    if (bAllowedCrewmanExitingLockedVehicle)
    {
        AV.CheckSetUnlockTimer(); // note this has to be called after DriverLeft(), otherwise exiting player will still be registered as the occupant
    }

    return true;
}

// Modified to remove overlap with KDriverLeave(), moving common features into DriverLeft(), which gets called by both functions, & to remove some redundancy
// Also made it so function progresses to call DriverLeft() even if has no Controller, which specifically works with the LeaveBody() debug exec
function DriverDied()
{
    local Controller SavedController;

    if (Driver != none)
    {
        Level.Game.DiscardInventory(Driver);
        Driver.StopDriving(self);
        Driver.Controller = Controller;
        Driver.DrivenVehicle = self; // for in game stats, so it knows player was killed inside a vehicle

        if (Controller != none)
        {
            if (IsHumanControlled()) // set PlayerController to view the dead driver
            {
                Controller.SetLocation(Location);
                PlayerController(Controller).SetViewTarget(Driver);
                PlayerController(Controller).ClientSetViewTarget(Driver);
            }

            SavedController = Controller; // save because Unpossess() will clear our reference
            Controller.Unpossess();

            if (Controller == SavedController) // if our Controller didn't change, clear it
            {
                Controller = none;
            }

            SavedController.Pawn = Driver;
        }
    }

    DriverLeft();
}

// Modified to add common features from KDriverLeave() & DriverDied(), which both call this function, & to reset to InitialPositionIndex instead of zero
// Moving the VehWep section here fixes a major bug caused because before it was only being run in KDriverLeave() and not in DriverDied()
// If player died in vehicle weapon, next player who entered would find weapon rotating wildly to remain facing towards a fixed point (resetting Gun.bActive is key)
// Also modified to pause any reload if player exits (authority roles get this here; owning net client gets it in ClientKDriverLeave())
function DriverLeft()
{
    if (bMultiPosition)
    {
        DriverPositionIndex = InitialPositionIndex;
        LastPositionIndex = InitialPositionIndex;
    }

    if (VehWep != none)
    {
        VehWep.bActive = false;
        VehWep.FlashCount = 0;
        VehWep.NetUpdateFrequency = VehWep.default.NetUpdateFrequency;
        VehWep.NetPriority = VehWep.default.NetPriority;
        VehWep.PauseAnyReloads();
    }

    SetRotatingStatus(0); // stop playing any turret rotation sound

    Level.Game.DriverLeftVehicle(self, Driver);
    Driver = none;
    bDriving = false;
    DrivingStatusChanged();

    if (VehicleBase != none)
    {
        VehicleBase.MaybeDestroyVehicle(); // checks if vehicle is now empty & may set a timer to destroy later
    }
}

// Modified to pause any reload if player exits
// Only applies to owning net client, as authority roles get this is DriverLeft() & reloading status isn't relevant to other net clients
simulated function ClientKDriverLeave(PlayerController PC)
{
    super.ClientKDriverLeave(PC);

    if (Role < ROLE_Authority && VehWep != none)
    {
        VehWep.PauseAnyReloads();
    }
}

// Modified to remove playing BeginningIdleAnim as that now gets done for all net modes in DrivingStatusChanged()
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

// Modified to make sure driver's health is no more than zero on a net client, in case that isn't replicated until later
// Health now affects collision handling in DHPawn's StopDriving() function
simulated function Destroyed_HandleDriver()
{
    if (Role < ROLE_Authority && Driver != none && Driver.Health > 0 && Driver.DrivenVehicle == self)
    {
        Driver.Health = 0;
    }

    super.Destroyed_HandleDriver();
}

// New function to check if player can exit, displaying an "unbutton hatch" message if he can't (just saves repeating code in different functions)
simulated function bool CanExit()
{
    if ((DriverPositionIndex < UnbuttonedPositionIndex || (IsInState('ViewTransition') && DriverPositionIndex == UnbuttonedPositionIndex)) && IsHumanControlled())
    {
        if (DriverPositions.Length > UnbuttonedPositionIndex) // means it is possible to unbutton
        {
            DisplayVehicleMessage(9,, true); // must unbutton the hatch
        }

        return false;
    }

    return true;
}

// Modified to use new, simplified system with exit positions for all vehicle positions included in the vehicle class default properties
// Also to trace from player's actual world location, with a smaller trace extent so player is less likely to snag on objects that wouldn't really block his exit
function bool PlaceExitingDriver()
{
    local vector Extent, ZOffset, ExitPosition, HitLocation, HitNormal;
    local int    StartIndex, i;
    local DHVehicle DHV;

    if (Driver == none || VehicleBase == none)
    {
        return false;
    }

    // Try absolute exit positions first
    DHV = DHVehicle(VehicleBase);

    for (i = 0; i < DHV.AbsoluteExitPositions.Length; ++i)
    {
        ExitPosition = DHV.AbsoluteExitPositions[i].Location;

        if (Driver.SetLocation(ExitPosition))
        {
            return true;
        }
    }

    // Set extent & ZOffset, using a smaller extent than original
    Extent.X = Driver.default.DrivingRadius;
    Extent.Y = Driver.default.DrivingRadius;
    Extent.Z = Driver.default.DrivingHeight;
    ZOffset.Z = Driver.default.CollisionHeight * 0.5;

    // Check through exit positions to see if player can be moved there, using the 1st valid one we find
    // Start with the exit position for this weapon pawn, & if necessary loop back to position zero to find a valid exit
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

// Overriden to support metrics.
function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
    local PlayerController PC;
    local Controller C;
    local DarkestHourGame G;
    local DHGameReplicationInfo GRI;
    local int RoundTime;

    if (bDeleteMe || Level.bLevelChange)
    {
        return; // already destroyed, or level is being cleaned up
    }

    if (Level.Game.PreventDeath(self, Killer, damageType, HitLocation))
    {
        Health = Max(Health, 1); //mutator should set this higher
        return;
    }

    Health = Min(0, Health);

    if (Controller != none)
    {
        C = Controller;
        C.WasKilledBy(Killer);
        Level.Game.Killed(Killer, C, self, damageType);

        if (C.bIsPlayer)
        {
            PC = PlayerController(C);

            if (PC != none)
            {
                ClientKDriverLeave(PC); // Just to reset HUD etc.
            }
            else
            {
                ClientClearController();
            }

            if ((bRemoteControlled || bEjectDriver) && Driver != none && Driver.Health > 0)
            {
                C.Unpossess();
                C.Possess(Driver);

                if (bEjectDriver)
                {
                    EjectDriver();
                }

                Driver = none;
            }
            else
            {
                G = DarkestHourGame(Level.Game);

                if (G != none && G.Metrics != none)
                {
                    GRI = DHGameReplicationInfo(G.GameReplicationInfo);

                    if (GRI != none)
                    {
                        RoundTime = GRI.ElapsedTime - GRI.RoundStartTime;
                    }

                    // Log the crew/passenger kill.
                    G.Metrics.OnPlayerFragged(PlayerController(Killer), PC, DamageType, HitLocation, 0, RoundTime);
                }

                if (PC != none && VehicleBase != none)
                {
                    PC.SetViewTarget(VehicleBase);
                    PC.ClientSetViewTarget(VehicleBase);
                }

                C.PawnDied(self);
            }
        }
        else
        {
            C.Destroy();
        }

        if (Driver != none)
        {
            if (!bRemoteControlled && !bEjectDriver)
            {
                if (!bDrawDriverInTP && PlaceExitingDriver())
                {
                    Driver.StopDriving(self);
                    Driver.DrivenVehicle = self;
                }

                Driver.SetTearOffMomemtum(Velocity * 0.25);
                Driver.Died(Controller, class'RODiedInTankDamType', Driver.Location);
            }
            else
            {
                if (bEjectDriver)
                {
                    EjectDriver();
                }
                else
                {
                    KDriverLeave(false);
                }
            }
        }
    }
    else
    {
        Level.Game.Killed(Killer, Controller(Owner), self, damageType);
    }

    if (Killer != none)
    {
        TriggerEvent(Event, self, Killer.Pawn);
    }
    else
    {
        TriggerEvent(Event, self, none);
    }

    if (IsHumanControlled())
    {
        PlayerController(Controller).ForceDeathUpdate();
    }

    Destroy();
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

    if (default.GunClass != none)
    {
        default.GunClass.static.StaticPrecache(L);
    }

    if (default.ArtillerySpottingScope != none)
    {
        L.AddPrecacheMaterial(default.ArtillerySpottingScope.default.SpottingScopeOverlay);
    }
}

// Modified to add extra material properties (no need to call the Super, as it's only in Actor & only caches the Skins array, which a weapon pawn doesn't have)
simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(GunsightOverlay);

    if (default.ArtillerySpottingScope != none)
    {
        Level.AddPrecacheMaterial(default.ArtillerySpottingScope.default.SpottingScopeOverlay);
    }
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

// New function to do set up that requires the 'Gun' reference to the VehicleWeapon actor
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

// New function to do set up that requires the 'VehicleBase' reference to the Vehicle actor
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

// New function to do any set up that requires both 'VehicleBase' & 'Gun' references to Vehicle & VehicleWeapon actors - implement functionality in subclasses
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

// New keybind function to toggle whether an armored vehicle is locked, stopping new players from entering tank crew positions
// CanPlayerLockVehicle() is pre-checked by net client for network efficiency, by avoiding sending invalid replicated function calls to server
exec simulated function ToggleVehicleLock()
{
    local DHArmoredVehicle AV;

    if (GetArmoredVehicleBase(AV) && (Role == ROLE_Authority || AV.CanPlayerLockVehicle(self)))
    {
        ServerToggleVehicleLock();
    }
}

// New client-to-server function to toggle whether an armored vehicle is locked
function ServerToggleVehicleLock()
{
    local DHArmoredVehicle AV;

    if (GetArmoredVehicleBase(AV) && AV.CanPlayerLockVehicle(self) && Role == ROLE_Authority)
    {
        AV.SetVehicleLocked(!AV.bVehicleLocked);
    }
}

// Modified to make simulated, so can be used on a net client
// Especially as simulated function GetTeamNum() relies on this!
simulated function Vehicle GetVehicleBase()
{
    return VehicleBase;
}

// New helper function to check whether the base vehicle is an armored vehicle class & to populate an actor reference if it is
simulated function bool GetArmoredVehicleBase(out DHArmoredVehicle AV)
{
    AV = DHArmoredVehicle(VehicleBase);

    return AV != none;
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
simulated function DisplayVehicleMessage(int MessageNumber, optional Pawn P, optional bool bPassController)
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

// Emptied out as blast damage to exposed vehicle occupants is now handled from HurtRadius() in the projectile class
function DriverRadiusDamage(float DamageAmount, float DamageRadius, Controller EventInstigator, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
}

// Functions emptied out as not relevant to a VehicleWeaponPawn in RO/DH:
simulated event StartDriving(Vehicle V);
simulated event StopDriving(Vehicle V);
function bool IsHeadShot(vector Loc, vector Ray, float AdditionalScale) { return false; }
function AttachFlag(Actor FlagActor);
function ShouldCrouch(bool Crouch);
function ShouldProne(bool Prone);
event EndCrouch(float HeightAdjust);
event StartCrouch(float HeightAdjust);
function bool DoJump(bool bUpdating) { return false; }
function bool CheckWaterJump(out vector WallNormal) { return false; }
function JumpOutOfWater(vector JumpDir);
function ClimbLadder(LadderVolume L);
function EndClimbLadder(LadderVolume OldLadder);
function ShouldTargetMissile(Projectile P);
function ShootMissile(Projectile P);
function GiveWeapon(string aClassName);
simulated function bool CanThrowWeapon() { return false; }
function TossWeapon(vector TossVel);
exec function SwitchToLastWeapon();
simulated function ChangedWeapon();
function ServerChangedWeapon(Weapon OldWeapon, Weapon NewWeapon);
function bool AddInventory(Inventory NewItem) { return false; }
function DeleteInventory(Inventory Item);
function Inventory FindInventoryType(class DesiredClass) { return none; }
simulated function Weapon GetDemoRecordingWeapon() { return none; }
exec function NextItem(); // only concerns UT2004 PowerUps) & just causes "accessed none" log errors if keybound & used

///////////////////////////////////////////////////////////////////////////////////////
//  *************************** DEBUG EXEC FUNCTIONS  *****************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New helper function to check whether debug execs can be run
simulated function bool IsDebugModeAllowed()
{
    return Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode();
}

// New exec function to toggle between external & internal meshes (mostly useful with behind view if want to see internal mesh)
exec function ToggleMesh()
{
    local int i;

    if (IsDebugModeAllowed() && DriverPositions.Length > 0)
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

    if (IsDebugModeAllowed() && Gun != none) // removed requirement to be in single player mode, as valid in multi-player if in DHDebugMode
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

// New debug exec to adjust the yaw limits for the current 'driver' position
exec function SetViewLimits(int NewPitchUp, int NewPitchDown, int NewYawRight, int NewYawLeft)
{
    if (IsDebugModeAllowed())
    {
        Log(Tag @ ": ViewPitchUpLimit =" @ NewPitchUp @ "ViewPitchDownLimit =" @ NewPitchDown @ "ViewPositiveYawLimit =" @ NewYawRight @ "ViewNegativeYawLimit =" @ NewYawLeft
            @ "(was" @ DriverPositions[DriverPositionIndex].ViewPitchUpLimit @ DriverPositions[DriverPositionIndex].ViewPitchDownLimit
            @ DriverPositions[DriverPositionIndex].ViewPositiveYawLimit @ DriverPositions[DriverPositionIndex].ViewNegativeYawLimit $ ")");

        DriverPositions[DriverPositionIndex].ViewPitchUpLimit = NewPitchUp;
        DriverPositions[DriverPositionIndex].ViewPitchDownLimit = NewPitchDown;
        DriverPositions[DriverPositionIndex].ViewPositiveYawLimit = NewYawRight;
        DriverPositions[DriverPositionIndex].ViewNegativeYawLimit = NewYawLeft;
    }
}

// New debug exec to toggles showing any collision static mesh actor
exec function ShowColMesh()
{
    local int i;

    if (VehWep != none && VehWep.CollisionMeshActors.Length > 0 && IsDebugModeAllowed() && Level.NetMode != NM_DedicatedServer)
    {
        for (i = 0; i < VehWep.CollisionMeshActors.Length; ++i)
        {
            // If in normal mode, with CSM hidden, we toggle the CSM to be visible
            if (VehWep.CollisionMeshActors[i].DrawType == DT_None)
            {
                VehWep.CollisionMeshActors[i].ToggleVisible();
            }
            // Or if CSM has already been made visible & so is the weapon, we next toggle the weapon to be hidden
            else if (VehWep.Skins[0] != Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha')
            {
                VehWep.CollisionMeshActors[i].HideOwner(true); // can't simply make weapon DrawType=none or bHidden, as that also hides all attached actors, including col mesh & player
            }
            // Or if CSM has already been made visible & the weapon has been hidden, we now go back to normal mode, by toggling weapon back to visible & CSM to hidden
            else
            {
                VehWep.CollisionMeshActors[i].HideOwner(false);
                VehWep.CollisionMeshActors[i].ToggleVisible();
            }
        }
    }
}

// New debug exec to set the projectile's launch position offset in the X axis
exec function SetWeaponFireOffset(float NewValue)
{
    if (IsDebugModeAllowed() && Gun != none)
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
exec function SetAttachOffset(string NewX, string NewY, string NewZ)
{
    if (IsDebugModeAllowed() && VehWep != none)
    {
        Log(VehWep.Tag @ "WeaponAttachOffset =" @ float(NewX) @ float(NewY) @ float(NewZ) @ "(was" @ VehWep.WeaponAttachOffset $ ")");
        VehWep.WeaponAttachOffset.X = float(NewX);
        VehWep.WeaponAttachOffset.Y = float(NewY);
        VehWep.WeaponAttachOffset.Z = float(NewZ);
        VehWep.SetRelativeLocation(VehWep.WeaponAttachOffset);
    }
}

// New debug exec to adjust position of hatch fire
exec function SetFEOffset(int NewX, int NewY, int NewZ, optional float NewScale)
{
    if (IsDebugModeAllowed() && Level.NetMode != NM_DedicatedServer && VehWep != none)
    {
        if (NewScale == 0.0)
        {
            NewScale = VehWep.FireEffectScale;
        }

        // Only update offset if something has been entered (otherwise just entering "SetFEOffset" is quick way of triggering hatch fire at current position)
        if (NewX != 0 || NewY != 0 || NewZ != 0 || NewScale != VehWep.FireEffectScale)
        {
            Log(VehWep.Tag @ "FireEffectOffset =" @ NewX @ NewY @ NewZ @ "scale =" @ NewScale @ "(old was" @ VehWep.FireEffectOffset @ "scale =" @ VehWep.FireEffectScale $ ")");
            VehWep.FireEffectOffset.X = NewX;
            VehWep.FireEffectOffset.Y = NewY;
            VehWep.FireEffectOffset.Z = NewZ;
            VehWep.FireEffectScale = NewScale;
        }
        else
        {
            Log(VehWep.Tag @ "FireEffectOffset =" @ VehWep.FireEffectOffset @ "scale =" @ VehWep.FireEffectScale);
        }

        VehWep.StartHatchFire();
    }
}

// New debug exec to adjust size of gunsight overlay
exec function SetSightSize(float NewValue)
{
    Log(Tag @ "GunsightSize =" @ NewValue @ " (was" @ GunsightSize $ ")");
    GunsightSize = NewValue;
}

// New debug exec to adjust ambient sound radius
exec function SetSoundRadius(float NewValue)
{
    if (IsDebugModeAllowed() && Gun != none)
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

// New debug exec to adjust all the view shake settings
exec function SetShake(string RotMag, string RotRate, string RotTime, string OffMag, string OffRate, string OffTime)
{
    if (IsDebugModeAllowed() && Gun != none)
    {
        log(Gun.Tag @ "ShakeRotMag =" @ RotMag @ "ShakeRotRate =" @ RotRate @ "ShakeRotTime =" @ RotTime @ "ShakeOffsetMag =" @ OffMag @ "ShakeOffsetRate =" @ OffRate @ "ShakeOffsetTime =" @ OffTime
            @ "  Rot was" @ Gun.ShakeRotMag.Z @ Gun.ShakeRotRate.Z @ Gun.ShakeRotTime @ "  Offset was" @ Gun.ShakeOffsetMag.Z @ Gun.ShakeOffsetRate.Z @ Gun.ShakeOffsetTime);

        Gun.ShakeRotMag.Z = float(RotMag);
        Gun.ShakeRotRate.Z = float(RotRate);
        Gun.ShakeRotTime = float(RotTime);
        Gun.ShakeOffsetMag.Z = float(OffMag);
        Gun.ShakeOffsetRate.Z = float(OffRate);
        Gun.ShakeOffsetTime = float(OffTime);
    }
}

// Modified to use a small font so the extensive vehicle debug info fits on the screen (before a lot of it was missing at the bottom of the screen)
// Also re-stating & slightly modifying the Super from VehicleWeaponPawn to improve the formatting
simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
    Canvas.Font = Canvas.SmallFont;

    super(Vehicle).DisplayDebug(Canvas, YL, YPos);

    YPos += YL;
    Canvas.SetPos(0.0, YPos);
    Canvas.SetDrawColor(0, 64, 192);

    if (Gun != none)
    {
        Canvas.DrawText("-- GUN:" @ GetItemName(string(Gun)));
        YPos += YL;
        Canvas.SetPos(4.0, YPos);
        Gun.DisplayDebug(Canvas, YL, YPos);
    }
    else
    {
        Canvas.DrawText("-- NO GUN");
    }

    if (DebugInfo != "")
    {
        YPos += YL;
        Canvas.SetPos(0.0, YPos);
        Canvas.SetDrawColor(255, 0, 0);
        Canvas.DrawText(DebugInfo);
        DebugInfo = "";
    }
}

defaultproperties
{
    bCustomAiming=true
    bHasAltFire=false
    BinocPositionIndex=-1 // none by default, so set an invalid position
    SpottingScopePositionIndex=-1
    WeaponFOV=0.0 // neutralise inherited RO value, so unless overridden in subclass we will use the player's default view FOV (i.e. player's normal FOV when on foot)
    DriveAnim=""
    TPCamDistance=300.0
    TPCamLookat=(X=-25.0,Y=0.0,Z=0.0)
    TPCamWorldOffset=(X=0.0,Y=0.0,Z=120.0)

    // These variables are effectively deprecated & should not be used - they are either ignored or values below are assumed & may be hard coded into functionality:
    bPCRelativeFPRotation=true
    bZeroPCRotOnEntry=false // no point, as on entering we now call SetInitialViewRotation() to set weapon pawn's rotation & PC rotation gets matched to that
    bFPNoZFromCameraPitch=false
    FPCamViewOffset=(X=0.0,Y=0.0,Z=0.0) // always use FPCamPos for any camera offset, including for single position weapon pawns
    bAllowViewChange=false
    bDesiredBehindView=false
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn

    // RangeString="Range"
    // ElevationString="Elevation"
}

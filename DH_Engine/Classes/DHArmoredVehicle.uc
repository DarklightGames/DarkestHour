//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHArmoredVehicle extends DHVehicle
    abstract;

#exec OBJ LOAD FILE=..\sounds\Amb_Destruction.uax
#exec OBJ LOAD FILE=..\Textures\DH_VehicleOptics_tex.utx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex2.utx

struct ArmorSection
{
    var     float   Thickness;         // in cm
    var     float   Slope;             // in degrees from vertical (must specify a negative if armor slopes 'inwards')
    var     float   MaxRelativeHeight; // max height (in UU) of this armor section, relative to hull mesh's centre
    var     string  LocationName;      // e.g. "lower front", "driver's upstand plate"
};

enum ENewHitPointType
{
    NHP_Normal,
    NHP_GunOptics,
    NHP_PeriscopeOptics,
    NHP_Traverse,
    NHP_GunPitch,
};

struct NewHitpoint
{
    var   float             PointRadius;
    var   name              PointBone;
    var   vector            PointOffset;
    var   float             DamageMultiplier;
    var   ENewHitPointType  NewHitPointType;
};

// General
var     int         UnbuttonedPositionIndex;    // lowest DriverPositions index where driver is unbuttoned & exposed
var     vector      OverlayFPCamPos;            // optional camera offset for overlay position, so can snap to exterior view position, avoiding camera anims passing through hull
var     texture     PeriscopeOverlay;           // driver's periscope overlay texture
var     float       PeriscopeSize;              // so we can adjust the "exterior" FOV of the periscope overlay, just like Gunsights, if needed
var     texture     DamagedPeriscopeOverlay;    // periscope overlay to show if optics have been broken
var     bool        bUsesCodedDestroyedSkins;   // Uses code to create a combiner for the destroyed mesh skins, rather than using one from a texture package

// Vehicle locking
var     bool        bVehicleLocked;             // vehicle has been locked by a player, stopping new players from entering tank crew positions
var     float       UnlockVehicleTime;          // the next time to check whether to unlock a locked vehicle that its crew may have abandoned

// Armor penetration
var     array<ArmorSection> FrontArmor;        // array of armor properties (divided into horizontal bands) for each side of vehicle
var     array<ArmorSection> RightArmor;
var     array<ArmorSection> LeftArmor;
var     array<ArmorSection> RearArmor;
var     bool        bVehicleHit;                // A simple check used in TakeDamage to inflict non-penetrating damage; when we don't want to use radius damage
var     bool        bHasAddedSideArmor;         // this vehicle has added side armour skirts (schurzen) that will stop HEAT rounds
var     bool        bProjectilePenetrated;      // shell has passed penetration tests & has entered the vehicle (used in TakeDamage)
var     bool        bTurretPenetration;         // shell has penetrated the turret (used in TakeDamage)
var     bool        bRearHullPenetration;       // shell has penetrated the rear hull (so TakeDamage can tell if an engine hit should stop the round penetrating any further)

// Damage
var     array<NewHitpoint>  NewVehHitpoints;    // an array of extra hit points (new DH types) that may be hit & damaged
var     int         GunOpticsHitPointIndex;     // index of any special hit point for exposed gunsight optics, which may be damaged by a bullet
var     float       AmmoIgnitionProbability;    // chance that direct hit on ammo store will ignite it
var     float       TurretDetonationThreshold;  // chance that shrapnel will detonate turret ammo
var     float       DriverKillChance;           // chance that shrapnel will kill driver
var     float       CommanderKillChance;        // chance that shrapnel will kill commander
var     float       GunnerKillChance;           // chance that shrapnel will kill bow gunner
var     float       GunDamageChance;            // chance that shrapnel will damage gun pivot mechanism
var     float       TraverseDamageChance;       // chance that shrapnel will damage gun traverse mechanism or turret ring is jammed
var     float       OpticsDamageChance;         // chance that shrapnel will break gunsight optics
var     float       SpikeTime;                  // saved future time when a disabled vehicle will be automatically blown up, if empty at that time

// Fire stuff- Shurek & Ch!cKeN (modified by Matt)
var     class<DamageType>           VehicleBurningDamType;
var     class<VehicleDamagedEffect> FireEffectClass;
var     VehicleDamagedEffect        DriverHatchFireEffect;
var     name        FireAttachBone;
var     vector      FireEffectOffset;
var     float       HullFirePercent; //helper variable
var     bool        bOnFire;               // the vehicle itself is on fire
var     float       HullFireDamagePer2Secs;
var     float       PlayerFireDamagePer2Secs;
var     float       NextHullFireDamageTime;
var     float       EngineFirePercent; //helper variable
var     bool        bEngineOnFire;
var     float       EngineFireDamagePer3Secs;
var     float       NextEngineFireDamageTime;
var     bool        bSetHullFireEffects;
var     bool        bDriverHatchFireNeeded;
var     float       DriverHatchFireSpawnTime;
var     bool        bTurretFireNeeded;
var     float       TurretHatchFireSpawnTime;
var     bool        bHullMGFireNeeded;
var     float       HullMGHatchFireSpawnTime;
var     float       FireDetonationChance;   // chance of a fire blowing a vehicle up, runs each time the fire does damage
var     float       EngineToHullFireChance; // chance of an engine fire spreading to the rest of the vehicle, runs each time engine takes fire damage
var     bool        bFirstPenetratingHit;
var     bool        bHEATPenetration;       // a penetrating round is a HEAT round
var     Controller  WhoSetOnFire;
var     int         HullFireStarterTeam;
var     Controller  WhoSetEngineOnFire;
var     int         EngineFireStarterTeam;
var     sound       SmokingEngineSound;
var     bool        bEnableHatchFires;     // allow hatch fires for this vehicle

// Debugging
var     bool        bDebugPenetration;    // debug lines & text on screen, relating to turret hits & penetration calculations
var     bool        bLogDebugPenetration; // similar debug log entries

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bOnFire, bEngineOnFire;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerToggleVehicleLock;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ********************** ACTOR INITIALISATION & DESTRUCTION  ********************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to set fire damage properties
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        // Set fire damage rates
        HullFireDamagePer2Secs = HealthMax * 0.02;             // so approx 100 seconds from full vehicle health to detonation due to fire
        EngineFireDamagePer3Secs = default.EngineHealth * 0.1; // so approx 30 seconds engine fire until engine destroyed
    }
}

// Modified to unlock a locked vehicle (unlocking isn't directly necessary, but unlocking it finds & clears any references to the now destroyed vehicle)
simulated function Destroyed()
{
    super.Destroyed();

    if (bVehicleLocked && Role == ROLE_Authority)
    {
        SetVehicleLocked(false);
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ***************************** KEY ENGINE EVENTS  ******************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to handle fire effects
simulated function PostNetReceive()
{
    super.PostNetReceive();

    if (bOnFire)
    {
        // Vehicle fire has started
        if (!bSetHullFireEffects && Health > 0)
        {
            SetFireEffects();
        }
    }
    else if (bEngineOnFire)
    {
        // Engine fire has started (DEHFireFactor of 1.0 would flag that the engine fire effect is already on)
        if (DamagedEffectHealthFireFactor != 1.0 && Health > 0 && EngineHealth > 0)
        {
            SetEngineFireEffects();
        }
    }
    // Engine is dead & engine fire has burned out, so set it to smoke instead of burn
    else if (EngineHealth <= 0 && (DamagedEffectHealthFireFactor != 0.0 || DamagedEffectHealthHeavySmokeFactor != 1.0) && Health > 0)
    {
        SetEngineFireEffects();
    }
}

// Modified to use a system of interwoven timers instead of constantly checking for things in Tick() - fire damage, spiked vehicle timer
simulated function Timer()
{
    local float Now;

    if (Health <= 0)
    {
        return;
    }

    Now = Level.TimeSeconds;

    if (Role == ROLE_Authority)
    {
        // Handle any hull fire damage due
        if (bOnFire && Now >= NextHullFireDamageTime)
        {
            TakeFireDamage();
        }

        // Handle any engine fire damage due
        if (bEngineOnFire && Now >= NextEngineFireDamageTime)
        {
            TakeEngineFireDamage();
        }

        // Check to see if we need to destroy a spiked, abandoned vehicle
        if (bSpikedVehicle && Now >= SpikeTime)
        {
            if (IsVehicleEmpty() && !bOnFire)
            {
                KilledBy(self);
            }
            else
            {
                bSpikedVehicle = false; // cancel spike timer if vehicle is now occupied or burning (just let the fire destroy it)
            }
        }

        // Unlock a locked vehicle that has been abandoned by its crew
        if (UnlockVehicleTime != 0.0 && Now >= UnlockVehicleTime)
        {
            if (bVehicleLocked && Health > 0)
            {
                SetVehicleLocked(false);
            }

            UnlockVehicleTime = 0.0; // note this must come after unlocking vehicle, as when DHPawns get notified they need to be able to tell it's from this unlock timer
        }
    }

    // Vehicle is burning, so check if we need to spawn any hatch fire effects
    if (bOnFire && Level.NetMode != NM_DedicatedServer)
    {
        if (bDriverHatchFireNeeded && Now >= DriverHatchFireSpawnTime && DriverHatchFireSpawnTime != 0.0)
        {
            StartDriverHatchFire();
        }

        if (bTurretFireNeeded && Now >= TurretHatchFireSpawnTime && TurretHatchFireSpawnTime != 0.0)
        {
            bTurretFireNeeded = false;

            if (Cannon != none)
            {
                Cannon.StartHatchFire();
            }
        }

        if (bHullMGFireNeeded && Now >= HullMGHatchFireSpawnTime && HullMGHatchFireSpawnTime != 0.0)
        {
            bHullMGFireNeeded = false;

            if (MGun != none)
            {
                MGun.StartHatchFire();
            }
        }
    }

    // Engine is dead, but there's no fire, so make sure it is set to smoke instead of burn
    if (EngineHealth <= 0 && !IsEngineBurning() && (DamagedEffectHealthFireFactor != 0.0 || DamagedEffectHealthHeavySmokeFactor != 1.0))
    {
        SetEngineFireEffects();
    }

    SetNextTimer(Now);
}

// New function as we are using timers for different things in different net modes, so work out which one (if any) is due next
simulated function SetNextTimer(optional float Now)
{
    local float NextTimerTime;

    if (Now == 0.0)
    {
        Now = Level.TimeSeconds;
    }

    if (Role == ROLE_Authority)
    {
        if (bOnFire && NextHullFireDamageTime > Now)
        {
            NextTimerTime = NextHullFireDamageTime;
        }

        if (bEngineOnFire && (NextEngineFireDamageTime < NextTimerTime || NextTimerTime == 0.0) && NextEngineFireDamageTime > Now)
        {
            NextTimerTime = NextEngineFireDamageTime;
        }

        if (bSpikedVehicle && (SpikeTime < NextTimerTime || NextTimerTime == 0.0) && SpikeTime > Now)
        {
            NextTimerTime = SpikeTime;
        }

        if (bVehicleLocked && (UnlockVehicleTime < NextTimerTime || NextTimerTime == 0.0) && UnlockVehicleTime > Now)
        {
            NextTimerTime = UnlockVehicleTime;
        }
    }

    if (Level.NetMode != NM_DedicatedServer && bOnFire)
    {
        if (bDriverHatchFireNeeded && (DriverHatchFireSpawnTime < NextTimerTime || NextTimerTime == 0.0) && DriverHatchFireSpawnTime > Now)
        {
            NextTimerTime = DriverHatchFireSpawnTime;
        }

        if (bTurretFireNeeded && (TurretHatchFireSpawnTime < NextTimerTime || NextTimerTime == 0.0) && TurretHatchFireSpawnTime > Now)
        {
            NextTimerTime = TurretHatchFireSpawnTime;
        }

        if (bHullMGFireNeeded && (HullMGHatchFireSpawnTime < NextTimerTime || NextTimerTime == 0.0) && HullMGHatchFireSpawnTime > Now)
        {
            NextTimerTime = HullMGHatchFireSpawnTime;
        }
    }

    // Finally set the next timer, if we need one
    if (NextTimerTime > Now)
    {
        SetTimer(NextTimerTime - Now, false);
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *******************************  VIEW/DISPLAY  ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to add support for periscope texture overlay
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
            // Draw periscope overlay
            if (HUDOverlay == none)
            {
                // Save current HUD opacity & then set up for drawing overlays
                SavedOpacity = C.ColorModulate.W;
                C.ColorModulate.W = 1.0;
                C.DrawColor.A = 255;
                C.Style = ERenderStyle.STY_Alpha;

                DrawPeriscopeOverlay(C);

                C.ColorModulate.W = SavedOpacity; // reset HudOpacity to original value
            }
            // Draw any HUD overlay
            else if (!Level.IsSoftwareRendering())
            {
                HUDOverlay.SetLocation(PC.CalcViewLocation + (HUDOverlayOffset >> PC.CalcViewRotation));
                HUDOverlay.SetRotation(PC.CalcViewRotation);
                C.DrawActor(HUDOverlay, false, true, FClamp(HUDOverlayFOV * (PC.DesiredFOV / PC.DefaultFOV), 1.0, 170.0));
            }
        }

        // Draw vehicle, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(C, self);
        }
    }
}

// New function to draw any textured driver's periscope overlay - updated in 2019 to add PeriscopeSize so that we can adjust FOV's
simulated function DrawPeriscopeOverlay(Canvas C)
{
    /*local float ScreenRatio;

    if (PeriscopeOverlay != none)
    {
        ScreenRatio = float(C.SizeY) / float(C.SizeX);
        C.SetPos(0.0, 0.0);

        C.DrawTile(PeriscopeOverlay, C.SizeX, C.SizeY,                            // screen drawing area (to fill screen)
            0.0, (1.0 - ScreenRatio) * float(PeriscopeOverlay.VSize) / 2.0,       // position in texture to begin drawing tile (from left edge, with vertical position to suit screen aspect ratio)
            PeriscopeOverlay.USize, float(PeriscopeOverlay.VSize) * ScreenRatio); // width & height of tile within texture
    }
    */
    local float TextureSize, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight;

    if (PeriscopeOverlay != none)
    {
        // The drawn portion of the gunsight texture is 'zoomed' in or out to suit the desired scaling
        // This is inverse to the specified GunsightSize, i.e. the drawn portion is reduced to 'zoom in', so sight is drawn bigger on screen
        // The draw start position (in the texture, not the screen position) is often negative, meaning it starts drawing from outside of the texture edges
        // Draw areas outside the texture edges are drawn black, so this handily blacks out all the edges around the scaled gunsight, in 1 draw operation
        TextureSize = float(PeriscopeOverlay.MaterialUSize());
        TilePixelWidth = TextureSize / PeriscopeSize * 0.955; // width based on vehicle's GunsightSize (0.955 factor widens visible FOV to full screen for 'standard' overlay if GS=1.0)
        TilePixelHeight = TilePixelWidth * float(C.SizeY) / float(C.SizeX); // height proportional to width, maintaining screen aspect ratio
        TileStartPosU = (TextureSize - TilePixelWidth) / 2.0;// - OverlayCorrectionX;
        TileStartPosV = (TextureSize - TilePixelHeight) / 2.0;// - OverlayCorrectionY;

        // Draw the periscope overlay
        C.SetPos(0.0, 0.0);

        C.DrawTile(PeriscopeOverlay, C.SizeX, C.SizeY, TileStartPosU, TileStartPosV, TilePixelWidth, TilePixelHeight);
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************* VEHICLE ENTRY, EXIT & SWITCHING POSITIONS ****************** //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to prevent entry if either vehicle or engine is on fire (with message if own team's vehicle)
function Vehicle FindEntryVehicle(Pawn P)
{
    if ((IsVehicleBurning()) || (IsEngineBurning()))
    {
        if (P != none && (P.GetTeamNum() == VehicleTeam || !bTeamLocked))
        {
            DisplayVehicleMessage(5, P); // vehicle is on fire
        }

        return none;
    }

    return super.FindEntryVehicle(P);
}

// Modified to handle optional camera offset for initial overlay position
simulated function ClientKDriverEnter(PlayerController PC)
{
    super.ClientKDriverEnter(PC);

    // If initial position is an overlay position (e.g. driver's periscope), apply any optional 1st person camera offset for the overlay
    if (DriverPositions[InitialPositionIndex].bDrawOverlays && OverlayFPCamPos != vect(0.0, 0.0, 0.0))
    {
        FPCamPos = OverlayFPCamPos;
    }
}

// Modified to handle optional camera offset for overlay position
simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        super.HandleTransition();

        if (OverlayFPCamPos != vect(0.0, 0.0, 0.0) && DriverPositions[PreviousPositionIndex].bDrawOverlays && IsFirstPerson())
        {
            FPCamPos = default.FPCamPos; // if moving away from overlay, remove offset immediately
        }
    }

    simulated function EndState()
    {
        super.EndState();

        if (OverlayFPCamPos != vect(0.0, 0.0, 0.0) && DriverPositions[DriverPositionIndex].bDrawOverlays && IsFirstPerson())
        {
            FPCamPos = OverlayFPCamPos; // if moving into overlay, apply offset at end of transition
        }
    }
}

// Modified so if an 'allowed' crewman exits a locked vehicle, we check whether we need to set an unlock timer
function bool KDriverLeave(bool bForceLeave)
{
    local bool bAllowedCrewmanExitingLockedVehicle;

    bAllowedCrewmanExitingLockedVehicle = bVehicleLocked && IsAnAllowedCrewman(Driver) && !(bForceLeave && DHPawn(Driver).SwitchingController != none);

    if (super.KDriverLeave(bForceLeave))
    {
        if (bAllowedCrewmanExitingLockedVehicle)
        {
            CheckSetUnlockTimer(); // note this has to be called after the Super, otherwise exiting player will still be registered as the driver
        }

        return true;
    }

    return false;
}

// Implemented to prevent exit if player is buttoned up, displaying an appropriate "unbutton the hatch" message if he can't
simulated function bool CanExit()
{
    if ((DriverPositionIndex < UnbuttonedPositionIndex || (IsInState('ViewTransition') && DriverPositionIndex == UnbuttonedPositionIndex)) && IsHumanControlled())
    {
        if (DriverPositions.Length > UnbuttonedPositionIndex) // means it is possible to unbutton
        {
            DisplayVehicleMessage(9,, true); // must unbutton the hatch
        }
        else if (MGun != none && MGun.WeaponPawn != none && MGun.WeaponPawn.DriverPositions.Length > MGun.WeaponPawn.UnbuttonedPositionIndex) // means it's possible to exit MG position
        {
            DisplayVehicleMessage(12); // must exit through commander's or MG hatch
        }
        else
        {
            DisplayVehicleMessage(10); // must exit through commander's hatch
        }

        return false;
    }

    return true;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************** VEHICLE LOCKING ******************************* //
///////////////////////////////////////////////////////////////////////////////////////

// New keybind function to toggle whether an armored vehicle is locked, stopping new players from entering tank crew positions
// CanPlayerLockVehicle() is pre-checked by net client for network efficiency, by avoiding sending invalid replicated function calls to server
exec simulated function ToggleVehicleLock()
{
    if (Role == ROLE_Authority || CanPlayerLockVehicle(self))
    {
        ServerToggleVehicleLock();
    }
}

// New client-to-server function to toggle whether an armored vehicle is locked
function ServerToggleVehicleLock()
{
    if (CanPlayerLockVehicle(self) && Role == ROLE_Authority)
    {
        SetVehicleLocked(!bVehicleLocked);
    }
}

// New function to set whether an armored vehicle is locked (stopping new players from entering tank crew positions) or is unlocked
function SetVehicleLocked(bool bNewLockedStatus)
{
    local Controller C;
    local DHPawn     P;
    local int        i;

    bVehicleLocked = bNewLockedStatus;

    // Go through all vehicle positions & update the locked vehicle settings for all occupants
    UpdatePlayersLockedVehicleSettings(self);

    for (i = 0; i < WeaponPawns.Length; ++i)
    {
        UpdatePlayersLockedVehicleSettings(WeaponPawns[i]);
    }

    // If vehicle has been unlocked, we also need to check for any remaining 'allowed' crew who may be outside the vehicle & clear their locked vehicle reference
    // Any players we find who are still registered as allowed crew must be out of the vehicle, as we've just cleared it for anyone in one of our vehicle positions
    if (!bVehicleLocked)
    {
        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            if (IsAnAllowedCrewman(C.Pawn, P))
            {
                P.SetCrewedLockedVehicle(none);
            }
        }
    }
}

// New helper function to set a player's locked vehicle settings, base on whether their vehicle is locked or unlocked
// Includes message to player to tell them that their vehicle has been locked/unlocked
function UpdatePlayersLockedVehicleSettings(Vehicle PlayersVehiclePosition)
{
    local DHPawn P;

    if (PlayersVehiclePosition != none)
    {
        P = DHPawn(PlayersVehiclePosition.Driver);
    }

    if (P != none)
    {
        // If player is a tank crew role, either set or clear the player's CrewedLockedVehicle reference
        if (class'DHPlayerReplicationInfo'.static.IsPlayerTankCrew(PlayersVehiclePosition))
        {
            if (bVehicleLocked)
            {
                P.SetCrewedLockedVehicle(self);
            }
            else
            {
                P.SetCrewedLockedVehicle(none);
            }
        }

        // Update player's bInLockedVehicle flag, so net client's vehicle HUD displays the locked vehicle icon correctly
        P.SetInLockedVehicle(bVehicleLocked);

        // Notify the player that the vehicle was just locked or unlocked
        if (bVehicleLocked)
        {
            DisplayVehicleMessage(20, PlayersVehiclePosition); // "tank crew positions in this vehicle have now been locked"
        }
        else
        {
            DisplayVehicleMessage(21, PlayersVehiclePosition); // "tank crew positions in this vehicle have now been unlocked"
        }
    }
}

// Modified to handle vehicle locking functionality for a tank or similar armored vehicle
// If vehicle is locked & the new player has entered a tank position, it makes sure he is registered as allowed to use the vehicle
// If vehicle is locked but has an unlock timer running, meaning its crew had exited, if new player is an allowed crewman the timer is cancelled
// If vehicle isn't locked but new crewman has the 'lock tank on entry' option enabled & is a tanker, it attempts to lock the vehicle automatically
function UpdateVehicleLockOnPlayerEntering(Vehicle EntryPosition)
{
    local DHPawn            Player;
    local VehicleWeaponPawn WP;
    local bool              bEnteredTankCrewPosition, bFoundCrewman;
    local int               i;

    if (EntryPosition != none)
    {
        Player = DHPawn(EntryPosition.Driver);
    }

    if (Player == none)
    {
         return;
    }

    if (EntryPosition == self)
    {
        bEnteredTankCrewPosition = bMustBeTankCommander;
    }
    else
    {
        bEnteredTankCrewPosition = EntryPosition.IsA('ROVehicleWeaponPawn') && ROVehicleWeaponPawn(EntryPosition).bMustBeTankCrew;
    }

    if (bVehicleLocked)
    {
        // If an allowed crewman just entered (any vehicle position), cancel any unlock timer that's been set
        if (IsAnAllowedCrewman(Player))
        {
            CancelAnyVehicleUnlockTimer();
        }
    }
    // If player has the 'lock tank on entry' option enabled & he's a tank crewman, he attempts to lock the vehicle automatically
    // This only works if there are no other tank crew in the vehicle (& the vehicle must be for tank crew only)
    else if (bEnteredTankCrewPosition && DHPlayer(EntryPosition.Controller) != none && DHPlayer(EntryPosition.Controller).bLockTankOnEntry
        && class'DHPlayerReplicationInfo'.static.IsPlayerTankCrew(EntryPosition) && bMustBeTankCommander)
    {
        // Check through vehicle positions to see if if there is a tank crewman already in the vehicle
        if (Driver != none && Driver != Player && class'DHPlayerReplicationInfo'.static.IsPlayerTankCrew(self))
        {
            bFoundCrewman = true;
        }
        else
        {
            for (i = 0; i < WeaponPawns.Length; ++i)
            {
                WP = WeaponPawns[i];

                if (WP != none && WP.Driver != none && WP.Driver != Player && class'DHPlayerReplicationInfo'.static.IsPlayerTankCrew(WP))
                {
                    bFoundCrewman = true;
                    break;
                }
            }
        }

        // If we didn't find any tank crew, the entering player locks the vehicle automatically
        if (!bFoundCrewman)
        {
            SetVehicleLocked(true);
        }
    }

    // Update player's bInLockedVehicle flag, so a net client's vehicle HUD displays the locked vehicle icon correctly
    Player.SetInLockedVehicle(bVehicleLocked);
}

// New function to check whether we need to set a timer to unlock a locked armored vehicle after a set period
// This happens if the 'allowed' crew have left the vehicle & it may be abandoned
function CheckSetUnlockTimer()
{
    local int i;

    if (IsAnAllowedCrewman(Driver))
    {
        return;
    }

    for (i = 0; i < WeaponPawns.Length; ++i)
    {
        if (IsAnAllowedCrewman(WeaponPawns[i]))
        {
            return;
        }
    }

    // No allowed crew left in the vehicle, so we set an unlock timer
    SetVehicleUnlockTimer();
}

// New function to check whether we need to either (1) unlock the vehicle now (if no 'allowed' crew remain alive)
// Or (2) set a timer to unlock it after a set period (if there are still allowed crew, but none currently in the vehicle, e.g. they may be outside scouting etc)
// Makes sure that if all tank crew members are killed or abandon a locked vehicle, it doesn't stay locked forever
function CheckUnlockVehicle()
{
    local Controller C;
    local bool       bFoundAllowedCrewmanOutOfVehicle;

    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        // Found an allowed crewman
        if (IsAnAllowedCrewman(C.Pawn))
        {
            // Do nothing if any 'allowed' crewman is still in this vehicle
            if (C.Pawn == self || (C.Pawn.IsA('VehicleWeaponPawn') && VehicleWeaponPawn(C.Pawn).VehicleBase == self))
            {
                return;
            }

            // This allowed crewman is not currently in the vehicle, so for now we just record that we've found at least one such crewman
            bFoundAllowedCrewmanOutOfVehicle = true;
        }
    }

    // No allowed crewman left in the vehicle but we did find one away from it, so it remains locked, but we set an unlock timer
    if (bFoundAllowedCrewmanOutOfVehicle)
    {
        SetVehicleUnlockTimer();
    }
    // No allowed crew remain alive, so unlock the vehicle now, & cancel any unlock timer
    else
    {
        SetVehicleLocked(false);
        CancelAnyVehicleUnlockTimer();
    }
}

// New function to set a timer to unlock a locked armored vehicle after a set period
// Triggered when all 'allowed' crew exit a locked vehicle, so it may be abandoned
function SetVehicleUnlockTimer()
{
    UnlockVehicleTime = Level.TimeSeconds + class'DarkestHourGame'.default.EmptyTankUnlockTime;
    SetNextTimer();
}

// New function to check whether an unlock timer has been set & to cancel it if so
function CancelAnyVehicleUnlockTimer()
{
    if (UnlockVehicleTime != 0.0)
    {
        UnlockVehicleTime = 0.0;
        SetNextTimer(); // checks whether some other event now requires a timer setting
    }
}

// New helper function to check whether a player is allowed to lock or unlock an armored vehicle
// If there is more than one human player in a tank crew position, only the most senior crewman is allowed to lock/unlock the vehicle
// This is based on their position in the vehicle - any commander is most senior, then any driver, then any other crew (i.e. MG position)
simulated function bool CanPlayerLockVehicle(Vehicle PlayersVehiclePosition)
{
    local DHPlayer     PC;
    local DH_LevelInfo LI;
    local int          FailMessageNumber;

    FailMessageNumber = -1; // start with an invalid number, so later we know if a genuine failure has occured

    PC = DHPlayer(PlayersVehiclePosition.Controller);

    if (PC != none)
    {
        LI = PC.GetLevelInfo();
    }

    // Not if this armored vehicle isn't for tank crew only (very unlikely for an armored vehicle, but possible - perhaps for a scenario map)
    if (!bMustBeTankCommander)
    {
        FailMessageNumber = 25; // can't lock vehicle as it can be driven by non-tank crew roles
    }
    // Not if the player isn't a tank crew role
    else if (!class'DHPlayerReplicationInfo'.static.IsPlayerTankCrew(PlayersVehiclePosition))
    {
        FailMessageNumber = 26; // only tank crew roles can lock or unlock vehicle
    }
    // Not if the player isn't a tank crew role
    else if (PlayersVehiclePosition.IsA('ROVehicleWeaponPawn') && !ROVehicleWeaponPawn(PlayersVehiclePosition).bMustBeTankCrew)
    {
        FailMessageNumber = 27; // can only lock or unlock vehicle if you are in a tank crew position
    }
    // Not if another human player is in the vehicle commander's position
    else if (Cannon != none && Cannon.WeaponPawn != none && Cannon.WeaponPawn.PlayerReplicationInfo != none && !Cannon.WeaponPawn.PlayerReplicationInfo.bBot)
    {
        if (PlayersVehiclePosition != Cannon.WeaponPawn)
        {
            FailMessageNumber = 28; // only the most senior crew position can lock or unlock vehicle
        }
    }
    // Not if another human player is in the driver's 's position (& we already know our player isn't the commander)
    else if (PlayerReplicationInfo != none && !PlayerReplicationInfo.bBot && PlayersVehiclePosition != self)
    {
        FailMessageNumber = 28; // only the most senior crew position can lock or unlock vehicle
    }

    // Player cannot lock/unlock vehicle, so give him a screen message to say why not
    if (FailMessageNumber >= 0)
    {
        DisplayVehicleMessage(FailMessageNumber, PlayersVehiclePosition);

        return false;
    }

    // Player can lock/unlock this vehicle -  he's a tank crewman in a crew position & there are no other crewmen who rank above him
    return true;
}

// Implemented here to check whether a player is prevented from entering a tank crew position in an armored vehicle that has been locked
// If vehicle is locked, entry is allowed if player is registered as an 'allowed' crewman, i.e. they were in it when it was locked
// Displays a screen message if player isn't allowed in, unless that is flagged to be avoided
function bool AreCrewPositionsLockedForPlayer(Pawn P, optional bool bNoMessageToPlayer)
{
    if (bVehicleLocked && P != none)
    {
        // Player is one of the allowed crew, so allow him in
        if (IsAnAllowedCrewman(P))
        {
            return false;
        }

        // Player is locked out of this vehicle's crew positions, so display screen message to notify him (unless flagged not to show message)
        if (!bNoMessageToPlayer)
        {
            DisplayVehicleMessage(22, P); // this vehicle has been locked by its crew
        }

        return true;
    }

    return false;
}

// New helper function to check whether a pawn is 'allowed' crewman for this vehicle, if it is locked
function bool IsAnAllowedCrewman(Pawn P, optional out DHPawn DHP)
{
    if (Vehicle(P) != none) // if pawn is a vehicle position, switch pawn to be its occupant
    {
        P = Vehicle(P).Driver;
    }

    DHP = DHPawn(P);

    return DHP != none && DHP.CrewedLockedVehicle == self;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************** VEHICLE FIRES  ******************************** //
///////////////////////////////////////////////////////////////////////////////////////

// New function to handle starting a hull fire
function StartHullFire(Pawn InstigatedBy)
{
    bOnFire = true;

    if (bDebuggingText)
    {
        Log("Vehicle set on fire");
    }

    // Record the player responsible for starting fire, so score can be awarded later if results in a kill
    if (InstigatedBy != none)
    {
        WhoSetOnFire = InstigatedBy.Controller;
        DelayedDamageInstigatorController = WhoSetOnFire;
    }

    if (WhoSetOnFire != none)
    {
        HullFireStarterTeam = WhoSetOnFire.GetTeamNum();
    }

    // Set the 1st hull damage due in 2 seconds
    NextHullFireDamageTime = Level.TimeSeconds + 2.0;

    // Start fire effects, including timers for delayed hatch fires
    SetFireEffects();

    // Set timer for damage only on dedicated server (other authority modes get this in SetFireEffects)
    if (Level.NetMode == NM_DedicatedServer)
    {
        SetNextTimer();
    }
}

// New function to handle starting an engine fire
function StartEngineFire(Pawn InstigatedBy)
{
    bEngineOnFire = true;

    if (bDebuggingText)
    {
        Log("Engine set on fire");
    }

    // Record the player responsible for starting fire, so score can be awarded later if results in a kill
    if (InstigatedBy != none)
    {
        WhoSetEngineOnFire = InstigatedBy.Controller;

        if (WhoSetEngineOnFire != none)
        {
            EngineFireStarterTeam = WhoSetEngineOnFire.GetTeamNum();

            if (DelayedDamageInstigatorController == none) // don't override DDIC if already set, e.g. someone else may already have set hull on fire
            {
                DelayedDamageInstigatorController = WhoSetEngineOnFire;
            }
        }
    }

    // Set fire damage due immediately & call Timer() directly (it handles damage & setting of next due Timer)
    NextEngineFireDamageTime = Level.TimeSeconds;
    Timer();

    // Engine fire effect
    SetEngineFireEffects();
}

// Set up for spawning various hatch fire effects, but randomise start times to desync them
simulated function SetFireEffects()
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (IsVehicleBurning() && bEnableHatchFires)
        {
            // Hatch fire effects
            if (bOnFire && !bSetHullFireEffects)
            {
                bSetHullFireEffects = true;

                // If bClientInitialized or we're an authority role (single player or listen server) then this must have been called as the fire breaks out
                // Randomise the fire effect start times (spreading from the engine forwards) & set a timer
                if (bClientInitialized || Role == ROLE_Authority)
                {
                    if (Cannon != none)
                    {
                        bTurretFireNeeded = true;
                        TurretHatchFireSpawnTime = Level.TimeSeconds + 2.0 + (FRand() * 3.0); // turret hatch fire starts 2-5 secs after fire starts in engine
                    }

                    bDriverHatchFireNeeded = true;
                    DriverHatchFireSpawnTime = FMax(TurretHatchFireSpawnTime, Level.TimeSeconds) + 2.0 + (FRand() * 3.0); // driver hatch fire starts 2-5 secs after turret fire

                    if (MGun != none)
                    {
                        bHullMGFireNeeded = true;
                        HullMGHatchFireSpawnTime = DriverHatchFireSpawnTime + 1.0 + (FRand() * 2.0); // MG hatch fire starts 1-3 secs after turret fire
                    }

                    SetNextTimer();
                }
                // Otherwise this must have been called when an already burning vehicle is replicated to a net client
                // Start driver's hatch fire effect immediately, but let VehicleWeapons start their own fires as those actors replicate
                else
                {
                    StartDriverHatchFire();
                }
            }
        }
    }
}

// Set up for spawning the engine fire effects, but randomise start times to desync them
simulated function SetEngineFireEffects()
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (IsEngineBurning())
        {
            // Engine fire effect
            if (DamagedEffectHealthFireFactor != 1.0)
            {
                DamagedEffectHealthFireFactor = 1.0;
                DamagedEffectHealthSmokeFactor = 1.0; // appears necessary to get native code to spawn a DamagedEffect if it doesn't already exist
                                                      // (presumably doesn't check for fire unless vehicle is at least damaged enough to smoke)

                if (DamagedEffect == none && Health == HealthMax) // clientside Health hack to get native code to spawn DamagedEffect (it won't unless vehicle has taken some damage)
                {
                    Health--;
                }
            }
        }
        // Engine is dead, but there's no fire, so make sure it is set to smoke instead of burn
        else if (EngineHealth <= 0 && (DamagedEffectHealthFireFactor != 0.0 || DamagedEffectHealthHeavySmokeFactor != 1.0))
        {
            DamagedEffectHealthFireFactor = 0.0;
            DamagedEffectHealthHeavySmokeFactor = 1.0;
            DamagedEffectHealthSmokeFactor = 1.0; // appears necessary to get native code to spawn a DamagedEffect if it doesn't already exist
                                                  // (presumably doesn't check for fire or dark smoke unless vehicle is at least damaged enough to lightly smoke)
            if (DamagedEffect != none)
            {
                DamagedEffect.UpdateDamagedEffect(false, 0.0, false, false); // reset existing effect
                DamagedEffect.UpdateDamagedEffect(false, 0.0, false, true);  // then set to dark smoke
            }
            else if (Health == HealthMax) // clientside Health hack to get native code to spawn DamagedEffect (it won't unless vehicle has taken some damage)
            {
                Health--;
            }
        }
    }

    // If engine is off, update sound to burning or smoking sound)
    if (bEngineOff)
    {
        SetEngine();
    }
}


// New function to start a driver's hatch fire effect
simulated function StartDriverHatchFire()
{
    bDriverHatchFireNeeded = false;

    if (DriverHatchFireEffect == none && Level.NetMode != NM_DedicatedServer)
    {
        DriverHatchFireEffect = Spawn(FireEffectClass);
    }

    if (DriverHatchFireEffect != none)
    {
        AttachToBone(DriverHatchFireEffect, FireAttachBone);
        DriverHatchFireEffect.SetRelativeLocation(FireEffectOffset);
        DriverHatchFireEffect.UpdateDamagedEffect(true, 0.0, false, false);

        if (DamagedEffectScale != 1.0)
        {
            DriverHatchFireEffect.SetEffectScale(DamagedEffectScale);
        }
    }
}

// Modified to use more sophisticated burning vehicle system for armored vehicles
simulated function bool IsVehicleBurning()
{
    return bOnFire;
}

// Modified to use more sophisticated burning vehicle system for armored vehicles
simulated function bool IsEngineBurning()
{
    return bEngineOnFire;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ************************  HIT DETECTION & PENETRATION  ************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New function to check if something hit a certain DH NewVehHitpoints (the same as IsPointShot checks for hits on VehHitpoints)
function bool IsNewPointShot(vector HitLocation, vector LineCheck, int Index, optional float CheckDistance)
{
    local coords HitPointCoords;
    local vector HitPointLocation, Difference;
    local float  t, DotMM, ClosestDistance;

    if (NewVehHitpoints[Index].PointBone == '')
    {
        return false;
    }

    // Get location of the hit point we're going to check (with option to handle turret's yaw bone being specified, so hit point rotates with turret)
    if (Cannon != none && NewVehHitpoints[Index].PointBone == Cannon.YawBone)
    {
        HitPointCoords = Cannon.GetBoneCoords(NewVehHitpoints[Index].PointBone);
    }
    else
    {
        HitPointCoords = GetBoneCoords(NewVehHitpoints[Index].PointBone);
    }

    HitPointLocation = HitPointCoords.Origin;

    if (NewVehHitpoints[Index].PointOffset != vect(0.0, 0.0, 0.0))
    {
        HitPointLocation += NewVehHitpoints[Index].PointOffset >> rotator(HitPointCoords.XAxis);
    }

    // Set the hit line to check
    if (CheckDistance > 0.0)
    {
        LineCheck = Normal(LineCheck) * CheckDistance;
    }
    else
    {
        LineCheck *= 150.0;
    }

    // Find closest distance of line check to hit point (all squared for now, for efficiency)
    Difference = HitPointLocation - HitLocation;
    t = LineCheck dot Difference;

    if (t > 0.0) // if not positive it means line check is heading away from hit point, so distance is simply based on HitLocation as that's the closest point
    {
        DotMM = LineCheck dot LineCheck;

        if (t < DotMM)
        {
            t /= DotMM;
            Difference -= t * LineCheck;
        }
        else
        {
            Difference -= LineCheck;
        }
    }

    // Convert distance back from squared & return true if within the hit point's radius (including any scaling)
    ClosestDistance = Sqrt(Difference dot Difference);

    return ClosestDistance < NewVehHitpoints[Index].PointRadius;
}

// Re-written from deprecated ROTreadCraft class for DH's armour penetration system
// Handles penetration calcs for any shell type, & adds including an option for multiple armor sections for each side
simulated function bool ShouldPenetrate(DHAntiVehicleProjectile P, vector HitLocation, vector ProjectileDirection, float MaxArmorPenetration)
{
    local vector  HitLocationRelativeOffset, HitSideAxis, ArmorNormal, X, Y, Z;
    local rotator ArmourSlopeRotator;
    local float   HitLocationAngle, AngleOfIncidence, ArmorThickness, ArmorSlope;
    local float   OverMatchFactor, SlopeMultiplier, EffectiveArmorThickness, PenetrationRatio, ShatterChance;
    local int     i;
    local string  HitSide, OppositeSide, DebugString1, DebugString2, DebugString3;
    local bool    bRearHit, bSideHit;
    local array<ArmorSection> HitSideArmorArray;

    ProjectileDirection = Normal(ProjectileDirection); // should be passed as a normal but we need to be certain
    GetAxes(Rotation, X, Y, Z);

    // Calculate the angle direction of hit relative to vehicle's facing direction, so we can work out out which side was hit (a 'top down 2D' angle calc)
    // Start by getting the offset of HitLocation from vehicle's centre, relative to vehicle's facing direction
    // Then convert to a rotator &, because it's relative, we can simply use the yaw element to give us the angle direction of hit, relative to vehicle
    // Must ignore relative height of hit (represented now by rotator's pitch) as isn't a factor in 'top down 2D' calc & would sometimes actually distort result
    HitLocationRelativeOffset = (HitLocation - Location) << Rotation;
    HitLocationAngle = class'UUnits'.static.UnrealToDegrees(rotator(HitLocationRelativeOffset).Yaw);

    if (HitLocationAngle < 0.0)
    {
        HitLocationAngle += 360.0; // convert negative angles to 180 to 360 degree format
    }

    // Assign settings based on which side we hit
    if (HitLocationAngle >= FrontLeftAngle || HitLocationAngle < FrontRightAngle) // frontal hit
    {
        HitSide = "front";
        OppositeSide = "rear";
        HitSideAxis = X;
    }
    else if (HitLocationAngle >= FrontRightAngle && HitLocationAngle < RearRightAngle) // right side hit
    {
        HitSide = "right";
        OppositeSide = "left";
        HitSideAxis = Y;
    }
    else if (HitLocationAngle >= RearRightAngle && HitLocationAngle < RearLeftAngle) // rear hit
    {
        HitSide = "rear";
        OppositeSide = "front";
        HitSideAxis = -X;
    }
    else if (HitLocationAngle >= RearLeftAngle && HitLocationAngle < FrontLeftAngle) // left side hit
    {
        HitSide = "left";
        OppositeSide = "right";
        HitSideAxis = -Y;
    }
    else // didn't hit any side !! (angles must be screwed up, so fix those)
    {
        Log("ERROR: hull angles not set up correctly for" @ VehicleNameString @ "(took hit from" @ HitLocationAngle @ "degrees & couldn't resolve which side that was");

        if ((bDebugPenetration || class'DH_LevelInfo'.static.DHDebugMode()) && Role == ROLE_Authority)
        {
            Log("ERROR: hull angles not set up correctly for" @ VehicleNameString @ "(took hit from" @ HitLocationAngle @ "degrees & couldn't resolve which side that was");
        }

        ResetTakeDamageVariables();

        return false;
    }

    // Check for 'hit bug', where a projectile may pass through the 1st face of vehicle's collision & be detected as a hit on the opposite side (on the way out)
    // Calculate incoming angle of the shot, relative to perpendicular from the side we think we hit (ignoring armor slope for now; just a reality check on calculated side)
    // If the angle is too high it's impossible, so we do a crude fix by switching the hit to the opposite
    // Angle of over 90 degrees is theoretically impossible, but in reality vehicles aren't regular shaped boxes & it is possible for legitimate hits a bit over 90 degrees
    // So have softened the threshold to 120 degrees, which should still catch genuine hit bugs
    // Also modified to skip this check for deflected shots, which can ricochet onto another part of the vehicle at weird angles
    if (P.NumDeflections == 0)
    {
        AngleOfIncidence = class'UUnits'.static.RadiansToDegrees(Acos(-ProjectileDirection dot HitSideAxis));

        if (AngleOfIncidence > 120.0)
        {
            if (bLogDebugPenetration || class'DH_LevelInfo'.static.DHDebugMode())
            {
                Log("Hit detection bug - switching from" @ HitSide @ "to" @ OppositeSide
                    @ "as angle of incidence to original side was" @ int(Round(AngleOfIncidence)) @ "degrees");
            }

            if ((bDebugPenetration || class'DH_LevelInfo'.static.DHDebugMode()) && Role == ROLE_Authority)
            {
                Log("Hit detection bug - switching from" @ HitSide @ "to" @ OppositeSide
                    @ "as angle of incidence to original side was" @ int(Round(AngleOfIncidence)) @ "degrees");
            }

            HitSide = OppositeSide;
            HitSideAxis = -HitSideAxis;
        }
    }

    // Get the relevant armour array to use, based on which side we hit
    if (HitSide ~= "front")
    {
        HitSideArmorArray = FrontArmor;
    }
    else if (HitSide ~= "rear")
    {
        HitSideArmorArray = RearArmor;
        bRearHit = true; // so we can set bRearHullPenetration if we do penetrate (it's used in TakeDamage)
    }
    else if (HitSide ~= "right" || HitSide ~= "left")
    {
        bSideHit = true; // so we can check HEAT AOI vs. added side armor below

        // No penetration if vehicle has extra side armor that stops small and med HE shells or armor-piercing bullet projectiles, so exit here (after any debug options)
        // This is per Kummersdorf testing in Feb. 1943
        if (bHasAddedSideArmor && (P.RoundType == RT_APBULLET  || (P.RoundType == RT_HE && P.ShellDiameter < 8.5)))
        {
            if (bLogDebugPenetration)
            {
                Log("Hit hull" @ HitSide $ ": no penetration as extra side armor stops HE/PTRD projectiles");
            }

            if (bDebugPenetration && Role == ROLE_Authority)
            {
                Log("Hit hull" @ HitSide $ ": no penetration as extra side armor stops HE/PTRD projectiles");
            }

            ResetTakeDamageVariables();

            return false;
        }

        if (HitSide ~= "right")
        {
            HitSideArmorArray = RightArmor;
        }
        else
        {
            HitSideArmorArray = LeftArmor;
        }
    }

    // Loop through the armor array for the side of the vehicle we hit, to find which height band (relative to hull mesh centre) our hit fits within
    // Then get the armor thickness & slope for that section, & append any extra location description for the armor plate
    for (i = 0; i < HitSideArmorArray.Length; ++i)
    {
        if (HitLocationRelativeOffset.Z <= HitSideArmorArray[i].MaxRelativeHeight || i == HitSideArmorArray.Length - 1)
        {
            ArmorThickness = HitSideArmorArray[i].Thickness;
            ArmorSlope = HitSideArmorArray[i].Slope;

            if (HitSideArmorArray[i].LocationName != "")
            {
                HitSide @= HitSideArmorArray[i].LocationName;
            }

            break;
        }
    }

    // Calculate the effective armor thickness, factoring in projectile's angle of incidence, & compare to projectile's penetration capability
    // We can skip these calcs if MaxArmorPenetration doesn't exceed ArmorThickness, because that means we can't ever penetrate
    // But if a debug option is enabled, we'll do the calcs as they get used in the debug
    if (MaxArmorPenetration > ArmorThickness || ((bLogDebugPenetration || bDebugPenetration) && P.NumDeflections == 0))
    {
        // Calculate the projectile's angle of incidence to the actual armor slope
        // Apply armor slope to HitSideAxis to get an ArmorNormal (a normal from the sloping face of the armor), then calculate an AOI relative to that
        ArmourSlopeRotator.Pitch = class'UUnits'.static.DegreesToUnreal(ArmorSlope);
        ArmorNormal = Normal(vector(ArmourSlopeRotator) >> rotator(HitSideAxis));
        AngleOfIncidence = class'UUnits'.static.RadiansToDegrees(Acos(-ProjectileDirection dot ArmorNormal));

        // Check if round is to be deflected because the AOI is too high.
        if (P.bDeflectAOI && AngleOfIncidence > P.DeflectAOI)
        {
            P.bRoundDeflected = true;

            ResetTakeDamageVariables();

            return false;
        }

        //Added side armor (schurzen) defeat HEAT projectiles if angle of shot is above 45°
        if (bSideHit && bHasAddedSideArmor && (P.RoundType == RT_HEAT && AngleOfIncidence > 45))
        {
            ResetTakeDamageVariables();

            return false;
        }

        // Get the armor's slope multiplier to calculate effective armor thickness
        OverMatchFactor = ArmorThickness / P.ShellDiameter;
        SlopeMultiplier = GetArmorSlopeMultiplier(P, AngleOfIncidence, OverMatchFactor);
        EffectiveArmorThickness = ArmorThickness * SlopeMultiplier;

        // Get the penetration ratio (penetration capability vs effective thickness)
        PenetrationRatio = MaxArmorPenetration / EffectiveArmorThickness;
    }

    // Check & record whether or not we penetrated the vehicle (including check if shattered on the armor)
    P.bRoundShattered = P.bShatterProne && PenetrationRatio >= 1.0 && CheckIfShatters(P, PenetrationRatio, OverMatchFactor, ShatterChance);
    bProjectilePenetrated = PenetrationRatio >= 1.0 && !P.bRoundShattered;

    // Set variables used in TakeDamage()
    bHEATPenetration = P.RoundType == RT_HEAT && bProjectilePenetrated;
    bRearHullPenetration = bRearHit && bProjectilePenetrated;
    bTurretPenetration = false;
    bVehicleHit = true;
    HullFirePercent = P.HullFireChance;
    EngineFirePercent = P.EngineFireChance;

    // Debugging options
    if ((bLogDebugPenetration || bDebugPenetration) && P.NumDeflections == 0)
    {
        DebugString1 = Caps("Hit hull" @ HitSide) $ ": penetrated =" @ Locs(bProjectilePenetrated && !P.bRoundShattered) $ ", hit location angle ="
            @ int(Round(HitLocationAngle)) @ "deg, armor =" @ int(Round(ArmorThickness * 10.0)) $ "mm @" @ int(Round(ArmorSlope)) @ "deg";

        DebugString2 = "Shot penetration =" @ int(Round(MaxArmorPenetration * 10.0)) $ "mm, effective armor =" @ int(Round(EffectiveArmorThickness * 10.0))
            $ "mm, shot AOI =" @ int(Round(AngleOfIncidence)) @ "deg, armor slope multiplier =" @ SlopeMultiplier;

        DebugString3 = "Penetration radio =" @ PenetrationRatio $ ", shatter chance =" @ (ShatterChance * 100) $ "%, shattered =" @ Locs(P.bRoundShattered);

        if (bLogDebugPenetration)
        {
            Log(DebugString1);
            Log(DebugString2);
            Log(DebugString3);
            Log("------------------------------------------------------------------------------------------------------");
        }

        if (bDebugPenetration)
        {
            if (Role == ROLE_Authority)
            {
                Log(DebugString1);
                Log(DebugString2);
                Log(DebugString3);
            }

            if (Level.NetMode != NM_DedicatedServer)
            {
                ClearStayingDebugLines();
                DrawStayingDebugLine(HitLocation, HitLocation + (600.0 * ArmorNormal), 0, 0, 255); // blue line for ArmorNormal

                if (bProjectilePenetrated)
                {
                    DrawStayingDebugLine(HitLocation, HitLocation + (2000.0 * -ProjectileDirection), 0, 255, 0); // green line for penetration
                }
                else
                {
                    DrawStayingDebugLine(HitLocation, HitLocation + (2000.0 * -ProjectileDirection), 255, 0, 0); // red line if failed to penetrate
                }
            }
        }
    }

    // Finally return whether or not we penetrated the vehicle hull
    return bProjectilePenetrated;
}

// New function to calculate the appropriate armor slope multiplier for various projectile types & angles
// A static function so it can be used by cannon class for turret armor, avoiding lots of armor code repetition (same with several others)
simulated static function float GetArmorSlopeMultiplier(DHAntiVehicleProjectile P, float AngleOfIncidence, optional float OverMatchFactor)
{
    local float CompoundExp, BaseLookupAngle, DegreesSpread, ExtraAngleDegrees, BaseSlopeMultiplier, NextSlopeMultiplier, MultiplierDifference;

    if (P.RoundType == RT_HVAP)
    {
        if (P.ShellDiameter > 8.5) // HVAP rounds bigger than 85mm shell diameter (instead of using separate RoundType RT_HVAPLarge)
        {
            if (AngleOfIncidence <= 30.0)
            {
               CompoundExp = AngleOfIncidence ** 1.75;

               return 2.71828 ** (CompoundExp * 0.000662);
            }
            else
            {
               CompoundExp = AngleOfIncidence ** 2.2;

               return 0.9043 * (2.71828 ** (CompoundExp * 0.0001987));
            }
        }
        else // smaller HVAP rounds
        {
            if (AngleOfIncidence <= 25.0)
            {
               CompoundExp = AngleOfIncidence ** 2.2;

               return 2.71828 ** (CompoundExp * 0.0001727);
            }
            else
            {
               CompoundExp = AngleOfIncidence ** 1.5;

               return 0.7277 * (2.71828 ** (CompoundExp * 0.003787));
            }
        }
    }
    else if (P.RoundType == RT_APDS)
    {
        CompoundExp = AngleOfIncidence ** 2.6;

        return 2.71828 ** (CompoundExp * 0.00003011);
    }
    else if (P.RoundType == RT_HEAT)
    {
        return 1.0 / Cos(class'UUnits'.static.DegreesToRadians(Abs(AngleOfIncidence)));
    }
    else // should mean RoundType is RT_APC, RT_HE or RT_Smoke, but treating this as a catch-all default (will also handle DO's AP & APBC shells)
    {
        if (AngleOfIncidence < 10.0)
        {
            BaseLookupAngle = 10.0; // we'll start with base multiplier for 10 degrees & then reduce based on how far much lower than 10 we are
            DegreesSpread = 10.0;
        }
        else
        {
            BaseLookupAngle = float(int(AngleOfIncidence / 5.0)) * 5.0; // to nearest 5 degrees, rounded down
            DegreesSpread = 5.0;
        }

        ExtraAngleDegrees = AngleOfIncidence - BaseLookupAngle;
        BaseSlopeMultiplier = ArmorSlopeTable(P, BaseLookupAngle, OverMatchFactor);
        NextSlopeMultiplier = ArmorSlopeTable(P, BaseLookupAngle + 5.0, OverMatchFactor);
        MultiplierDifference = NextSlopeMultiplier - BaseSlopeMultiplier;

        return BaseSlopeMultiplier + (ExtraAngleDegrees / DegreesSpread * MultiplierDifference);
    }

    return 1.0; // fail-safe neutral return value
}

// New lookup function to calculate the appropriate armor slope multiplier for various projectile types & angles
// All from "WWII Ballistics: Armor & Gunnery" by Bird & Livingston
// A static function so it can be used by cannon class for turret armor, avoiding lots of armor code repetition (same with several others)
simulated static function float ArmorSlopeTable(DHAntiVehicleProjectile P, float AngleOfIncidence, float OverMatchFactor)
{
    if (P.RoundType == RT_AP) // from Darkest Orchestra
    {
        if      (AngleOfIncidence <= 10.0)  return 0.98  * (OverMatchFactor ** 0.06370); // at 10 degrees
        else if (AngleOfIncidence <= 15.0)  return 1.00  * (OverMatchFactor ** 0.09690);
        else if (AngleOfIncidence <= 20.0)  return 1.04  * (OverMatchFactor ** 0.13561);
        else if (AngleOfIncidence <= 25.0)  return 1.11  * (OverMatchFactor ** 0.16164);
        else if (AngleOfIncidence <= 30.0)  return 1.22  * (OverMatchFactor ** 0.19702);
        else if (AngleOfIncidence <= 35.0)  return 1.38  * (OverMatchFactor ** 0.22546);
        else if (AngleOfIncidence <= 40.0)  return 1.63  * (OverMatchFactor ** 0.26313);
        else if (AngleOfIncidence <= 45.0)  return 2.00  * (OverMatchFactor ** 0.34717);
        else if (AngleOfIncidence <= 50.0)  return 2.64  * (OverMatchFactor ** 0.57353);
        else if (AngleOfIncidence <= 55.0)  return 3.23  * (OverMatchFactor ** 0.69075);
        else if (AngleOfIncidence <= 60.0)  return 4.07  * (OverMatchFactor ** 0.81826);
        else if (AngleOfIncidence <= 65.0)  return 6.27  * (OverMatchFactor ** 0.91920);
        else if (AngleOfIncidence <= 70.0)  return 8.65  * (OverMatchFactor ** 1.00539);
        else if (AngleOfIncidence <= 75.0)  return 13.75 * (OverMatchFactor ** 1.07400);
        else if (AngleOfIncidence <= 80.0)  return 21.87 * (OverMatchFactor ** 1.17973);
        else                                       return 34.49 * (OverMatchFactor ** 1.28631); // at 85 degrees
    }
    else if (P.RoundType == RT_APBC) // from Darkest Orchestra
    {
        if      (AngleOfIncidence <= 10.0)  return 1.04  * (OverMatchFactor ** 0.01555); // at 10 degrees
        else if (AngleOfIncidence <= 15.0)  return 1.06  * (OverMatchFactor ** 0.02315);
        else if (AngleOfIncidence <= 20.0)  return 1.08  * (OverMatchFactor ** 0.03448);
        else if (AngleOfIncidence <= 25.0)  return 1.11  * (OverMatchFactor ** 0.05134);
        else if (AngleOfIncidence <= 30.0)  return 1.16  * (OverMatchFactor ** 0.07710);
        else if (AngleOfIncidence <= 35.0)  return 1.22  * (OverMatchFactor ** 0.11384);
        else if (AngleOfIncidence <= 40.0)  return 1.31  * (OverMatchFactor ** 0.16952);
        else if (AngleOfIncidence <= 45.0)  return 1.44  * (OverMatchFactor ** 0.24604);
        else if (AngleOfIncidence <= 50.0)  return 1.68  * (OverMatchFactor ** 0.37910);
        else if (AngleOfIncidence <= 55.0)  return 2.11  * (OverMatchFactor ** 0.56444);
        else if (AngleOfIncidence <= 60.0)  return 3.50  * (OverMatchFactor ** 1.07411);
        else if (AngleOfIncidence <= 65.0)  return 5.34  * (OverMatchFactor ** 1.46188);
        else if (AngleOfIncidence <= 70.0)  return 9.48  * (OverMatchFactor ** 1.81520);
        else if (AngleOfIncidence <= 75.0)  return 20.22 * (OverMatchFactor ** 2.19155);
        else if (AngleOfIncidence <= 80.0)  return 56.20 * (OverMatchFactor ** 2.56210);
        else                                       return 221.3 * (OverMatchFactor ** 2.93265); // at 85 degrees
    }
    else // should mean RoundType is RT_APC (also covers APCBC) or RT_HE, but treating this as a catch-all default
    {
        if      (AngleOfIncidence <= 10.0)  return 1.01  * (OverMatchFactor ** 0.0225); // at 10 degrees
        else if (AngleOfIncidence <= 15.0)  return 1.03  * (OverMatchFactor ** 0.0327);
        else if (AngleOfIncidence <= 20.0)  return 1.10  * (OverMatchFactor ** 0.0454);
        else if (AngleOfIncidence <= 25.0)  return 1.17  * (OverMatchFactor ** 0.0549);
        else if (AngleOfIncidence <= 30.0)  return 1.27  * (OverMatchFactor ** 0.0655);
        else if (AngleOfIncidence <= 35.0)  return 1.39  * (OverMatchFactor ** 0.0993);
        else if (AngleOfIncidence <= 40.0)  return 1.54  * (OverMatchFactor ** 0.1388);
        else if (AngleOfIncidence <= 45.0)  return 1.72  * (OverMatchFactor ** 0.1655);
        else if (AngleOfIncidence <= 50.0)  return 1.94  * (OverMatchFactor ** 0.2035);
        else if (AngleOfIncidence <= 55.0)  return 2.12  * (OverMatchFactor ** 0.2427);
        else if (AngleOfIncidence <= 60.0)  return 2.56  * (OverMatchFactor ** 0.2450);
        else if (AngleOfIncidence <= 65.0)  return 3.20  * (OverMatchFactor ** 0.3354);
        else if (AngleOfIncidence <= 70.0)  return 3.98  * (OverMatchFactor ** 0.3478);
        else if (AngleOfIncidence <= 75.0)  return 5.17  * (OverMatchFactor ** 0.3831);
        else if (AngleOfIncidence <= 80.0)  return 8.09  * (OverMatchFactor ** 0.4131);
        else                                       return 11.32 * (OverMatchFactor ** 0.4550); // at 85 degrees
    }

    return 1.0; // fail-safe neutral return value
}

// Shatter chance is plotted on a curve where the middle of the two shatter ratios is a 75% chance, and the outer-edges are 0% chance.
simulated static function float GetShatterChance(float PenetrationRatio, float PenetrationRatioMin, float PenetrationRatioMax)
{
    local float T;

    T = (PenetrationRatio - PenetrationRatioMin) / (PenetrationRatioMax - PenetrationRatioMin);

    if (T < 0 || T > 1.0)
    {
        return 0.0;
    }

    return 0.75 * class'UInterp'.static.Mimi(T);
}

// New function to check whether a projectile should shatter on vehicle's armor, based on the 'shatter gap' for different round types
// A static function so it can be used by cannon class for turret armor, avoiding lots of armor code repetition (same with several others)
// This data is based on the book WW2 Ballistics - Armor and Gunnery (p.29)
simulated static function bool CheckIfShatters(DHAntiVehicleProjectile P, float PenetrationRatio, float OverMatchFactor, out float ShatterChance)
{
    if (P.RoundType == RT_HVAP)
    {
        if (P.ShellDiameter >= 9.0) // HVAP rounds of at least 90mm shell diameter, e.g. Jackson's 90mm cannon (instead of using separate RoundType RT_HVAPLarge)
        {
            ShatterChance = GetShatterChance(PenetrationRatio, 1.1, 1.27);
        }
        else // smaller HVAP rounds
        {
            ShatterChance = GetShatterChance(PenetrationRatio, 1.1, 1.34);
        }
    }
    else if (P.RoundType == RT_APDS)
    {
        ShatterChance = GetShatterChance(PenetrationRatio, 1.06, 1.2);
    }
    else if (P.RoundType == RT_HEAT) // no chance of shatter for HEAT round
    {
    }
    else // should mean RoundType is RT_APC, RT_HE or RT_Smoke, but treating this as a catch-all default (will also handle DO's AP & APBC shells)
    {
        if (OverMatchFactor > 0.8)
        {
            ShatterChance = GetShatterChance(PenetrationRatio, 1.06, 1.19);
        }
    }

    return FRand() <= ShatterChance;
}

///////////////////////////////////////////////////////////////////////////////////////
//  *********************************  DAMAGE  ************************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to DH special damage points, random special damage and/or crew deaths if penetrated, & possibility of setting engine or vehicle on fire
// Also to use TankDamageModifier instead of VehicleDamageModifier (unless an APC)
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    local class<ROWeaponDamageType> WepDamageType;
    local DHVehicleCannonPawn       CannonPawn;
    local Controller InstigatorController;
    local float      DamageModifier, TreadDamageMod, HullChanceModifier, TurretChanceModifier;
    local int        InstigatorTeam, i;
    local bool       bEngineStoppedProjectile, bAmmoDetonation;

    // Suicide/self-destruction
    if (DamageType == class'Suicided' || DamageType == class'ROSuicided')
    {
        super(Vehicle).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, class'ROSuicided');

        ResetTakeDamageVariables();

        return;
    }

    // Quick fix for the vehicle giving itself impact damage
    if (InstigatedBy == self && DamageType != VehicleBurningDamType)
    {
        ResetTakeDamageVariables();

        return;
    }

    // Prevent griefer players from damaging own team's vehicles that haven't yet been entered, i.e. are sitting in a spawn area (not applicable in single player)
    if (!bDriverAlreadyEntered && Level.NetMode != NM_Standalone)
    {
        if (InstigatedBy != none)
        {
            InstigatorController = InstigatedBy.Controller;
        }

        if (InstigatorController == none && DamageType.default.bDelayedDamage)
        {
            InstigatorController = DelayedDamageInstigatorController;
        }

        if (InstigatorController != none)
        {
            InstigatorTeam = InstigatorController.GetTeamNum();

            if (GetTeamNum() != 255 && InstigatorTeam != 255 && GetTeamNum() == InstigatorTeam)
            {
                ResetTakeDamageVariables();

                return;
            }
        }
    }

    // Apply damage modifier from the DamageType, plus a little damage randomisation (but not randomised for fire damage as it messes up timings)
    WepDamageType = class<ROWeaponDamageType>(DamageType);

    if (WepDamageType != none)
    {

        if (bIsApc)
        {
            DamageModifier = WepDamageType.default.APCDamageModifier;
        }
        else
        {
            DamageModifier = WepDamageType.default.TankDamageModifier;
        }

        /*
        if (DamageType != VehicleBurningDamType)
        {
            DamageModifier *= RandRange(0.85, 1.25);
        }
        */

        if (bHasTreads)
        {
            TreadDamageMod = WepDamageType.default.TreadDamageModifier;
        }

        //A chance that a non-penetrating WP shell impact sets the engine on fire
        if (WepDamageType == class'DHShellSmokeWPDamageType' && bVehicleHit)
        {
            if (FRand() < (EngineFirePercent * 0.15))
            {
                StartEngineFire(InstigatedBy);
            }
        }
    }

    Damage *= DamageModifier;

    // Exit if no damage
    if (Damage < 1)
    {
        ResetTakeDamageVariables();

        return;
    }

    // Check RO VehHitpoints (engine, ammo)
    // Note driver hit check is deprecated as we use a new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    if (bProjectilePenetrated)
    {
        for (i = 0; i < VehHitpoints.Length; ++i)
        {
            if (IsPointShot(HitLocation, Momentum, 1.0, i))
            {
                if (bLogDebugPenetration)
                {
                    Log("We hit VehHitpoints[" $ i $ "]:" @ GetEnum(enum'EHitPointType', VehHitpoints[i].HitPointType));
                }

                // Engine hit
                if (VehHitpoints[i].HitPointType == HP_Engine)
                {
                    if (bDebuggingText)
                    {
                        Log("Hit vehicle engine");
                    }

                    Damage *= 0.55; // reduce damage to vehicle itself if hit engine
                    DamageEngine(Damage, InstigatedBy, HitLocation, Momentum, DamageType);

                    // Shot from the rear that hits engine will stop shell from passing through to cabin, so don't check any more VehHitpoints
                    if (bRearHullPenetration)
                    {
                        bEngineStoppedProjectile = true;
                        HullFirePercent=0.0; //the projectile has not passed into the hull compartment, thus no danger of setting ammo or other internal flammables on fire
                        break;
                    }
                }
                // Hit ammo store
                else if (VehHitpoints[i].HitPointType == HP_AmmoStore)
                {
                    // Random chance that ammo explodes & vehicle is destroyed
                    if ((bHEATPenetration && FRand() < 0.85) || (!bHEATPenetration && FRand() < AmmoIgnitionProbability))
                    {
                        if (bDebuggingText)
                        {
                            Log("Hit vehicle ammo store - exploded");
                        }

                        Damage *= Health; //obliterate vehicle
                        bAmmoDetonation = true;
                        break;
                    }
                    // Even if ammo did not explode, increase the chance of a fire breaking out
                    else
                    {
                        if (bDebuggingText)
                        {
                            Log("Hit vehicle ammo store but did not explode");
                        }

                        HullFirePercent = FMax(0.75, HullFirePercent);
                        //HullFireHEATChance = FMax(0.90, HullFireHEATChance);
                    }
                }
            }
        }
    }

    if (!bEngineStoppedProjectile && !bAmmoDetonation) // we can skip lots of checks if either has been flagged true
    {
        if ((bProjectilePenetrated || NewVehHitpoints.Length > 0) && Cannon != none)
        {
            CannonPawn = DHVehicleCannonPawn(Cannon.WeaponPawn);
        }

        // Check additional DH NewVehHitPoints
        for (i = 0; i < NewVehHitpoints.Length; ++i)
        {
            if (IsNewPointShot(HitLocation, Momentum, i))
            {
                if (bLogDebugPenetration)
                {
                    Log("We hit NewVehHitpoints[" $ i $ "]:" @ GetEnum(enum'EHitPointType', NewVehHitpoints[i].NewHitPointType));
                }

                // Hit periscope optics
                if (NewVehHitpoints[i].NewHitPointType == NHP_PeriscopeOptics)
                {
                    // does nothing at present - possibly add in future
                }
                else if (CannonPawn != none)
                {
                    // Hit exposed gunsight optics
                    if (NewVehHitpoints[i].NewHitPointType == NHP_GunOptics)
                    {
                        if (bDebuggingText)
                        {
                            Log("Hit gunsight optics");
                        }

                        CannonPawn.DamageCannonOverlay();
                    }
                    else if (bProjectilePenetrated)
                    {
                        // Hit turret ring or gun traverse mechanism
                        if (NewVehHitpoints[i].NewHitPointType == NHP_Traverse)
                        {
                            if (bDebuggingText)
                            {
                                Log("Hit gun/turret traverse");
                            }

                            CannonPawn.bTurretRingDamaged = true;
                        }
                        // Hit gun pivot mechanism
                        else if (NewVehHitpoints[i].NewHitPointType == NHP_GunPitch)
                        {
                            if (bDebuggingText)
                            {
                                Log("Hit gun pivot");
                            }

                            CannonPawn.bGunPivotDamaged = true;
                        }
                    }
                }
            }
        }

        // Random damage to crew or vehicle components due to spalling or fragmentation inside vehicle
        if (bProjectilePenetrated)
        {
            if (Cannon != none)
            {
                // Although shrapnel etc can get everywhere, modify chance of random damage based on whether penetration was to hull or turret
                if (Cannon.bHasTurret)
                {
                    if (bTurretPenetration)
                    {
                        HullChanceModifier = 0.25;   // 25% usual chance of damage to things in the hull
                        TurretChanceModifier = 1.0;
                    }
                    else
                    {
                        HullChanceModifier = 1.0;
                        TurretChanceModifier = 0.35; // 35% usual chance of damage to things in the turret
                    }
                }
                else // normal chance of damage to everything in vehicles without a turret (e.g. casemate-style tank destroyers)
                {
                    HullChanceModifier = 1.0;
                    TurretChanceModifier = 1.0;
                }

                if (CannonPawn != none)
                {
                    // Random chance of shrapnel killing commander
                    if (CannonPawn != none && CannonPawn.Driver != none && FRand() < (float(Damage) / CommanderKillChance * TurretChanceModifier))
                    {
                        if (bDebuggingText)
                        {
                            Log("Commander killed by shrapnel");
                        }

                        CannonPawn.Driver.TakeDamage(150, InstigatedBy, Location, vect(0.0, 0.0, 0.0), DamageType);
                    }

                    // Random chance of shrapnel damaging gunsight optics
                    if (FRand() < (float(Damage) / OpticsDamageChance * TurretChanceModifier))
                    {
                        if (bDebuggingText)
                        {
                            Log("Gunsight optics destroyed by shrapnel");
                        }

                        CannonPawn.DamageCannonOverlay();
                    }

                    // Random chance of shrapnel damaging gun pivot mechanism
                    if (FRand() < (float(Damage) / GunDamageChance * TurretChanceModifier))
                    {
                        if (bDebuggingText)
                        {
                            Log("Gun pivot damaged by shrapnel");
                        }

                        CannonPawn.bGunPivotDamaged = true;
                    }

                    // Random chance of shrapnel damaging gun traverse mechanism
                    if (FRand() < (float(Damage) / TraverseDamageChance * TurretChanceModifier))
                    {
                        if (bDebuggingText)
                        {
                            Log("Gun/turret traverse damaged by shrapnel");
                        }

                        CannonPawn.bTurretRingDamaged = true;
                    }
                }
            }

            // Random chance of shrapnel detonating turret ammo & destroying the vehicle - this should really be based on if turret stores ammo or not
            if (FRand() < (float(Damage) / TurretDetonationThreshold * TurretChanceModifier))
            {
                if (bDebuggingText)
                {
                    Log("Turret ammo detonated by shrapnel");
                }

                Damage *= Health;
            }
            else if (bTurretPenetration)
            {
                // Random chance of shrapnel killing driver
                if (Driver != none && FRand() < (float(Damage) / DriverKillChance * HullChanceModifier))
                {
                    if (bDebuggingText)
                    {
                        Log("Driver killed by shrapnel");
                    }

                    Driver.TakeDamage(150, InstigatedBy, Location, vect(0.0, 0.0, 0.0), DamageType);
                }

                // Random chance of shrapnel killing hull machine gunner
                if (MGun != none && MGun.WeaponPawn != none && MGun.WeaponPawn.Driver != none && FRand() < (float(Damage) / GunnerKillChance * HullChanceModifier))
                {
                    if (bDebuggingText)
                    {
                        Log("Hull gunner killed by shrapnel");
                    }

                    MGun.WeaponPawn.Driver.TakeDamage(150, InstigatedBy, Location, vect(0.0, 0.0, 0.0), DamageType);
                }

                Damage *= 0.75; //(reduce damage to vehicle itself from a turret hit, if the turret ammo didn't detonate)
            }
        }

        // Check if we hit & damaged either track
        if (bHasTreads && TreadDamageMod >= TreadDamageThreshold && !bTurretPenetration && !bRearHullPenetration)
        {
            CheckTreadDamage(HitLocation, Momentum);

            Damage *= 0.55; // -- reduce overall damage to vehicle itself if tread area hit (wheels and bottom treads usually below critical areas)
        }
    }

    if (bDebuggingText)
    {
        Log("Damaging vehicle with:" @ Damage);
    }

    // Call the Super from Vehicle (skip over others)
    super(Vehicle).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);

    // Vehicle is still alive, so check for possibility of a fire breaking out in hull
    if (Health > 0)
    {
        if (bProjectilePenetrated && !bEngineStoppedProjectile && !bOnFire)
        {
            // Random chance of penetration causing a hull fire // TODO: relate probability to damage, as currently even tiny damage has a high chance of starting a fire
            if (FRand() < HullFirePercent)
            {
                StartHullFire(InstigatedBy);
            }
            // If we didn't start a fire & this is the 1st time a projectile has penetrated, increase the chance of causing a hull fire for any future penetrations (spilled fuel, loose electrical circuits, etc)
            else if (bFirstPenetratingHit)
            {
                bFirstPenetratingHit = false;
                HullFirePercent = FMax(0.75, HullFirePercent);
                //HullFireHEATChance = FMax(0.90, HullFireHEATChance);
            }
        }

        // If an APC's health is very low, kill the engine & start a fire
        if (bIsApc && Health <= (HealthMax / 3) && EngineHealth > 0)
        {
            EngineHealth = 0;
            bEngineOff = true;
            StartEngineFire(InstigatedBy);
        }
    }

    ResetTakeDamageVariables();
}

// New function to reset all variables used in TakeDamage, ready for next penetration
function ResetTakeDamageVariables()
{
    bProjectilePenetrated = false;
    bTurretPenetration = false;
    bRearHullPenetration = false;
    bHEATPenetration = false;
    HullFirePercent = 0.0;
    bVehicleHit = false;
}

// Modified to add random chance of engine fire breaking out
function DamageEngine(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
    // Apply new damage
    if (EngineHealth > 0)
    {
        if (DamageType != VehicleBurningDamType)
        {
            Damage = Level.Game.ReduceDamage(Damage, self, InstigatedBy, HitLocation, Momentum, DamageType);
        }

        if (bDebuggingText)
        {
            Log("Damaging engine with a damage of:" @ Damage);
        }

        EngineHealth -= Damage;
    }

    // Kill the engine if its health has now fallen to zero
    if (EngineHealth <= 0)
    {
        if (bDebuggingText)
        {
            Log("Engine is dead");
        }

        if (!bEngineOff)
        {
            bEngineOff = true;
            PlaySound(DamagedShutDownSound, SLOT_None, FClamp(Abs(Throttle), 0.3, 0.75));
        }

        SetEngine();
    }
    // Or if engine still alive, a random chance of engine fire breaking out // TODO: relate probability to damage, as currently even tiny damage has a high chance of starting a fire
    else if (DamageType != VehicleBurningDamType && !bEngineOnFire && Damage > 0 && Health > 0)
    {
        if (FRand() < EngineFirePercent)
        {
            if (bDebuggingText)
            {
                Log("Engine fire started");
            }

            StartEngineFire(InstigatedBy);
        }
    }
}

// New function to handle hull fire damage
function TakeFireDamage()
{
    local Pawn PawnWhoSetOnFire;
    local int  i;

    if (Role == ROLE_Authority)
    {
        if (WhoSetOnFire != none)
        {
            // If the instigator gets teamswapped before a burning vehicle dies, make sure they don't get friendly kills for it
            if (WhoSetOnFire.GetTeamNum() != HullFireStarterTeam)
            {
                WhoSetOnFire = none;
                DelayedDamageInstigatorController = none;
            }
            else
            {
                PawnWhoSetOnFire = WhoSetOnFire.Pawn;
            }
        }

        // Burn the driver
        if (Driver != none)
        {
            Driver.TakeDamage(PlayerFireDamagePer2Secs, PawnWhoSetOnFire, Location, vect(0.0, 0.0, 0.0), VehicleBurningDamType);
        }

        // Burn any other vehicle occupants
        for (i = 0; i < WeaponPawns.Length; ++i)
        {
            if (WeaponPawns[i] != none && WeaponPawns[i].Driver != none)
            {
                WeaponPawns[i].Driver.TakeDamage(PlayerFireDamagePer2Secs, PawnWhoSetOnFire, Location, vect(0.0, 0.0, 0.0), VehicleBurningDamType);
            }
        }

        // Chance of cooking off ammo before health runs out
        if (FRand() < FireDetonationChance)
        {
            if (bDebuggingText)
            {
                Log("Fire detonated ammo");
            }

            TakeDamage(Health, PawnWhoSetOnFire, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), VehicleBurningDamType);
        }
        // Otherwise the vehicle takes normal fire damage
        else
        {
            TakeDamage(HullFireDamagePer2Secs, PawnWhoSetOnFire, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), VehicleBurningDamType);
        }

        // Set next hull damage due in another 2 seconds, unless vehicle is now dead
        if (Health > 0)
        {
            NextHullFireDamageTime += 2.0;
        }
    }
}

// New function to handle engine fire damage
function TakeEngineFireDamage()
{
    local Pawn PawnWhoSetOnFire;

    if (Role == ROLE_Authority)
    {
        // Damage engine if not already dead
        if (EngineHealth > 0)
        {
            if (WhoSetEngineOnFire != none)
            {
                // If the instigator gets teamswapped before a burning vehicle dies, make sure they don't get friendly kills for it
                if (WhoSetEngineOnFire.GetTeamNum() != EngineFireStarterTeam)
                {
                    WhoSetEngineOnFire = none;
                    DelayedDamageInstigatorController = none;
                }
                else
                {
                    PawnWhoSetOnFire = WhoSetEngineOnFire.Pawn;
                }
            }

            DamageEngine(EngineFireDamagePer3Secs, PawnWhoSetOnFire, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), VehicleBurningDamType);

            // Small chance each time of engine fire spreading & setting whole vehicle on fire
            if (!bOnFire && FRand() < EngineToHullFireChance)
            {
                StartHullFire(PawnWhoSetOnFire);
            }

            // Engine not dead, so set next engine damage due in the normal 3 seconds
            if (EngineHealth > 0)
            {
                NextEngineFireDamageTime += 3.0;
            }
            // Engine is dead, but use NextEngineFireDamageTime to set next timer so engine fire dies down 30 secs after engine health hits zero (unless hull has caught fire)
            else if (!bOnFire)
            {
                NextEngineFireDamageTime += 30.0;
            }
        }
        // Engine fire dies down 30 seconds after engine health hits zero, unless hull has caught fire
        else if (!bOnFire)
        {
            bEngineOnFire = false;
        }
    }
}

// Modified to unlock a locked vehicle (unlocking isn't directly necessary, but unlocking it finds & clears any references to the now destroyed vehicle)
state VehicleDestroyed
{
ignores Tick;

    function BeginState()
    {
        super.BeginState();

        if (bVehicleLocked)
        {
            SetVehicleLocked(false);
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *************************  SETUP, UPDATE, CLEAN UP  ***************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to add periscope materials
static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(default.PeriscopeOverlay);
    L.AddPrecacheMaterial(default.DamagedPeriscopeOverlay);
}

// Modified to add periscope materials
simulated function UpdatePrecacheMaterials()
{
    super.UpdatePrecacheMaterials();

    Level.AddPrecacheMaterial(PeriscopeOverlay);
    Level.AddPrecacheMaterial(DamagedPeriscopeOverlay);
}

// Modified to include extra attachment
simulated function DestroyAttachments()
{
    super. DestroyAttachments();

    if (DriverHatchFireEffect != none)
    {
        DriverHatchFireEffect.Kill();
    }
}

simulated event DestroyAppearance()
{
    local Combiner DestroyedSkin;

    if (bUsesCodedDestroyedSkins)
    {
        DestroyedSkin = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
        DestroyedSkin.Material1 = Skins[0];
        DestroyedSkin.Material2 = Texture'DH_FX_Tex.Overlays.DestroyedVehicleOverlay2';
        DestroyedSkin.FallbackMaterial = Skins[0];
        DestroyedSkin.CombineOperation = CO_Multiply;
        DestroyedMeshSkins[0] = DestroyedSkin;
    }

    super.DestroyAppearance();
}

// Modified to handle extended vehicle fire system, plus setting manual/powered turret
simulated function SetEngine()
{
    // Engine off
    if (bEngineOff || Health <= 0 || EngineHealth <= 0)
    {
        TurnDamping = 0.0;

        if (IsVehicleBurning())
        {
            AmbientSound = VehicleBurningSound;
            SoundVolume = 255;
            SoundRadius = 300.0;
        }
        else if (EngineHealth <= 0)
        {
            AmbientSound = SmokingEngineSound;
            SoundVolume = 64;
            SoundRadius = 200.0;
        }
        else
        {
            AmbientSound = none;
        }

        if (bEmittersOn)
        {
            StopEmitters();
        }

        if (ShutDownForce != "")
        {
            ClientPlayForceFeedback(ShutDownForce);
        }
    }
    // Engine on
    else
    {
        if (IdleSound != none)
        {
            AmbientSound = IdleSound;
            SoundVolume = default.SoundVolume;
            SoundRadius = default.SoundRadius;
        }

        if (!bEmittersOn)
        {
            StartEmitters();
        }

        if (StartUpForce != "")
        {
            ClientPlayForceFeedback(StartUpForce);
        }
    }

    if (Cannon != none && DHVehicleCannonPawn(Cannon.WeaponPawn) != none)
    {
        DHVehicleCannonPawn(Cannon.WeaponPawn).SetManualTurret(bEngineOff);
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *******************************  MISCELLANEOUS ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to stop vehicle from prematurely destroying itself when on fire; instead just let the fire run its course
function MaybeDestroyVehicle()
{
    if (!IsVehicleBurning())
    {
        super.MaybeDestroyVehicle();
    }
}

// Modified to work with interwoven Timer system instead of directly setting a timer for VehicleSpikeTime duration
function SetSpikeTimer()
{
    SpikeTime = Level.TimeSeconds + VehicleSpikeTime;
    SetNextTimer();
}

// Bot functions from deprecated ROTreadCraft class
function bool RecommendLongRangedAttack()
{
    return true;
}

function bool StronglyRecommended(Actor S, int TeamIndex, Actor Objective)
{
    return true;
}

function float ModifyThreat(float Current, Pawn Threat)
{
    local vector to, t;
    local float  r;

    if (Vehicle(Threat) != none)
    {
        Current += 0.2;

        if (DHArmoredVehicle(Threat) != none)
        {
            Current += 0.2;

            // Big bonus points for perpendicular tank targets
            to = Normal(Threat.Location - Location);
            to.z = 0.0;
            t = Normal(vector(Threat.Rotation));
            t.z = 0.0;
            r = to dot t;

            if ((r >= 0.90630 && r < -0.73135) || (r >= -0.73135 && r < 0.90630))
            {
                Current += 0.3;
            }
        }
        else if (ROWheeledVehicle(Threat) != none && ROWheeledVehicle(Threat).bIsAPC)
        {
            Current += 0.1;
        }
    }
    else
    {
        Current += 0.25;
    }

    return Current;
}

///////////////////////////////////////////////////////////////////////////////////////
//  *************************** DEBUG EXEC FUNCTIONS  *****************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New debug exec for testing hull fire damage & effects
exec function HullFire()
{
    if (IsDebugModeAllowed() && !bOnFire)
    {
        StartHullFire(none);
    }
}

// New debug exec for testing engine fire damage & effects
exec function EngineFire()
{
    if (IsDebugModeAllowed() && !bEngineOnFire)
    {
        StartEngineFire(none);
    }
}

// New debug exec to adjust position of driver's hatch fire
exec function SetFEOffset(int NewX, int NewY, int NewZ)
{
    if (IsDebugModeAllowed() && Level.NetMode != NM_DedicatedServer)
    {
        // Only update offset if something has been entered (otherwise just entering "SetFEOffset" is quick way of triggering hatch fire at current position)
        if (NewX != 0 || NewY != 0 || NewZ != 0)
        {
            Log(VehicleNameString @ "FireEffectOffset =" @ NewX @ NewY @ NewZ @ "(old was" @ FireEffectOffset $ ")");
            FireEffectOffset.X = NewX;
            FireEffectOffset.Y = NewY;
            FireEffectOffset.Z = NewZ;
        }
        else
        {
            Log(VehicleNameString @ "FireEffectOffset =" @ FireEffectOffset);
        }

        StartDriverHatchFire();
    }
}

defaultproperties
{
    // Vehicle properties
    VehicleMass=12.5
    CollisionHeight=60.0
    MaxDesireability=1.9
    EngineRestartFailChance=0.1
    MinRunOverSpeed=83.82 // decreased to 5 kph, as players should be easier to run over with armored vehicles
    PointValue=1000
    WeaponLockTimeForTK=30
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_Vehicle_Armored'

    // Driver & positions
    bMustBeTankCommander=true
    UnbuttonedPositionIndex=2
    BeginningIdleAnim="driver_hatch_idle_close"
    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.General.PERISCOPE_overlay_Allied'

    //Periscope overlay
    PeriscopeSize=0.955 //default for most peri's

    // Damage
    Health=525
    HealthMax=525.0
    EngineHealth=300
    VehHitpoints(0)=(PointBone="Body") // default engine hit point bone
    GunOpticsHitPointIndex=-1 // set in subclass if vehicle has exposed gunsight optics
    TreadDamageThreshold=0.75
    bCanCrash=false
    ImpactDamageThreshold=5000.0
    DamagedPeriscopeOverlay=Texture'DH_VehicleOpticsDestroyed_tex.General.Destroyed'
    bUsesCodedDestroyedSkins=true

    // Component damage probabilities
    DriverKillChance=1150.0
    GunnerKillChance=1150.0
    CommanderKillChance=950.0
    OpticsDamageChance=3000.0
    GunDamageChance=1250.0
    TraverseDamageChance=2000.0
    TurretDetonationThreshold=1750.0
    // above values are misleading: the greater the number, the lower the chance is
    AmmoIgnitionProbability=0.75

    // Vehicle fires
    bEnableHatchFires=true
    EngineToHullFireChance=0.05  //increased to 0.1 on all petrol engines
    PlayerFireDamagePer2Secs=15.0 // roughly 12 seconds from full health to death; reduced to 12 on all diesels
    FireDetonationChance=0.07  //reduced to 0.045 on all diesels
    bFirstPenetratingHit=true
    VehicleBurningDamType=class'DHVehicleBurningDamageType'

    // Burning/smoking vehicle effects
    DamagedEffectOffset=(X=-40.0,Y=10.0,Z=10.0) // position of engine smoke or fire
    HeavyEngineDamageThreshold=0.5 // causes the engine icon in the HUD to flash red at this engine health level
    DamagedEffectHealthSmokeFactor=0.85
    DamagedEffectHealthMediumSmokeFactor=0.65
    DamagedEffectHealthHeavySmokeFactor=0.35
    DamagedEffectHealthFireFactor=0.0
    FireEffectClass=class'DH_Effects.DHVehicleDamagedEffect' //'DH_Effects.DHVehicleDamagedEffect' // driver's hatch fire
    FireAttachBone="driver_player"
    FireEffectOffset=(X=0.0,Y=0.0,Z=-10.0) // position of driver's hatch fire - hull mg and turret fire positions are set in those pawn classes

    // Vehicle destruction
    DestructionEffectClass=class'DH_Effects.DHVehicleDestroyedEmitter'//'DH_Effects.DHVehicleDestroyedEmitter'//
    DestructionEffectLowClass=class'ROEffects.ROVehicleDestroyedEmitter_simple'
    DisintegrationEffectClass=class'DH_Effects.DHVehicleObliteratedEmitter'
    DisintegrationEffectLowClass=class'ROEffects.ROVehicleObliteratedEmitter_simple'
    DisintegrationHealth=-1000.0 // unlike other vehicles, an armoured vehicle disintegrates by default if health falls bellow this threshold, due to explosive ammo
    ExplosionDamage=200.0
    ExplosionRadius=450.0
    ExplosionSoundRadius=1000.0

    // Vehicle reset/respawn
    TimeTilDissapear=120.0    // time from tank kill until its destroyed mesh and emitter disappear
    IdleTimeBeforeReset=200.0 // if empty & no friendlies nearby

    // Treads & track wheels
    bHasTreads=true
    LeftTreadIndex=1
    RightTreadIndex=2
    LeftTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
    RightTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
    TreadVelocityScale=450.0

    // Sounds
    SoundRadius=650.0
    TransientSoundRadius=700.0
    SmokingEngineSound=Sound'Amb_Constructions.steam.Krasnyi_Steam_Deep'
    TrackDamagedSound=Sound'Vehicle_Engines.track_broken'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundVolumeModifier=1.0

    // Effects
    SparkEffectClass=class'ROEngine.VehicleImpactSparks' // reinstate from ROVehicle (removed for non-armoured DHVehicles)
    SteeringScaleFactor=0.75
    SteerBoneAxis=AXIS_X
    LeftLeverAxis=AXIS_Z
    RightLeverAxis=AXIS_Z
    StartUpForce="TankStartUp"
    ShutDownForce="TankShutDown"

    // Camera & view
    ViewShakeRadius=50.0 // was 600 in RO
    ViewShakeOffsetMag=(X=0.0,Y=0.0,Z=0.0) // was X=0.5,Z=2 in RO
    ViewShakeOffsetFreq=0.0 // was 7 in RO
    TPCamDistance=375.0
    TPCamLookat=(X=0.0,Y=0.0,Z=0.0)
    TPCamWorldOffset=(X=0.0,Y=0.0,Z=100.0)

    // Exit positions
    ExitPositions(0)=(X=0.0,Y=-165.0,Z=40.0)
    ExitPositions(1)=(X=0.0,Y=165.0,Z=40.0)
    ExitPositions(2)=(X=0.0,Y=-165.0,Z=-40.0)
    ExitPositions(3)=(X=0.0,Y=165.0,Z=-40.0)

    // Driving & steering
    MaxCriticalSpeed=700.0 // approx 42 kph
    TorqueCurve=(Points=((InVal=0.0,OutVal=12.0),(InVal=200.0,OutVal=3.0),(InVal=1500.0,OutVal=4.0),(InVal=2200.0,OutVal=0.0)))
    ChangeUpPoint=2050.0   // was 2000 in RO
    ChangeDownPoint=1100.0 // was 1000 in RO
    ChassisTorqueScale=0.9 // was 0.25 in RO
    bSpecialTankTurning=true
    TurnDamping=50.0
    SteerSpeed=160.0
    MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=35.0),(InVal=1500.0,OutVal=20.0),(InVal=1000000000.0,OutVal=15.0)))
    bHasHandbrake=true

    // Physics wheels properties
    WheelPenScale=2.0
    WheelLongFrictionFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.9),(InVal=10000000000.0,OutVal=0.9)))
    WheelLongFrictionScale=1.5
    WheelLatSlipFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=30.0,OutVal=0.009),(InVal=10000000000.0,OutVal=0.00)))
    WheelLatFrictionScale=3.0

    // Karma properties
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.0,Y=0.0,Z=-0.5)
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
        KMaxAngularSpeed=1.0 // slow down the angular velocity so the tank feels "heavier"
    End Object
    KParams=KarmaParamsRBFull'DH_Engine.DHArmoredVehicle.KParams0'
}

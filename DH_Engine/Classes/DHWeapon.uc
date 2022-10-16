//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHWeapon extends ROWeapon
    abstract;

var     int     TeamIndex;                      // Which team this weapon "belongs" to, used for ammo giving, you can't give enemy weapons ammo
                                                // Default: 2 which is neutral and allows anyone to reupply it

var     bool    bCanHaveInitialNumMagsChanged;  // Determines if the weapon will have initial number of magazines affected by the game's variables

var     float   SwayNotMovingModifier;
var     float   SwayRestingModifier;
var     float   SwayCrouchedModifier;
var     float   SwayProneModifier;
var     float   SwayTransitionModifier;
var     float   SwayLeanModifier;
var     float   SwayBayonetModifier;

var     bool            bIsMantling;
var     bool            bUsesIronsightFOV;
var     private float   PlayerIronsightFOV;
var     float           SwayModifyFactor;
var     float           BobModifyFactor;

// An alternate animation to `SelectAnim` that plays when a weapon is drawn
// for a first time.
var()   name            FirstSelectAnim;
var     bool            bHasBeenDrawn;

var     float           ResupplyInterval;
var     int             LastResupplyTimestamp;

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bIsMantling;
}

simulated function float GetPlayerIronsightFOV()
{
    if (bUsesIronsightFOV)
    {
        return PlayerIronsightFOV;
    }
    else
    {
        return class'DHPlayer'.default.DefaultFOV;
    }
}

// Modified to reset player's FOV back to default
simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    ResetPlayerFOV();
}

// Modified to prevent firing if player's weapons are locked due to spawn killing, with screen message if the local player
// Gets called on both client & server, so includes server verification that player's weapons aren't locked (belt & braces as clientside check stops it reaching server)
// Also modified to set the proper player animations for melee attacks
// Originally in the projectile weapon class, but moved here as it's possible for non-projectile weapons to be used for bash attacks, e.g. shovels
simulated function bool StartFire(int Mode)
{
    local class<DHWeaponFire> WF;
    local DHPlayer PC;

    WF = class<DHWeaponFire>(FireModeClass[Mode]);

    // Certain weapon fire modes are exempt from weapon locking logic (e.g. shovel "digging").
    if (Instigator != none && (WF == none || !WF.default.bIgnoresWeaponLock))
    {
        PC = DHPlayer(Instigator.Controller);

        if (PC != none && PC.AreWeaponsLocked())
        {
            return false;
        }
    }

    if (super.StartFire(Mode))
    {
        if (FireMode[Mode].bMeleeMode && ROPawn(Instigator) != none)
        {
            ROPawn(Instigator).SetMeleeHoldAnims(true);
        }

        return true;
    }

    return false;
}

// Function which should return how many pickups this weapon should drop
function int GetNumberOfDroppedPickups()
{
    return 1;
}

// Modfied to add randomize to a drop and to be more modular (please try to avoid duplicating this function everywhere)
function DropFrom(vector StartLocation)
{
    local Pickup  Pickup;
    local rotator R;
    local int     i;

    if (bCanThrow)
    {
        if (bUsingSights)
        {
            bUsingSights = false;

            if (ROPawn(Instigator) != none)
            {
                ROPawn(Instigator).SetIronSightAnims(false);
            }
        }

        ClientWeaponThrown();

        for (i = 0; i < NUM_FIRE_MODES; ++i)
        {
            if (FireMode[i].bIsFiring)
            {
                StopFire(i);
            }
        }

        if (Instigator != none)
        {
            DetachFromPawn(Instigator);
        }

        for (i = 0; i < GetNumberOfDroppedPickups(); ++i)
        {
            Pickup = Spawn(PickupClass,,, StartLocation, Rotation);

            if (Pickup != none)
            {
                R.Yaw = Rand(8000) - 4000; // about 23 degrees to either side, so roughly in the direction player is facing

                Pickup.InitDroppedPickupFor(self);
                Pickup.Velocity = Velocity >> R;
                Pickup.Velocity.X += RandRange(-100.0, 100.0);
                Pickup.Velocity.Y += RandRange(-100.0, 100.0);

                if (Instigator != none && Instigator.Health > 0)
                {
                    WeaponPickup(Pickup).bThrown = true;
                }
            }

            Pickup = none; // Make sure pickup is none (this probably isn't needed)
        }

        Destroy();
    }
}

// Resets player's FOV back to default
simulated function ResetPlayerFOV()
{
    if (InstigatorIsLocalHuman())
    {
        SetPlayerFOV(PlayerController(Instigator.Controller).DefaultFOV);
    }
}

// Sets player's FOV
simulated function SetPlayerFOV(float PlayerFOV)
{
    if (InstigatorIsLocalHuman())
    {
        PlayerController(Instigator.Controller).DesiredFOV = PlayerFOV;
    }
}

// Re-implemented to fix a long-standing bug where picking up a weapon while
// reloading an empty weapon would trigger a latent weapon change upon firing
// the currently held weapon.
function GiveTo(Pawn Other, optional Pickup Pickup)
{
    local ROWeaponPickup Pick;
    local int m;
    local weapon w;
    local bool bPossiblySwitch, bJustSpawned;
    local ROWeapon ROW;

    if (Pickup != none)
    {
        Pick = ROWeaponPickup(Pickup);

        if (Pick != none)
        {
            bBayonetMounted = Pick.bHasBayonetMounted;
        }
    }

    Instigator = Other;
    W = Weapon(Instigator.FindInventoryType(Class));

    if (W == none || W.Class != Class)
    {
        bJustSpawned = true;

        super(Inventory).GiveTo(Other);

        bPossiblySwitch = true;

        W = self;
    }
    else if (!W.HasAmmo())
    {
        bPossiblySwitch = true;
    }

    if (Pickup == none)
    {
        bPossiblySwitch = true;
    }

    for (m = 0; m < NUM_FIRE_MODES; ++m)
    {
        if (FireMode[m] != none)
        {
            FireMode[m].Instigator = Instigator;

            W.GiveAmmo(m, WeaponPickup(Pickup), bJustSpawned);
        }
    }

    // MODIFICATION:
    // Do not switch to this weapon if the user cannot switch from their current
    // weapon!
    ROW = ROWeapon(Instigator.Inventory);

    if (ROW != none && !ROW.WeaponCanSwitch())
    {
        bPossiblySwitch = false;
    }

    if (Instigator.Weapon != W)
    {
        W.ClientWeaponSet(bPossiblySwitch);
    }

    if (!bJustSpawned)
    {
        for (m = 0; m < NUM_FIRE_MODES; ++m)
        {
            Ammo[m] = none;
        }

        Destroy();
    }
}

// Modified to remove resetting DefaultFOV to hard coded RO value of 85
simulated function PlayerViewZoom(bool ZoomDirection)
{
    bPlayerViewIsZoomed = ZoomDirection;

    if (InstigatorIsHumanControlled())
    {
        if (bPlayerViewIsZoomed)
        {
            PlayerController(Instigator.Controller).SetFOV(PlayerFOVZoom);
        }
        else
        {
            PlayerController(Instigator.Controller).ResetFOV();
        }
    }
}

// State for player mantling over obstacle
simulated state StartMantle extends Busy
{
    simulated function Timer()
    {
        // Stay in this state until the mantle is complete, to keep the weapon lowered without actually switching it
        if (!bIsMantling)
        {
            GotoState('RaisingWeapon');
        }
        else
        {
            SetTimer(0.2, false);
        }
    }

    simulated function BeginState()
    {
        local int i;

        if (ClientState == WS_BringUp || ClientState == WS_ReadyToFire)
        {
            if (InstigatorIsLocallyControlled())
            {
                for (i = 0; i < NUM_FIRE_MODES; ++i)
                {
                    if (FireMode[i].bIsFiring)
                    {
                        ClientStopFire(i);
                    }
                }

                if (ClientState == WS_BringUp)
                {
                    if (HasAnim(GetSelectAnim()))
                    {
                        TweenAnim(GetSelectAnim(), PutDownTime);
                    }
                }
                else if (HasAnim(PutDownAnim))
                {
                    PlayAnim(PutDownAnim, PutDownAnimRate, 0.0);
                }
            }

            ClientState = WS_PutDown;
        }

        SetTimer(GetAnimDuration(PutDownAnim, PutDownAnimRate), false);

        for (i = 0; i < NUM_FIRE_MODES; ++i)
        {
            FireMode[i].bServerDelayStartFire = false;
            FireMode[i].bServerDelayStopFire = false;
        }
    }

    simulated function EndState()
    {
        if (ClientState == WS_PutDown)
        {
            ClientState = WS_Hidden;
        }
    }
}

// Modified to include states PostFiring & AutoLoweringWeapon
simulated function SetSprinting(bool bNewSprintStatus)
{
    if (FireMode[1].bMeleeMode && FireMode[1].bIsFiring)
    {
        return;
    }

    if (bNewSprintStatus)
    {
        if (ClientState != WS_PutDown && ClientState != WS_Hidden && !IsInState('WeaponSprinting') && !IsInState('RaisingWeapon')
            && !IsInState('LoweringWeapon') && !IsInState('PostFiring') && !IsInState('AutoLoweringWeapon'))
        {
            GotoState('StartSprinting');
        }
    }
    else if (IsInState('WeaponSprinting') || IsInState('StartSprinting'))
    {
        GotoState('EndSprinting');
    }
}

// Modified as DH only uses WeaponPickups (AmmoPickups are obsolete)
function bool HandlePickupQuery(Pickup Item)
{
    local int i;

    // If no passed item, prevent pick up & stops checking rest of Inventory chain
    if (Item == none)
    {
        return true;
    }

    // Pickup weapon is same as this weapon, so see if we can carry another
    if (Class == Item.InventoryType && WeaponPickup(Item) != none)
    {
        for (i = 0; i < NUM_FIRE_MODES; ++i)
        {
            if (AmmoClass[i] != none && AmmoCharge[i] < MaxAmmo(i) && WeaponPickup(Item).AmmoAmount[i] > 0)
            {
                AddAmmo(WeaponPickup(Item).AmmoAmount[i], i);

                // Need to do this here as we're going to prevent a new weapon pick up, so the pickup won't give a screen message or destroy/respawn itself
                Item.AnnouncePickup(Pawn(Owner));
                Item.SetRespawn();

                break;
            }
        }

        return true; // prevents pick up, as already have weapon, & stops checking rest of Inventory chain
    }

    // Pickup weapon's inventory slot is same as this weapon (& we can't carry more then one item in the same slot)
    if (Item.InventoryType.default.InventoryGroup == InventoryGroup)
    {
        // If this is the currently held weapon & it can be dropped by human player, throw it away & pick up the weapon on the ground
        if (InstigatorIsHumanControlled() && Instigator.Weapon != none && Instigator.Weapon.InventoryGroup == InventoryGroup && Instigator.CanThrowWeapon())
        {
            PlayerController(Instigator.Controller).ThrowWeapon();

            return false; // allows pick up of new weapon & stops checking rest of Inventory chain
        }

        return true; // prevents pick up (as can't carry more than 1 item in same slot) & stops checking rest of Inventory chain
    }

    // Didn't do any pick up for this weapon, so pass this query on to the next item in the Inventory chain
    // If we've reached the last Inventory item, returning false will allow pick up of the weapon
    return Inventory != none && Inventory.HandlePickupQuery(Item);
}

// Modified so resupply point gradually replenishes ammo (no full resupply in one go)
function bool FillAmmo()
{
    if (Level.TimeSeconds > LastResupplyTimestamp + ResupplyInterval)
    {
        if (AmmoAmount(0) < MaxAmmo(0))
        {
            AddAmmo(1, 0);
            LastResupplyTimestamp = Level.TimeSeconds;
            return true;
        }
    }

    return false;
}

// Modified to avoid "accessed none" errors on Instigator
simulated state Idle
{
    simulated function BeginState()
    {
        if (ClientState == WS_BringUp)
        {
            PlayIdle();
            ClientState = WS_ReadyToFire;
        }

        // If we started sprinting during another activity, as soon as it completes start the weapon sprinting
        if (Instigator != none && Instigator.bIsSprinting)
        {
            SetSprinting(true);
        }

        // Send the weapon to crawling if we started crawling during some other activity that couldn't be interrupted
        if (Instigator != none && Instigator.bIsCrawling && CanStartCrawlMoving() && VSizeSquared(Instigator.Velocity) > 1.0)
        {
            GotoState('StartCrawling');
        }
    }
}

// Implemented in subclasses as required
simulated state PostFiring
{
}

simulated state RaisingWeapon
{
    simulated function bool IsBusy()
    {
        return Mesh != none && HasAnim(FirstSelectAnim) && !bHasBeenDrawn;
    }

    simulated function EndState()
    {
        super.EndState();

        bHasBeenDrawn = true;
    }
}

// New state to automatically lower one-shot weapons, then either bring up another if player still has more, or switch to a different weapon if just used last one
simulated state AutoLoweringWeapon extends LoweringWeapon
{
    simulated function bool IsBusy()
    {
        return true;
    }

    simulated function bool WeaponCanSwitch()
    {
        return ClientState == WS_PutDown;
    }

    simulated function Timer()
    {
        local Inventory Inv;
        local bool      bFoundOtherWeapon;
        local int       i;

        // If we still have more of the weapon, bring up a new one
        if (AmmoAmount(0) > 0)
        {
            if (Instigator != none)
            {
                Instigator.PendingWeapon = self;
            }

            BringUp(self);
        }
        // Otherwise if we have no more, try to switch to a new weapon
        else if (InstigatorIsLocallyControlled())
        {
            // Need to check if we have another weapon, otherwise this weapon can get stuck in this state
            for (Inv = Instigator.Inventory; Inv != none && i < 500; Inv = Inv.Inventory)
            {
                if (Weapon(Inv) != none && Inv != self)
                {
                    bFoundOtherWeapon = true;
                    break;
                }

                ++i;
            }
        }

        if (bFoundOtherWeapon)
        {
            DoAutoSwitch(); // switch to best weapon
        }
        else
        {
            GotoState('Idle');
        }
    }

    simulated function BeginState()
    {
        local int i;

        if (ClientState == WS_BringUp || ClientState == WS_ReadyToFire)
        {
            if (InstigatorIsLocallyControlled())
            {
                for (i = 0; i < NUM_FIRE_MODES; ++i)
                {
                    if (FireMode[i].bIsFiring)
                    {
                        ClientStopFire(i);
                    }
                }

                if (ClientState == WS_BringUp)
                {
                    if (HasAnim(GetSelectAnim()))
                    {
                        TweenAnim(GetSelectAnim(), PutDownTime);
                    }
                }
                else if (HasAnim(PutDownAnim))
                {
                    PlayAnim(PutDownAnim, PutDownAnimRate, FastTweenTime);
                }
            }

            ClientState = WS_PutDown;
        }

        SetTimer(GetAnimDuration(PutDownAnim, PutDownAnimRate), false);

        for (i = 0; i < NUM_FIRE_MODES; ++i)
        {
            FireMode[i].bServerDelayStartFire = false;
            FireMode[i].bServerDelayStopFire = false;
        }
    }

    simulated function EndState()
    {
        local int i;

        if (ClientState == WS_PutDown)
        {
            if (Instigator.PendingWeapon == none)
            {
                PlayIdle();
                ClientState = WS_ReadyToFire;
            }
            else
            {
                ClientState = WS_Hidden;

                if (Instigator != none)
                {
                    Instigator.ChangedWeapon();
                }

                for (i = 0; i < NUM_FIRE_MODES; ++i)
                {
                    FireMode[i].DestroyEffects();
                }
            }
        }

        // If we don't have another of these weapons, self-destruct now
        if (Role == ROLE_Authority && AmmoAmount(0) < 1 && !bDeleteMe)
        {
            GotoState('Idle');
            SelfDestroy();
        }
    }
}

// New function that allows weapon to destroy itself without spawning a pickup, e.g. when used the last grenade
function SelfDestroy()
{
    local int i;

    for (i = 0; i < NUM_FIRE_MODES; ++i)
    {
        if (FireMode[i].bIsFiring)
        {
            StopFire(i);
        }
    }

    if (Instigator != none)
    {
        DetachFromPawn(Instigator);
    }

    ClientWeaponThrown();

    Destroy();
}

// Modified so an ROEmptyFireClass won't return busy just because it can't fire (it never can)
// TODO: change this so it only returns true if FireMode[1] actually is a melee attack, rather than assume it always will be (as ROWeapon did)
// Then remove hack fix in MG weapon class, which stops the MG34 from bugging out as perma-busy when it's out of ammo, just because it has a non-melee FireMode[1]
simulated function bool IsBusy()
{
    return !FireMode[1].AllowFire() && FireModeClass[1] != class'ROEmptyFireClass';
}

// Modified to optimise, as gets called every PostNetReceive()
simulated function CheckOutOfAmmo()
{
    if (IsCurrentWeapon() && AmmoCharge[0] <= 0 && AmmoCharge[1] <= 0)
    {
        OutOfAmmo();
    }
}

// Modified so HUD shows ammo count based on number of these weapons carried
simulated function int GetHudAmmoCount()
{
    return AmmoAmount(0);
}

// Implemented in subclasses
function bool AssistedReload()
{
    return false;
}

simulated function bool WeaponAllowMantle()
{
    return true;
}

// Determines if the weapon is thrown on death.
function bool CanDeadThrow()
{
    return bCanThrow && Level.Game.bAllowWeaponThrowing;
}

// Modified to avoid "accessed none" Instigator log errors
simulated function ClientWeaponThrown()
{
    local int i;

    AmbientSound = none;

    if (ROWeaponAttachment(ThirdPersonActor) != none)
    {
        ROWeaponAttachment(ThirdPersonActor).AmbientSound = none;
    }

    if (Level.NetMode == NM_Client && Instigator != none)
    {
        Instigator.DeleteInventory(self);

        for (i = 0; i < NUM_FIRE_MODES; ++i)
        {
            if (Ammo[i] != none)
            {
                Instigator.DeleteInventory(Ammo[i]);
            }
        }
    }
}

// Added function to this class to handle all related pre-caching - DHRoleInfo.HandlePrecache calls it on every inventory item (assuming it is a DHWeapon)
static function StaticPrecache(LevelInfo L)
{
    local int i;

    for (i = 0; i < default.Skins.Length; ++i)
    {
        if (default.Skins[i] != none)
        {
            L.AddPrecacheMaterial(default.Skins[i]); // 1st person mesh skins
        }
    }

    if (default.HighDetailOverlay != none)
    {
        L.AddPrecacheMaterial(default.HighDetailOverlay); // 1st person mesh shader
    }

    if (default.AttachmentClass != none)
    {
        for (i = 0; i < default.AttachmentClass.default.Skins.Length; ++i)
        {
            if (default.AttachmentClass.default.Skins[i] != none)
            {
                L.AddPrecacheMaterial(default.AttachmentClass.default.Skins[i]); // 3rd person mesh skins
            }
        }
    }

    if (default.FireModeClass[0].default.AmmoClass != none && default.FireModeClass[0].default.AmmoClass.default.IconMaterial != none)
    {
        L.AddPrecacheMaterial(default.FireModeClass[0].default.AmmoClass.default.IconMaterial); // HUD icon
    }

    if (default.FireModeClass[0].default.ProjectileClass != none && default.FireModeClass[0].default.ProjectileClass.default.StaticMesh != none)
    {
        L.AddPrecacheStaticMesh(default.FireModeClass[0].default.ProjectileClass.default.StaticMesh); // projectile SM
    }

    if (default.PickupClass != none && default.PickupClass.default.StaticMesh != none)
    {
        L.AddPrecacheStaticMesh(default.PickupClass.default.StaticMesh); // pickup SM
    }
}

// New functions used by DHPawn to pass lean events to the weapon for
// possible consumption. Return true to consume the lean event.
simulated function bool WeaponLeanRight() { return false; }
simulated function WeaponLeanRightReleased();
simulated function bool WeaponLeanLeft() { return false; }
simulated function WeaponLeanLeftReleased();

/////////////////////////////////////////////////////////////
// New functions to save code repetition in many functions //
/////////////////////////////////////////////////////////////

simulated function bool InstigatorIsLocallyControlled()
{
    return Instigator != none && Instigator.IsLocallyControlled();
}

simulated function bool InstigatorIsHumanControlled()
{
    return Instigator != none && Instigator.IsHumanControlled();
}

simulated function bool InstigatorIsLocalHuman()
{
    return InstigatorIsLocallyControlled() && Instigator.IsHumanControlled();
}

simulated function bool IsCurrentWeapon()
{
    return Instigator != none && Instigator.Weapon == self;
}

simulated function PlayAnimAndSetTimer(name Anim, float AnimRate, optional float ServerTimerReduction)
{
    local float AnimTimer;

    if (HasAnim(Anim))
    {
        if (InstigatorIsLocallyControlled())
        {
            PlayAnim(Anim, AnimRate, FastTweenTime);
        }

        AnimTimer = GetAnimDuration(Anim, AnimRate) + FastTweenTime;

        if (ServerTimerReduction > 0.0 && (Level.NetMode == NM_DedicatedServer || (Level.NetMode == NM_ListenServer && !InstigatorIsLocallyControlled())))
        {
            SetTimer(AnimTimer * (1.0 - ServerTimerReduction), false);
        }
        else
        {
            SetTimer(AnimTimer, false);
        }
    }
    else // if there is no valid animation, just call the timer immediately, as we'll often need it to do something like exit the current state
    {
        Timer();
    }
}

// Modified to remove the RODebugMode check in ROWeapon, which prevented this from running at all in DHPlayer
// Don't need to replace that with an equivalent DHDebugMode check because that's already checked in the ShowDebug() exec function that enables this
simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
    super(Weapon).DisplayDebug(Canvas, YL, YPos);

    Canvas.DrawText("DisplayFOV =" @ DisplayFOV @ " Default =" @ default.DisplayFOV @ "Zoomed default =" @ IronSightDisplayFOV);
    YPos += YL;
    Canvas.SetPos(4.0, YPos);
}

exec function SetMuzzleOffset(int X, int Y, int Z)
{
    local int i;
    local DHWeaponFire WF;
    local vector V;

    V.X = X;
    V.Y = Y;
    V.Z = Z;

    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        for (i = 0; i < arraycount(FireMode); ++i)
        {
            WF = DHWeaponFire(FireMode[i]);

            if (WF != none)
            {
                if (WF.FlashEmitter != none)
                {
                    WF.FlashEmitter.SetRelativeLocation(V);
                }

                if (WF.SmokeEmitter != none)
                {
                    WF.SmokeEmitter.SetRelativeLocation(V);
                }
            }
        }
    }
}

// New debug exec to toggle the 1st person weapon's HighDetailOverlay (generally a specularity shader) on or off
exec function ToggleHDO()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        if (default.HighDetailOverlay != none)
        {
            if (HighDetailOverlay == default.HighDetailOverlay)
            {
                HighDetailOverlay = none;
                Log(ItemName @ "disabled HighDetailOverlay:" @ default.HighDetailOverlay);
            }
            else
            {
                HighDetailOverlay = default.HighDetailOverlay;
                Log(ItemName @ "enabled HighDetailOverlay :" @ HighDetailOverlay);
            }
        }
        else
        {
            Log(ItemName @ "doesn't have a HighDetailOverlay to toggle");
        }
    }
}

// This function overrides ROWeapon's (see NextWeapon for more info)
simulated function Weapon PrevWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
    if ((CurrentChoice == none))
    {
        if (CurrentWeapon != self)
        {
            CurrentChoice = self;
        }
    }
    else if (CurrentChoice.InventoryGroup == CurrentWeapon.InventoryGroup && CurrentChoice.GroupOffset > CurrentWeapon.GroupOffset)
    {
        CurrentChoice = self;
    }
    else if (InventoryGroup == CurrentWeapon.InventoryGroup)
    {
        if (GroupOffset < CurrentWeapon.GroupOffset &&
           (CurrentChoice.InventoryGroup != InventoryGroup || GroupOffset > CurrentChoice.GroupOffset))
        {
            CurrentChoice = self;
        }
    }
    else if (InventoryGroup == CurrentChoice.InventoryGroup)
    {
        if (GroupOffset > CurrentChoice.GroupOffset)
        {
            CurrentChoice = self;
        }
    }
    else if (InventoryGroup > CurrentChoice.InventoryGroup)
    {
        if (InventoryGroup < CurrentWeapon.InventoryGroup || CurrentChoice.InventoryGroup > CurrentWeapon.InventoryGroup)
        {
            CurrentChoice = self;
        }
    }
    else if (CurrentChoice.InventoryGroup > CurrentWeapon.InventoryGroup && InventoryGroup < CurrentWeapon.InventoryGroup)
    {
        CurrentChoice = self;
    }

    if (Inventory == none)
    {
        return CurrentChoice;
    }
    else
    {
        return Inventory.PrevWeapon(CurrentChoice,CurrentWeapon);
    }
}

// This function overrides ROWeapon's
// This function is recursive and on the client
// Basically when you "NextWeapon" it goes through your inventory, each part of the inventory calling the nexts "NextWeapon" until
// the inventory has been interated through. It keeps track of the "choice" and some weapons can "win" over others by replacing itself as the CurrentChoice
simulated function Weapon NextWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
    if (CurrentChoice == none)
    {
        if (CurrentWeapon != self)
        {
            CurrentChoice = self;
        }
    }
    else if (InventoryGroup == CurrentWeapon.InventoryGroup)
    {
        if (GroupOffset > CurrentWeapon.GroupOffset && (CurrentChoice.InventoryGroup != InventoryGroup || GroupOffset < CurrentChoice.GroupOffset))
        {
            CurrentChoice = self;
        }
    }
    else if (InventoryGroup == CurrentChoice.InventoryGroup)
    {
        if (GroupOffset < CurrentChoice.GroupOffset)
        {
            CurrentChoice = self;
        }
    }
    else if (InventoryGroup < CurrentChoice.InventoryGroup)
    {
        if (InventoryGroup > CurrentWeapon.InventoryGroup || CurrentChoice.InventoryGroup < CurrentWeapon.InventoryGroup)
        {
            CurrentChoice = self;
        }
    }
    // If the chosen weapon's inventory group is < the current selected weapon AND
    // this weapon's inventory group is greater than current selected weapon's inventory group, then set current choice to this weapon
    else if (CurrentChoice.InventoryGroup < CurrentWeapon.InventoryGroup && InventoryGroup > CurrentWeapon.InventoryGroup)
    {
        CurrentChoice = self;
    }
    // If the chosen's inventory group is <= the current weapon's AND the chosen's group offset is < the currentweapon's, then pick me!
    // This is added, because unlike RO DH supports items on the same inventory slot
    // This is needed so players with multiple items on the same slot can cycle through and onto the next slot (otherwise it loops in the same slot)
    else if (CurrentChoice.InventoryGroup == CurrentWeapon.InventoryGroup && CurrentChoice.GroupOffset < CurrentWeapon.GroupOffset)
    {
        CurrentChoice = self;
    }

    if (Inventory == none)
    {
        return CurrentChoice;
    }
    else
    {
        return Inventory.NextWeapon(CurrentChoice,CurrentWeapon);
    }
}

exec simulated function SetPlayerViewOffset(int X, int Y, int Z)
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        default.PlayerViewOffset.X = X;
        default.PlayerViewOffset.Y = Y;
        default.PlayerViewOffset.Z = Z;
    }
}

simulated function name GetSelectAnim()
{
    if (FirstSelectAnim != '' && !bHasBeenDrawn)
    {
        return FirstSelectAnim;
    }

    return SelectAnim;
}

// This function handles sleeve and hand swapping depending on the player's role
// (overriden to support hand textures).
simulated function HandleSleeveSwapping()
{
    local Material RoleSleeveTexture, RoleHandTexture;
    local DHRoleInfo RI;
    local ROPlayer PC;

    // Don't bother with AI players.
    if (!Instigator.IsHumanControlled() || !Instigator.IsLocallyControlled())
    {
        return;
    }

    PC = ROPlayer(Instigator.Controller);

    if (PC != none)
    {
        RI = DHRoleInfo(PC.GetRoleInfo());
    }

    if (RI != none)
    {
        RoleSleeveTexture = RI.static.GetSleeveTexture();
        RoleHandTexture = RI.GetHandTexture(class'DH_LevelInfo'.static.GetInstance(Level));
    }

    if (RoleSleeveTexture != none && SleeveNum >= 0)
    {
        Skins[SleeveNum] = RoleSleeveTexture;
    }

    if (HandNum >= 0)
    {
        // We want our hands to look consistent when we change weapons.
        // Handtex is still supported to preserve the old functionality,
        // but hand textures defined by roles will take precedence.
        if (RoleHandTexture != none)
        {
            Skins[HandNum] = RoleHandTexture;
        }
        else
        {
            Skins[HandNum] = Handtex;
        }
    }
}

defaultproperties
{
    // Sway modifiers
    SwayModifyFactor=0.7
    SwayNotMovingModifier=0.5
    SwayRestingModifier=0.25
    SwayCrouchedModifier=0.9
    SwayProneModifier=0.5
    SwayTransitionModifier=4.5
    SwayLeanModifier=1.25
    SwayBayonetModifier=1.2

    PlayerIronsightFOV=60.0
    BobModifyFactor=0.9
    BobDamping=1.6
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    ScopeDetail=RO_TextureScope
    FireModeClass(0)=class'ROInventory.ROEmptyFireclass'
    FireModeClass(1)=class'ROInventory.ROEmptyFireclass'
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"

    TeamIndex=2
    bCanHaveInitialNumMagsChanged=true

    bUsesIronsightFOV=true

    ResupplyInterval=2.5
}

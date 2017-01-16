//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHWeapon extends ROWeapon
    abstract;

var     bool    bIsMantling;
var     float   PlayerIronsightFOV;
var     float   SwayModifyFactor;
var     float   BobModifyFactor;

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bIsMantling;
}

// Modified to reset player's FOV back to default
simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    ResetPlayerFOV();
}

// Modified to prevent firing if player's weapons are locked due to spawn killing, with screen message if the local player
// Gets called on both client & server, so includes server verification that player's weapons aren't locked (belt & braces as clientside check stops it reaching server)
simulated function bool StartFire(int Mode)
{
    // Passing the locally controlled check into AreWeaponsLocked() function means only local player receives "Your weapons are locked for X seconds" screen message
    if (Instigator != none && DHPlayer(Instigator.Controller) != none && DHPlayer(Instigator.Controller).AreWeaponsLocked(InstigatorIsLocallyControlled()))
    {
        return false;
    }

    return super.StartFire(Mode);
}

// Modified to take player out of ironsights if necessary, & to allow for multiple copies of weapon to drop with spread (so they aren't inside each other)
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

        for (i = 0; i < AmmoAmount(0); ++i)
        {
            R.Yaw = Rand(16000) - 8000; // about 45 degrees to either side, so roughly in the direction player is facing

            Pickup = Spawn(PickupClass,,, StartLocation, R);

            if (Pickup != none)
            {
                Pickup.InitDroppedPickupFor(self);
                Pickup.Velocity = Velocity >> R;
                Pickup.Velocity.X += RandRange(-100.0, 100.0);
                Pickup.Velocity.Y += RandRange(-100.0, 100.0);

                if (Instigator != none && Instigator.Health > 0)
                {
                    WeaponPickup(Pickup).bThrown = true;
                }

                Pickup = none;
            }
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
                    if (HasAnim(SelectAnim))
                    {
                        TweenAnim(SelectAnim, PutDownTime);
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
    if (AmmoAmount(0) < MaxAmmo(0))
    {
        AddAmmo(1, 0);

        return true;
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
                    if (HasAnim(SelectAnim))
                    {
                        TweenAnim(SelectAnim, PutDownTime);
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
    return bCanThrow;
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

defaultproperties
{
    PlayerIronsightFOV=60.0
    SwayModifyFactor=0.66
    BobModifyFactor=0.2
    BobDamping=1.6
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    ScopeDetail=RO_TextureScope
    FireModeClass(0)=class'ROInventory.ROEmptyFireclass'
    FireModeClass(1)=class'ROInventory.ROEmptyFireclass'
}

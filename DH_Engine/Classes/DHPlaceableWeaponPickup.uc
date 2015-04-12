//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHPlaceableWeaponPickup extends ROPlaceableAmmoPickup;

var()   class<Inventory>    WeaponType; // the pickup weapon class - either specify in weapon-specific subclass, or leveller can place this generic class & set weapon in editor

replication
{
    // Variables the server will replicate to clients when this actor is 1st replicated
    reliable if (bNetInitial && Role == ROLE_Authority)
        WeaponType;
}

// Modified to set StaticMesh, mesh DrawScale & InventoryType if they haven't been specified, based on WeaponType (which is replicated, so these can be set on clients too)
// A leveller may have used this placeable class & set the WeaponType in the editor, in which we won't have the default properties found in a weapon-specific subclass
// A smart leveller will at least set StaticMesh in editor, so it displays correctly in editor & can be positioned accurately, but this ensures correct weapon properties will be used in game
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (WeaponType == none && Role == ROLE_Authority)
    {
        Error(self @ "self-destructing as no WeaponType has been set");
    }

    if (Level.NetMode != NM_DedicatedServer && StaticMesh == default.StaticMesh && WeaponType.default.PickupClass != none)
    {
        SetStaticMesh(WeaponType.default.PickupClass.default.StaticMesh);

        if (DrawScale == 1.0 && WeaponType.default.PickupClass.default.DrawScale != 1.0)
        {
            SetDrawScale(WeaponType.default.PickupClass.default.DrawScale);
        }
    }

    if (InventoryType == none && class<Weapon>(WeaponType) != none && class<Weapon>(WeaponType).default.FireModeClass[0] != none)
    {
        InventoryType = class<Weapon>(WeaponType).default.FireModeClass[0].default.AmmoClass;
    }
}

// Modified to give the player the weapon, instead of ammo, including handling the situation where player already has a weapon in same inventory slot as the pickup weapon
auto state Pickup
{
    function UsedBy(Pawn User)
    {
        local Inventory Copy, Inv;
        local bool      bHasWeapon;

        if (User == none)
        {
            return;
        }

        if (User.Inventory != none)
        {
            for (Inv = User.Inventory; Inv != none; Inv = Inv.Inventory)
            {
                // Abort pick up if player already has a weapon in the same inventory slot (unless it's their current weapon, in which case we'll drop it later)
                if (Inv.InventoryGroup == WeaponType.default.InventoryGroup && (User.Weapon == none || User.Weapon.Class != Inv.Class))
                {
                    return;
                }

                // Check if the player already has the same weapon - if they do, we'll just give them ammo (or exit if they have full ammo)
                if (Weapon(Inv) != none && Inv.Class == WeaponType)
                {
                    if (Weapon(Inv).AmmoMaxed(0))
                    {
                        return;
                    }

                    bHasWeapon = true;
                    break;
                }
            }
        }

        // Valid touch will pick up the object, or ammo if player already has the weapon
        if (ValidTouch(User))
        {
            if (bHasWeapon)
            {
                Copy = SpawnCopy(User); // Matt TODO: meant to give ammo if player already has same weapon - seems to work for AT weapons but not for guns needing mags
            }
            else
            {
                // Player's current weapon is same InventoryGroup as the pickup, so drop current weapon & and pick up the one on the ground
                if (User.Weapon != none && User.Weapon.InventoryGroup == WeaponType.default.InventoryGroup && User.CanThrowWeapon() && PlayerController(User.Controller) != none)
                {
                    PlayerController(User.Controller).ThrowWeapon();
                }

                Copy = SpawnWeaponCopy(User);
            }

            AnnouncePickup(User);

            if (Copy != none)
            {
                Copy.PickupFunction(User);
            }

            SetRespawn();
        }
    }

// Modified to make sure replication is enabled, as will have been disabled if pickup has been used & is inactive
Begin:
    RemoteRole = default.RemoteRole;
    CheckTouching();
}

// Modified to enable replication as pickup is now inactive
state Sleeping
{
Begin:
    Sleep(1.0); // allow a little time for bHidden to replicate to clients, before switching off all further replication (by setting RemoteRole to none)
    RemoteRole = ROLE_None;
    Sleep(GetReSpawnTime() - RespawnEffectTime - 1.0);
    Goto('Respawn');
}

// Modified to always go inactive instead of being destroyed
// Pickup may respawn if suitable RespawnTime was set, but even if a very high time effectively prevents respawning, Sleeping state still allows pickup to be rectivated if we reset the match
function SetRespawn()
{
    StartSleeping();
}

// New function to give weapon to player (it's a weapon version of SpawnCopy, which gives ammo)
function Inventory SpawnWeaponCopy(Pawn Other)
{
    local Inventory Copy;

    if (Inventory != none)
    {
        Copy = Inventory;
        Inventory = none;
    }
    else
    {
        Copy = Other.Spawn(WeaponType, Other,,, rot(0, 0, 0));
    }

    Copy.GiveTo(Other, self);

    return Copy;
}

// Modified to pass the weapon class when calling ReceiveLocalizedMessage(), which allows the message class to access the weapon's name
simulated event NotifySelected(Pawn User)
{
    if (User.IsHumanControlled() && (Level.TimeSeconds - LastNotifyTime) >= TouchMessageClass.default.LifeTime)
    {
        PlayerController(User.Controller).ReceiveLocalizedMessage(TouchMessageClass,,,, WeaponType);
        LastNotifyTime = Level.TimeSeconds;
    }
}

// Modified to pass the weapon class when calling ReceiveLocalizedMessage(), which allows the message class to access the weapon's name
// Avoid calling HandlePickup() for a human player & instead do what that funbction does, except for the modfied message call
function AnnouncePickup(Pawn Receiver)
{
    if (Receiver.IsHumanControlled())
    {
        PlayerController(Receiver.Controller).ReceiveLocalizedMessage(MessageClass,,,, WeaponType);
    }
    else
    {
        Receiver.HandlePickup(self); // bots don't need a messages, so just revert to default call to HandlePickup()
    }

    PlaySound(PickupSound, SLOT_Interact);
    MakeNoise(0.2);
}

// Modified to skip over the Super in ROPlaceableAmmoPickup, as it just duplicates the Super in Pickup
function Reset()
{
    super(Pickup).Reset();
}

static function StaticPrecache(LevelInfo L)
{
    if (default.WeaponType != none &&
        default.WeaponType.default.PickupClass != none &&
        default.WeaponType.default.PickupClass.default.StaticMesh != none)
    {
        L.AddPrecacheStaticMesh(default.WeaponType.default.PickupClass.default.StaticMesh);
    }
}

defaultproperties
{
    AmmoAmount=1
    bAmmoPickupIsWeapon=true
    PickupMessage="You got the %w"
    TouchMessage="Pick up: %w"
    MessageClass=class'DHWeaponPickupMessage' // new message classes that are passed the weapon class & use it to lookup the weapon name (for touch or pickup screen messages)
    TouchMessageClass=class'DHWeaponPickupTouchMessage'
    PickupSound=sound'Inf_Weapons_Foley.WeaponPickup'
    PickupForce="AssaultRiflePickup"
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.satchel' // just to make sure we see the pickup in the editor - in game the StaticMesh will be set based on WeaponType
    AmbientGlow=10
    PrePivot=(X=0.0,Y=0.0,Z=3.0)
    CollisionRadius=25.0
    CollisionHeight=3.0
}

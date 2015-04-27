//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHPlaceableWeaponPickup extends DHWeaponPickup
    placeable;

var() class<Weapon> WeaponType; // the pickup weapon class - either specify in weapon-specific subclass, or leveller can place this generic class & set weapon in editor

replication
{
    // Variables the server will replicate to clients when this actor is 1st replicated
    reliable if (bNetInitial && Role == ROLE_Authority)
        WeaponType;
}

// Emptied out the Super in WeaponPickup, as we won't yet have an InventoryType (have to wait until PostNetBeginPlay, when net client receives replicated WeaponType)
function PostBeginPlay()
{
}

// Modified to set InventoryType from the replicated WeaponType, then setting StaticMesh & mesh DrawScale if they haven't been specified
// A leveller may have used this placeable class & set the WeaponType in the editor, in which we won't have the default properties found in a weapon-specific subclass
// A smart leveller will at least set StaticMesh in editor, so it displays correctly in editor & can be positioned accurately - but here we ensure correct in-game weapon properties
simulated function PostNetBeginPlay()
{
    local class<Pickup> PickupClass;

    if (WeaponType != none)
    {
        InventoryType = WeaponType;

        MaxDesireability = 1.2 * WeaponType.default.AIRating;

        if (Level.NetMode != NM_DedicatedServer)
        {
            PickupClass = InventoryType.default.PickupClass;

            if (PickupClass != none)
            {
                if (StaticMesh != PickupClass.default.StaticMesh)
                {
                    SetStaticMesh(PickupClass.default.StaticMesh);
                }

                if (DrawScale != PickupClass.default.DrawScale)
                {
                    SetDrawScale(PickupClass.default.DrawScale);
                }
            }
        }
    }
    else if (Role == ROLE_Authority)
    {
        Error(self @ "self-destructing as no WeaponType has been set");
    }
}

// New function, very similar to InitDroppedPickupFor(), but here we have to use weapon class defaults, as we don't have an actual weapon actor
function InitPickup()
{
    local class<DHProjectileWeapon> W;
    local int InitialAmount, i;

    if (WeaponType.default.FireModeClass[0].default.AmmoClass != none)
    {
        InitialAmount = WeaponType.default.FireModeClass[0].default.AmmoClass.default.InitialAmount;
    }

    W = class<DHProjectileWeapon>(InventoryType);

    // Load the pickup with the ammo the weapon would start loaded with
    if (W == none || !W.default.bDoesNotRetainLoadedMag)
    {
        AmmoAmount[0] = InitialAmount;
    }

    if (W != none)
    {
        for (i = 0; i < W.default.InitialNumPrimaryMags; ++i)
        {
            AmmoMags[AmmoMags.Length] = InitialAmount; // give the pickup the ammo mags the weapon would start with
        }

        bHasBayonetMounted = W.default.bBayonetMounted;

        if (W.default.InitialBarrels > 0 && W.default.BarrelClass != none)
        {
            bHasBarrel = true;
            LevelCTemp = class'DHWeaponBarrel'.static.FtoCelsiusConversion(DarkestHourGame(Level.Game).LevelInfo.TempFahrenheit);
            Temperature = LevelCTemp;
            BarrelCoolingRate = W.default.BarrelClass.default.BarrelCoolingRate;
            bBarrelFailed = false;

            if (W.default.InitialBarrels > 1)
            {
                bHasSpareBarrel = true;
                RemainingBarrel = 1;
                Temperature2 = LevelCTemp;
            }
        }
    }
}

// Modified to check whether player already has a weapon in the same inventory slot & to call SetRespawn()
auto state Pickup
{
    function UsedBy(Pawn User)
    {
        local Inventory Copy;

        if (ValidTouch(User))
        {
            Copy = SpawnCopy(User);

            if (Copy != none)
            {
                Copy.PickupFunction(User);
            }

            AnnouncePickup(User);
            SetRespawn(); // instead of Destroy() for normal, temporary weapon pickup
        }
    }

// Modified to make sure replication is enabled, as will have been disabled if pickup has been used & is inactive
Begin:
    RemoteRole = default.RemoteRole;
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
// Pickup may respawn if suitable RespawnTime was set, but even if a very high time effectively prevents respawning, Sleeping state still allows pickup to be rectivated if match is reset
function SetRespawn()
{
    StartSleeping();
}

// Modified to pass the weapon class when calling ReceiveLocalizedMessage(), which allows the message class to access the weapon's name
simulated event NotifySelected(Pawn User)
{
    if (User.IsHumanControlled() && (Level.TimeSeconds - LastNotifyTime) >= TouchMessageClass.default.LifeTime)
    {
        PlayerController(User.Controller).ReceiveLocalizedMessage(TouchMessageClass,,,, InventoryType);
        LastNotifyTime = Level.TimeSeconds;
    }
}

// Modified to pass the weapon class when calling ReceiveLocalizedMessage(), which allows the message class to access the weapon's name
// Avoid calling HandlePickup() for a human player & instead do what that funbction does, except for the modfied message call
function AnnouncePickup(Pawn Receiver)
{
    if (Receiver.IsHumanControlled())
    {
        PlayerController(Receiver.Controller).ReceiveLocalizedMessage(MessageClass,,,, InventoryType);
    }
    else
    {
        Receiver.HandlePickup(self); // bots don't need a messages, so just revert to default call to HandlePickup()
    }

    PlaySound(PickupSound, SLOT_Interact);
    MakeNoise(0.2);
}

// Modified to call InitPickup() & to skip over the Super in ROPlaceableAmmoPickup, as it just duplicates the Super in Pickup
// Note that this function gets called when a new round starts, so we always start with InitPickup() & not just if match is reset in the middle of a round
function Reset()
{
    InitPickup();

    super(Pickup).Reset();
}

// Modified to call StaticPrecache() on the WeaponType (but pointless on net client, as this actor won't replicate to client until after level has finished pre-caching)
simulated function UpdatePrecacheMaterials()
{
    if (Role == ROLE_Authority && class<DHWeapon>(WeaponType) != none)
    {
        class<DHWeapon>(WeaponType).static.StaticPrecache(Level);
    }
}

defaultproperties
{
    MessageClass=class'DHWeaponPickupMessage' // new message classes that are passed the weapon class & use it to lookup the weapon name (for touch or pickup screen messages)
    TouchMessageClass=class'DHWeaponPickupTouchMessage'
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.satchel' // just to make sure we see the pickup in the editor - in game the StaticMesh will be set based on InventoryType
    Physics=PHYS_None
    bWeaponStay=false
    bIgnoreEncroachers=false
    bAlwaysRelevant=false
    NetUpdateFrequency=8.0
}

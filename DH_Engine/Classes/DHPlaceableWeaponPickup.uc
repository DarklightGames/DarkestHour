//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHPlaceableWeaponPickup extends DHWeaponPickup
    placeable;

var(Pickup) bool    bRespawn;         // the pickup will respawn the weapon in RespawnTime seconds if true
var() class<Weapon> WeaponType;       // the pickup weapon class - either specify in weapon-specific subclass, or leveller can place this generic class & set weapon in editor
var   bool          bIsOneShotWeapon; // pickup weapon is a one shot weapon, e.g. a grenade, satchel or faust

replication
{
    // Variables the server will replicate to clients when this actor is 1st replicated
    reliable if (bNetInitial && Role == ROLE_Authority)
        WeaponType;
}

// Emptied out as net client won't yet have InventoryType (have to wait until PostNetBeginPlay, when client receives replicated WeaponType)
simulated function PreBeginPlay()
{
}

// Emptied out as net client won't yet have InventoryType (have to wait until PostNetBeginPlay, when client receives replicated WeaponType)
simulated event PostBeginPlay()
{
}

// Modified to set InventoryType from the replicated WeaponType, then setting other properties from that weapon's normal PickupClass
// A smart leveller using this generic placeable pickup will at least set StaticMesh in the editor, so it displays correctly in editor & can be positioned accurately
// Also to do some stuff usually done in earlier BeginPlay events, but here a net client has only just received the replicated WeaponType to set its InventoryType
simulated event PostNetBeginPlay()
{
    local class<Pickup> PickupClass;

    if (WeaponType != none)
    {
        // Set InventoryType from replicated WeaponType specified by leveller, & now do some stuff usually done in earlier BeginPlay events
        InventoryType = WeaponType;

        super.PreBeginPlay();
        super.PostBeginPlay();

        // Set pickup properties from InventoryType's PickupClass
        PickupClass = InventoryType.default.PickupClass;

        if (PickupClass != none)
        {
            SetStaticMesh(PickupClass.default.StaticMesh);
            SetDrawScale(PickupClass.default.DrawScale);
            SetCollisionSize(PickupClass.default.CollisionRadius, PickupClass.default.CollisionHeight);
            PickupSound = PickupClass.default.PickupSound;
            PrePivot = PickupClass.default.PrePivot;

            if (class<ROWeaponPickup>(PickupClass) != none)
            {
                DropLifeTime = class<ROWeaponPickup>(PickupClass).default.DropLifeTime;

                if (class<DHWeaponPickup>(PickupClass) != none)
                {
                    BarrelSteamEmitterClass = class<DHWeaponPickup>(PickupClass).default.BarrelSteamEmitterClass;

                    if (class<DHOneShotWeaponPickup>(PickupClass) != none)
                    {
                        bIsOneShotWeapon = true; // different ammo handling (in InitPickup) for one-shot weapons
                    }
                }
            }
        }
    }
    else if (Role == ROLE_Authority)
    {
        Log("WARNING:" @ Name @ "self-destructing as no WeaponType has been set!");
        Destroy();
    }
}

// New function, very similar to InitDroppedPickupFor(), but here we have to use weapon class defaults, as we don't have an actual weapon actor
function InitPickup()
{
    local class<DHProjectileWeapon> W;
    local int InitialAmount, i;

    // One-shot weapon (e.g. grenade, satchel, faust) just needs 1 ammo - don't want it using weapon's usual InitialAmount (e.g. 2 grenades) & the other stuff isn't relevant
    if (bIsOneShotWeapon)
    {
        AmmoAmount[0] = 1;
    }
    else
    {
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
            AmmoMags.Length = 0; // so when Reset, we start again

            // Give the pickup the ammo mags the weapon would start with
            for (i = 0; i < W.default.InitialNumPrimaryMags; ++i)
            {
                AmmoMags[AmmoMags.Length] = InitialAmount;
            }

            bHasBayonetMounted = W.default.bBayonetMounted;

            // If weapon has barrels, copy the weapon's reference to the Barrels array & make this pickup the owner of the barrels
            if (W.default.InitialBarrels > 0 && W.default.BarrelClass != none)
            {
                Barrels.Length = 0; // so when Reset, we start again

                for (i = 0; i < W.default.InitialBarrels; ++i)
                {
                    Barrels[Barrels.Length] = Spawn(W.default.BarrelClass, self);
                }

                BarrelIndex = 0;
                Barrels[BarrelIndex].SetCurrentBarrel(true);
            }
        }
    }
}

// Modified to call SetRespawn() instead of destroying the pickup
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
            SetRespawn();
        }
    }
}

// Modified so pickup only re-spawns if specified ReSpawnTime is not zero
// Allows mapper to specify zero to signify the weapon pickup should never re-spawn
// But even if it won't re-spawn we don't destroy the pickup, we just leave it sleeping, because if the round gets reset it can then be reactivated & the item re-spawned
state Sleeping
{
ignores Touch;

Begin:
    if (bRespawn && GetReSpawnTime() > 0.0)
    {
        Sleep(GetReSpawnTime() - RespawnEffectTime - 1.0);
        GoTo('Respawn');
    }
}

// Modified to always go inactive instead of being destroyed
// Even if pickup is set not to respawn, the Sleeping state still allows pickup to be reactivated if match is reset
function SetRespawn()
{
    StartSleeping();
}

// Modified to call InitPickup() & to skip over the duplication & redundancy in the Supers
// Note that this function gets called when a new round starts, so we always start with InitPickup() & not just if match is reset in the middle of a round
function Reset()
{
    InitPickup();
    GotoState('Pickup');
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
    bRespawn=false
    RespawnTime=120.0 // leveller can override
    Physics=PHYS_None
    bWeaponStay=false
    bIgnoreEncroachers=false
    bAlwaysRelevant=false
    NetUpdateFrequency=8.0
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.satchel' // just to make sure we see the pickup in the editor - in game the StaticMesh will be set based on InventoryType
}

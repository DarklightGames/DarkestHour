//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PlaceableWeaponPickup extends ROPlaceableAmmoPickup
    abstract;

var() class<Inventory> WeaponType;


static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.Panzerfaust');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Ammo.Warhead3rd');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Ammo.Warhead1st');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.Panzerfaust_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Grenades.Panzerfaust_S');
}

auto state Pickup
{
    function UsedBy(Pawn User)
    {
        local Inventory Copy;
        local inventory Inv;
        local bool      bHasWeapon;

        if (User == none)
        {
            return;
        }

        // check if Other has a primary weapon
        if (User != none && User.Inventory != none)
        {
            for (Inv = User.Inventory; Inv != none; Inv = Inv.Inventory)
            {
                if (Weapon(Inv) != none)
                {
                    if (Inv.Class == WeaponType)
                    {
                        if (Weapon(Inv).AmmoMaxed(0))
                        {
                            return;
                        }
                        else
                        {
                            bHasWeapon = true;
                        }
                    }
                }
            }
        }

        // valid touch will pickup the object
        if (ValidTouch(User))
        {
            if (bHasWeapon)
            {
                Copy = SpawnCopy(User);
            }
            else
            {
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
}

// Set up respawn waiting if desired
function SetRespawn()
{
    StartSleeping();
}

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
        Copy = Other.Spawn(WeaponType, Other, , , rot(0,0,0));
    }

    Copy.GiveTo(Other, self);

    return Copy;
}

static function string GetLocalString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2
    )
{
    switch (Switch)
    {
        case 0:
            return Repl(default.PickupMessage, "%w", default.InventoryType.default.ItemName);
        case 1:
            return Repl(default.TouchMessage, "%w", default.InventoryType.default.ItemName);
    }
}

defaultproperties
{
    AmmoAmount=1
    bAmmoPickupIsWeapon=true
    PickupMessage="You got the %w"
    TouchMessage="Pick Up: %w"
    PickupSound=Sound'Inf_Weapons_Foley.WeaponPickup'
    PickupForce="AssaultRiflePickup"
    DrawType=DT_StaticMesh
    AmbientGlow=10
    PrePivot=(X=0.0,Y=0.0,Z=3.0)
    CollisionRadius=25.0
    CollisionHeight=3.0
}

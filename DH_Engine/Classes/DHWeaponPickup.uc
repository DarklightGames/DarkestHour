//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHWeaponPickup extends ROWeaponPickup
    abstract;

//Barrel
var     float       Temperature, Temperature2;
var     float       BarrelCoolingRate;
var     bool        bBarrelFailed, bHasSpareBarrel;
var     int         RemainingBarrel;

//Ammo
var     array<int>  AmmoMags;
var     int         LoadedMagazineIndex;

function InitDroppedPickupFor(Inventory Inv)
{
    local int i;
    local DH_ProjectileWeapon W;

    W = DH_ProjectileWeapon(Inv);

    super.InitDroppedPickupFor(Inv);

    if (W != none)
    {
        if (W.Barrels.Length > 0 && W.BarrelIndex >= 0 && W.BarrelIndex < W.Barrels.Length)
        {
            Temperature = W.Barrels[W.BarrelIndex].Temperature;
            BarrelCoolingRate = W.Barrels[W.BarrelIndex].BarrelCoolingRate;
            bBarrelFailed = W.Barrels[W.BarrelIndex].bBarrelFailed;

            if (W.RemainingBarrels > 1)
            {
                if (W.BarrelIndex == 0)
                {
                    RemainingBarrel = 1;
                }
                else
                {
                    RemainingBarrel = 0;
                }

                Temperature2 = W.Barrels[RemainingBarrel].Temperature;

                bHasSpareBarrel = true;
            }
        }

        for (i = 0; i < W.PrimaryAmmoArray.Length; ++i)
        {
            AmmoMags[AmmoMags.Length] = W.PrimaryAmmoArray[i];
        }
    }
}

function Tick(float dt)
{
    // make sure it's run on the server
    if (Role < ROLE_Authority)
    {
        return;
    }

    // continue to lower the barrel temp
    Temperature -= dt * BarrelCoolingRate;

    if (bHasSpareBarrel)
    {
        Temperature2 -= dt * BarrelCoolingRate;
    }
}

function array<int> GetLoadedMagazineIndices()
{
    local array<int> Indices;
    local int i;

    for (i = 0; i < AmmoMags.Length; ++i)
    {
        if (AmmoMags[i] <= 0)
        {
            continue;
        }

        Indices[Indices.Length] = i;
    }

    return Indices;
}

static function string GetLocalString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2
    )
{
    switch(Switch)
    {
        case 0:
            return Repl(default.PickupMessage, "%w", default.InventoryType.default.ItemName);
        case 1:
            return Repl(default.TouchMessage, "%w", default.InventoryType.default.ItemName);
    }
}

defaultproperties
{
    DrawType=DT_StaticMesh
    PickupMessage="You got the %w"
    TouchMessage="Pick up: %w"
}

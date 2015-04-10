//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHWeaponPickup extends ROWeaponPickup
    abstract;

//Barrel
var     float       Temperature, Temperature2;
var     float       LevelCTemp, BarrelCoolingRate;
var     bool        bHasBarrel, bBarrelFailed, bHasSpareBarrel;
var     int         RemainingBarrel;

//Ammo
var     array<int>  AmmoMags;
var     int         LoadedMagazineIndex;

function InitDroppedPickupFor(Inventory Inv)
{
    local int i;
    local DHProjectileWeapon W;

    W = DHProjectileWeapon(Inv);

    super.InitDroppedPickupFor(Inv);

    if (W != none)
    {
        if (W.Barrels.Length > 0 && W.BarrelIndex >= 0 && W.BarrelIndex < W.Barrels.Length)
        {
            bHasBarrel = true;

            LevelCTemp = W.Barrels[W.BarrelIndex].LevelCTemp;
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
        else
        {
            bHasBarrel = false;
        }

        for (i = 0; i < W.PrimaryAmmoArray.Length; ++i)
        {
            AmmoMags[AmmoMags.Length] = W.PrimaryAmmoArray[i];
        }
    }
}

// Matt: modified (with a couple of extra class variables) so this only happens if weapon has a barrel to cool & also to stop it reducing barrel temperature below the level temperature
function Tick(float DeltaTime)
{
    if (bHasBarrel && Role == ROLE_Authority)
    {
        // continue to lower the barrel temp
        if (Temperature > LevelCTemp)
        {
            Temperature = FMax(Temperature + (DeltaTime * BarrelCoolingRate), LevelCTemp);
        }

        if (bHasSpareBarrel && Temperature2 > LevelCTemp)
        {
            Temperature2 = FMax(Temperature2 + (DeltaTime * BarrelCoolingRate), LevelCTemp);
        }
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

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
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
    AmbientGlow=64
    PickupMessage="You got the %w"
    TouchMessage="Pick Up: %w"
    PrePivot=(X=0.0,Y=0.0,Z=3.0)
    CollisionRadius=25.0
    CollisionHeight=3.0
}

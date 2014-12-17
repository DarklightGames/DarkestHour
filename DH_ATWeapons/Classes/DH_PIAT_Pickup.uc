//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PIAT_Pickup extends ROPlaceableAmmoPickup;

var() class<Inventory> WeaponType;

auto state Pickup
{
    function bool ReadyToPickup(float MaxWait)
    {
        return true;
    }

    function bool ValidTouch(actor Other)
    {
        // make sure its a live player
        if ((Pawn(Other) == none) || !Pawn(Other).bCanPickupInventory || (Pawn(Other).Health <= 0) || (Pawn(Other).DrivenVehicle == none && Pawn(Other).Controller == none))
            return false;

        if (ROPawn(Other) != none && ROPawn(Other).AutoTraceActor != none && ROPawn(Other).AutoTraceActor == self)
        {
            // do nothing
        }
        // make sure not touching through wall
        else if (!FastTrace(Other.Location, Location))
            return false;

        // make sure game will let player pick me up
        if (Level.Game.PickupQuery(Pawn(Other), self))
        {
            TriggerEvent(Event, self, Pawn(Other));
            return true;
        }
        return false;
    }

    // When touched by an actor.
    function Touch(actor Other)
    {
    }

    function CheckTouching()
    {
    }

    function UsedBy(Pawn user)
    {
        local Inventory Copy;
        local inventory Inv;
        local bool bHasWeapon;

        if (user == none)
            return;

        // check if Other has a primary weapon
        if (user != none && user.Inventory != none)
        {
            for (Inv=user.Inventory; Inv!=none; Inv=Inv.Inventory)
            {
                if (Inv != none && Weapon(Inv) != none)
                {
                    if (Inv.class == WeaponType)
                    {
                        if (Weapon(Inv).AmmoMaxed(0))
                            return;
                        else
                            bHasWeapon = true;
                    }
                }
            }
        }

        // valid touch will pickup the object
        if (ValidTouch(user))
        {
            if (bHasWeapon)
                Copy = SpawnCopy(user);
            else
                Copy = SpawnWeaponCopy(user);

            AnnouncePickup(user);
            if (Copy != none)
                Copy.PickupFunction(user);

            SetRespawn();
        }
    }

    function Timer()
    {
        if (bDropped)
            GotoState('FadeOut');
    }

    function BeginState()
    {
        UntriggerEvent(Event, self, none);
        if (bDropped)
        {
            AddToNavigation();
            SetTimer(DropLifeTime, false);
        }
    }

    function EndState()
    {
        if (bDropped)
            RemoveFromNavigation();
    }

Begin:
    CheckTouching();
}

//
// Set up respawn waiting if desired.
//
function SetRespawn()
{
    StartSleeping();
}

function inventory SpawnWeaponCopy(pawn Other)
{
    local inventory Copy;

    if (Inventory != none)
    {
        Copy = Inventory;
        Inventory = none;
    }
    else
        Copy = Other.spawn(WeaponType,Other,,,rot(0,0,0));

    Copy.GiveTo(Other, self);

    return Copy;
}

defaultproperties
{
    WeaponType=class'DH_ATWeapons.DH_PIATWeapon'
    TouchMessage="Pick Up: PIAT"
    bAmmoPickupIsWeapon=true
    AmmoAmount=1
    MaxDesireability=0.780000
    InventoryType=class'DH_ATWeapons.DH_PIATAmmo'
    PickupMessage="You got the PIAT."
    PickupSound=sound'Inf_Weapons_Foley.Misc.WeaponPickup'
    PickupForce="AssaultRiflePickup"
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.PIAT'
    PrePivot=(Z=3.000000)
    AmbientGlow=10
    CollisionRadius=25.000000
    CollisionHeight=3.000000
}

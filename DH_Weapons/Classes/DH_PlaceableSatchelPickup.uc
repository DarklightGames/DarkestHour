//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PlaceableSatchelPickup extends ROPlaceableAmmoPickup;

var() class<Inventory> WeaponType;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Projectile.satchel');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Projectile.satchel_throw');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.satchel_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Grenades.SatchelCharge');
    //L.AddPrecacheMaterial(Material'ROInterfaceArt.HUD.hud_g43');
}

auto state Pickup
{
    function bool ReadyToPickup(float MaxWait)
    {
        return true;
    }

    /* ValidTouch()
     Validate touch (if valid return true to let other pick me up and trigger event).
    */
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
     WeaponType=class'DH_Weapons.DH_SatchelCharge10lb10sWeapon'
     TouchMessage="Pick Up: Satchel charge 10lb"
     bAmmoPickupIsWeapon=true
     AmmoAmount=1
     MaxDesireability=0.780000
     InventoryType=class'DH_Weapons.DH_SachelChargeAmmo'
     PickupMessage="You got a 10lb satchel."
     PickupSound=Sound'Inf_Weapons_Foley.Misc.WeaponPickup'
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponPickupSM.Projectile.satchel'
     PrePivot=(Z=3.000000)
     AmbientGlow=10
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}

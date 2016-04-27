//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHOneShotWeaponPickup extends DHWeaponPickup
    abstract;

// Every dropped weapon pickup is one shot only
function InitDroppedPickupFor(Inventory Inv)
{
    local Weapon W;

    W = Weapon(Inv);

    if (W != none)
    {
        AmmoAmount[0] = 1;
        AmmoAmount[1] = 0;
    }

    SetPhysics(PHYS_Falling);
    GotoState('FallingPickup');
    Inventory = Inv;
    bAlwaysRelevant = false;
    bOnlyReplicateHidden = false;
    bUpdateSimulatedPosition = true;
    bDropped = true;
    LifeSpan = DropLifeTime + Rand(10);
    bIgnoreEncroachers = false; // handles case of dropping stuff on lifts etc
    NetUpdateFrequency = 8.0;
}

defaultproperties
{
    PickupSound=sound'Inf_Weapons_Foley.Misc.ammopickup'
    CollisionRadius=15.0
}

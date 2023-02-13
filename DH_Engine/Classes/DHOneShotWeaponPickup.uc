//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
    bIgnoreEncroachers = false; // handles case of dropping stuff on lifts etc
    NetUpdateFrequency = 8.0;
}

defaultproperties
{
    PickupSound=Sound'Inf_Weapons_Foley.Misc.ammopickup'
    CollisionRadius=15.0
}

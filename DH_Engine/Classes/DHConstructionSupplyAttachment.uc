//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstructionSupplyAttachment extends RODummyAttachment
    notplaceable;

var bool            bCanBeResupplied;
var int             SupplyCount;
var int             TeamIndex;

function bool HasSupplies()
{
    return SupplyCount > 0;
}

// TODO: logic for getting this resupplied; some sort of hook that things can
// put on it for getting notified (OnResupplied)

defaultproperties
{
    bCanBeResupplied=true
    SupplyCount=1000
    CollisionRadius=600.0
    CollisionHeight=100
    RemoteRole=ROLE_SimulatedProxy
}

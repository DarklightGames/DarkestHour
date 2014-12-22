//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHOneShotWeaponPickup extends ROOneShotWeaponPickup
    abstract
    notplaceable;

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
    DrawType=DT_StaticMesh
    AmbientGlow=0
    PickupMessage="You got the %w"
    TouchMessage="Pick up: %w"
}

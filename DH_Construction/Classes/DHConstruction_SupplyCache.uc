//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstruction_SupplyCache extends DHConstruction;

var DHConstructionSupplyAttachment SupplyAttachment;

function PostBeginPlay()
{
    super.PostBeginPlay();

    SupplyAttachment = Spawn(class'DHConstructionSupplyAttachment', self);

    if (SupplyAttachment == none)
    {
        Error("Failed to spawn supply attachment!");
    }

    SupplyAttachment.SetBase(self);
    SupplyAttachment.bCanBeResupplied = true;
}

defaultproperties
{
    MenuName="Supply Cache"
    SupplyCost=250
    StaticMesh=StaticMesh'DH_Military_stc.Ammo.cratepile1'
    DuplicateDistanceInMeters=100   // NOTE: 2x the supply attachment radius
    bCanPlaceIndoors=true
}

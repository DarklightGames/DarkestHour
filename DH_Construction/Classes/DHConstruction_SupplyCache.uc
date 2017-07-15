//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_SupplyCache extends DHConstruction;

var array<StaticMesh> StaticMeshes;

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
    SupplyAttachment.OnSupplyCountChanged = MyOnSupplyCountChanged;
    SupplyAttachment.SetSupplyCount(default.SupplyCost);
    SupplyAttachment.bCanReceiveSupplyDrops = true;

    // We hide the supply attachment since we are going to handle the visualization through the the construction.
    SupplyAttachment.bHidden = true;
}

function MyOnSupplyCountChanged(DHConstructionSupplyAttachment CSA)
{
    if (CSA != none)
    {
        SetStaticMesh(CSA.StaticMesh);

        NetUpdateTime = Level.TimeSeconds - 1.0;
    }
}

simulated function OnTeamIndexChanged()
{
    super.OnTeamIndexChanged();

    if (Role == ROLE_Authority && SupplyAttachment != none)
    {
        SupplyAttachment.TeamIndex = GetTeamIndex();
    }
}

defaultproperties
{
    MenuName="Supply Cache"
    SupplyCost=250
    StaticMesh=StaticMesh'DH_Military_stc.Ammo.cratepile1'
    DrawType=DT_StaticMesh
    DuplicateFriendlyDistanceInMeters=100   // NOTE: 2x the supply attachment radius
    bCanPlaceIndoors=true
    bCanBeTornDown=false
    bCanDieOfStagnation=false   // TODO: this shouldn't be necessary, right?
}


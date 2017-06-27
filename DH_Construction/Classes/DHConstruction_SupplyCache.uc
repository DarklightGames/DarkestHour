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
    SupplyAttachment.bCanBeResupplied = true;
    SupplyAttachment.OnSupplyCountChanged = MyOnSupplyCountChanged;
    SupplyAttachment.SetSupplyCount(default.SupplyCost);
}

function MyOnSupplyCountChanged(DHConstructionSupplyAttachment CSA)
{
    UpdateAppearance();
}

function UpdateAppearance()
{
    local float SupplyPercent;
    local int StaticMeshIndex;

    if (SupplyAttachment == none)
    {
        Destroy();
    }

    SupplyPercent = (SupplyAttachment.GetSupplyCount() / SupplyAttachment.default.SupplyCountMax);
    StaticMeshIndex = Clamp(SupplyPercent * StaticMeshes.Length, 0, StaticMeshes.Length - 1);
    SetStaticMesh(StaticMeshes[StaticMeshIndex]);
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
    StaticMeshes(0)=StaticMesh'DH_Military_stc.Ammo.cratepile1'
    StaticMeshes(1)=StaticMesh'DH_Military_stc.Ammo.cratepile2'
    StaticMeshes(2)=StaticMesh'DH_Military_stc.Ammo.cratepile3'
    DuplicateDistanceInMeters=100   // NOTE: 2x the supply attachment radius
    bCanPlaceIndoors=true
    bCanBeTornDown=false
}


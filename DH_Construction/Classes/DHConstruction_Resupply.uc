//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstruction_Resupply extends DHConstruction;

#exec OBJ LOAD FILE=..\StaticMeshes\DH_Construction_stc.usx

var DHResupplyAttachment ResupplyAttachment;

function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        ResupplyAttachment = Spawn(class'DHResupplyAttachment', self);

        if (ResupplyAttachment != none)
        {
            ResupplyAttachment.ResupplyType = RT_Players;
            ResupplyAttachment.SetBase(self);
        }
        else
        {
            Warn("Failed to spawn resupply attachment!");
        }
    }
}

function OnTeamIndexChanged()
{
    if (ResupplyAttachment != none)
    {
        ResupplyAttachment.SetTeamIndex(GetTeamIndex());
    }
}

event Destroyed()
{
    super.Destroyed();

    if (ResupplyAttachment != none)
    {
        ResupplyAttachment.Destroy();
    }
}

function UpdateAppearance()
{
    switch (GetTeamIndex())
    {
        case AXIS_TEAM_INDEX:
            SetStaticMesh(StaticMesh'DH_Construction_stc.Ammo.DH_Ger_ammo_box');
            break;
        case ALLIES_TEAM_INDEX:
            SetStaticMesh(StaticMesh'DH_Construction_stc.Ammo.DH_USA_ammo_box');
            break;
    }
}

function static StaticMesh GetProxyStaticMesh(DHConstructionProxy CP)
{
    switch (CP.PlayerOwner.GetTeamNum())
    {
        case AXIS_TEAM_INDEX:
            return StaticMesh'DH_Construction_stc.Ammo.DH_Ger_ammo_box';
        case ALLIES_TEAM_INDEX:
            return StaticMesh'DH_Construction_stc.Ammo.DH_USA_ammo_box';
        default:
            break;
    }

    return super.GetProxyStaticMesh(CP);
}

defaultproperties
{
    StaticMesh=StaticMesh'DH_Construction_stc.Ammo.DH_USA_ammo_box'
    bShouldAlignToGround=true
    MenuName="Resupply Box"
    ProxyDistanceInMeters=3.0
    DuplicateDistanceInMeters=100.0
    CollisionRadius=50.0
    CollisionHeight=30.0
    SupplyCost=300
    bCanPlaceIndoors=true
}

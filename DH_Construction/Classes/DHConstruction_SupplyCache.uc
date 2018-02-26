//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_SupplyCache extends DHConstruction;

#exec OBJ LOAD FILE=..\StaticMeshes\DH_Construction_stc.usx

var array<StaticMesh> StaticMeshes;
var DHConstructionSupplyAttachment SupplyAttachment;
var class<DHConstructionSupplyAttachment> SupplyAttachmentClass;

var() int InitialSupplyCount;

simulated function OnConstructed()
{
    if (Role == ROLE_Authority)
    {
        // Spawn the supply attachment and set up the delegates.
        // We hide the supply attachment since we are going to handle the visualization through the the construction.
        SupplyAttachment = Spawn(SupplyAttachmentClass, self);

        if (SupplyAttachment == none)
        {
            Error("Failed to spawn supply attachment!");
        }

        SupplyAttachment.SetBase(self);
        SupplyAttachment.SetTeamIndex(GetTeamIndex());
        SupplyAttachment.OnSupplyCountChanged = MyOnSupplyCountChanged;
        SupplyAttachment.SetSupplyCount(InitialSupplyCount);
        SupplyAttachment.bHidden = true;
    }
}

simulated function Destroyed()
{
    super.Destroyed();

    if (SupplyAttachment != none)
    {
        SupplyAttachment.Destroy();
    }
}

function MyOnSupplyCountChanged(DHConstructionSupplyAttachment CSA)
{
    if (CSA != none && IsConstructed())
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
        SupplyAttachment.SetTeamIndex(GetTeamIndex());
    }
}

static function StaticMesh GetConstructedStaticMesh(DHConstruction.Context Context)
{
    return default.SupplyAttachmentClass.static.GetStaticMesh(Context.LevelInfo.Level, Context.TeamIndex);
}

function StaticMesh GetStageStaticMesh(int StageIndex)
{
    switch (GetTeamIndex())
    {
        case AXIS_TEAM_INDEX:
            return StaticMesh'DH_Construction_stc.Supply_Cache.GER_supply_cache_undeployed';
        case ALLIES_TEAM_INDEX:
            return StaticMesh'DH_Construction_stc.Supply_Cache.USA_supply_cache_undeployed';
    }

    return none;
}

simulated function OnBroken()
{
    if (Role == ROLE_Authority)
    {
        if (SupplyAttachment != none)
        {
            SupplyAttachment.Destroy();
        }
    }
}

defaultproperties
{
    Stages(0)=(Progress=0)
    ProgressMax=5
    HealthMax=350
    MenuName="Supply Cache"
    MenuIcon=Texture'DH_InterfaceArt2_tex.icons.supply_cache'
    MenuDescription="Stores and generates supplies over time."
    SupplyCost=250
    InitialSupplyCount=250
    StaticMesh=StaticMesh'DH_Military_stc.Ammo.cratepile1'
    DrawType=DT_StaticMesh
    DuplicateFriendlyDistanceInMeters=150
    CollisionRadius=100
    bCanPlaceIndoors=true
    bCanBeTornDownByFriendlies=false
    bCanBeTornDownWhenConstructed=true
    SupplyAttachmentClass=class'DHConstructionSupplyAttachment_Static'
    ConstructionVerb="drop"

    // Essentially we are just making this a satchel explosion
    BrokenEmitterClass=class'ROEffects.ROSatchelExplosion'
    BrokenSoundRadius=4000.0
    BrokenSoundVolume=5.0
    BrokenSounds(0)=Sound'Inf_Weapons.satchel.satchel_explode01'
    BrokenSounds(1)=Sound'Inf_Weapons.satchel.satchel_explode02'
    BrokenSounds(2)=Sound'Inf_Weapons.satchel.satchel_explode03'

    GroupClass=class'DHConstructionGroup_Logistics'
}


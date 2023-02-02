//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_SupplyCache extends DHConstruction;

#exec OBJ LOAD FILE=..\StaticMeshes\DH_Construction_stc.usx

var array<StaticMesh> StaticMeshes;
var DHConstructionSupplyAttachment SupplyAttachment;
var class<DHConstructionSupplyAttachment> SupplyAttachmentClass;

var() int InitialSupplyCount;
var() int BonusSupplyGenerationRate;

var class<DHMapIconAttachment> MapIconAttachmentClass;
var DHMapIconAttachment        MapIconAttachment;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority && MapIconAttachmentClass != none)
    {
        MapIconAttachment = Spawn(MapIconAttachmentClass, self);

        if (MapIconAttachment != none)
        {
            MapIconAttachment.SetBase(self);
            MapIconAttachment.SetTeamIndex(GetTeamIndex());
        }
        else
        {
            MapIconAttachmentClass.static.OnError(ERROR_SpawnFailed);
        }
    }
}

simulated function OnConstructed()
{
    if (Role == ROLE_Authority)
    {
        // Spawn the supply attachment and set up the delegates.
        // We hide the supply attachment since we are going to handle the visualization through the the construction.
        SupplyAttachment = Spawn(SupplyAttachmentClass, self);

        if (SupplyAttachment != none)
        {
            SupplyAttachment.SetBase(self);
            SupplyAttachment.SetTeamIndex(GetTeamIndex());
            SupplyAttachment.OnSupplyCountChanged = MyOnSupplyCountChanged;
            SupplyAttachment.SetInitialSupply(InitialSupplyCount);
            SupplyAttachment.BonusSupplyGenerationRate = default.BonusSupplyGenerationRate;
            SupplyAttachment.bHidden = true;
        }
        else
        {
            Error("Failed to spawn supply attachment!");
        }
    }
}

simulated function Destroyed()
{
    super.Destroyed();

    if (SupplyAttachment != none)
    {
        SupplyAttachment.Destroy();
    }

    if (MapIconAttachment != none)
    {
        MapIconAttachment.Destroy();
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

    if (Role == ROLE_Authority)
    {
        if (SupplyAttachment != none)
        {
            SupplyAttachment.SetTeamIndex(GetTeamIndex());
        }

        if (MapIconAttachment != none)
        {
            MapIconAttachment.SetTeamIndex(GetTeamIndex());
        }
    }
}

static function StaticMesh GetConstructedStaticMesh(DHActorProxy.Context Context)
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

simulated state Constructed
{
    simulated function EndState()
    {
        super.EndState();

        DestroySupplyAttachment();
    }
}

simulated function OnBroken()
{
    DestroySupplyAttachment();
}

function DestroySupplyAttachment()
{
    if (Role == ROLE_Authority && SupplyAttachment != none)
    {
        SupplyAttachment.Destroy();
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
    SupplyCost=500
    InitialSupplyCount=500
    StaticMesh=StaticMesh'DH_Military_stc.Ammo.cratepile1'
    DrawType=DT_StaticMesh
    DuplicateFriendlyDistanceInMeters=300
    CollisionRadius=100
    bCanPlaceIndoors=true
    bCanBeTornDownByFriendlies=false
    bCanBeTornDownWhenConstructed=true
    bCanBePlacedInDangerZone=false
    SupplyAttachmentClass=class'DHConstructionSupplyAttachment_Static'
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_SupplyCache'
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

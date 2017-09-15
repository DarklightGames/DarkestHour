//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_SupplyCache extends DHConstruction;

var array<StaticMesh> StaticMeshes;
var DHConstructionSupplyAttachment SupplyAttachment;
var class<DHConstructionSupplyAttachment> SupplyAttachmentClass;

var() int InitialSupplyCount;

function PostBeginPlay()
{
    super.PostBeginPlay();

    // Spawn the supply attachment and set up the delegates.
    // We hide the supply attachment since we are going to handle the visualization through the the construction.
    SupplyAttachment = Spawn(SupplyAttachmentClass, self);

    if (SupplyAttachment == none)
    {
        Error("Failed to spawn supply attachment!");
    }

    SupplyAttachment.SetBase(self);
    SupplyAttachment.OnSupplyCountChanged = MyOnSupplyCountChanged;
    SupplyAttachment.SetSupplyCount(InitialSupplyCount);
    SupplyAttachment.bHidden = true;
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
        SupplyAttachment.SetTeamIndex(GetTeamIndex());
    }
}

function StaticMesh GetConstructedStaticMesh()
{
    return SupplyAttachment.GetStaticMeshForSupplyCount(Level, GetTeamIndex(), SupplyAttachment.GetSupplyCount());
}

function static StaticMesh GetProxyStaticMesh(DHConstructionProxy CP)
{
    return default.SupplyAttachmentClass.static.GetStaticMeshForSupplyCount(CP.Level, CP.PlayerOwner.GetTeamNum(), default.SupplyAttachmentClass.default.SupplyCountMax);
}

defaultproperties
{
    MenuName="Supply Cache"
    MenuIcon=Texture'DH_GUI_tex.ConstructionMenu.Construction_Supply'
    SupplyCost=250
    InitialSupplyCount=250
    StaticMesh=StaticMesh'DH_Military_stc.Ammo.cratepile1'
    DrawType=DT_StaticMesh
    DuplicateFriendlyDistanceInMeters=100   // NOTE: 2x the supply attachment radius
    CollisionRadius=128
    bCanPlaceIndoors=true
    bCanBeTornDownWhenConstructed=false
    bCanDieOfStagnation=false   // TODO: this shouldn't be necessary, right?
    SupplyAttachmentClass=class'DHConstructionSupplyAttachment_Static'
}


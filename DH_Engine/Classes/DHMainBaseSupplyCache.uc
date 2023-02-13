//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMainBaseSupplyCache extends Actor
    placeable
    hidecategories(Collision,Lighting,LightColor,Karma,Force,Sound);

enum ETeamOwner
{
    TEAM_Axis,
    TEAM_Allies,
};

var() ETeamOwner                TeamOwner;                      // Set the team the main cache is for
var() int                       InitialSupplyCount;             // Initial amount of supply
var() int                       SupplyCountMax;                 // The max amount of supply
var() int                       BonusSupplyGenerationRate;

var DHConstructionSupplyAttachment              SupplyAttachment;
var class<DHConstructionSupplyAttachment>       SupplyAttachmentClass;

function Reset()
{
    if (SupplyAttachment != none)
    {
        DestroySupplyAttachment();
    }

    if (SupplyAttachment == none)
    {
        CreateSupplyAttachment();
    }
}

function int GetTeamIndex()
{
    return int(TeamOwner);
}

function MyOnSupplyCountChanged(DHConstructionSupplyAttachment CSA)
{
    // @Basnett what is this doing? you'll have to explain to Theel how you "delegate" functions
    if (CSA != none)
    {
        NetUpdateTime = Level.TimeSeconds - 1.0;
    }
}

function CreateSupplyAttachment()
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
    SupplyAttachment.SetInitialSupply(Min(InitialSupplyCount, SupplyCountMax));
    SupplyAttachment.SupplyCountMax = SupplyCountMax;
    SupplyAttachment.BonusSupplyGenerationRate = BonusSupplyGenerationRate;
    SupplyAttachment.bHidden = true;
}

function DestroySupplyAttachment()
{
    if (SupplyAttachment != none)
    {
        SupplyAttachment.Destroy();
    }
}

defaultproperties
{
    SupplyAttachmentClass=class'DHConstructionSupplyAttachment_Static_Main'
    InitialSupplyCount=8000
    SupplyCountMax=8000
    BonusSupplyGenerationRate=500

    Texture=Texture'DHEngine_Tex.LevelActor'
    bHidden=true
    RemoteRole=ROLE_None
}

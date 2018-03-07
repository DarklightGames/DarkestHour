//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_Resupply extends DHConstruction
    abstract;

var class<DHResupplyAttachment>         ResupplyAttachmentClass;
var DHResupplyAttachment                ResupplyAttachment;
var int                                 ResupplyCount;
var DHResupplyAttachment.EResupplyType  ResupplyType;
var float                               ResupplyAttachmentCollisionRadius;
var float                               ResupplyAttachmentCollisionHeight;

function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        ResupplyAttachment = Spawn(ResupplyAttachmentClass, self);

        if (ResupplyAttachment != none)
        {
            ResupplyAttachment.ResupplyType = ResupplyType;
            ResupplyAttachment.SetTeamIndex(GetTeamIndex());
            ResupplyAttachment.SetCollisionSize(ResupplyAttachmentCollisionRadius, ResupplyAttachmentCollisionHeight);
            ResupplyAttachment.SetBase(self);
            ResupplyAttachment.OnPawnResupplied = MyOnPawnResupplied;
        }
        else
        {
            Warn("Failed to spawn resupply attachment!");
        }
    }
}

function MyOnPawnResupplied(Pawn P)
{
    --ResupplyCount;

    if (ResupplyCount <= 0)
    {
        // TODO: Have a different appearance for different supply levels.
        Destroy();
    }
}

simulated function OnTeamIndexChanged()
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

defaultproperties
{
    ResupplyAttachmentClass=class'DHResupplyAttachment'
    ResupplyType=RT_All
    ResupplyAttachmentCollisionRadius=300
    ResupplyAttachmentCollisionHeight=100

    BrokenEmitterClass=class'DHShellShatterEffect'
    bCanDieOfStagnation=false
    BrokenLifespan=0.1
    StaticMesh=StaticMesh'DH_Construction_stc.Ammo.DH_USA_ammo_box'
    MenuIcon=Texture'DH_InterfaceArt2_tex.icons.resupply_box'
    ProxyTraceDepthMeters=3.0
    DuplicateFriendlyDistanceInMeters=25.0
    CollisionRadius=50.0
    CollisionHeight=30.0
    SupplyCost=250
    bCanPlaceIndoors=true
    ResupplyCount=25
    HealthMax=50
    HarmfulDamageTypes(0)=class'ROArtilleryDamType'
    HarmfulDamageTypes(1)=class'DHThrowableExplosiveDamageType'
    HarmfulDamageTypes(2)=class'DHShellExplosionDamageType'
    HarmfulDamageTypes(3)=class'DHShellImpactDamageType'
    HarmfulDamageTypes(4)=class'DHMortarDamageType'
    HarmfulDamageTypes(5)=class'DHBurningDamageType'
    ConstructionVerb="drop"
    StartRotationMin=(Yaw=-16384)
    StartRotationMax=(Yaw=-16384)
    bShouldRefundSuppliesOnTearDown=false
    bCanBeTornDownByFriendlies=false
    GroupClass=class'DHConstructionGroup_Ammunition'
}

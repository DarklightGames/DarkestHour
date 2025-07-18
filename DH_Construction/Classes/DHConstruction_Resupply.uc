//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstruction_Resupply extends DHConstruction
    abstract;

var class<DHResupplyAttachment>         ResupplyAttachmentClass;
var DHResupplyAttachment                ResupplyAttachment;
var int                                 ResupplyCount;
var DHResupplyStrategy.EResupplyType    ResupplyType;
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
            ResupplyAttachment.SetResupplyType(ResupplyType);
            ResupplyAttachment.SetTeamIndex(GetTeamIndex());
            ResupplyAttachment.SetCollisionSize(ResupplyAttachmentCollisionRadius, ResupplyAttachmentCollisionHeight);
            ResupplyAttachment.SetBase(self);
            ResupplyAttachment.OnPawnResupplied = MyOnPawnResupplied;
            ResupplyAttachment.AttachMapIcon();
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
    ResupplyAttachmentClass=Class'DHResupplyAttachment'
    ResupplyType=RT_All
    ResupplyAttachmentCollisionRadius=300
    ResupplyAttachmentCollisionHeight=100

    BrokenEmitterClass=Class'DHShellShatterEffect'
    bCanDieOfStagnation=false
    BrokenLifespan=0.1
    StaticMesh=StaticMesh'DH_Construction_stc.DH_USA_ammo_box'
    MenuIcon=Texture'DH_InterfaceArt2_tex.resupply_box'
    ProxyTraceDepthMeters=3.0
    CollisionRadius=50.0
    CollisionHeight=30.0
    SupplyCost=500
    bCanPlaceIndoors=true
    ResupplyCount=30
    HealthMax=50
    ConstructionVerb="drop"
    StartRotationMin=(Yaw=-16384)
    StartRotationMax=(Yaw=-16384)
    bShouldRefundSuppliesOnTearDown=false
    bCanBeTornDownByFriendlies=false
    GroupClass=Class'DHConstructionGroup_Ammunition'

    CompletionPointValue=500
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstructionSupplyAttachment extends RODummyAttachment
    notplaceable;

var bool                bCanBeResupplied;
var int                 SupplyCount;
var int                 TeamIndex;

var ArrayList_Object    TouchingPawns;
var ArrayList_Object    NewTouchingPawns;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        TeamIndex, SupplyCount;
}

simulated function PostBeginPlay()
{
    super(Actor).PostBeginPlay();

    TouchingPawns = new class'ArrayList_Object';
    NewTouchingPawns = new class'ArrayList_Object';

    if (Role == ROLE_Authority)
    {
        SetTimer(1.0, true);
    }
}

function bool HasSupplies()
{
    return SupplyCount > 0;
}

function Timer()
{
    local DHPawn P;
    local int i, Index;

    NewTouchingPawns.Clear();

    foreach VisibleCollidingActors(class'DHPawn', P, CollisionRadius)
    {
        if (P != none && P.GetTeamNum() == TeamIndex)
        {
            NewTouchingPawns.Add(P);
        }
    }

    for (i = 0; i < TouchingPawns.Size(); ++i)
    {
        Index = NewTouchingPawns.IndexOf(TouchingPawns.Get(i));

        if (Index == -1)
        {
            // TODO: pawn is no longer in touching pawns, remove it!
            P = DHPawn(TouchingPawns.Get(i));

            if (P != none && P.TouchingSupplyAttachments != none)
            {
                P.TouchingSupplyAttachments.Remove(self);
            }
        }
    }

    TouchingPawns.Clear();
    TouchingPawns.Concatenate(NewTouchingPawns);

/*
    foreach TouchingActors(class'DHPawn', P)
    {
    }*/
}

// TODO: logic for getting this resupplied; some sort of hook that things can
// put on it for getting notified (OnResupplied)

defaultproperties
{
    bCanBeResupplied=true
    SupplyCount=1000
    bUseCylinderCollision=true
    CollisionRadius=1500
    CollisionHeight=100
    RemoteRole=ROLE_DumbProxy
}

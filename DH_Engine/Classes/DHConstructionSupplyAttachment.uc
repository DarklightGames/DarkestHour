//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstructionSupplyAttachment extends RODummyAttachment
    notplaceable;

var bool                bCanBeResupplied;
var private int         SupplyCount;
var int                 TeamIndex;

// Used to resolve the order in which supplies will be drawn from in the case
// where the the player is near multiple supply attachments when placing
// constructions.
var int                 SortPriority;

var ArrayList_Object    TouchingPawns;
var ArrayList_Object    NewTouchingPawns;

var float               TouchDistanceInMeters;  // The distance, in meters, a player must be within to have access to these supplies.

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        TeamIndex, SupplyCount;
}

delegate OnSuppliesDepleted(DHConstructionSupplyAttachment CSA);

simulated function PostBeginPlay()
{
    super(Actor).PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        TouchingPawns = new class'ArrayList_Object';
        NewTouchingPawns = new class'ArrayList_Object';

        SetTimer(1.0, true);
    }
}

function int GetSupplyCount()
{
    return SupplyCount;
}

function bool HasSupplies()
{
    return SupplyCount > 0;
}

// Uses supplies.
function bool UseSupplies(int Amount)
{
    if (SupplyCount < Amount)
    {
        return false;
    }

    SupplyCount -= Amount;

    if (SupplyCount == 0)
    {
        OnSuppliesDepleted(self);
    }

    return true;
}

function Destroyed()
{
    local int i;
    local DHPawn P;

    for (i = 0; i < TouchingPawns.Size(); ++i)
    {
        P = DHPawn(TouchingPawns.Get(i));

        if (P != none)
        {
            class'UArray'.static.Erase(P.TouchingSupplyAttachments, self);
        }
    }

    super.Destroyed();
}

function Timer()
{
    local DHPawn P;
    local int i, Index;

    NewTouchingPawns.Clear();

    // Gather all relevant pawns within the radius.
    foreach CollidingActors(class'DHPawn', P, class'DHUnits'.static.MetersToUnreal(TouchDistanceInMeters))
    {
        if (P != none && P.GetTeamNum() == TeamIndex)
        {
            NewTouchingPawns.Add(P);
        }
    }

    for (i = 0; i < NewTouchingPawns.Size(); ++i)
    {
        Index = TouchingPawns.IndexOf(NewTouchingPawns.Get(i));

        if (Index == -1)
        {
            // Pawn is now being touched, add ourselves to their touching list.
            P = DHPawn(NewTouchingPawns.Get(i));

            if (P != none)
            {
                P.TouchingSupplyAttachments[P.TouchingSupplyAttachments.Length] = self;
            }
        }
    }

    for (i = 0; i < TouchingPawns.Size(); ++i)
    {
        Index = NewTouchingPawns.IndexOf(TouchingPawns.Get(i));

        if (Index == -1)
        {
            // Pawn is no longer being touched, remove ourselves from their
            // touching list.
            P = DHPawn(TouchingPawns.Get(i));

            if (P != none)
            {
                class'UArray'.static.Erase(P.TouchingSupplyAttachments, self);
            }
        }
    }

    TouchingPawns.Clear();
    TouchingPawns.Concatenate(NewTouchingPawns);
}

// TODO: logic for getting this resupplied; some sort of hook that things can
// put on it for getting notified (OnResupplied)

defaultproperties
{
    bCanBeResupplied=true
    SupplyCount=1000
    TouchDistanceInMeters=50
    RemoteRole=ROLE_DumbProxy
}

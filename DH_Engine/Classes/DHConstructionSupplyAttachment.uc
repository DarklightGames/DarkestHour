//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstructionSupplyAttachment extends Actor
    abstract
    notplaceable;

#exec OBJ LOAD FILE=../StaticMeshes/DH_Construction_stc.usx

var int                 SupplyPointIndex;
var private int         SupplyCount;
var int                 SupplyCountMax;
var int                 TeamIndex;

var bool                bShouldShowOnMap;

// Whether or not this supply attachment can be resupplied from a static resupply point.
var bool                bCanBeResupplied;

// Whether or not this supply attachment can receive supply drops from a vehicle.
var bool                bCanReceiveSupplyDrops;

// Used to resolve the order in which supplies will be drawn from in the case
// where the the player is near multiple supply attachments when placing
// constructions. A higher value means it will be drawn from first.
var int                 SortPriority;

var array<Pawn>         TouchingPawns;

// The distance, in meters, a player must be within to have access to these supplies.
var float               TouchDistanceInMeters;

//==============================================================================
// Supply Generation
//==============================================================================
var bool                bCanGenerateSupplies;               // Whether or not this supply attachment is able to generate supplies.
var int                 SupplyDepositInterval;              // The amount of seconds before generated supplies are deposited into the supply count.
var int                 SupplyDepositCounter;               // The next time that generated supplies will be deposited.
var int                 SupplyGenerationRate;               // The amount of supplies that are able to be generated every minute.

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        TeamIndex, SupplyCount;
}

// This delegate will be called whenever the SupplyCount changes.
delegate OnSupplyCountChanged(DHConstructionSupplyAttachment CSA);

// Overridden to bypass bizarre logic that necessitated the Owner be a Pawn.
simulated function PostBeginPlay()
{
    local DHGameReplicationInfo GRI;

    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        SupplyCount = SupplyCountMax;

        GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

        if (bShouldShowOnMap && GRI != none)
        {
            SupplyPointIndex = GRI.AddSupplyPoint(self);
        }

        SetTimer(1.0, true);
    }
}

simulated function bool HasSupplies()
{
    return SupplyCount > 0;
}

simulated function bool IsFull()
{
    return SupplyCount == SupplyCountMax;
}

simulated function int GetSupplyCount()
{
    return SupplyCount;
}

static function StaticMesh GetStaticMeshForSupplyCount(LevelInfo Level, int TeamIndex, int SupplyCount)
{
    //local float SupplyPercent;
    //local int StaticMeshIndex;
    local DH_LevelInfo LI;

    //SupplyPercent = (float(SupplyCount) / SupplyCountMax);
    //StaticMeshIndex = Clamp(SupplyPercent * StaticMeshes.Length, 0, StaticMeshes.Length - 1);
    if (TeamIndex == AXIS_TEAM_INDEX)
    {
        return StaticMesh'DH_Construction_stc.Supply_Cache.GER_Supply_cache_full';
    }
    else if (TeamIndex == ALLIES_TEAM_INDEX)
    {
        LI = class'DH_LevelInfo'.static.GetInstance(Level);

        if (LI != none)
        {
            switch (LI.AlliedNation)
            {
                case NATION_USA:
                    return StaticMesh'DH_Construction_stc.Supply_Cache.USA_Supply_cache_full';
                case NATION_Britain:
                case NATION_Canada:
                case NATION_USSR:
                    return StaticMesh'DH_Construction_stc.Supply_Cache.USA_Supply_cache_full';
            }
        }
    }

    return none;
}

function SetSupplyCount(int Amount)
{
    SupplyCount = Clamp(Amount, 0, SupplyCountMax);

    // Update visualization
    SetStaticMesh(GetStaticMeshForSupplyCount(Level, TeamIndex, SupplyCount));
    NetUpdateTime = Level.TimeSeconds - 1.0;

    OnSupplyCountChanged(self);
}

function Destroyed()
{
    local int i;
    local DHPawn P;
    local DHVehicle V;
    local DHGameReplicationInfo GRI;

    for (i = 0; i < TouchingPawns.Length; ++i)
    {
        P = DHPawn(TouchingPawns[i]);

        if (P != none)
        {
            class'UArray'.static.Erase(P.TouchingSupplyAttachments, self);
        }

        V = DHVehicle(TouchingPawns[i]);

        if (V != none)
        {
            class'UArray'.static.Erase(V.TouchingSupplyAttachments, self);
        }
    }

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI != none && SupplyPointIndex != -1)
    {
        GRI.RemoveSupplyPoint(self);
    }

    super.Destroyed();
}

function Timer()
{
    local Pawn Pawn;
    local DHPawn P;
    local DHVehicle V;
    local int i, Index, SuppliesToDeposit;
    local array<Pawn> NewTouchingPawns;
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI != none && SupplyPointIndex != -1)
    {
        // Update supply point information in game replication info.
        GRI.SupplyPoints[SupplyPointIndex].TeamIndex = TeamIndex;
        GRI.SupplyPoints[SupplyPointIndex].Location.X = Location.X;
        GRI.SupplyPoints[SupplyPointIndex].Location.Y = Location.Y;
        GRI.SupplyPoints[SupplyPointIndex].Location.Z = Rotation.Yaw;
    }

    NewTouchingPawns.Length = 0;

    // Gather all relevant pawns within the radius.
    foreach CollidingActors(class'Pawn', Pawn, class'DHUnits'.static.MetersToUnreal(TouchDistanceInMeters))
    {
        if (Pawn != none && Pawn.GetTeamNum() == TeamIndex)
        {
            NewTouchingPawns[NewTouchingPawns.Length] = Pawn;
        }
    }

    for (i = 0; i < NewTouchingPawns.Length; ++i)
    {
        Index = class'UArray'.static.IndexOf(TouchingPawns, NewTouchingPawns[i]);

        if (Index == -1)
        {
            // Pawn is now being touched, add ourselves to their touching list.
            P = DHPawn(NewTouchingPawns[i]);
            V = DHVehicle(NewTouchingPawns[i]);

            if (P != none)
            {
                P.TouchingSupplyAttachments[P.TouchingSupplyAttachments.Length] = self;
            }
            else if (V != none)
            {
                V.TouchingSupplyAttachments[V.TouchingSupplyAttachments.Length] = self;
            }
        }
    }

    for (i = 0; i < TouchingPawns.Length; ++i)
    {
        Index = class'UArray'.static.IndexOf(NewTouchingPawns, TouchingPawns[i]);

        if (Index == -1)
        {
            // Pawn is no longer being touched, remove ourselves from their
            // touching list.
            P = DHPawn(TouchingPawns[i]);
            V = DHVehicle(TouchingPawns[i]);

            if (P != none)
            {
                class'UArray'.static.Erase(P.TouchingSupplyAttachments, self);
            }
            else if (V != none)
            {
                class'UArray'.static.Erase(V.TouchingSupplyAttachments, self);
            }
        }
    }

    TouchingPawns = NewTouchingPawns;

    if (bCanGenerateSupplies)
    {
        ++SupplyDepositCounter;

        if (SupplyDepositCounter >= SupplyDepositInterval)
        {
            // Deposit the supplies.
            SuppliesToDeposit = float(SupplyGenerationRate) / 60.0 * SupplyDepositInterval;
            SetSupplyCount(GetSupplyCount() + SuppliesToDeposit);

            // Reset counter
            SupplyDepositCounter = 0;
        }
    }
}

// This function is called by static resupply volumes on their timer.
function bool Resupply()
{
    if (bCanBeResupplied || IsFull())
    {
        return false;
    }

    SupplyCount = Min(SupplyCountMax, SupplyCount + 100); // TODO: magic number

    OnSupplyCountChanged(self);

    return true;
}

// TODO: logic for getting this resupplied; some sort of hook that things can
// put on it for getting notified (OnResupplied)

defaultproperties
{
    SupplyPointIndex=-1
    SupplyCount=2000
    SupplyCountMax=2000
    TouchDistanceInMeters=50
    RemoteRole=ROLE_DumbProxy
    bOnlyDrawIfAttached=true
    DrawType=DT_StaticMesh
    bAcceptsProjectors=true
    bUseLightingFromBase=true
}

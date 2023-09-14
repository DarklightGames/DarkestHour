//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstructionSupplyAttachment extends Actor
    abstract
    notplaceable;

#exec OBJ LOAD FILE=../StaticMeshes/DH_Construction_stc.usx

var int                 SupplyPointIndex;
var private float       SupplyCount;
var int                 SupplyCountMax;
var private int         TeamIndex;
var bool                bIsMainSupplyCache;

var localized private string   HumanReadableName;

var class<DHMapIconAttachment> MapIconAttachmentClass;
var DHMapIconAttachment        MapIconAttachment;

// Whether or not this supply attachment can be resupplied from a static resupply point.
var bool                bCanBeResupplied;

// Whether or not this supply attachment can have it's supplies loaded and unloaded from a vehicle.
var bool                bAreSuppliesTransactable;

// Used to resolve the order in which supplies will be drawn from in the case
// where the the player is near multiple supply attachments when placing
// constructions. A higher value means it will be drawn from first.
var int                 SortPriority;

var array<Pawn>         TouchingPawns;

// The distance, in meters, a player must be within to have access to these supplies.
var float               TouchDistanceInMeters;

// Used to circumvent an engine bug (see PostNetReceive below)
var bool                bIsBaseInitialized;

// Whether or not this supply attachment is attached to a vehicle
var bool                bIsAttachedToVehicle;

//==============================================================================
// Supply Generation
//==============================================================================
var bool                bIsInDangerZone;                    // Whether or not this supply attachment is in the danger zone.
var bool                bCanGenerateSupplies;               // Whether or not this supply attachment is able to generate supplies.
var int                 SupplyDepositInterval;              // The amount of seconds before generated supplies are deposited into the supply count.
var int                 SupplyDepositCounter;               // The next time that generated supplies will be deposited.
var int                 SupplyGenerationRate;               // The base amount of supplies that are generated every minute, gets reduced per cache.
var int                 BonusSupplyGenerationRate;          // Bonus amount of supplies that are generated on top of SupplyGenerationRate every minute (does not get reduced per # of caches).

struct Withdrawal
{
    var DHConstructionSupplyAttachment Attachment;
    var int Amount;
};

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        TeamIndex, SupplyCount;
}

// This delegate will be called whenever the SupplyCount changes.
delegate OnSupplyCountChanged(DHConstructionSupplyAttachment CSA);

function bool IsGeneratingSupplies()
{
    return bCanGenerateSupplies && !IsFull() && (bIsMainSupplyCache || !bIsInDangerZone);
}

// Overridden to bypass bizarre logic that necessitated the Owner be a Pawn.
simulated function PostBeginPlay()
{
    local DHGameReplicationInfo GRI;

    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        SupplyCount = default.SupplyCount;

        GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

        if (GRI != none)
        {
            SupplyPointIndex = GRI.AddSupplyPoint(self);
        }

        if (MapIconAttachmentClass != none)
        {
            MapIconAttachment = Spawn(MapIconAttachmentClass, self);

            if (MapIconAttachment != none)
            {
                MapIconAttachment.SetBase(self);
                MapIconAttachment.Setup();
            }
            else
            {
                MapIconAttachmentClass.static.OnError(ERROR_SpawnFailed);
            }
        }

        SetTimer(1.0, true);
    }
}

// This should be called after spawning
function SetInitialSupply(optional int Amount)
{
    if (Amount != -1)
    {
        SetSupplyCount(Amount);
    }
    else
    {
        SetSupplyCount(default.SupplyCount);
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

simulated function float GetSupplyCount()
{
    return SupplyCount;
}

static function StaticMesh GetStaticMesh(LevelInfo Level, int TeamIndex)
{
    local DH_LevelInfo LI;

    LI = class'DH_LevelInfo'.static.GetInstance(Level);

    if (LI != none)
    {
        return LI.GetTeamNationClass(TeamIndex).default.SupplyCacheStaticMesh;
    }

    return none;
}

function UpdateAppearance()
{
    SetStaticMesh(GetStaticMesh(Level, TeamIndex));
    NetUpdateTime = Level.TimeSeconds - 1.0;
}

function SetSupplyCount(float Amount)
{
    SupplyCount = FClamp(Amount, 0.0, float(SupplyCountMax));
    UpdateAppearance();
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

    if (MapIconAttachment != none)
    {
        MapIconAttachment.Destroy();
    }

    super.Destroyed();
}

function bool IsTouchingActor(Actor A)
{
    return A != none && VSize(Location - A.Location) <= class'DHUnits'.static.MetersToUnreal(TouchDistanceInMeters);
}

function Timer()
{
    local Pawn Pawn;
    local DHPawn P;
    local DHVehicle V;
    local int i, Index, SuppliesToDeposit, NumOfGeneratingSupplyPoints;
    local array<Pawn> NewTouchingPawns;
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI != none)
    {
        bIsInDangerZone = GRI.IsInDangerZone(Location.X, Location.Y, GetTeamIndex());
    }

    if (GRI != none && SupplyPointIndex != -1)
    {
        // Update supply point information in game replication info.
        GRI.SupplyPoints[SupplyPointIndex].TeamIndex = TeamIndex;
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
            else if (V != none && V.SupplyAttachment != self && bAreSuppliesTransactable)
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

    if (IsGeneratingSupplies())
    {
        ++SupplyDepositCounter;

        if (SupplyDepositCounter >= SupplyDepositInterval)
        {
            // Get number of generating supply points for the team
            NumOfGeneratingSupplyPoints = Max(GRI.GetNumberOfGeneratingSupplyPointsForTeam(TeamIndex), 1);

            // Calculate the base and bonus generation
            SuppliesToDeposit = float(SupplyGenerationRate / NumOfGeneratingSupplyPoints) + float(BonusSupplyGenerationRate);

            // Calculate the rate
            SuppliesToDeposit = SuppliesToDeposit / 60.0 * SupplyDepositInterval;

            // Deposit the supplies
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

    SupplyCount = FMin(float(SupplyCountMax), SupplyCount + 100.0); // TODO: magic number

    OnSupplyCountChanged(self);

    return true;
}

simulated function PostNetReceive()
{
    local DHVehicle V;

    // HACK: This is a workaround for an engine bug where the rotation and
    // location offsets are not re-applied if the actors are not replicated in
    // the "correct" order.
    if (!bIsBaseInitialized)
    {
        if (Base != none)
        {
            V = DHVehicle(Base);

            if (V != none)
            {
                SetRelativeRotation(V.SupplyAttachmentRotation);
                SetRelativeLocation(V.SupplyAttachmentOffset);
            }

            bIsBaseInitialized = true;
        }
    }
    else if (Base == none)
    {
        bIsBaseInitialized = false;
    }
}

simulated function int GetTeamIndex()
{
    return TeamIndex;
}

function SetTeamIndex(int TeamIndex)
{
    self.TeamIndex = TeamIndex;
    UpdateAppearance();

    if (MapIconAttachment != none)
    {
        MapIconAttachment.SetTeamIndex(TeamIndex);
    }
}

simulated function string GetHumanReadableName()
{
    return HumanReadableName;
}

static function bool CompareFunction(Object LHS, Object RHS)
{
    return DHConstructionSupplyAttachment(LHS).SortPriority > DHConstructionSupplyAttachment(RHS).SortPriority;
}

// TODO: logic for getting this resupplied; some sort of hook that things can
// put on it for getting notified (OnResupplied)
defaultproperties
{
    TeamIndex=-1
    SupplyPointIndex=-1
    SupplyCount=2000.0
    SupplyCountMax=2000
    TouchDistanceInMeters=50
    RemoteRole=ROLE_DumbProxy
    bOnlyDrawIfAttached=true
    DrawType=DT_StaticMesh
    bAcceptsProjectors=true
    bUseLightingFromBase=true
    bNetNotify=true
    HumanReadableName="Supply Cache"
}

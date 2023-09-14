//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// FOOLS

class DHIQManager extends Actor;

enum EReason
{
    REASON_None,
    REASON_NotInSquad,
    REASON_AWOL
};

var DHPlayer PC;
var DHPlayerReplicationInfo PRI;

var globalconfig float AWOLDistance;
var globalconfig float SupplyDistance;

var globalconfig float RefreshInterval;
var globalconfig float SpawnDelay;
var globalconfig int   IQIncrement;
var globalconfig int   HeadGrowthStep;
var globalconfig int   MinIQToGrowHead;

var globalconfig bool  bDebugIQManager;

var globalconfig int   MinIQ;
var globalconfig int   MaxIQ;
var globalconfig float MaxHeadScale;

var private      bool  bNormalHead;
var private      int   OldWholeScale;
var private      float ScaleMultiplier;

function OnSpawn() { GoToState('Pending'); }
function OnDeath() { GoToState(''); }
// function bool IsManaged() { return IsInState('Managed') || IsInState('Pending'); }
// function DebugLog(string Msg) { if (bDebugIQManager) Log(Msg); }

function PostBeginPlay()
{
    PC = DHPlayer(Owner);

    if (PC == none)
    {
        Warn("No controller.");
        return;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    if (PRI == none)
    {
        Warn("No PRI.");
    }

    PC.MinIQToGrowHead = MinIQToGrowHead;
}

function bool ResetPlayerIQ()
{
    if (PRI != none)
    {
        PRI.PlayerIQ = MinIQ;
        bNormalHead = default.bNormalHead;
        OldWholeScale = default.OldWholeScale;
        ScaleMultiplier = default.ScaleMultiplier;
        return true;
    }
}

state Pending
{
    function BeginState()
    {
        local DHRoleInfo RI;

        if (PC == none)
        {
            GotoState('');
            return;
        }

        RI = DHRoleInfo(PC.GetRoleInfo());

        if (RI != none && (RI.bCanUseMortars || RI.bCanBeTankCrew))
        {
            // DebugLog("Role does not qualify:" @ PC);
            GotoState('');
            return;
        }

        if (!ResetPlayerIQ())
        {
            return;
        }

        PC.bIQManaged = true;
        SetTimer(SpawnDelay, false);
    }

    function Timer()
    {
        GotoState('Managed');
    }
}

state Managed
{
    function BeginState()
    {
        if (PC == none)
        {
            GotoState('');
            return;
        }

        PC.bIQManaged = true;

        // DebugLog("Spawned:" @ PC);

        SetTimer(RefreshInterval, true);
    }

    function EndState()
    {
        // DebugLog("Died:" @ PC);
        ResetPlayerIQ();
    }

    function Timer()
    {
        local float IQIncrementMultiplier;
        local EReason Reason;

        if (PRI == none)
        {
            return;
        }

        if (IsDingus(Reason, IQIncrementMultiplier))
        {
            ChangeIQ(-IQIncrement * IQIncrementMultiplier, Reason);
        }
        else
        {
            ChangeIQ(IQIncrement * IQIncrementMultiplier, Reason);
        }
    }

    function bool IsDingus(out EReason Reason, out float IQIncrementMultiplier)
    {
        local DHPawn MyPawn;
        local Pawn P;
        local DHPlayerReplicationInfo OtherPRI;

        IQIncrementMultiplier = 1.0;

        if (PRI == none || PC == none || PC.SquadReplicationInfo == none)
        {
            return false;
        }

        if (!PRI.IsInSquad())
        {
            // DebugLog("+ Not in squad!");
            Reason = REASON_NotInSquad;
            return false;
        }

        if (PC.SquadReplicationInfo.GetMemberCount(PC.GetTeamNum(), PRI.SquadIndex) <= 1)
        {
            // DebugLog("- Alone in a squad.");
            IQIncrementMultiplier = 0.25;
            return true;
        }

        MyPawn = GetPawn();

        if (MyPawn == none)
        {
            return false;
        }

        // Player is in a squad and chilling next to his mates. What a tool!
        foreach RadiusActors(class'Pawn', P, AWOLDistance, MyPawn.Location)
        {
            if (P == none)
            {
                continue;
            }

            OtherPRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);

            if (OtherPRI == none ||
                PRI == OtherPRI ||
                P.GetTeamNum() != MyPawn.GetTeamNum() ||
                PRI.SquadIndex != OtherPRI.SquadIndex)
            {
                continue;
            }

            if (OtherPRI.IsSquadLeader() || PRI.IsSquadLeader())
            {
                // DebugLog("- Close to a squad leader / Close to a squad mate (I'm SL)!");
                return true;
            }

            // DebugLog("- Friend nearby (Get half IQ)");
            IQIncrementMultiplier = 0.5;
            return true;
        }

        if (!PRI.IsSLorASL())
        {
            // DebugLog("+ AWOL 1");
            Reason = REASON_AWOL;
            return false;
        }

        // Leader is hanging out near a resource point like he's got nothing
        // better to do.
        if (MyPawn.TouchingSupplyCount >= 0)
        {
            // DebugLog("Found supplies nearby.");
            return true;
        }

        // DebugLog("+ AWOL 2");
        Reason = REASON_AWOL;
    }

    protected function ChangeIQ(int Increment, EReason Reason)
    {
        local DHPawn P;
        local int IQGrowthRange;

        if (PC == none || PRI == none)
        {
            return;
        }

        PRI.PlayerIQ = Clamp(PRI.PlayerIQ + Increment, MinIQ, MaxIQ);

        if (PRI.PlayerIQ < MinIQToGrowHead)
        {
            // DebugLog("IQ changed:" @ PRI.PlayerIQ);
            return;
        }

        IQGrowthRange = MaxIQ - MinIQToGrowHead;
        OldWholeScale = int(ScaleMultiplier);

        if (IQGrowthRange <= 0)
        {
            // DebugLog("MaxIQ - MinIQToGrowHead is either negative or zero.");
            ScaleMultiplier = MaxHeadScale;
        }
        else
        {
            ScaleMultiplier = FMax(1.0, 1.0 + MaxHeadScale * (PRI.PlayerIQ - MinIQToGrowHead) / IQGrowthRange);
        }

        if (ScaleMultiplier <= 1.0)
        {
            bNormalHead = true;
        }

        if (Increment > 0 && (int(ScaleMultiplier) > OldWholeScale || bNormalHead))
        {
            bNormalHead = false;

            switch (Reason)
            {
                case REASON_NotInSquad:
                    PC.ReceiveLocalizedMessage(class'DHIQMessage', 3);
                    break;
                case REASON_AWOL:
                    if (PRI.IsSLorASL())
                    {
                        PC.ReceiveLocalizedMessage(class'DHIQMessage', 1);
                    }
                    else
                    {
                        PC.ReceiveLocalizedMessage(class'DHIQMessage', 2);
                    }
                    break;
            }
        }

        P = GetPawn();

        if (P != none)
        {
            P.SetHeadScale(FMax(P.default.HeadScale, ScaleMultiplier));
            // DebugLog("Head has been enlarged. Scale:" @ ScaleMultiplier);
        }
    }
}

function int GetScaleMultiplier()
{
    if (PRI == none)
    {
        return 1;
    }

    return Max(1, (PRI.PlayerIQ - MinIQ) / HeadGrowthStep);
}

function DHPawn GetPawn()
{
    local Vehicle Veh;

    if (PC == none)
    {
        return none;
    }

    Veh = Vehicle(PC.Pawn);

    if (Veh != none && Veh.Driver != none)
    {
        return DHPawn(Veh.Driver);
    }

    return DHPawn(PC.Pawn);
}

defaultproperties
{
    RemoteRole=ROLE_None
    bHidden=true

    bDebugIQManager=true

    AWOLDistance=6035 // 100m
    SupplyDistance=6035

    RefreshInterval=5.0
    SpawnDelay=10.0
    IQIncrement=5
    HeadGrowthStep=30
    MinIQToGrowHead=100
    MinIQ=40
    MaxIQ=400
    MaxHeadScale=15.0

    OldWholeScale=1
    ScaleMultiplier=1.0
    bNormalHead=true
}

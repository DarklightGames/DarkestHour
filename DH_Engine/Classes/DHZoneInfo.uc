//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHZoneInfo extends ZoneInfo;

const FOG_CHANGE_TIME =             700.0;                      // This doesn't seem to be in seconds, but does affect the fog change time
const CLIENTFRAMERATE_UPDATETIME =  5.0;                        // How often to calculate the average fps

var()   bool            bUseServerFogOptimization;              // WIP (not functional)

var     float           TargetDistanceFog,                      // WIP stuff (does not affect anything)
                        FogChangeStart,
                        FogChangeEnd;

var     float           ClientSavedFogRatio,                    // Client-sided fog ratio
                        TargetFogRatio,                         // Client target for fog distance ratio (to make fog adjustments smooth)
                        FogRatioChangeStart,                    // Used to make fog adjustments smooth
                        FogRatioChangeEnd;                      // ...
var     InterpCurve     ClientFogRatioCurve;                    // Curve used for more control over fog ratio (makes it so we can drop to min fog distance before 0 fps)

var     float           ClientAverageFrameRate;
var     float           ClientFrameRateConsolidated;            // Keeps track of tick rates over time, used to calculate average
var     int             ClientFrameRateCount;                   // Keeps track of how many frames are between ClientFrameRateConsolidated


replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        TargetDistanceFog;
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();

    // Set the initial target fog value
    if (Role == ROLE_Authority)
    {
        SetTargetFog(DistanceFogEnd);
    }
}

simulated function PostNetReceive()
{
    if (DistanceFogEnd != TargetDistanceFog)
    {
        FogChangeStart = Level.TimeSeconds;
        FogChangeEnd = FogChangeStart + FOG_CHANGE_TIME;
    }

    super.PostNetReceive();
}

simulated function Tick( float DeltaTime )
{
    local float T;
    local DHPlayer C;

    // Client
    if (Level.NetMode != NM_DedicatedServer)
    {
        // Handle the average frame rate
        ClientFrameRateConsolidated += DeltaTime;

        if (ClientFrameRateConsolidated > CLIENTFRAMERATE_UPDATETIME)
        {
            ClientAverageFrameRate = ClientFrameRateCount / ClientFrameRateConsolidated;
            ClientFrameRateCount = 0;
            ClientFrameRateConsolidated -= CLIENTFRAMERATE_UPDATETIME;

            C = DHPlayer(Level.GetLocalPlayerController());

            if (C != none && C.bDynamicFogRatio)
            {
                TargetFogRatio = InterpCurveEval(ClientFogRatioCurve, ClientAverageFrameRate / C.MinDesiredFPS);
                FogRatioChangeStart = Level.TimeSeconds;
                FogRatioChangeEnd = FogRatioChangeStart + FOG_CHANGE_TIME;
            }
        }
        else
        {
            ++ClientFrameRateCount;
        }

        // WIP stuff
        /*
        if (DistanceFogEnd != TargetDistanceFog)
        {
            T = FClamp((Level.TimeSeconds - FogChangeStart) / (FogChangeEnd - FogChangeStart), 0.0, 1.0);
            DistanceFogEnd = class'UInterp'.static.Linear(T, DistanceFogEnd, TargetDistanceFog);
        }
        */

        // Set C, but only if we haven't already
        if (C == none)
        {
            C = DHPlayer(Level.GetLocalPlayerController());
        }

        // If client has dynamic fog ratio true, then handle the Fog Distance based on current and target ratio
        if (C != none && C.bDynamicFogRatio)
        {
            if (ClientSavedFogRatio != TargetFogRatio)
            {
                T = FClamp((Level.TimeSeconds - FogRatioChangeStart) / (FogRatioChangeEnd - FogRatioChangeStart), 0.0, 1.0);
                ClientSavedFogRatio = class'UInterp'.static.Linear(T, ClientSavedFogRatio, TargetFogRatio);
                C.Level.UpdateDistanceFogLOD(ClientSavedFogRatio);
            }
        }
    }
}

function SetTargetFog(float NewDistance)
{
    if (NewDistance > 0.0)
    {
        TargetDistanceFog = NewDistance;
    }
    else
    {
        Warn("A target fog value was less than or equal to zero and is not valid.");
    }
}

defaultproperties
{
    ClientFogRatioCurve=(Points=((InVal=0.0,OutVal=0.0),(InVal=0.4,OutVal=0.0),(InVal=1.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    ClientSavedFogRatio=1.0
    bUseServerFogOptimization=true
    bNetNotify=true
    bStatic=false
    bAlwaysRelevant=true
    bSkipActorPropertyReplication=false
    RemoteRole=ROLE_SimulatedProxy
    bGameRelevant=true
}

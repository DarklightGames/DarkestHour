//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

// The purpose of this class is to optimize both server and client performance using FogDistance and FogRatio

class DHZoneInfo extends ZoneInfo;

const FOG_RATIO_CHANGE_TIME =       200.0;                      // Time in changing the fog ratio value, it needs to be very slow so it doesn't pulse
const FOG_CHANGE_TIME =             20.0;                       // Time in changing the fog distance
const MIN_DESIRED_UPDATE_TIME =     60.0;                       // After changing min deisred FPS, how quickly its change takes affect
const CLIENTFRAMERATE_UPDATETIME =  5.0;                        // How often to calculate the average fps

var()   bool            bUseDynamicFogDistance;                 // ...

var     float           OriginalFogDistanceEnd,                 // Saves at the beginning of the level, but only then
                        TargetDistanceFog,                      // Target fog distance for both the client and server, this is replicated to all clients
                        FogChangeStart,                         // Not replicated, but used by both server and client
                        FogChangeEnd,                           // Not replicated, but used by both server and client
                        SavedDistanceEndFog;                    // The fog value at which point the fog was changed (this gives us a starting point to change from)

var     float           ClientFogRatio,                         // Client-sided fog ratio
                        TargetFogRatio,                         // Client target for fog distance ratio (to make fog adjustments smooth)
                        FogRatioChangeStart,                    // Used to make fog adjustments smooth
                        FogRatioChangeEnd;                      // ...

var     InterpCurve     ClientFogRatioCurve;                    // Curve used for more control over fog ratio (makes it so we can drop to min fog distance before 0 fps)

var     float           ClientAverageFrameRate;
var     float           ClientFrameRateConsolidated;            // Keeps track of tick rates over time, used to calculate average
var     int             ClientFrameRateCount;                   // Keeps track of how many frames are between ClientFrameRateConsolidated

var     float           ClientFrameChangeStart,
                        ClientFrameChangeEnd;
var     int             ClientSavedDesiredFrame,
                        ClientMinDesiredFrame,
                        TargetMinDesiredFrame;                  // Keeps track of clients desired frame and will blend (smoothly) if client changes it

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        TargetDistanceFog;
}

simulated function float GetDistanceFogEndMin() { return FMax(DistanceFogEndMin, DistanceFogStart + 100.0); }

simulated event PostBeginPlay()
{
    super.PostBeginPlay();

    // Set the initial target fog value
    if (Role == ROLE_Authority)
    {
        OriginalFogDistanceEnd = DistanceFogEnd;
        SetNewTargetFogDistance(OriginalFogDistanceEnd);
    }
}

simulated function PostNetReceive()
{
    super.PostNetReceive();

    if (RealDistanceFogEnd != TargetDistanceFog)
    {
        FogChangeStart = Level.TimeSeconds;
        FogChangeEnd = FogChangeStart + FOG_CHANGE_TIME;
        SavedDistanceEndFog = RealDistanceFogEnd;
    }
}

function Reset()
{
    super.Reset();

    // Reset to the initial fog value
    if (Role == ROLE_Authority)
    {
        SetNewTargetFogDistance(OriginalFogDistanceEnd);
    }
}

simulated function Tick( float DeltaTime )
{
    local float         T;
    local bool          bUpdate;
    local DHPlayer      C;

    super.Tick(DeltaTime);

    // Net Client Only
    if (Level.NetMode == NM_Client)
    {
        C = DHPlayer(Level.GetLocalPlayerController());

        // Return out if can't find controller
        if (C == none)
        {
            return;
        }

        // Consolidate DeltaTime onto ClientFrameRateConsolidated (used to limit calculations in tick)
        ClientFrameRateConsolidated += DeltaTime;

        // If enough time has passed, calculate Average Frame Rate and Fog Ratio
        if (ClientFrameRateConsolidated > CLIENTFRAMERATE_UPDATETIME)
        {
            // Set
            ClientAverageFrameRate = ClientFrameRateCount / ClientFrameRateConsolidated;
            ClientFrameRateCount = 0;
            ClientFrameRateConsolidated -= CLIENTFRAMERATE_UPDATETIME;

            // Update the to the client's MinFPS setting
            if (TargetMinDesiredFrame != C.MinDesiredFPS && C.bDynamicFogRatio)
            {
                ClientFrameChangeStart = Level.TimeSeconds;
                ClientFrameChangeEnd = ClientFrameChangeStart + MIN_DESIRED_UPDATE_TIME;
                ClientSavedDesiredFrame = C.MinDesiredFPS;
                TargetMinDesiredFrame = C.MinDesiredFPS;
            }

            if (C.bDynamicFogRatio)
            {
                TargetFogRatio = InterpCurveEval(ClientFogRatioCurve, ClientAverageFrameRate / ClientMinDesiredFrame);
            }
            else
            {
                // TODO: This should not be a console command to get this damn value, only other way is to keep track of it :C
                TargetFogRatio = float(C.ConsoleCommand("get ini:Engine.Engine.ViewportManager DrawDistanceLOD"));
            }

            FogRatioChangeStart = Level.TimeSeconds;
            FogRatioChangeEnd = FogRatioChangeStart + FOG_RATIO_CHANGE_TIME;
        }
        else
        {
            ++ClientFrameRateCount;
        }

        // Update MinDesiredFrames
        if (ClientMinDesiredFrame != TargetMinDesiredFrame && C.bDynamicFogRatio)
        {
            T = FClamp((Level.TimeSeconds - ClientFrameChangeStart) / (ClientFrameChangeEnd - ClientFrameChangeStart), 0.0, 1.0);
            ClientMinDesiredFrame = class'UInterp'.static.Linear(T, ClientSavedDesiredFrame, TargetMinDesiredFrame);
            bUpdate = true;
        }

        // Update replicated fog distance from server
        if (RealDistanceFogEnd != TargetDistanceFog)
        {
            T = FClamp((Level.TimeSeconds - FogChangeStart) / (FogChangeEnd - FogChangeStart), 0.0, 1.0);
            RealDistanceFogEnd = class'UInterp'.static.Linear(T, SavedDistanceEndFog, TargetDistanceFog);
            ClientFogRatio = TargetFogRatio;
            bUpdate = true;
        }

        // Calc ClientFogRatio if bDynamicFogRatio == true
        if (ClientFogRatio != TargetFogRatio && C.bDynamicFogRatio)
        {
            T = FClamp((Level.TimeSeconds - FogRatioChangeStart) / (FogRatioChangeEnd - FogRatioChangeStart), 0.0, 1.0);
            ClientFogRatio = class'UInterp'.static.Linear(T, ClientFogRatio, TargetFogRatio);
            bUpdate = true;
        }

        // Update the client's FogLOD
        if (bUpdate)
        {
            // This function must be called for the fog distance to actually change!
            // So it actually needs to be called regardless of the user's bDynamicFogRatio setting
            C.Level.UpdateDistanceFogLOD(ClientFogRatio);
        }
    }

    // Non net client
    if (Level.NetMode != NM_Client)
    {
        if (DistanceFogEnd != TargetDistanceFog && TargetDistanceFog >= 0.0)
        {
            if (FogChangeEnd > FogChangeStart)
            {
                T = FClamp((Level.TimeSeconds - FogChangeStart) / (FogChangeEnd - FogChangeStart), 0.0, 1.0);
                DistanceFogEnd = class'UInterp'.static.Linear(T, SavedDistanceEndFog, TargetDistanceFog);
            }
            else
            {
                DistanceFogEnd = TargetDistanceFog;
            }
        }
    }
}

function SetNewTargetFogDistance(float NewDistance)
{
    // Not client (dedicated, stanalone, listen)
    if (Level.NetMode != NM_Client)
    {
        // Clamp the view distance to the level's FogEndMin and ~4km.
        // It is important to never let the DistanceFogEnd be less than
        // DistanceFogStart, because of a very strange render effect.
        TargetDistanceFog = FClamp(NewDistance, GetDistanceFogEndMin() + 100.0, 256000.0);

        if (DistanceFogEnd != TargetDistanceFog && TargetDistanceFog > DistanceFogStart)
        {
            FogChangeStart = Level.TimeSeconds;
            FogChangeEnd = FogChangeStart + FOG_CHANGE_TIME;
            SavedDistanceEndFog = DistanceFogEnd;
        }
    }
}

// Will set the server's target fog distance based on a ratio (min being DistanceFogEndMin and max being OriginalFogDistanceEnd)
function SetFogDistanceWithRatio(float Ratio)
{
    if (Ratio >= 0.0 && Ratio <= 1.0)
    {
        SetNewTargetFogDistance(GetDistanceFogEndMin() + ((OriginalFogDistanceEnd - FMin(OriginalFogDistanceEnd, GetDistanceFogEndMin())) * Ratio));
    }
}

defaultproperties
{
    bUseDynamicFogDistance=true
    ClientFogRatioCurve=(Points=((InVal=0.0,OutVal=0.0),(InVal=0.5,OutVal=0.0),(InVal=1.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    ClientFogRatio=1.0
    bNetNotify=true
    bStatic=false
    bAlwaysRelevant=true
    bSkipActorPropertyReplication=false
    RemoteRole=ROLE_SimulatedProxy
    bGameRelevant=true
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHZoneInfo extends ZoneInfo;

const FOG_CHANGE_TIME=10.0;

var()   bool        bUseDynamicFogOptimization,
                    bUpdateFogDistance;

var     float       TargetDistanceFog,
                    FogChangeStart,
                    FogChangeEnd;

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

        bUpdateFogDistance = true;
    }

    super.PostNetReceive();
}

simulated function Tick( float DeltaTime )
{
    local float T;

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (DistanceFogEnd != TargetDistanceFog)
        {
            T = FClamp((Level.TimeSeconds - FogChangeStart) / (FogChangeEnd - FogChangeStart), 0.0, 1.0);
            DistanceFogEnd = class'UInterp'.static.Linear(T, DistanceFogEnd, TargetDistanceFog);
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
    bUseDynamicFogOptimization=true
    bNetNotify=true
    bStatic=false
    bAlwaysRelevant=true
    bSkipActorPropertyReplication=false
    RemoteRole=ROLE_SimulatedProxy
    bGameRelevant=true
}

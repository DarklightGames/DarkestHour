//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================
// This is the placeable obstacle class.
// Obstacles are replicated to clients only once, and then become independent.
// The DHObstacleManager class handles obstacle state synchronization.
//==============================================================================

class DHObstacle extends Actor
    placeable;

//==============================================================================
// Because this is a non-static actor, location and rotations are quantized down
// by default. Replicating this struct allows us the highest level of positional
// precision possible over the network.
//==============================================================================
struct UncompressedPosition
{
    var float LocationX;
    var float LocationY;
    var float LocationZ;
    var int Pitch;
    var int Yaw;
    var int Roll;
    var float ScaleX;
    var float ScaleY;
    var float ScaleZ;
};

var() float         SpawnClearedChance;

var byte            TypeIndex;
var int             Index;
var config bool     bDebug;

var bool            bPlayEffects;

var private DHObstacleInfo          Info;
var private UncompressedPosition    UP;

replication
{
    reliable if ((bNetDirty || bNetInitial) && Role == ROLE_Authority)
        TypeIndex, Index, UP;
}

simulated function bool IsCleared()
{
    return IsInState('Cleared');
}

function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        UP.LocationX = Location.X;
        UP.LocationY = Location.Y;
        UP.LocationZ = Location.Z;
        UP.Pitch = Rotation.Pitch;
        UP.Yaw = Rotation.Yaw;
        UP.Roll = Rotation.Roll;
        UP.ScaleX = DrawScale3D.X * DrawScale;
        UP.ScaleY = DrawScale3D.Y * DrawScale;
        UP.ScaleZ = DrawScale3D.Z * DrawScale;
    }
}

simulated function PostNetBeginPlay()
{
    local DHObstacleManager OM;
    local vector L, S;
    local rotator R;

    foreach AllActors(class'DHObstacleInfo', Info)
    {
        break;
    }

    if (Info == none)
    {
        Destroy();

        return;
    }

    if (Role < ROLE_Authority)
    {
        Info.Obstacles[Index] = self;

        foreach AllActors(class'DHObstacleManager', OM)
        {
            // If this obstacle gets replicated *after* the obstacle manager,
            // we need to query the manager to get the state otherwise the state
            // never gets set correctly!
            if (OM.IsClearedInBitfield(Index))
            {
                SetCleared(true);
            }

            break;
        }

        L.X = UP.LocationX;
        L.Y = UP.LocationY;
        L.Z = UP.LocationZ;
        SetLocation(L);

        R.Pitch = UP.Pitch;
        R.Yaw = UP.Yaw;
        R.Roll = UP.Roll;
        SetRotation(R);

        S.X = UP.ScaleX;
        S.Y = UP.ScaleY;
        S.Z = UP.ScaleZ;
        SetDrawScale3D(S);
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        bPlayEffects = true;
    }
}

simulated state Intact
{
    simulated function BeginState()
    {
        SetStaticMesh(GetIntactStaticMesh());
        KSetBlockKarma(false);

        super.BeginState();
    }

    simulated function EndState()
    {
        super.EndState();
    }

    event Touch(Actor Other)
    {
        local DarkestHourGame G;

        if (!CanBeCrushed())
        {
            return;
        }

        if (Role == ROLE_Authority && SVehicle(Other) != none)
        {
            G = DarkestHourGame(Level.Game);

            if (G != none && G.ObstacleManager != none)
            {
                G.ObstacleManager.SetCleared(self, true);
            }
        }

        super.Touch(Other);
    }
}

simulated state Cleared
{
    simulated function BeginState()
    {
        if (Level.NetMode != NM_DedicatedServer && class'DHObstacleManager'.default.bPlayEffects && bPlayEffects)
        {
            if (GetClearSound() != none)
            {
                PlayOwnedSound(GetClearSound(), SLOT_None, 255.0);
            }

            if (GetClearEmitterClass() != none)
            {
                Spawn(GetClearEmitterClass(), none, '', Location, Rotation);
            }
        }

        SetStaticMesh(GetClearedStaticMesh());
        KSetBlockKarma(false);

        super.BeginState();
    }
}

simulated function SetCleared(bool bIsCleared)
{
    if (bDebug)
    {
        Log(Index @ "SetCleared" @ bIsCleared);
    }

    if (bIsCleared)
    {
        GotoState('Cleared');
    }
    else
    {
        GotoState('Intact');
    }
}

simulated function StaticMesh GetIntactStaticMesh()
{
    return Info.Types[TypeIndex].IntactStaticMesh;
}

simulated function StaticMesh GetClearedStaticMesh()
{
    if (Info.Types[TypeIndex].ClearedStaticMeshes.Length > 0)
    {
        return Info.Types[TypeIndex].ClearedStaticMeshes[Index % Info.Types[TypeIndex].ClearedStaticMeshes.Length];
    }

    return none;
}

simulated function bool CanBeCut()
{
    return Info.Types[TypeIndex].bCanBeCut;
}

simulated function bool CanBeMantled()
{
    return Info.Types[TypeIndex].bCanBeMantled;
}

simulated function bool CanBeCrushed()
{
    return Info.Types[TypeIndex].bCanBeCrushed;
}

simulated function sound GetClearSound()
{
    return Info.Types[TypeIndex].ClearSound;
}

simulated function float GetCutDuration()
{
    return Info.Types[TypeIndex].CutDuration;
}

simulated function class<Emitter> GetClearEmitterClass()
{
    if (Info.Types[TypeIndex].ClearEmitterClasses.Length > 0)
    {
        return Info.Types[TypeIndex].ClearEmitterClasses[Index % Info.Types[TypeIndex].ClearEmitterClasses.Length];
    }

    return none;
}

simulated function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    local DarkestHourGame G;

    if (Role == ROLE_Authority &&
        Info.Types[TypeIndex].bCanBeDestroyedByExplosives &&
        !DamageType.default.bLocationalHit &&
        Damage >= Info.Types[TypeIndex].ExplosionDamageThreshold)
    {
        G = DarkestHourGame(Level.Game);

        if (G != none && G.ObstacleManager != none)
        {
            G.ObstacleManager.SetCleared(self, true);
        }
    }
}

defaultproperties
{
    bBlockPlayers=true
    bBlockActors=true
    bBlockKarma=true
    bBlockProjectiles=true
    bBlockHitPointTraces=true
    bBlockNonZeroExtentTraces=true
    bCanBeDamaged=true
    bCollideActors=true
    bCollideWorld=false
    bWorldGeometry=false
    bStatic=false
    bStaticLighting=true
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_Obstacles_stc.Barbed.fence_farm01'
    bNetTemporary=true
    bAlwaysRelevant=true
    RemoteRole=ROLE_None
    bCompressedPosition=false
    SpawnClearedChance=0.0
    TypeIndex=255
    bDebug=false
}


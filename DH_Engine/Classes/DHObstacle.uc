//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHObstacle extends Actor
    placeable;

//------------------------------------------------------------------------------
// Because this is a non-static actor, location and rotations are quantized down
// by default. Replicating this struct allows us the highest level of positional
// precision possible over the network.
//------------------------------------------------------------------------------
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

var     byte                    TypeIndex;
var     int                     Index;
var     UncompressedPosition    UP;
var     StaticMesh              IntactStaticMesh;
var     StaticMesh              ClearedStaticMesh;
var     sound                   ClearSound;
var     class<Emitter>          ClearEmitterClass;
var     bool                    bCanBeClearedWithWirecutters;
var     DHObstacleInfo          Info;

var()   float                   SpawnClearedChance;

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

    if (Role < ROLE_Authority)
    {
        foreach AllActors(class'DHObstacleInfo', Info)
        {
            break;
        }

        IntactStaticMesh = Info.Types[TypeIndex].IntactStaticMesh;

        if (Info.Types[TypeIndex].ClearedStaticMeshes.Length > 0)
        {
            ClearedStaticMesh = Info.Types[TypeIndex].ClearedStaticMeshes[Index % Info.Types[TypeIndex].ClearedStaticMeshes.Length];
        }

        bCanBeClearedWithWirecutters = Info.Types[TypeIndex].bCanBeClearedWithWireCutters;
        ClearSound = Info.Types[TypeIndex].ClearSound;

        if (Info.Types[TypeIndex].ClearEmitterClasses.Length > 0)
        {
            ClearEmitterClass = Info.Types[TypeIndex].ClearEmitterClasses[Index % Info.Types[TypeIndex].ClearEmitterClasses.Length];
        }

        foreach AllActors(class'DHObstacleManager', OM)
        {
            OM.Obstacles[Index] = self;

            // If this obstacle gets replicated *after* the obstacle manager,
            // we need to query the manager to get the state otherwise the state
            // never gets set correctly!
            if (OM.IsClearedInBitfield(Index))
            {
                SetCleared(true);
            }
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
}

auto simulated state Intact
{
    simulated function BeginState()
    {
        SetStaticMesh(IntactStaticMesh);
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

        if (Role == ROLE_Authority)
        {
            if (SVehicle(Other) != none)
            {
                G = DarkestHourGame(Level.Game);

                if (G != none && G.ObstacleManager != none)
                {
                    //TODO: destruction requires a certain speed?
                    G.ObstacleManager.SetCleared(self, true);
                }
            }
        }

        super.Touch(Other);
    }
}

simulated state Cleared
{
    simulated function BeginState()
    {
        if (Level.NetMode != NM_DedicatedServer)
        {
            //TODO: this is super quiet for some reason
            if (ClearSound != none)
            {
                PlayOwnedSound(ClearSound, SLOT_None);
            }

            if (ClearEmitterClass != none)
            {
                Spawn(ClearEmitterClass, none, '', Location, Rotation);
            }
        }

        SetStaticMesh(ClearedStaticMesh);
        KSetBlockKarma(false);

        super.BeginState();
    }
}

simulated function SetCleared(bool bIsCleared)
{
    if (bIsCleared)
    {
        GotoState('Cleared');
    }
    else
    {
        GotoState('Intact');
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
    bNetTemporary=true
    bAlwaysRelevant=true
    RemoteRole=ROLE_None
    bCompressedPosition=false
    SpawnClearedChance=0.0
    bCanBeClearedWithWireCutters=true
    TypeIndex=255
}


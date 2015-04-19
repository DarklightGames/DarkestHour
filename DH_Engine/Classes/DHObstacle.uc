//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================
// This is the placeable obstacle class.
// This acts simply as an informational actor. The client and server will spawn.
//==============================================================================

class DHObstacle extends Actor
    hidecategories(Events,Force,Karama,Object,Sound)
    placeable;

var() float         SpawnClearedChance;

var int             TypeIndex;
var int             Index;

var config bool     bDebug;

var DHObstacleInstance      Instance;

var private DHObstacleInfo  Info;

simulated function bool IsCleared()
{
    return IsInState('Cleared');
}

simulated function PostBeginPlay()
{
    local int i;

    foreach AllActors(class'DHObstacleInfo', Info)
    {
        break;
    }

    if (Info == none)
    {
        Error("DHObstacleInfo could not be found.");
    }

    // Deduce type index
    for (i = 0; i < Info.Types.Length; ++i)
    {
         if (Info.Types[i].IntactStaticMesh == StaticMesh)
         {
             TypeIndex = i;
             break;
         }
    }

    if (TypeIndex == -1)
    {
        Error("DHObstacle could not match to type.");
    }

    // Add to obstacle list
    Index = Info.Obstacles.Length;

    // Create instance
    Instance = Spawn(class'DHObstacleInstance', self,, Location, Rotation);
    Instance.SetStaticMesh(StaticMesh);
    Instance.SetDrawScale(DrawScale);
    Instance.SetDrawScale3D(DrawScale3D);

    Info.Obstacles[Index] = Instance;

    super.PostBeginPlay();
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

simulated function bool CanBeDestroyedByExplosives()
{
    return Info.Types[TypeIndex].bCanBeDestroyedByExplosives;
}

simulated function int GetExplosionDamageThreshold()
{
    return Info.Types[TypeIndex].ExplosionDamageThreshold;
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

defaultproperties
{
    bBlockPlayers=false
    bBlockActors=false
    bBlockKarma=false
    bBlockProjectiles=false
    bBlockHitPointTraces=false
    bBlockNonZeroExtentTraces=false
    bCanBeDamaged=false
    bCollideActors=false
    bCollideWorld=false
    bWorldGeometry=false
    bStatic=true
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_Obstacles_stc.Barbed.fence_farm01'
    RemoteRole=ROLE_None
    SpawnClearedChance=0.0
    TypeIndex=-1
    bDebug=false
    bNoDelete=false
    bHidden=true
    bHiddenEd=false
}

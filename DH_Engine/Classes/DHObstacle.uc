//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// This is the placeable obstacle class.
// This acts simply as an informational actor. The client and server will spawn
// their own DHObstacleInstance actors.
//==============================================================================

class DHObstacle extends Actor
    hidecategories(Events,Force,Karama,Object,Sound)
    placeable;

var() float         SpawnClearedChance;

var int             TypeIndex;
var int             Index;
var bool            bIsDefault;

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

    // Deduce type index (if default)
    for (i = 0; i < Info.DefaultTypes.Length; ++i)
    {
        if (Info.DefaultTypes[i].IntactStaticMesh == StaticMesh)
        {
            TypeIndex = i;
            bIsDefault = true;
            break;
        }
    }

    // If we didn't find a default, try level's custom
    if (!bIsDefault)
    {
        for (i = 0; i < Info.Types.Length; ++i)
        {
            if (Info.Types[i].IntactStaticMesh == StaticMesh)
            {
                TypeIndex = i;
                break;
            }
        }
    }

    if (TypeIndex == -1)
    {
        Warn("=============================================");
        Warn("=== DHObstacle could not match to a type. ===");
        Warn("=============================================");
    }

    // Add to obstacle list
    Index = Info.Obstacles.Length;

    // Create instance
    Instance = Spawn(class'DHObstacleInstance', self,, Location, Rotation);
    Instance.SetStaticMesh(StaticMesh);
    Instance.SetDrawScale(DrawScale);
    Instance.SetDrawScale3D(DrawScale3D);
    Instance.Skins = Skins;
    Instance.AmbientGlow = AmbientGlow;
    Instance.CullDistance = CullDistance;

    for (i = 0; i < Skins.Length; ++i)
    {
        Instance.Skins[i] = Skins[i];
    }

    Info.Obstacles[Index] = Instance;

    super.PostBeginPlay();
}

simulated function StaticMesh GetIntactStaticMesh() {return Info.GetIntactStaticMesh(TypeIndex, bIsDefault);}
simulated function StaticMesh GetClearedStaticMesh() {return Info.GetClearedStaticMesh(TypeIndex, Index, bIsDefault);}
simulated function bool CanBeCut() {return Info.CanBeCut(TypeIndex, bIsDefault);}
simulated function bool CanBeMantled() {return Info.CanBeMantled(TypeIndex, bIsDefault);}
simulated function bool CanBeCrushed() {return Info.CanBeCrushed(TypeIndex, bIsDefault);}
simulated function bool CanBeDestroyedByExplosives() {return Info.CanBeDestroyedByExplosives(TypeIndex, bIsDefault);}
simulated function bool CanBeDestroyedByWeapons() {return Info.CanBeDestroyedByWeapons(TypeIndex, bIsDefault);}
simulated function int GetExplosionDamageThreshold() {return Info.GetExplosionDamageThreshold(TypeIndex, bIsDefault);}
simulated function int GetDamageThreshold() {return Info.GetDamageThreshold(TypeIndex, bIsDefault);}
simulated function sound GetClearSound(out float SoundRadius) {return Info.GetClearSound(TypeIndex, bIsDefault, SoundRadius);}
simulated function float GetCutDuration() {return Info.GetCutDuration(TypeIndex, bIsDefault);}
simulated function class<Emitter> GetClearEmitterClass() {return Info.GetClearEmitterClass(TypeIndex, Index, bIsDefault);}

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
    TypeIndex=-1
    bDebug=false
    bNoDelete=false
    bHidden=true
    bHiddenEd=false
}

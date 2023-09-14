//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHObstacleInfo extends Info
    hidecategories(Object,Movement,Collision,Lighting,LightColor,Karma,Force,Events,Advanced,Sound)
    placeable;

struct Type
{
    var()   StaticMesh              IntactStaticMesh;
    var()   array<StaticMesh>       ClearedStaticMeshes;
    var()   sound                   ClearSound;
    var()   float                   ClearSoundRadius;
    var()   array<class<Emitter> >  ClearEmitterClasses;
    var()   bool                    bCanBeCut;
    var()   bool                    bCanBeMantled;
    var()   bool                    bCanBeCrushed;
    var()   bool                    bCanBeDestroyedByExplosives;
    var()   bool                    bCanBeDestroyedByWeapons;
    var()   int                     ExplosionDamageThreshold;
    var()   int                     DamageThreshold;
    var()   float                   CutDuration;
};

var()   array<Type>                 Types;

var     array<Type>                 DefaultTypes;

var     array<DHObstacleInstance>   Obstacles;

simulated function StaticMesh GetIntactStaticMesh(int Index, bool bIsDefault)
{
    if (bIsDefault)
    {
        return DefaultTypes[Index].IntactStaticMesh;
    }
    else
    {
        return Types[Index].IntactStaticMesh;
    }
}

simulated function StaticMesh GetClearedStaticMesh(int Index, int InstanceIndex, bool bIsDefault)
{
    if (bIsDefault)
    {
        if (DefaultTypes[Index].ClearedStaticMeshes.Length > 0)
        {
            return DefaultTypes[Index].ClearedStaticMeshes[InstanceIndex % DefaultTypes[Index].ClearedStaticMeshes.Length];
        }
    }
    else
    {
        if (Types[Index].ClearedStaticMeshes.Length > 0)
        {
            return Types[Index].ClearedStaticMeshes[InstanceIndex % Types[Index].ClearedStaticMeshes.Length];
        }
    }

    return none;
}

simulated function bool CanBeCut(int Index, bool bIsDefault)
{
    if (bIsDefault)
    {
        return DefaultTypes[Index].bCanBeCut;
    }
    else
    {
        return Types[Index].bCanBeCut;
    }
}

simulated function bool CanBeMantled(int Index, bool bIsDefault)
{
    if (bIsDefault)
    {
        return DefaultTypes[Index].bCanBeMantled;
    }
    else
    {
        return Types[Index].bCanBeMantled;
    }
}

simulated function bool CanBeCrushed(int Index, bool bIsDefault)
{
    if (bIsDefault)
    {
        return DefaultTypes[Index].bCanBeCrushed;
    }
    else
    {
        return Types[Index].bCanBeCrushed;
    }
}

simulated function bool CanBeDestroyedByExplosives(int Index, bool bIsDefault)
{
    if (bIsDefault)
    {
        return DefaultTypes[Index].bCanBeDestroyedByExplosives;
    }
    else
    {
        return Types[Index].bCanBeDestroyedByExplosives;
    }
}

simulated function bool CanBeDestroyedByWeapons(int Index, bool bIsDefault)
{
    if (bIsDefault)
    {
        return DefaultTypes[Index].bCanBeDestroyedByWeapons;
    }
    else
    {
        return Types[Index].bCanBeDestroyedByWeapons;
    }
}

simulated function int GetExplosionDamageThreshold(int Index, bool bIsDefault)
{
    if (bIsDefault)
    {
        return DefaultTypes[Index].ExplosionDamageThreshold;
    }
    else
    {
        return Types[Index].ExplosionDamageThreshold;
    }
}

simulated function int GetDamageThreshold(int Index, bool bIsDefault)
{
    if (bIsDefault)
    {
        return DefaultTypes[Index].DamageThreshold;
    }
    else
    {
        return Types[Index].DamageThreshold;
    }
}

simulated function sound GetClearSound(int Index, bool bIsDefault, out float ClearSoundRadius)
{
    if (bIsDefault)
    {
        if (DefaultTypes[Index].ClearSoundRadius == 0.0)
        {
            // NOTE: Sound radius was added after-the-fact, so we have to maintain backwards compatibility
            // by returning what the hard-coded value was (60.0)
            ClearSoundRadius = 60.0;
        }
        else
        {
            ClearSoundRadius = DefaultTypes[Index].ClearSoundRadius;
        }

        return DefaultTypes[Index].ClearSound;
    }
    else
    {
        if (Types[Index].ClearSoundRadius == 0.0)
        {
            ClearSoundRadius = 60.0;
        }
        else
        {
            ClearSoundRadius = DefaultTypes[Index].ClearSoundRadius;
        }

        return Types[Index].ClearSound;
    }
}

simulated function float GetCutDuration(int Index, bool bIsDefault)
{
    if (bIsDefault)
    {
        return DefaultTypes[Index].CutDuration;
    }
    else
    {
        return Types[Index].CutDuration;
    }
}

simulated function class<Emitter> GetClearEmitterClass(int Index, int InstanceIndex, bool bIsDefault)
{
    if (bIsDefault)
    {
        if (DefaultTypes[Index].ClearEmitterClasses.Length > 0)
        {
            return DefaultTypes[Index].ClearEmitterClasses[InstanceIndex % DefaultTypes[Index].ClearEmitterClasses.Length];
        }
    }
    else
    {
        if (Types[Index].ClearEmitterClasses.Length > 0)
        {
            return Types[Index].ClearEmitterClasses[InstanceIndex % Types[Index].ClearEmitterClasses.Length];
        }
    }

    return none;
}

defaultproperties
{
    DefaultTypes(0)=(IntactStaticMesh=StaticMesh'DH_Obstacles_stc.Barbed.fence_braced',ClearedStaticMeshes=(StaticMesh'DH_Obstacles_stc.Barbed.fence_braced_destroyed'),ClearSound=Sound'DH_Obstacles.Barbed.FenceBreaking',bCanBeCut=true,bCanBeCrushed=true,bCanBeDestroyedByExplosives=true,ExplosionDamageThreshold=300,CutDuration=7.0)
    DefaultTypes(1)=(IntactStaticMesh=StaticMesh'DH_Obstacles_stc.Barbed.fence_farm01',ClearedStaticMeshes=(StaticMesh'DH_Obstacles_stc.Barbed.fence_farm01_destroyed'),ClearSound=Sound'DH_Obstacles.Barbed.FenceBreaking',bCanBeCut=true,bCanBeCrushed=true,bCanBeDestroyedByExplosives=true,ExplosionDamageThreshold=300,CutDuration=3.0)
    DefaultTypes(2)=(IntactStaticMesh=StaticMesh'DH_Obstacles_stc.Barbed.fence_farm02',ClearedStaticMeshes=(StaticMesh'DH_Obstacles_stc.Barbed.fence_farm02_destroyed'),ClearSound=Sound'DH_Obstacles.Barbed.FenceBreaking',bCanBeCut=true,bCanBeCrushed=true,bCanBeDestroyedByExplosives=true,ExplosionDamageThreshold=300,CutDuration=3.0)
    DefaultTypes(3)=(IntactStaticMesh=StaticMesh'DH_Obstacles_stc.Barbed.fence_braced',ClearedStaticMeshes=(StaticMesh'DH_Obstacles_stc.Barbed.fence_braced_destroyed'),ClearSound=Sound'DH_Obstacles.Barbed.FenceBreaking',bCanBeCut=true,bCanBeCrushed=true,bCanBeDestroyedByExplosives=true,ExplosionDamageThreshold=300,CutDuration=7.0)
    DefaultTypes(4)=(IntactStaticMesh=StaticMesh'DH_Obstacles_stc.Barbed.fence_military',ClearedStaticMeshes=(StaticMesh'DH_Obstacles_stc.Barbed.fence_military_destroyed'),ClearSound=Sound'DH_Obstacles.Barbed.FenceBreaking',bCanBeCut=true,bCanBeCrushed=true,bCanBeDestroyedByExplosives=true,ExplosionDamageThreshold=300,CutDuration=5.0)
    DefaultTypes(5)=(IntactStaticMesh=StaticMesh'DH_Obstacles_stc.Barbed.fence_rabbit',ClearedStaticMeshes=(StaticMesh'DH_Obstacles_stc.Barbed.fence_rabbit_destroyed'),ClearSound=Sound'DH_Obstacles.Barbed.FenceBreaking',bCanBeCut=true,bCanBeCrushed=true,bCanBeDestroyedByExplosives=true,ExplosionDamageThreshold=300,CutDuration=6.0)
    DefaultTypes(6)=(IntactStaticMesh=StaticMesh'DH_Obstacles_stc.Wood.fence_rail2_12ft',ClearedStaticMeshes=(StaticMesh'DH_Obstacles_stc.Wood.fence_rail2_12ft_destroyed'),ClearSound=SoundGroup'DH_Obstacles.Wooden.Break',bCanBeMantled=true,bCanBeCrushed=true,bCanBeDestroyedByExplosives=true,ExplosionDamageThreshold=300)
    DefaultTypes(7)=(IntactStaticMesh=StaticMesh'DH_Obstacles_stc.Wood.fence_rail2_6ft',ClearedStaticMeshes=(StaticMesh'DH_Obstacles_stc.Wood.fence_rail2_6ft_destroyed'),ClearSound=SoundGroup'DH_Obstacles.Wooden.Break',bCanBeMantled=true,bCanBeCrushed=true,bCanBeDestroyedByExplosives=true,ExplosionDamageThreshold=300)
    DefaultTypes(8)=(IntactStaticMesh=StaticMesh'DH_Obstacles_stc.Wood.fence_rail4_12ft',ClearedStaticMeshes=(StaticMesh'DH_Obstacles_stc.Wood.fence_rail4_12ft_destroyed'),ClearSound=SoundGroup'DH_Obstacles.Wooden.Break',bCanBeMantled=true,bCanBeCrushed=true,bCanBeDestroyedByExplosives=true,ExplosionDamageThreshold=300)
    DefaultTypes(9)=(IntactStaticMesh=StaticMesh'DH_Obstacles_stc.Wood.fence_rail4_6ft',ClearedStaticMeshes=(StaticMesh'DH_Obstacles_stc.Wood.fence_rail4_6ft_destroyed'),ClearSound=SoundGroup'DH_Obstacles.Wooden.Break',bCanBeMantled=true,bCanBeCrushed=true,bCanBeDestroyedByExplosives=true,ExplosionDamageThreshold=300)
    DefaultTypes(10)=(IntactStaticMesh=StaticMesh'DH_Obstacles_stc.Wood.gate_rail',ClearedStaticMeshes=(StaticMesh'DH_Obstacles_stc.Wood.gate_rail_destroyed'),ClearSound=SoundGroup'DH_Obstacles.Wooden.Break',bCanBeMantled=true,bCanBeCrushed=true,bCanBeDestroyedByExplosives=true,ExplosionDamageThreshold=250)
    DefaultTypes(11)=(IntactStaticMesh=StaticMesh'DH_Obstacles_stc.Wood.PicketFence_intact',ClearedStaticMeshes=(StaticMesh'DH_Obstacles_stc.Wood.PicketFence_destr_01',StaticMesh'DH_Obstacles_stc.Wood.PicketFence_destr_02'),ClearSound=SoundGroup'DH_Obstacles.Wooden.Break',bCanBeMantled=true,bCanBeCrushed=true,bCanBeDestroyedByExplosives=true,ExplosionDamageThreshold=50)
    DefaultTypes(12)=(IntactStaticMesh=StaticMesh'DH_Obstacles_stc.Wood.PicketFence_intactw',ClearedStaticMeshes=(StaticMesh'DH_Obstacles_stc.Wood.PicketFence_destr_01w',StaticMesh'DH_Obstacles_stc.Wood.PicketFence_destr_02w'),ClearSound=SoundGroup'DH_Obstacles.Wooden.Break',bCanBeMantled=true,bCanBeCrushed=true,bCanBeDestroyedByExplosives=true,ExplosionDamageThreshold=50)

    Texture=Texture'DHEngine_Tex.ObstacleInfo'
    bStatic=true
}

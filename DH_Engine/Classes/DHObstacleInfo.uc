//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHObstacleInfo extends Info
    hidecategories(Object,Movement,Collision,Lighting,LightColor,Karma,Force,Events,Display,Advanced,Sound)
    placeable;

struct Type
{
    var()   StaticMesh              IntactStaticMesh;
    var()   array<StaticMesh>       ClearedStaticMeshes;
    var()   sound                   ClearSound;
    var()   array<class<Emitter> >  ClearEmitterClasses;
    var()   bool                    bCanBeClearedWithWireCutters;
};

var()   array<Type> Types;

defaultproperties
{
    bStatic=true
}

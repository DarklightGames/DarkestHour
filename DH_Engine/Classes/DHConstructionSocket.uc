//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// This is an actor that acts as snapping point for specific constructions.
// These are meant to be attached to other actors. For example, the foxhole
// construction may add one of these on either side of the "pit" so that
// a stationary machine-gun can be placed on it, overriding the usual rules
// that would disallow placement for other reasons.
//==============================================================================

class DHConstructionSocket extends DHActorProxySocket
    dependson(DHConstructionTypes);

var() array<DHConstructionTypes.SClassFilter> ClassFilters;
var() array<DHConstructionTypes.STagFilter> TagFilters;
var() int CollisionRadiusMax;

simulated function PostBeginPlay()
{   
    super.PostBeginPlay();

    Hide();
}

simulated function Show()
{
    bHidden = false;
    bBlockZeroExtentTraces = true;
}

simulated function Hide()
{
    bHidden = true;
    bBlockZeroExtentTraces = false;
}

simulated function bool IsForConstructionClass(DHActorProxy.Context Context, Class<DHConstruction> ConstructionClass)
{
    local int i;
    local bool bIncluded;
    local float MyCollisionRadius, MyCollisionHeight;

    if (ConstructionClass == none)
    {
        return false;
    }

    if (CollisionRadiusMax > 0.0)
    {
        ConstructionClass.static.GetCollisionSize(Context, MyCollisionRadius, MyCollisionHeight);

        if (MyCollisionRadius > CollisionRadiusMax)
        {
            return false;
        }
    }

    for (i = 0; i < ClassFilters.Length; ++i)
    {
        if (ConstructionClass == ClassFilters[i].Class ||
            ClassIsChildOf(ConstructionClass, ClassFilters[i].Class))
        {
            switch (ClassFilters[i].Operation)
            {
                case Include:
                    bIncluded = true;
                    break;
                case Exclude:
                    return false;
            }
        }
    }

    for (i = 0; i < TagFilters.Length; ++i)
    {
        if (ConstructionClass.static.HasConstructionTag(TagFilters[i].Tag))
        {
            switch (TagFilters[i].Operation)
            {
                case Include:
                    bIncluded = true;
                    break;
                case Exclude:
                    return false;
            }
        }
    }

    return bIncluded;
}

defaultproperties
{
    RemoteRole=ROLE_DumbProxy

    bCollideActors=true
	bCollideWorld=false
	bIgnoreEncroachers=true
	bProjTarget=true
	bBlockHitPointTraces=true

    CollisionRadius=16.0
    CollisionHeight=32.0
    bBlockNonZeroExtentTraces=true
    bBlockZeroExtentTraces=true
    bBlockProjectiles=false
    bBlockActors=false
    bBlockKarma=false

    bHidden=false
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_Misc.CONSTRUCTION_SOCKET'
}

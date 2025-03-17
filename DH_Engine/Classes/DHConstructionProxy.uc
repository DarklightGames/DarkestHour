//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstructionProxy extends DHActorProxy
    dependson(DHConstruction);

var class<DHConstruction>   ConstructionClass;

var int                     VariantIndex;       // The current selected variant index.
var int                     DefaultSkinIndex;   // The default skin index for the current variant.
var int                     SkinIndex;          // The current selected skin index. This is unbounded here, but modulo'd downstream.

var private DHConstruction.RuntimeData  RuntimeData;

function DHConstruction.RuntimeData GetRuntimeData()
{
    return RuntimeData;
}

function DHActorProxy.Context GetContext()
{
    local DHActorProxy.Context Context;

    Context = super.GetContext();
    
    // TODO: replace this with optional object?
    Context.VariantIndex = VariantIndex;
    Context.SkinIndex = DefaultSkinIndex + SkinIndex;

    return Context;
}

final function SetConstructionClass(class<DHConstruction> ConstructionClass)
{
    if (ConstructionClass == none)
    {
        Warn("Cannot set the construction class to none");
        return;
    }

    // Reset the variant and skin indices.
    VariantIndex = 0;
    SkinIndex = 0;

    self.ConstructionClass = ConstructionClass;

    UpdateDefaultSkinIndex();
    UpdateAppearance();

    // Initialize the local rotation based on the parameters in the new construction class
    LocalRotation = class'URotator'.static.RandomRange(ConstructionClass.default.StartRotationMin, ConstructionClass.default.StartRotationMax);
}

final function UpdateDefaultSkinIndex()
{
    DefaultSkinIndex = ConstructionClass.static.GetDefaultSkinIndexForVariant(GetContext(), VariantIndex);
}

final function CycleVariant()
{
    VariantIndex++;

    UpdateDefaultSkinIndex();
    UpdateAppearance();
}

final function CycleSkin()
{
    SkinIndex++;

    UpdateAppearance();
}

// TODO: Bit of a misnomer right now.
function UpdateProxyAppearance()
{
    if (ConstructionClass != none)
    {
        ConstructionClass.static.UpdateProxy(self);
    }

    RuntimeData = ConstructionClass.static.CreateProxyRuntimeData(self);
}

function GetCollisionSize(Context Context, out float OutRadius, out float OutHeight)
{
    if (ConstructionClass != none)
    {
        ConstructionClass.static.GetCollisionSize(Context, OutRadius, OutHeight);
    }
    else
    {
        super.GetCollisionSize(Context, OutRadius, OutHeight);
    }
}

// TODO: maybe create a context object? :think:
protected simulated function float GetGroundSlopeMaxDegrees()
{
    return ConstructionClass.default.GroundSlopeMaxInDegrees;
}

protected simulated function float GetArcLengthTraceIntervalMeters()
{
    return ConstructionClass.default.ArcLengthTraceIntervalInMeters;
}

protected simulated function float GetFloatToleranceMeters()
{
    return ConstructionClass.default.FloatToleranceInMeters;
}

protected simulated function bool CanOnlyPlaceOnTerrain()
{
    return ConstructionClass.default.bCanOnlyPlaceOnTerrain;
}
protected simulated function bool ShouldAlignToGround()
{
    return ConstructionClass.default.bShouldAlignToGround;
}

protected simulated function bool CanPlaceIndoors()
{
    return ConstructionClass.default.bCanPlaceIndoors;
}

protected simulated function bool ShouldSnapToTerrainVertex()
{
    return ConstructionClass.default.bSnapToTerrainVertex;
}

protected simulated function bool CanPlaceInDangerZone()
{
    return ConstructionClass.default.bCanBePlacedInDangerZone;
}

protected simulated function bool CanPlaceInMinefield()
{
    return false;
}

protected simulated function bool CanPlaceInObjective(DHObjective Objective)
{
    return ConstructionClass.default.bCanPlaceInObjective;
}

protected simulated function bool CanPlaceOnTerrainSurfaceType(Material.ESurfaceTypes SurfaceType)
{
    local int i;

    if (!ConstructionClass.default.bLimitTerrainSurfaceTypes)
    {
        return true;
    }

    // Search for the surface type in the allowed surface types array.
    for (i = 0; i < ConstructionClass.default.TerrainSurfaceTypes.Length; ++i)
    {
        if (SurfaceType == ConstructionClass.default.TerrainSurfaceTypes[i])
        {
            return true;
        }
    }
    
    return false;
}

protected simulated function Vector GetPlacementOffset()
{
    return ConstructionClass.static.GetPlacementOffset(GetContext());
}

protected simulated function bool CanPlaceOnTerrain(TerrainInfo TerrainInfo)
{
    if (TerrainInfo.TerrainScale.X > ConstructionClass.default.TerrainScaleMax ||
        TerrainInfo.TerrainScale.Y > ConstructionClass.default.TerrainScaleMax)
    {
        return false;
    }

    return true;
}

function ActorProxyError GetContextError(Context Context)
{
    local ActorProxyError Error;

    Error = super.GetContextError(Context);

    if (Error.Type != ERROR_None)
    {
        return Error;
    }

    return ConstructionClass.static.GetContextError(Context);
}

function ActorProxyError GetPositionError()
{
    local ActorProxyError E;
    local int i;
    local float Distance, DistanceMin, F;
    local int ObjectiveIndex;
    local DHGameReplicationInfo GRI;
    local DHRestrictionVolume RV;
    local Actor A;
    local bool bDidSatisfyProximityRequirement;
    local DHConstruction C;

    E = super.GetPositionError();

    if (E.Type != ERROR_None)
    {
        return E;
    }

    if (ConstructionClass == none)
    {
        E.Type = ERROR_Fatal;
        return E;
    }
    
    GRI = DHGameReplicationInfo(PlayerOwner.GameReplicationInfo);

    // TODO: Make the evaluation of these two errors dependent on the values
    // since we want the more restrictive check to be run first. For now, this
    // order will suffice.
    if (ConstructionClass.default.EnemyObjectiveDistanceMinMeters > 0.0)
    {
        // Don't allow this construction to be placed too close to an enemy-controlled objective.
        ObjectiveIndex = -1;
        DistanceMin = class'UFloat'.static.Infinity();

        for (i = 0; i < arraycount(GRI.DHObjectives); ++i)
        {
            if (GRI.DHObjectives[i] != none && PawnOwner.GetTeamNum() != int(GRI.DHObjectives[i].ObjState))
            {
                Distance = VSize(Location - GRI.DHObjectives[i].Location);

                if (Distance < class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.EnemyObjectiveDistanceMinMeters) &&
                    Distance < DistanceMin)
                {
                    DistanceMin = Distance;
                    ObjectiveIndex = i;
                }
            }
        }

        if (ObjectiveIndex != -1)
        {
            E.Type = ERROR_TooCloseToEnemyObjective;
            E.OptionalString = GRI.DHObjectives[ObjectiveIndex].ObjName;
            E.OptionalInteger = Max(1, ConstructionClass.default.EnemyObjectiveDistanceMinMeters - class'DHUnits'.static.UnrealToMeters(DistanceMin));
            return E;
        }
    }

    if (ConstructionClass.default.ObjectiveDistanceMinMeters > 0.0)
    {
        // Don't allow this construction to be placed too close to an objective.
        DistanceMin = class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.ObjectiveDistanceMinMeters);
        ObjectiveIndex = -1;

        for (i = 0; i < arraycount(GRI.DHObjectives); ++i)
        {
            if (GRI.DHObjectives[i] != none)
            {
                Distance = VSize(Location - GRI.DHObjectives[i].Location);

                if (Distance < DistanceMin)
                {
                    DistanceMin = Distance;
                    ObjectiveIndex = i;
                }
            }
        }

        if (ObjectiveIndex != -1)
        {
            E.Type = ERROR_TooCloseToObjective;
            E.OptionalString = GRI.DHObjectives[ObjectiveIndex].ObjName;
            E.OptionalInteger = Max(1, ConstructionClass.default.ObjectiveDistanceMinMeters - class'DHUnits'.static.UnrealToMeters(DistanceMin));
            return E;
        }
    }

        // Don't allow constructions to overlap restriction volumes that restrict constructions.
    foreach TouchingActors(class'DHRestrictionVolume', RV)
    {
        if (RV != none)
        {
            if (RV.bNoConstructions)
            {
                E.Type = ERROR_Restricted;
                return E;
            }
            else
            {
                for (i = 0; i < RV.ConstructionClasses.Length; ++i)
                {
                    if (ConstructionClass == RV.ConstructionClasses[i])
                    {
                        E.Type = ERROR_Restricted;
                        return E;
                    }
                }
            }
        }
    }

    // If a duplicate distance is specified, don't allow the construction to be
    // placed if is within the duplicate distance.
    if (ConstructionClass.default.DuplicateFriendlyDistanceInMeters > 0.0)
    {
        F = 0.0;

        foreach RadiusActors(ConstructionClass, A, class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.DuplicateFriendlyDistanceInMeters))
        {
            C = DHConstruction(A);

            if (C != none && !C.IsDummy() && (C.GetTeamIndex() == NEUTRAL_TEAM_INDEX || C.GetTeamIndex() == PawnOwner.GetTeamNum()))
            {
                F = FMax(F, ConstructionClass.default.DuplicateFriendlyDistanceInMeters - class'DHUnits'.static.UnrealToMeters(VSize(C.Location - Location)));
            }
        }

        if (F > 0.0)
        {
            E.Type = ERROR_TooCloseFriendly;
            E.OptionalInteger = int(Ceil(F));
            return E;
        }
    }

    if (ConstructionClass.default.DuplicateEnemyDistanceInMeters > 0.0)
    {
        F = 0.0;

        foreach RadiusActors(ConstructionClass, A, class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.DuplicateEnemyDistanceInMeters))
        {
            C = DHConstruction(A);

            if (C != none && !C.IsDummy() && C.GetTeamIndex() != NEUTRAL_TEAM_INDEX && C.GetTeamIndex() != PawnOwner.GetTeamNum())
            {
                F = FMax(F, ConstructionClass.default.DuplicateEnemyDistanceInMeters - class'DHUnits'.static.UnrealToMeters(VSize(C.Location - Location)));
            }
        }

        if (F > 0.0)
        {
            E.Type = ERROR_TooCloseEnemy;
            E.OptionalInteger = int(Ceil(F));
            return E;
        }
    }

    for (i = 0; i < ConstructionClass.default.ProximityRequirements.Length; ++i)
    {
        bDidSatisfyProximityRequirement = false;

        foreach RadiusActors(ConstructionClass.default.ProximityRequirements[i].ConstructionClass, A,
                             class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.ProximityRequirements[i].DistanceMeters))
        {
            C = DHConstruction(A);

            if (C != none && C.GetTeamIndex() == PawnOwner.GetTeamNum() && C.IsConstructed())
            {
                bDidSatisfyProximityRequirement = true;
                break;
            }
        }

        if (!bDidSatisfyProximityRequirement)
        {
            E.Type = ERROR_MissingRequirement;
            E.OptionalInteger = ConstructionClass.default.ProximityRequirements[i].DistanceMeters;
            E.OptionalString = ConstructionClass.default.ProximityRequirements[i].ConstructionClass.default.MenuName;
            return E;
        }
    }

    // We give the construction class an opportunity to return a class-specific error, if one is defined.
    E = ConstructionClass.static.GetCustomProxyError(self);

    return E;
}

function string GetMenuName()
{
    return GetRuntimeData().MenuName;
}

function string GetMenuVerb()
{
    if (ConstructionClass == none)
    {
        return super.GetMenuName();
    }


    return ConstructionClass.default.ConstructionVerb;
}

defaultproperties
{
    RemoteRole=ROLE_None
    DrawType=DT_StaticMesh
    bCollideActors=true
    bCollideWorld=false
    bBlockActors=false
    bAcceptsProjectors=false
}

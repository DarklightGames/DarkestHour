//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstructionProxy extends DHActorProxy
    dependson(DHConstruction);

var class<DHConstruction>   ConstructionClass;

var rotator                 Direction;
var Actor                   GroundActor;
var vector                  GroundNormal;

var DHConstruction.ConstructionError    ProxyError;

function DHActorProxy.Context GetContext()
{
    local DHActorProxy.Context Context;

    Context.TeamIndex = Instigator.GetTeamNum();
    Context.LevelInfo = class'DH_LevelInfo'.static.GetInstance(Level);
    Context.PlayerController = PlayerOwner;
    Context.GroundActor = GroundActor;

    return Context;
}

final function SetConstructionClass(class<DHConstruction> ConstructionClass)
{
    local DHConstruction.ConstructionError E;

    if (ConstructionClass == none)
    {
        Warn("Cannot set the construction class to none");
        return;
    }

    self.ConstructionClass = ConstructionClass;

    UpdateCollisionSize();
    DestroyAttachments();

    // Update ourselves using the function in the construction class
    ConstructionClass.static.UpdateProxy(self);

    // Initialize the local rotation based on the parameters in the new construction class
    LocalRotation = class'URotator'.static.RandomRange(ConstructionClass.default.StartRotationMin, ConstructionClass.default.StartRotationMax);

    // Set the error to none so that our material colors get initialized properly
    E.Type = ERROR_None;
    SetProxyError(E);
}

function UpdateCollisionSize()
{
    local float NewRadius, NewHeight;

    if (ConstructionClass != none)
    {
        // Determine the collision size to use given the current team and level info.
        ConstructionClass.static.GetCollisionSize(GetContext(), NewRadius, NewHeight);
    }

    SetCollisionSize(NewRadius, NewHeight);
}


function color GetProxyColor()
{
    switch (ProxyError.Type)
    {
        case ERROR_None:
            return class'UColor'.default.Green;
        case ERROR_Fatal:
        case ERROR_PlayerBusy:
            return class'UColor'.default.Black;
        default:
            return class'UColor'.default.Red;
    }
}

function SetProxyError(DHConstruction.ConstructionError NewProxyError)
{
    ProxyError = NewProxyError;

    if (Projector != none)
    {
        switch (ProxyError.Type)
        {
        case ERROR_None:
            Projector.ProjTexture = Projector.GreenTexture;
            break;
        default:
            Projector.ProjTexture = Projector.RedTexture;
            break;
        }
    }

    UpdateColor(GetProxyColor());
}

function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    UpdateError();
}

function UpdateError()
{
    local DHConstruction.ConstructionError ProvisionalPositionError, NewProxyError;

    // An error may be thrown when determining the location, so store it here.
    ProvisionalPositionError = GetProvisionalPosition();
    NewProxyError = ConstructionClass.static.GetPlayerError(GetContext());

    if (NewProxyError.Type == ERROR_None)
    {
        NewProxyError = GetPositionError();
    }

    if (NewProxyError.Type == ERROR_None)
    {
        // All other checks passed, set new proxy error to be the provisional
        // position error. The order is important so that we prioritize
        // other more critical errors rather than minor errors like "not enough
        // room" etc.
        NewProxyError = ProvisionalPositionError;
    }

    if (ProxyError != NewProxyError)
    {
        SetProxyError(NewProxyError);
    }

    // This should happen every tick regardless.
    UpdateProjector();
}

// This function gets the provisional location and rotation of the construction.

// TODO: this function could simply be the function that *alters* the original position, and there could be.
function DHConstruction.ConstructionError GetProvisionalPosition()
{
    local vector TraceStart, TraceEnd, HitLocation, HitNormal, OtherHitNormal, Forward, Left, X, Y, Z, HitNormalAverage, BaseLocation;
    local rotator R;
    local float GroundSlopeDegrees, AngleRadians, CircumferenceInMeters;
    local DHConstruction.ConstructionError E;
    local int i, ArcLengthTraceCount;
    local TerrainInfo TI;
    local Material HitMaterial;
    local bool bIsTerrainSurfaceTypeAllowed;
    local DHGameReplicationInfo GRI;
    local Actor HitActor;

    GRI = DHGameReplicationInfo(Level.GetLocalPlayerController().GameReplicationInfo);

    if (ConstructionClass == none || GRI == none)
    {
        E.Type = ERROR_Fatal;
        return E;
    }

    if (GroundActor == none)
    {
        // Didn't hit anything!
        E.Type = ERROR_NoGround;
        BaseLocation = Location;
        R = Direction;
        R.Pitch = 0;
        R.Roll = 0;
        Forward = vector(R);
    }
    else
    {
        BaseLocation = Location;

        if (ConstructionClass.default.bCanOnlyPlaceOnTerrain && !GroundActor.IsA('TerrainInfo'))
        {
            E.Type = ERROR_NotOnTerrain;
        }

        HitNormal = GroundNormal;

        // Terrain alignment steps.
        // Get the terrain info that's hit
        if (ConstructionClass.default.bSnapToTerrain && GroundActor.IsA('TerrainInfo'))
        {
            TI = TerrainInfo(GroundActor);

            // Transform location into the terrain's local space.
            BaseLocation -= TI.Location;

            // Snap X and Y to nearest vertex.
            BaseLocation.X = Round(BaseLocation.X / TI.TerrainScale.X) * TI.TerrainScale.X;
            BaseLocation.Y = Round(BaseLocation.Y / TI.TerrainScale.Y) * TI.TerrainScale.Y;

            // Transform location back to world-space.
            BaseLocation += TI.Location;

            // Trace down to get the height at this vertex (no other way to query the height!)
            TraceStart = BaseLocation;
            TraceStart.Z += 100.0;    // TODO: Magic number used for now, in future find out the maximum terrain z-height programmatically.

            TraceEnd = BaseLocation;
            TraceEnd.Z -= 100.0;

            // An explanation is in order. For some reason, this trace can fail
            // for no discernible reason. I can only assume this it's some sort
            // floating point limitation or perhaps a bug in the engine.
            // This can be remedied by making this an extents trace, but then
            // the hit location is not actually going to be at the same location
            // as the vertex we are trying to align to, which in turn can create
            // problems with the super unreliable terrain poking functionality.
            // To keep things as reliable as possible, we disallow placement
            // if this trace fails and report it as "ground too hard".
            TI = TerrainInfo(Trace(HitLocation, HitNormal, TraceEnd, TraceStart, false,, HitMaterial));

            if (TI != none)
            {
                if (TI.TerrainScale.X > ConstructionClass.default.TerrainScaleMax ||
                    TI.TerrainScale.Y > ConstructionClass.default.TerrainScaleMax)
                {
                    E.Type = ERROR_GroundTooHard;
                }

                BaseLocation = HitLocation;

                if (ConstructionClass.default.bLimitTerrainSurfaceTypes)
                {
                    // Search for the surface type in the allowed surface types array.
                    for (i = 0; i < ConstructionClass.default.TerrainSurfaceTypes.Length; ++i)
                    {
                        if (HitMaterial.SurfaceType == ConstructionClass.default.TerrainSurfaceTypes[i])
                        {
                            bIsTerrainSurfaceTypeAllowed = true;
                            break;
                        }
                    }

                    if (!bIsTerrainSurfaceTypeAllowed)
                    {
                        // Surface type is not allowed.
                        E.Type = ERROR_BadSurface;
                    }
                }
            }
            else
            {
                E.Type = ERROR_GroundTooHard;
            }
        }

        if (!ConstructionClass.default.bShouldAlignToGround)
        {
            // Not aligning to ground, just use world up vector as the hit normal.
            HitNormal = vect(0, 0, 1);
        }

        Forward = Normal(vector(Direction));
        Left = Forward cross HitNormal;
        Forward = HitNormal cross Left;

        // Hit something static in the world.
        GroundSlopeDegrees = class'UUnits'.static.RadiansToDegrees(Acos(HitNormal dot vect(0, 0, 1)));

        if (E.Type == ERROR_None && GroundSlopeDegrees >= ConstructionClass.default.GroundSlopeMaxInDegrees)
        {
            // Too steep!
            E.Type = ERROR_TooSteep;
        }

        if (E.Type == ERROR_None)
        {
            GetAxes(rotator(Forward), X, Y, Z);

            CircumferenceInMeters = class'DHUnits'.static.UnrealToMeters(CollisionRadius * Pi * 2);
            ArcLengthTraceCount = (CircumferenceInMeters / ConstructionClass.default.ArcLengthTraceIntervalInMeters) / 2;

            // For safety's sake, make sure we don't overdo or underdo it.
            ArcLengthTraceCount = Clamp(ArcLengthTraceCount, 8, 64);

            for (i = 0; i < ArcLengthTraceCount; ++i)
            {
                AngleRadians = (float(i) / ArcLengthTraceCount) * Pi;

                TraceStart = vect(0, 0, 0);
                TraceStart.Z = CollisionHeight;
                TraceEnd = TraceStart;
                TraceEnd.X = Sin(AngleRadians) * CollisionRadius;
                TraceEnd.Y = Cos(AngleRadians) * CollisionRadius;
                TraceStart.X = -TraceEnd.X;
                TraceStart.Y = -TraceEnd.Y;

                TraceStart = BaseLocation + QuatRotateVector(QuatFromRotator(rotator(X)), TraceStart);
                TraceEnd = BaseLocation + QuatRotateVector(QuatFromRotator(rotator(X)), TraceEnd);

                // Trace across the diameter of the collision cylinder
                HitActor = Trace(HitLocation, OtherHitNormal, TraceEnd, TraceStart, true);

                if (HitActor != none && !HitActor.IsA('ROBulletWhipAttachment') && !HitActor.IsA('Volume'))
                {
                    E.Type = ERROR_NoRoom;
                    break;
                }

                // Trace down from the top of the cylinder to the bottom
                TraceEnd = TraceStart - (Z * (CollisionHeight + class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.FloatToleranceInMeters)));

                HitActor = Trace(HitLocation, OtherHitNormal, TraceEnd, TraceStart, false);

                if (HitActor == none)
                {
                    E.Type = ERROR_NoGround;
                    break;
                }
                else
                {
                    if (ConstructionClass.default.bCanOnlyPlaceOnTerrain && !HitActor.IsA('TerrainInfo'))
                    {
                        E.Type = ERROR_NotOnTerrain;
                        break;
                    }

                    HitNormalAverage += OtherHitNormal;
                }
            }
        }

        if (E.Type == ERROR_None)
        {
            HitNormalAverage.X /= ArcLengthTraceCount;
            HitNormalAverage.Y /= ArcLengthTraceCount;
            HitNormalAverage.Z /= ArcLengthTraceCount;
        }
        else
        {
            HitNormalAverage = vect(0, 0, 1);
        }

        // Now check the groundslope again.
        GroundSlopeDegrees = class'UUnits'.static.RadiansToDegrees(Acos(HitNormalAverage dot vect(0, 0, 1)));

        if (E.Type == ERROR_None && GroundSlopeDegrees >= ConstructionClass.default.GroundSlopeMaxInDegrees)
        {
            // Too steep!
            E.Type = ERROR_TooSteep;
        }

        // If we're aligning to terrain, set HitNormal to the HtNormalAverage
        // calculated from the circumfrencial traces.
        if (ConstructionClass.default.bShouldAlignToGround)
        {
            HitNormal = HitNormalAverage;
        }

        Forward = Normal(vector(Direction));
        Left = Forward cross HitNormal;
        Forward = HitNormal cross Left;
    }

    SetLocation(BaseLocation + (ConstructionClass.static.GetPlacementOffset(GetContext()) << rotator(Forward)));
    SetRotation(QuatToRotator(QuatProduct(QuatFromRotator(LocalRotation), QuatFromRotator(rotator(Forward)))));

    return E;
}

// We separate this function from GetProvisionalPosition because we need to have
// the server do it's own check before attempting to spawn the construction.
function DHConstruction.ConstructionError GetPositionError()
{
    local DHRestrictionVolume RV;
    local Actor A;
    local DHConstruction C;
    local Actor TouchingActor;
    local ROMineVolume MV;
    local DHSpawnPointBase SP;
    local DHLocationHint LH;
    local float OtherRadius, OtherHeight, F, DistanceMin, Distance, SquareLength;
    local DHGameReplicationInfo GRI;
    local int i, ObjectiveIndex;
    local DHConstruction.ConstructionError E;
    local vector TraceStart, TraceEnd, CeilingHitLocation, CeilingHitNormal;
    local Actor HitActor;
    local DHConstructionProxy CP;
    local bool bDidSatisfyProximityRequirement;

    GRI = DHGameReplicationInfo(PlayerOwner.GameReplicationInfo);

    if (Level.NetMode != NM_DedicatedServer && !bHidden)
    {
        foreach TouchingActors(class'DHConstructionProxy', CP)
        {
            if (CP != none && !CP.bHidden && CP != self)
            {
                E.Type = ERROR_NoRoom;
                return E;
            }
        }
    }

    // Don't allow the construction to be placed in water if this is disallowed.
    if (!ConstructionClass.default.bCanPlaceInWater && PhysicsVolume != none && PhysicsVolume.bWaterVolume)
    {
        E.Type = ERROR_InWater;
        return E;
    }

    if (!ConstructionClass.default.bCanBePlacedInDangerZone)
    {
        if (class'DHDangerZone'.static.IsIn(GRI, Location.X, Location.Y, Instigator.GetTeamNum()))
        {
            E.Type = ERROR_InDangerZone;
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

    // Don't allow constructions in active minefields.
    foreach TouchingActors(class'ROMineVolume', MV)
    {
        if (MV != none &&
            MV.bActive &&
            (MV.MineKillStyle == KS_All ||
             (PawnOwner.GetTeamNum() == AXIS_TEAM_INDEX && MV.MineKillStyle == KS_Axis) ||
             (PawnOwner.GetTeamNum() == ALLIES_TEAM_INDEX && MV.MineKillStyle == KS_Allies)))
        {
            E.Type = ERROR_InMinefield;
            return E;
        }
    }

    // Don't allow construction to be placed in objectives if this is disallowed.
    if (!ConstructionClass.default.bCanPlaceInObjective)
    {
        for (i = 0; i < arraycount(GRI.DHObjectives); ++i)
        {
            if (GRI.DHObjectives[i] != none && GRI.DHObjectives[i].WithinArea(self))
            {
                E.Type = ERROR_InObjective;
                return E;
            }
        }
    }

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

    // Don't allow the construction to touch blocking actors.
    foreach TouchingActors(class'Actor', TouchingActor)
    {
        if (TouchingActor != none && TouchingActor.bBlockActors)
        {
            E.Type = ERROR_NoRoom;
            return E;
        }
    }


    if (!ConstructionClass.default.bCanPlaceIndoors)
    {
        // Knowing whether or not we are "indoors" is somewhat subjective,
        // therefore, any attempt to systemize will not be 100% correct to all
        // people all the time.
        //
        // The primary reason for classifying constructions as being unable to
        // be built inside is to stop players from blocking tight entrances and
        // walkways (eg. stairs, hallways, doors etc.)
        //
        // Most of these tight spaces are inside of buildings, where BSP and
        // static meshes are likely to be on the floor. It's also true that most
        // of these spaces have a fairly low roof. Therefore, we hit on the
        // following solution.
        //
        // A construction is deemed "inside" if both of these are true:
        // 1. The floor below it is BSP or static mesh.
        // 2. The space above it is obstructed with static geometry.
        //
        // This will work perfectly fine for the vast majority of cases. Some
        // cases where this logic could produce incorrect results include:
        // 1. On a bridge with low metal girders. [FALSE POSITIVE]
        // 2. On the top floor of a house with no roof. [FALSE NEGATIVE]
        // 3. In a garage where the floor is terrain. [FALSE NEGATIVE]
        //
        // We are more concerned with reducing false negatives (allowing
        // placement when it would be detrimental to gameplay) than eliminating
        // false positives, so a DHRestrictionVolume can be used by levelers to
        // plug any holes left open by the programmatic logic.
        if (GroundActor != none && GroundActor.bStatic && !GroundActor.IsA('TerrainInfo'))
        {
            // Determine the size of the extents trace (a square that is
            // inscribed inside a circle with the collision radius).
            SquareLength = Sin(Pi / 4) * CollisionRadius;

            // Do an extents trace upwards to determine if there is a ceiling
            // above us. We start the trace slightly higher than the ground
            // because uneven terrain tends to produce false positives.
            TraceStart = Location + (vect(0, 0, 1) * ConstructionClass.default.CollisionHeight / 2);
            TraceEnd = Location + (vect(0, 0, 1) * class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.IndoorsCeilingHeightInMeters));
            HitActor = Trace(CeilingHitLocation, CeilingHitNormal, TraceEnd, TraceStart,, vect(1.0, 1.0, 0.0) * SquareLength);

            if (HitActor != none)
            {
                E.Type = ERROR_Indoors;
                return E;
            }
        }
    }

    // Don't allow constructions within 2 meters of spawn points or location hints.
    foreach RadiusActors(class'DHSpawnPointBase', SP, CollisionRadius + class'DHUnits'.static.MetersToUnreal(2.0))
    {
        E.Type = ERROR_NearSpawnPoint;
        return E;
    }

    foreach RadiusActors(class'DHLocationHint', LH, CollisionRadius + class'DHUnits'.static.MetersToUnreal(2.0))
    {
        E.Type = ERROR_NearSpawnPoint;
        return E;
    }

    // Don't allow constructions to have overlapping collision radii.
    // NOTE: We are using a 25 meter radius here just to include the largest
    // likely combined radius. Using AllActors would be incredibly slow, and
    // keeping a separate list of constructions via replication or some other
    // mechanism would probably be a bad idea.
    foreach CollidingActors(class'DHConstruction', C, class'DHUnits'.static.MetersToUnreal(25.0))
    {
        C.GetCollisionSize(C.GetContext(), OtherRadius, OtherHeight);

        if (VSize(Location - C.Location) < CollisionRadius + OtherRadius)
        {
            E.Type = ERROR_NoRoom;
            return E;
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

            if (C != none && !C.IsInState('Dummy') && (C.GetTeamIndex() == NEUTRAL_TEAM_INDEX || C.GetTeamIndex() == PawnOwner.GetTeamNum()))
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

            if (C != none && !C.IsInState('Dummy') && C.GetTeamIndex() != NEUTRAL_TEAM_INDEX && C.GetTeamIndex() != PawnOwner.GetTeamNum())
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

function UpdateParameters(vector Location, rotator Direction, Actor GroundActor, vector GroundNormal)
{
    self.Direction = Direction;

    SetLocation(Location);

    self.GroundNormal = GroundNormal;

    if (self.GroundActor != GroundActor)
    {
        self.GroundActor = GroundActor;

        // Ground actor changed so let's re-evaluate our collison size.
        // TODO: we may want to do more than just re-evaluate the collision size
        // in the future, so moving `UpdateCollisionSize` to `UpdateProxy` and
        // calling `UpdateProxy` might be a more appropriate route.
        UpdateCollisionSize();
    }

    UpdateError();
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


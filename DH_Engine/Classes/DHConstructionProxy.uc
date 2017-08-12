//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstructionProxy extends Actor
    dependson(DHConstruction);

var class<DHConstruction>   ConstructionClass;

var DHConstruction.EConstructionError   ProxyError;

var DHPawn                  PawnOwner;
var DHPlayer                PlayerOwner;

// Rotation
var rotator                 LocalRotation;
var rotator                 LocalRotationRate;

// Projector
var DHConstructionProxyProjector            Projector;

// Attachments
var array<DHConstructionProxyAttachment>    Attachments;

function PostBeginPlay()
{
    super.PostBeginPlay();

    PawnOwner = DHPawn(Owner);

    if (PawnOwner == none)
    {
        return;
    }

    PlayerOwner = DHPlayer(PawnOwner.Controller);

    if (PlayerOwner == none)
    {
        Destroy();
    }

    Projector = Spawn(class'DHConstructionProxyProjector', self);

    if (Projector != none)
    {
        Projector.SetBase(self);
    }
}

event Destroyed()
{
    super.Destroyed();

    if (Projector != none)
    {
        Projector.Destroy();
    }

    DestroyAttachments();
}

function DestroyAttachments()
{
    local int i;

    for (i = 0; i < Attachments.Length; ++i)
    {
        Attachments[i].Destroy();
    }

    Attachments.Length = 0;
}

final function SetConstructionClass(class<DHConstruction> ConstructionClass)
{
    local float NewRadius;
    local float NewHeight;

    if (ConstructionClass == none)
    {
        Warn("Cannot set the construction class to none");
        return;
    }

    self.ConstructionClass = ConstructionClass;

    // Determine the collision size to use given the current team and level info.
    ConstructionClass.static.GetCollisionSize(PlayerOwner.GetTeamNum(), PlayerOwner.ClientLevelInfo, NewRadius, NewHeight);
    SetCollisionSize(NewRadius, NewHeight);

    DestroyAttachments();

    // Update ourselves using the function in the construction class
    ConstructionClass.static.UpdateProxy(self);

    // Initialize the local rotation based on the parameters in the new construction class
    LocalRotation = class'URotator'.static.RandomRange(ConstructionClass.default.StartRotationMin, ConstructionClass.default.StartRotationMax);

    // Set the error to none so that our material colors get initialized properly
    SetProxyError(ERROR_None);
}

function static Material CreateProxyMaterial(Material M)
{
    local Combiner C;
    local FadeColor FC;
    local FinalBlend FB;

    FC = new class'FadeColor';
    FC.Color1 = class'UColor'.default.White;
    FC.Color1.A = 64;
    FC.Color2 = class'UColor'.default.White;
    FC.Color2.A = 128;
    FC.FadePeriod = 0.25;
    FC.ColorFadeType = FC_Sinusoidal;

    C = new class'Combiner';
    C.CombineOperation = CO_Multiply;
    C.AlphaOperation = AO_Multiply;
    C.Material1 = M;
    C.Material2 = FC;
    C.Modulate4X = true;

    FB = new class'FinalBlend';
    FB.FrameBufferBlending = FB_AlphaBlend;
    FB.ZWrite = true;
    FB.ZTest = true;
    FB.AlphaTest = true;
    FB.TwoSided = true;
    FB.Material = C;

    return FB;
}

function static UpdateProxyMaterialColors(Actor A, color Color)
{
    local FinalBlend FB;
    local Combiner C;
    local FadeColor FC;
    local int i;

    for (i = 0; i < A.Skins.Length; ++i)
    {
        FB = FinalBlend(A.Skins[i]);

        if (FB != none)
        {
            C = Combiner(FB.Material);

            if (C != none)
            {
                FC = FadeColor(C.Material2);

                if (FC != none)
                {
                    FC.Color1 = Color;
                    FC.Color1.A = 64;

                    FC.Color2 = Color;
                    FC.Color2.A = 128;
                }
            }
        }
    }
}

function SetProxyError(DHConstruction.EConstructionError NewProxyError)
{
    local int i;
    local color ProxyColor;

    ProxyError = NewProxyError;

    if (Projector != none)
    {
        switch (ProxyError)
        {
        case ERROR_None:
            Projector.ProjTexture = Projector.GreenTexture;
            break;
        default:
            Projector.ProjTexture = Projector.RedTexture;
            break;
        }
    }

    ProxyColor = GetProxyErrorColor(ProxyError);

    UpdateProxyMaterialColors(self, ProxyColor);

    for (i = 0; i < Attachments.Length; ++i)
    {
        if (Attachments[i] != none)
        {
            UpdateProxyMaterialColors(Attachments[i], ProxyColor);
        }
    }
}

function static color GetProxyErrorColor(DHConstruction.EConstructionError ProxyError)
{
    switch (ProxyError)
    {
        case ERROR_None:
            return class'UColor'.default.Green;
        default:
            return class'UColor'.default.Red;
    }
}

function Tick(float DeltaTime)
{
    local vector L, RL;
    local rotator R;
    local DHConstruction.EConstructionError ProvisionalPositionError, NewProxyError;

    super.Tick(DeltaTime);

    if (PawnOwner == none || PawnOwner.Health == 0 || PawnOwner.bDeleteMe || PawnOwner.Controller == none)
    {
        Destroy();
    }

    LocalRotation += (LocalRotationRate * DeltaTime);

    // TODO: Combine getprovisionallocation and getpositionerror into one
    // function able to be run on the client and the server independently!

    // An error may be thrown when determining the location, so store it here.
    ProvisionalPositionError = GetProvisionalPosition(L, R);

    // Set the location
    SetLocation(L);
    SetRotation(R);

    NewProxyError = ConstructionClass.static.GetPlayerError(PlayerOwner);

    if (NewProxyError == ERROR_None)
    {
        NewProxyError = GetPositionError();
    }

    if (NewProxyError == ERROR_None)
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

    // NOTE: The relative location and rotation needs to be set every tick.
    // Without it, the projector seems to "drift" away from the object it's
    // attached to. This is probably due to some sort of cumulative floating
    // point errors.
    RL.Z = ConstructionClass.default.CollisionHeight;

    if (Projector != none)
    {
        Projector.MaxTraceDistance = CollisionHeight * 2;
        Projector.SetDrawScale((CollisionRadius * 2) / Projector.ProjTexture.MaterialUSize());
        Projector.SetRelativeLocation(RL);
        Projector.SetRelativeRotation(rot(-16384, 0, 0));
    }
}

// This function gets the provisional location and rotation of the construction.
function DHConstruction.EConstructionError GetProvisionalPosition(out vector OutLocation, out rotator OutRotation)
{
    local vector TraceStart, TraceEnd, HitLocation, HitNormal, Left, Forward, X, Y, Z, HitNormalSum, BaseLocation, CeilingHitLocation, CeilingHitNormal;
    local Actor TempHitActor, HitActor;
    local rotator R;
    local float GroundSlopeDegrees, AngleRadians, SquareLength;
    local DHConstruction.EConstructionError Error;
    local int i;
    local TerrainInfo TI;
    local Material HitMaterial;
    local bool bIsTerrainSurfaceTypeAllowed;

    if (PawnOwner == none || PlayerOwner == none || ConstructionClass == none)
    {
        return ERROR_Fatal;
    }

    // Trace out into the world and try and hit something static.
    TraceStart = PawnOwner.Location + PawnOwner.EyePosition();
    TraceEnd = TraceStart + (vector(PlayerOwner.CalcViewRotation) * class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.ProxyDistanceInMeters));

    foreach TraceActors(class'Actor', TempHitActor, HitLocation, HitNormal, TraceEnd, TraceStart)
    {
        if (TempHitActor.bStatic && !TempHitActor.IsA('ROBulletWhipAttachment') && !TempHitActor.IsA('Volume'))
        {
            HitActor = TempHitActor;
            break;
        }
    }

    if (HitActor == none)
    {
        // We didn't hit anything, trace down to the ground in hopes of finding
        // something solid to rest on
        TraceStart = TraceEnd;
        TraceEnd = TraceStart + vect(0, 0, -1) * class'DHUnits'.static.MetersToUnreal(2.0); // TODO: get rid of magic number

        foreach TraceActors(class'Actor', TempHitActor, HitLocation, HitNormal, TraceEnd, TraceStart)
        {
            if (TempHitActor.bStatic && !TempHitActor.IsA('ROBulletWhipAttachment') && !TempHitActor.IsA('Volume'))
            {
                HitActor = TempHitActor;
                break;
            }
        }
    }

    if (HitActor == none)
    {
        // Didn't hit anything!
        Error = ERROR_NoGround;
        // TODO: verify correctness
        BaseLocation = TraceStart;
        R = PlayerOwner.CalcViewRotation;
        R.Pitch = 0;
        R.Roll = 0;
        Forward = vector(R);
    }
    else
    {
        BaseLocation = HitLocation;

        if (ConstructionClass.default.bCanOnlyPlaceOnTerrain && !HitActor.IsA('TerrainInfo'))
        {
            Error = ERROR_NotOnTerrain;
        }

        // Terrain alignment steps.
        // Get the terrain info that's hit
        if (ConstructionClass.default.bSnapToTerrain && HitActor.IsA('TerrainInfo'))
        {
            TI = TerrainInfo(HitActor);

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
                    Error = ERROR_GroundTooHard;
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
                        Error = ERROR_BadSurface;
                    }
                }
            }
            else
            {
                Error = ERROR_GroundTooHard;
            }
        }

        if (!ConstructionClass.default.bShouldAlignToGround)
        {
            // Not aligning to ground, just use world up vector as the hit normal.
            HitNormal = vect(0, 0, 1);
        }

        Forward = Normal(vector(PlayerOwner.CalcViewRotation));
        Left = Forward cross HitNormal;
        Forward = HitNormal cross Left;

        // Hit something static in the world.
        GroundSlopeDegrees = class'UUnits'.static.RadiansToDegrees(Acos(HitNormal dot vect(0, 0, 1)));

        if (Error == ERROR_None && GroundSlopeDegrees >= ConstructionClass.default.GroundSlopeMaxInDegrees)
        {
            // Too steep!
            Error = ERROR_TooSteep;
        }

        if (Error == ERROR_None)
        {
            // TODO: enable or disable this check
            GetAxes(rotator(Forward), X, Y, Z);

            const TRACE_RESOLUTION = 8;

            for (i = 0; i < TRACE_RESOLUTION; ++i)
            {
                AngleRadians = (float(i) / TRACE_RESOLUTION) * Pi;

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
                HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true);

                if (HitActor != none && !HitActor.IsA('ROBulletWhipAttachment') && !HitActor.IsA('Volume'))
                {
                    Error = ERROR_NoRoom;
                    break;
                }

                // Trace down from the top of the cylinder to the bottom
                TraceEnd = TraceStart - (Z * (CollisionHeight + class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.FloatToleranceInMeters)));

                HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, false);

                if (HitActor == none)
                {
                    Error = ERROR_NoGround;
                    break;
                }
                else
                {
                    HitNormalSum += HitNormal;
                }
            }
        }

        if (Error == ERROR_None)
        {
            HitNormalSum.X /= TRACE_RESOLUTION;
            HitNormalSum.Y /= TRACE_RESOLUTION;
            HitNormalSum.Z /= TRACE_RESOLUTION;
        }
        else
        {
            HitNormalSum = vect(0, 0, 1);
        }

        // Now check the groundslope again.
        GroundSlopeDegrees = class'UUnits'.static.RadiansToDegrees(Acos(HitNormalSum dot vect(0, 0, 1)));

        if (Error == ERROR_None && GroundSlopeDegrees >= ConstructionClass.default.GroundSlopeMaxInDegrees)
        {
            // Too steep!
            Error = ERROR_TooSteep;
        }

        if (ConstructionClass.default.bInheritsOwnerRotation)
        {
            Forward = Normal(vector(PlayerOwner.CalcViewRotation));
            Left = Forward cross HitNormalSum;
            Forward = HitNormalSum cross Left;
        }
        else
        {
            Forward = vect(1, 0, 0);
        }
    }

    OutLocation = BaseLocation + (ConstructionClass.static.GetPlacementOffset() << rotator(Forward));
    OutRotation = QuatToRotator(QuatProduct(QuatFromRotator(LocalRotation), QuatFromRotator(rotator(Forward))));

    if (Error == ERROR_None && !ConstructionClass.default.bCanPlaceIndoors)
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
        if (HitActor != none && HitActor.bStatic && !HitActor.IsA('TerrainInfo'))
        {
            // Determine the size of the extents trace (a square that is
            // inscribed inside a circle with the collision radius).
            SquareLength = Sin(Pi / 4) * CollisionRadius;

            // Do an extents trace upwards to determine if there is a ceiling
            // above us.
            // TODO: will the extents trace hit the ground if it's uneven?
            TraceStart = OutLocation;
            TraceEnd = TraceStart + ((vect(0, 0, 1) * class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.IndoorsCeilingHeightInMeters)) << rotator(Forward));

            if (Trace(CeilingHitLocation, CeilingHitNormal, TraceEnd, TraceStart,, vect(1.0, 1.0, 0.0) * SquareLength) != none)
            {
                Error = ERROR_Indoors;
            }
        }
    }

    return Error;
}

// We separate this function from GetProvisionalPosition because we need to have
// the server do it's own check before attempting to spawn the construction.
function DHConstruction.EConstructionError GetPositionError()
{
    local DHRestrictionVolume RV;
    local Actor A;
    local DHConstruction C;
    local Actor TouchingActor;
    local ROMineVolume MV;
    local DHSpawnPointBase SP;
    local DHLocationHint LH;
    local float OtherRadius, OtherHeight;
    local DHGameReplicationInfo GRI;
    local int i;

    GRI = DHGameReplicationInfo(PlayerOwner.GameReplicationInfo);

    // Don't allow the construction to be placed in water if this is disallowed.
    if (!ConstructionClass.default.bCanPlaceInWater && PhysicsVolume != none && PhysicsVolume.bWaterVolume)
    {
        return ERROR_InWater;
    }

    // Don't allow constructions to overlap restriction volumes that restrict constructions.
    foreach TouchingActors(class'DHRestrictionVolume', RV)
    {
        if (RV != none && RV.bNoConstructions)
        {
            return ERROR_Restricted;
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
            return ERROR_InMinefield;
        }
    }

    // Don't allow the construction to touch blocking actors.
    foreach TouchingActors(class'Actor', TouchingActor)
    {
        if (TouchingActor != none && TouchingActor.bBlockActors)
        {
            return ERROR_NoRoom;
        }
    }

    // Don't allow construction to be placed in objectives if this is disallowed.
    if (!ConstructionClass.default.bCanPlaceInObjective)
    {
        for (i = 0; i < arraycount(GRI.DHObjectives); ++i)
        {
            if (GRI.DHObjectives[i] != none && GRI.DHObjectives[i].WithinArea(self))
            {
                return ERROR_InObjective;
            }
        }
    }

    // Don't allow constructions within 2 meters of spawn points or location hints.
    foreach RadiusActors(class'DHSpawnPointBase', SP, CollisionRadius + class'DHUnits'.static.MetersToUnreal(2.0))
    {
        return ERROR_NearSpawnPoint;
    }

    foreach RadiusActors(class'DHLocationHint', LH, CollisionRadius + class'DHUnits'.static.MetersToUnreal(2.0))
    {
        return ERROR_NearSpawnPoint;
    }

    // Don't allow constructions to have overlapping collision radii.
    // NOTE: We are using a 25 meter radius here just to include the largest
    // likely combined radius. Using AllActors would be incredibly slow, and
    // keeping a separate list of constructions via replication or some other
    // mechanism would probably be a bad idea.
    foreach CollidingActors(class'DHConstruction', C, class'DHUnits'.static.MetersToUnreal(25.0))
    {
        C.GetCollisionSize(C.GetTeamIndex(), PlayerOwner.ClientLevelInfo, OtherRadius, OtherHeight);

        if (VSize(Location - C.Location) < CollisionRadius + OtherRadius)
        {
            return ERROR_NoRoom;
        }
    }

    // If a duplicate distance is specified, don't allow the construction to be
    // placed if is within the duplicate distance.
    if (ConstructionClass.default.DuplicateFriendlyDistanceInMeters > 0.0)
    {
        foreach RadiusActors(ConstructionClass, A, class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.DuplicateFriendlyDistanceInMeters))
        {
            C = DHConstruction(A);

            if (C != none && C.GetTeamIndex() == PawnOwner.GetTeamNum())
            {
                return ERROR_TooCloseFriendly;
            }
        }
    }

    if (ConstructionClass.default.DuplicateEnemyDistanceInMeters > 0.0)
    {
        foreach RadiusActors(ConstructionClass, A, class'DHUnits'.static.MetersToUnreal(ConstructionClass.default.DuplicateEnemyDistanceInMeters))
        {
            C = DHConstruction(A);

            if (C != none && C.GetTeamIndex() != NEUTRAL_TEAM_INDEX && C.GetTeamIndex() != PawnOwner.GetTeamNum())
            {
                return ERROR_TooCloseEnemy;
            }
        }
    }

    return ERROR_None;
}

defaultproperties
{
    RemoteRole=ROLE_None
    DrawType=DT_StaticMesh
    bCollideActors=true
    bCollideWorld=false
    bBlockActors=false
}


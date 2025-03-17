//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// This is an actor that represents where an actor will be placed in the world.
// Its responsibility to both provide the visual representation of the actor and
// run the logic that determines where the actor can be placed.
//==============================================================================

class DHActorProxy extends Actor;

var DHPawn                  PawnOwner;
var DHPlayer                PlayerOwner;
var Actor                   GroundActor;
var Vector                  GroundNormal;
var Rotator                 Direction;

var DHActorProxyProjector   Projector;
var array<Actor>            Attachments;

// Rotation
var Rotator                 LocalRotation;
var Rotator                 LocalRotationRate;
var bool                    bLimitLocalRotation;    // Whether or not the limit the local rotation.
var Range                   LocalRotationYawRange;

var localized string        MenuName;
var localized string        MenuVerb;

enum EActorProxyErrorType
{
    ERROR_None,
    ERROR_Fatal,                    // Some fatal error occurred, usually a case of unexpected values
    ERROR_NoGround,                 // No solid ground was able to be found
    ERROR_TooSteep,                 // The ground slope exceeded the allowable maximum
    ERROR_InWater,                  // The actor is in water
    ERROR_NoRoom,                   // No room to place this actor
    ERROR_NotOnTerrain,             // Actor is not on terrain
    ERROR_InMinefield,              // Cannot be in a minefield!
    ERROR_NearSpawnPoint,           // Cannot be so close to a spawn point or location hint
    ERROR_Indoors,                  // Cannot be placed indoors
    ERROR_InObjective,              // Cannot be placed inside an objective area
    ERROR_BadSurface,               // Cannot be placed on this surface type
    ERROR_BadTerrain,               // This is used when something needs to snap to the terrain, but the engine's native trace functionality isn't cooperating!
    ERROR_InDangerZone,             // Cannot place this actor inside enemy territory.
    ERROR_Custom,                   // Custom error type (provide an error message in OptionalString)
    ERROR_SocketOccupied,           // The socket is already occupied.
    // TODO: The following errors are only used in the construction system, but it's
    // currently less of a hassle to keep them here since these error types are used
    // in lots of different places. In future, this should maybe be a secondary error
    // code attached to the proxy error.
    ERROR_Restricted,               // In a restriction volume.
    ERROR_TooCloseFriendly,         // Too close to an identical friendly actor.
    ERROR_TooCloseEnemy,            // Too close to an identical enemy actor.
    ERROR_MaxActive,                // Max active limit reached.
    ERROR_InsufficientSupply,       // Not enough supplies to build this actor.
    ERROR_RestrictedType,           // Restricted actor type (can't build on this map!)
    ERROR_SquadTooSmall,            // Not enough players in the squad!
    ERROR_PlayerBusy,               // Player is in an undesireable state (e.g. MG deployed, crawling, prone transitioning or otherwise unable to switch weapons).
    ERROR_TooCloseToObjective,      // Too close to an objective.
    ERROR_TooCloseToEnemyObjective, // Too close to enemy controlled objective.
    ERROR_MissingRequirement,       // Not close enough to a required friendly actor.
    ERROR_Exhausted,                // Your team cannot place any more of these this round.
    ERROR_Other,
};

var struct ActorProxyError
{
    var EActorProxyErrorType    Type;
    var string                  CustomErrorString;  // When Type is ERROR_Custom, this will contain the error string to be used.
    var int                     OptionalInteger;
    var Object                  OptionalObject;
    var string                  OptionalString;
} ProxyError;

// A context object used for passing context-relevant values to functions that
// determine various parameters of the actor.
struct Context
{
    var int TeamIndex;
    var DH_LevelInfo LevelInfo;
    var DHPlayer PlayerController;
    var Actor GroundActor;
    var Object OptionalObject;
    // TODO: these are construction-specific.
    var int VariantIndex;
    var int SkinIndex;
};

protected simulated function bool CanPlaceIndoors() { return true; }
protected simulated function float GetIndoorsCeilingHeightMeters() { return 25.0; }
protected simulated function float GetGroundSlopeMaxDegrees() { return 25.0;}
protected simulated function float GetArcLengthTraceIntervalMeters() { return 0.5; }
protected simulated function float GetFloatToleranceMeters() { return 0.5; }
protected simulated function bool CanOnlyPlaceOnTerrain();
protected simulated function bool ShouldAlignToGround();
protected simulated function bool ShouldSnapToTerrainVertex();
protected simulated function bool CanPlaceInWater() { return false; }
protected simulated function bool CanPlaceInDangerZone() { return true; }
protected simulated function bool CanPlaceInMinefield() { return false; }
protected simulated function bool CanPlaceInObjective(DHObjective Objective) { return true; }
protected simulated function float GetSpawnPointDistanceThresholdMeters() { return 2.0; }
protected simulated function bool CanPlaceOnTerrainSurfaceType(Material.ESurfaceTypes SurfaceType) { return true; }
protected simulated function Vector GetPlacementOffset();
protected simulated function bool CanPlaceOnTerrain(TerrainInfo TerrainInfo) { return true; }

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

    Projector = Spawn(class'DHActorProxyProjector', self);

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

function static Material CreateProxyMaterial(Material M)
{
    local Combiner C;
    local FadeColor FC;
    local FinalBlend FB;

    // HACK: Material cannot be a Combiner, since it doesn't play nice with
    // the processing we are doing below (Combiners using Combiners I suppose is
    // a bad thing). To fix this, we'll just use the combiner's fallback
    // material as the material to work with. If there's no FallbackMaterial,
    // we'll use the combiner's Material1.
    C = Combiner(M);

    if (C != none)
    {
        if (C.FallbackMaterial != none)
        {
            M = C.FallbackMaterial;
        }

        M = C.Material1;
    }

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
    FB.FallbackMaterial = M;

    return FB;
}

function static UpdateProxyMaterialColors(Actor A, Color Color)
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
                    // Interpolate between white and the specified color.
                    // This allows the user to see the object's original color, which is needed when selecting skins.
                    FC.Color1 = class'UColor'.static.Interp(0.25, class'UColor'.default.White, Color);
                    FC.Color1.A = 32;

                    FC.Color2 = class'UColor'.static.Interp(0.5, class'UColor'.default.White, Color);
                    FC.Color2.A = 128;
                }
            }
        }
    }
}

function Color GetProxyColor()
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

function UpdateColor(Color Color)
{
    local int i;

    UpdateProxyMaterialColors(self, Color);

    for (i = 0; i < Attachments.Length; ++i)
    {
        if (Attachments[i] != none)
        {
            UpdateProxyMaterialColors(Attachments[i], Color);
        }
    }
}

function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    if (PawnOwner == none || PawnOwner.Health == 0 || PawnOwner.bDeleteMe || PawnOwner.Controller == none)
    {
        Destroy();
    }

    LocalRotation += LocalRotationRate * DeltaTime;

    if (bLimitLocalRotation)
    {
        LocalRotation.Yaw = Clamp(LocalRotation.Yaw, LocalRotationYawRange.Min, LocalRotationYawRange.Max);
    }

    UpdateError();
}

function ActorProxyError GetContextError(Context Context)
{
    local ActorProxyError Error;

    Error.Type = ERROR_None;

    // TODO: put common context error handling here.

    return Error;
}

function UpdateError(optional bool bForceUpdate)
{
    local ActorProxyError ProvisionalPositionError, NewProxyError;

    // An error may be thrown when determining the location, so store it here.
    ProvisionalPositionError = SetProvisionalLocationAndRotation();
    NewProxyError = GetContextError(GetContext());

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

    if (bForceUpdate || ProxyError != NewProxyError)
    {
        SetProxyError(NewProxyError);
    }

    // This should happen every tick regardless.
    UpdateProjector();
}

simulated function UpdateProjector()
{
    local Vector RL;

    // NOTE: The relative location and rotation needs to be set every tick.
    // Without it, the projector seems to "drift" away from the object it's
    // attached to. This is probably due to some sort of cumulative floating
    // point errors.
    RL.Z = CollisionHeight;

    if (Projector != none)
    {
        if (bHidden)
        {
            RL.Z -= 2048.0;
        }

        Projector.MaxTraceDistance = CollisionHeight * 2;
        Projector.SetDrawScale((CollisionRadius * 2) / Projector.ProjTexture.MaterialUSize());
        Projector.SetRelativeLocation(RL);
        Projector.SetRelativeRotation(rot(-16384, 0, 0));
    }
}

function Context GetContext()
{
    local Context Context;

    Context.TeamIndex = PlayerOwner.GetTeamNum();
    Context.LevelInfo = class'DH_LevelInfo'.static.GetInstance(Level);
    Context.PlayerController = PlayerOwner;
    Context.GroundActor = GroundActor;

    return Context;
}

// Sets the location and rotation of the proxy and returns an error if one occurs.
function ActorProxyError SetProvisionalLocationAndRotation()
{
    local Vector TraceStart, TraceEnd, HitLocation, HitNormal, OtherHitNormal, Forward, Left, X, Y, Z, HitNormalAverage, BaseLocation;
    local Rotator R;
    local float GroundSlopeDegrees, AngleRadians, CircumferenceInMeters;
    local ActorProxyError E;
    local int i, ArcLengthTraceCount;
    local TerrainInfo TI;
    local Material HitMaterial;
    local DHGameReplicationInfo GRI;
    local Actor HitActor;
    local DHConstructionSocket Socket;

    GRI = DHGameReplicationInfo(Level.GetLocalPlayerController().GameReplicationInfo);

    if (GRI == none)
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
        Forward = Vector(R);
    }
    else if (GroundActor.IsA('DHConstructionSocket'))
    {
        // The ground actor is a location hint, so just use the hint location & rotation.
        BaseLocation = GroundActor.Location;
        Forward = Vector(GroundActor.Rotation);
        Socket = DHConstructionSocket(GroundActor);
    }
    else
    {
        // Ground is some sort of static geometry.
        BaseLocation = Location;

        if (CanOnlyPlaceOnTerrain() && !GroundActor.IsA('TerrainInfo'))
        {
            E.Type = ERROR_NotOnTerrain;
        }

        HitNormal = GroundNormal;

        // Terrain alignment steps.
        // Get the terrain info that's hit
        if (ShouldSnapToTerrainVertex() && GroundActor.IsA('TerrainInfo'))
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
                if (!CanPlaceOnTerrain(TI))
                {
                    E.Type = ERROR_BadTerrain;
                }

                BaseLocation = HitLocation;

                if (!CanPlaceOnTerrainSurfaceType(HitMaterial.SurfaceType))
                {
                    // Surface type is not allowed.
                    E.Type = ERROR_BadSurface;
                }
            }
            else
            {
                E.Type = ERROR_BadTerrain;
            }
        }

        if (!ShouldAlignToGround())
        {
            // Not aligning to ground, just use world up vector as the hit normal.
            HitNormal = vect(0, 0, 1);
        }

        Forward = Normal(Vector(Direction));
        Left = Forward cross HitNormal;
        Forward = HitNormal cross Left;

        // Hit something static in the world.
        GroundSlopeDegrees = class'UUnits'.static.RadiansToDegrees(Acos(HitNormal dot vect(0, 0, 1)));

        if (E.Type == ERROR_None && GroundSlopeDegrees >= GetGroundSlopeMaxDegrees())
        {
            // Too steep!
            E.Type = ERROR_TooSteep;
        }

        if (E.Type == ERROR_None)
        {
            GetAxes(Rotator(Forward), X, Y, Z);

            CircumferenceInMeters = class'DHUnits'.static.UnrealToMeters(CollisionRadius * Pi * 2);
            ArcLengthTraceCount = (CircumferenceInMeters / GetArcLengthTraceIntervalMeters()) / 2;

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

                TraceStart = BaseLocation + QuatRotateVector(QuatFromRotator(Rotator(X)), TraceStart);
                TraceEnd = BaseLocation + QuatRotateVector(QuatFromRotator(Rotator(X)), TraceEnd);

                // Trace across the diameter of the collision cylinder
                HitActor = Trace(HitLocation, OtherHitNormal, TraceEnd, TraceStart, true);

                if (HitActor != none && !HitActor.IsA('ROBulletWhipAttachment') && !HitActor.IsA('Volume'))
                {
                    E.Type = ERROR_NoRoom;
                    break;
                }

                // Trace down from the top of the cylinder to the bottom
                TraceEnd = TraceStart - (Z * (CollisionHeight + class'DHUnits'.static.MetersToUnreal(GetFloatToleranceMeters())));

                HitActor = Trace(HitLocation, OtherHitNormal, TraceEnd, TraceStart, false);

                if (HitActor == none)
                {
                    E.Type = ERROR_NoGround;
                    break;
                }
                else
                {
                    if (CanOnlyPlaceOnTerrain() && !HitActor.IsA('TerrainInfo'))
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

        if (E.Type == ERROR_None && GroundSlopeDegrees >= GetGroundSlopeMaxDegrees())
        {
            // Too steep!
            E.Type = ERROR_TooSteep;
        }

        // If we're aligning to terrain, set HitNormal to the HtNormalAverage
        // calculated from the circumfrencial traces.
        if (ShouldAlignToGround())
        {
            HitNormal = HitNormalAverage;
        }

        Forward = Normal(Vector(Direction));
        Left = Forward cross HitNormal;
        Forward = HitNormal cross Left;
    }

    SetLocation(BaseLocation + (GetPlacementOffset() << Rotator(Forward)));
    SetRotation(QuatToRotator(QuatProduct(QuatFromRotator(LocalRotation), QuatFromRotator(Rotator(Forward)))));

    return E;
}

// This function just checks for errors after the position has been set by SetProvisionalLocationAndRotation.
// This function is also called by the server to validate the placement (TODO: wait, is it?)
function ActorProxyError GetPositionError()
{
    local DHConstruction C;
    local Actor TouchingActor;
    local ROMineVolume MV;
    local DHSpawnPointBase SP;
    local DHLocationHint LH;
    local float OtherRadius, OtherHeight, SquareLength;
    local DHGameReplicationInfo GRI;
    local int i;
    local ActorProxyError E;
    local Vector TraceStart, TraceEnd, CeilingHitLocation, CeilingHitNormal;
    local Actor HitActor;
    local DHConstructionSocket Socket;

    GRI = DHGameReplicationInfo(PlayerOwner.GameReplicationInfo);

    // Don't allow the construction to be placed in water if this is disallowed.
    if (!CanPlaceInWater() && PhysicsVolume != none && PhysicsVolume.bWaterVolume)
    {
        E.Type = ERROR_InWater;
        return E;
    }

    if (!CanPlaceInDangerZone())
    {
        if (class'DHDangerZone'.static.IsIn(GRI, Location.X, Location.Y, Instigator.GetTeamNum()))
        {
            E.Type = ERROR_InDangerZone;
            return E;
        }
    }

    // Don't allow placement in active minefields.
    if (!CanPlaceInMinefield())
    {
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
    }

    // Don't allow actors to be placed in objectives if this is disallowed.
    for (i = 0; i < arraycount(GRI.DHObjectives); ++i)
    {
        if (GRI.DHObjectives[i] != none && GRI.DHObjectives[i].WithinArea(self) && !CanPlaceInObjective(GRI.DHObjectives[i]))
        {
            E.Type = ERROR_InObjective;
            return E;
        }
    }

    // TODO: abstract socketing

    // Don't allow placement on a socket if it's occupied.
    Socket = DHConstructionSocket(GroundActor);

    if (Socket != none && Socket.Occupant != none)
    {
        E.Type = ERROR_SocketOccupied;
        return E;
    }

    // Don't allow the actor to touch blocking actors if we aren't on a socket.
    if (Socket == none)
    {
        foreach TouchingActors(class'Actor', TouchingActor)
        {
            if (TouchingActor != none && TouchingActor.bBlockActors)
            {
                E.Type = ERROR_NoRoom;
                return E;
            }
        }

        // TODO: this is construction only!

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
    }

    if (!CanPlaceIndoors())
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
        // An actor is deemed "inside" if both of these are true:
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
            TraceStart = Location + (vect(0, 0, 1) * CollisionHeight / 2);
            TraceEnd = Location + (vect(0, 0, 1) * class'DHUnits'.static.MetersToUnreal(GetIndoorsCeilingHeightMeters()));
            HitActor = Trace(CeilingHitLocation, CeilingHitNormal, TraceEnd, TraceStart,, vect(1.0, 1.0, 0.0) * SquareLength);

            if (HitActor != none)
            {
                E.Type = ERROR_Indoors;
                return E;
            }
        }
    }

    // Don't allow actors to be placed within 2 meters of spawn points or location hints.
    foreach RadiusActors(class'DHSpawnPointBase', SP, CollisionRadius + class'DHUnits'.static.MetersToUnreal(GetSpawnPointDistanceThresholdMeters()))
    {
        E.Type = ERROR_NearSpawnPoint;
        return E;
    }

    foreach RadiusActors(class'DHLocationHint', LH, CollisionRadius + class'DHUnits'.static.MetersToUnreal(GetSpawnPointDistanceThresholdMeters()))
    {
        E.Type = ERROR_NearSpawnPoint;
        return E;
    }

    return E;
}

function SetProxyError(ActorProxyError NewProxyError)
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

function GetCollisionSize(Context Context, out float Radius, out float Height)
{
    Radius = CollisionRadius;
    Height = CollisionHeight;
}

final function UpdateCollisionSize()
{
    local float Radius, Height;

    GetCollisionSize(GetContext(), Radius, Height);

    SetCollisionSize(Radius, Height);
}

function UpdateParameters(Vector Location, Rotator Direction, Actor GroundActor, Vector GroundNormal, bool bLimitLocalRotation, Range LocalRotationYawRange)
{
    self.Direction = Direction;
    self.GroundNormal = GroundNormal;
    self.bLimitLocalRotation = bLimitLocalRotation;
    self.LocalRotationYawRange = LocalRotationYawRange;

    SetLocation(Location);

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

// Call this function when something changes that requires the proxy to update its appearance.
final function UpdateAppearance()
{
    UpdateCollisionSize();
    DestroyAttachments();
    UpdateProxyAppearance();
    UpdateError(true);
}

// Override function to update the appearance of the proxy when triggered to update.
function UpdateProxyAppearance();

function string GetMenuName()
{
    return MenuName;
}

function string GetMenuVerb()
{
    return MenuVerb;
}

defaultproperties
{
    MenuName="object"
    MenuVerb="place"
}

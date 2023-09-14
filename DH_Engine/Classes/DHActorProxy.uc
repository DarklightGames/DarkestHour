//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHActorProxy extends Actor;

var DHPawn                          PawnOwner;
var DHPlayer                        PlayerOwner;

// Projector
var DHConstructionProxyProjector    Projector;

// Attachments
var array<Actor>                    Attachments;

// Rotation
var rotator                         LocalRotation;
var rotator                         LocalRotationRate;

var bool                            bIsInterpolated;    // NOTE: this is for some unused functionality that may find a home at some point

// A context object used for passing context-relevant values to functions that
// determine various parameters of the construction.
struct Context
{
    var int TeamIndex;
    var DH_LevelInfo LevelInfo;
    var DHPlayer PlayerController;
    var Actor GroundActor;
    var Object OptionalObject;
};

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
                    FC.Color1.A = 32;

                    FC.Color2 = Color;
                    FC.Color2.A = 128;
                }
            }
        }
    }
}

function color GetProxyColor()
{
    return class'UColor'.default.White;
}

function UpdateColor(color Color)
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
}

simulated function UpdateProjector()
{
    local vector RL;

    // NOTE: The relative location and rotation needs to be set every tick.
    // Without it, the projector seems to "drift" away from the object it's
    // attached to. This is probably due to some sort of cumulative floating
    // point errors.
    RL.Z = CollisionHeight;

    if (Projector != none)
    {
        if (bHidden || bIsInterpolated)
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
    Context.GroundActor = none/*GroundActor*/;  // TODO: we want ground actor in the actor proxy???

    return Context;
}

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

var() DHConstructionTypes.SClassFilter ClassFilters[4];
var() DHConstructionTypes.STagFilter TagFilters[4];
var() int CollisionRadiusMax;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        ClassFilters, TagFilters, CollisionRadiusMax;
}

simulated function PostBeginPlay()
{   
    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        SetupSkins();
    }
    
    Hide();
}

simulated function PostNetBeginPlay()
{
    local Vector SocketDrawScale3D;

    super.PostNetBeginPlay();

    // Because the DrawScale3D is not replicated, we rely on the client to set this up themselves.
    SocketDrawScale3D.X = CollisionRadius;
    SocketDrawScale3D.Y = CollisionRadius;
    SocketDrawScale3D.Z = CollisionHeight;
    
    SetDrawScale3D(SocketDrawScale3D);
}

function Setup(DHConstructionSocketParameters Parameters)
{
    local int i;
    local float SocketCollisionRadius, SocketCollisionHeight;

    bLimitLocalRotation = Parameters.bLimitLocalRotation;
    LocalRotationYawRange = Parameters.LocalRotationYawRange;

    for (i = 0; i < arraycount(Parameters.ClassFilters); ++i)
    {
        ClassFilters[i] = Parameters.ClassFilters[i];
    }

    for (i = 0; i < arraycount(Parameters.TagFilters); ++i)
    {
        TagFilters[i] = Parameters.TagFilters[i];
    }

    CollisionRadiusMax = Parameters.CollisionRadiusMax;
    bShouldDestroyOccupant = Parameters.bShouldDestroyOccupant;

    if (CollisionRadiusMax == 0)
    {
        SocketCollisionRadius = Parameters.CollisionRadius;
    }
    else
    {
        SocketCollisionRadius = CollisionRadiusMax;
    }

    SocketCollisionHeight = Parameters.CollisionHeight;

    SetCollisionSize(SocketCollisionRadius, SocketCollisionHeight);
}

simulated function SetupSkins()
{
    local int i;
    local array<Material> StaticMeshSkins;

    StaticMeshSkins = (new Class'UStaticMesh').FindStaticMeshSkins(StaticMesh);

    for (i = 0; i < StaticMeshSkins.Length; ++i)
    {
        Skins[i] = CreateProxyMaterial(StaticMeshSkins[i]);
    }
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

    for (i = 0; i < arraycount(ClassFilters); ++i)
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

    for (i = 0; i < arraycount(TagFilters); ++i)
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

static function Material CreateProxyMaterial(Material M)
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

    FC = new Class'FadeColor';
    FC.Color1 = Class'UColor'.default.White;
    FC.Color1.A = 64;
    FC.Color2 = Class'UColor'.default.White;
    FC.Color2.A = 128;
    FC.FadePeriod = 0.25;
    FC.ColorFadeType = FC_Sinusoidal;

    C = new Class'Combiner';
    C.CombineOperation = CO_Multiply;
    C.AlphaOperation = AO_Multiply;
    C.Material1 = M;
    C.Material2 = FC;
    C.Modulate4X = true;

    FB = new Class'FinalBlend';
    FB.FrameBufferBlending = FB_AlphaBlend;
    FB.ZWrite = false;
    FB.ZTest = true;
    FB.AlphaTest = false;
    FB.TwoSided = true;
    FB.Material = C;
    FB.FallbackMaterial = M;

    return FB;
}

static function UpdateMaterialColors(Actor A, Color Color)
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
                    FC.Color1 = Color;
                    FC.Color1.A = 32;

                    FC.Color2 = Color;
                    FC.Color2.A = 128;
                }
            }
        }
    }
}

simulated function Color GetProxyColor()
{
    return Class'UColor'.default.White;
}

simulated function UpdateColor(Color Color)
{
    UpdateMaterialColors(self, Color);
}

simulated function OnProxyChanged()
{
    super.OnProxyChanged();

    if (GetProxy() != none)
    {
        UpdateColor(class'UColor'.default.Green);
    }
    else
    {
        UpdateColor(class'UColor'.default.White);
    }
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
    bAcceptsProjectors=false
}

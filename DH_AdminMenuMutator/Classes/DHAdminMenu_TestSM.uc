//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

// A dummy static mesh actor used by SetDropHeight function in the mutator to determine height for parachute drops
class DHAdminMenu_TestSM extends StaticMeshActor;

defaultproperties
{
    RemoteRole=ROLE_None
    bExactProjectileCollision=false
    StaticMesh=StaticMesh'MilitarySM.sandbag.sandbag02'
    bUseDynamicLights=false
    bStatic=false
    bWorldGeometry=false
    bAcceptsProjectors=false
    bShadowCast=false
    bStaticLighting=false
    bCollideActors=false
    bCollideWorld=true
    bBlockActors=false
    bBlockKarma=false
}

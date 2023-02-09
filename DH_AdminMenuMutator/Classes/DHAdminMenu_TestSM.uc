//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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

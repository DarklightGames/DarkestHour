//===============================================================================================================
// DH_AdminMenu_TestSM - by Matt UK
//===============================================================================================================
//
// A test static mesh actor used by SetDropHeight function in the mutator to determine height for parachute drops
//
//===============================================================================================================
class DH_AdminMenu_TestSM extends StaticMeshActor;

defaultproperties
{
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

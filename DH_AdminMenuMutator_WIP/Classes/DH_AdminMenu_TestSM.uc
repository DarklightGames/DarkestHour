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
     bExactProjectileCollision=False
     StaticMesh=StaticMesh'MilitarySM.sandbag.sandbag02'
     bUseDynamicLights=False
     bStatic=False
     bWorldGeometry=False
     bAcceptsProjectors=False
     bShadowCast=False
     bStaticLighting=False
     bCollideActors=False
     bCollideWorld=True
     bBlockActors=False
     bBlockKarma=False
}

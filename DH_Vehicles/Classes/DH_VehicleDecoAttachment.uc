//=============================================================================
// DH_VehicleDecorationAttachment
//
// Allows us to attach some cool stuff to the vehicles - camouflage, MG's, etc
//=============================================================================
class DH_VehicleDecoAttachment extends RODummyAttachment
	abstract;


simulated function PostBeginPlay()
{
}

//-----------------------------------------------------------------------------
// StaticPrecache
//-----------------------------------------------------------------------------

static function StaticPrecache(LevelInfo L)
{
}

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
     bDramaticLighting=True
}

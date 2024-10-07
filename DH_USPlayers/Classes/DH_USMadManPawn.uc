//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_USMadManPawn extends DH_AmericanPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersUS_anm.US_tanker'
    Skins(1)=Texture'DHUSCharactersTex.743rdTank.Tanker_corpse'

    GroundSpeed=250
    WalkingPct=0.3   
    Health=300
    Stamina=500
    bNeverStaggers=true
    bAlwaysSeverBodyparts=true
    
// Same texture declared twice as this role has only one texture variant, necessary due to AmericanPawn inheritance
	BodySkins(0)=Texture'DHUSCharactersTex.743rdTank.Tanker_corpse'
    BodySkins(1)=Texture'DHUSCharactersTex.743rdTank.Tanker_corpse'
}

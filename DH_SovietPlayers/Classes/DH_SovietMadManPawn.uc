//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SovietMadManPawn extends DH_SovietPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersSOV_anm.sov_marine_Bushlat'
    Skins(0)=Texture'DHSovietCharactersTex.soviet_naval_bushlat.bushlat'
    Skins(1)=Texture'Characters_tex.rus_heads.rus_face01'
    Skins(2)=Texture'DHSovietCharactersTex.soviet_gear.Gear'

    GroundSpeed=250
    WalkingPct=0.3   
    Health=300
    Stamina=500
    MinHurtSpeed=700.0
    bNeverStaggers=true
   
    
}

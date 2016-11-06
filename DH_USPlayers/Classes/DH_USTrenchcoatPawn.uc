//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_USTrenchcoatPawn extends DH_USWinterPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharacters_anm.USWinter_Trenchcoat'
    Skins(0)=texture'DHUSCharactersTex.Winter.TrenchcoatWithScarf'
    Skins(1)=texture'DHUSCharactersTex.us_heads.WinterFace2'

    bReversedSkinsSlots=false // US trenchocat meshes are the only US ones with the body & face skin slots in the standard order, i.e. body is 0 & face is 1
}

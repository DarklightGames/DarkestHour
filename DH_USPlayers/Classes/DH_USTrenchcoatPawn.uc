//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USTrenchcoatPawn extends DH_USWinterPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersUS_anm.USWinter_Trenchcoat'
    Skins(0)=Texture'DHUSCharactersTex.TrenchcoatWithScarf'
    Skins(1)=Texture'DHUSCharactersTex.WinterFace2'

    bReversedSkinsSlots=false // US trenchocat meshes are the only US ones with the body & face skin slots in the standard order, i.e. body is 0 & face is 1
}

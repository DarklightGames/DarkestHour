//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================
// Halloween Special 2020

class DH_ZombieLeaderPawn extends DHPawn;

defaultproperties
{
    Species=class'DH_Engine.DHSPECIES_Human'

    Mesh=SkeletalMesh'DHCharactersGER_anm.Ger_TankCrew'

    Skins(0)=Texture'DHEventCharactersTex.GetTunics.h_zombie'
    Skins(1)=Texture'DHEventCharactersTex.GerHeads.h_face_zombie'

    bReversedSkinsSlots=false

    ShovelClassName="DH_Equipment.DHShovelItem_German"
    BinocsClassName="DH_Equipment.DHBinocularsItemGerman"
}

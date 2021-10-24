//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================
// Halloween Special 2020

class DH_ZTanker extends DHGETankCrewmanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_ZombieTankCrewPawn',Weight=1.0)

    HandTexture=Texture'DHEventCharactersTex.Arms.hands_zombie'
    SleeveTexture=Texture'DHEventCharactersTex.Arms.german_tanker_sleeves_zombie'

    Headgear(0)=class'DH_GerPlayers.DH_HeerTankerCap'
    Headgear(1)=class'DH_GerPlayers.DH_HeerCamoCap'
}

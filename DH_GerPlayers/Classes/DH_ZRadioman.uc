//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// Halloween Special 2020

class DH_ZRadioman extends DHGERadioOperatorRoles;

defaultproperties
{
    VoiceType="DH_GerPlayers.DHZVoice"
    AltVoiceType="DH_GerPlayers.DHZVoice"

    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_ZombieRadioHeerPawn')

    BareHandTexture=Texture'DHEventCharactersTex.Arms.hands_zombie'
    SleeveTexture=Texture'DHEventCharactersTex.Arms.german_sleeves_zombie'

    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
    Headgear(2)=none
}

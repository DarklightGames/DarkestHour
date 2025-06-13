//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Halloween Special 2020

class DH_ZMortarman extends DHGEMortarmanRoles;

defaultproperties
{
    VoiceType="DH_GerPlayers.DHZVoice"
    AltVoiceType="DH_GerPlayers.DHZVoice"

    RolePawns(0)=(PawnClass=Class'DH_ZombieHeerPawn',Weight=1.0)
    RolePawns(1)=(PawnClass=Class'DH_ZombieSmockHeerPawn',Weight=0.2)

    BareHandTexture=Texture'DHEventCharactersTex.hands_zombie'
    SleeveTexture=Texture'DHEventCharactersTex.german_sleeves_zombie'

    Headgear(0)=Class'DH_HeerHelmetThree'
    Headgear(1)=Class'DH_HeerHelmetTwo'
    Headgear(2)=none
}

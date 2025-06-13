//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Halloween Special 2020

class DH_ZTanker extends DHGETankCrewmanRoles;

defaultproperties
{
    VoiceType="DH_GerPlayers.DHZVoice"
    AltVoiceType="DH_GerPlayers.DHZVoice"

    RolePawns(0)=(PawnClass=Class'DH_ZombieTankCrewPawn',Weight=1.0)

    BareHandTexture=Texture'DHEventCharactersTex.hands_zombie'
    SleeveTexture=Texture'DHEventCharactersTex.german_tanker_sleeves_zombie'

    Headgear(0)=Class'DH_HeerTankerCap'
    Headgear(1)=Class'DH_HeerCamoCap'
}

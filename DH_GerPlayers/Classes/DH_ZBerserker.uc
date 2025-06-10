//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Halloween Special 2020

class DH_ZBerserker extends DHAxisRoles;

defaultproperties
{
    bCanPickupWeapons=false;

    MyName="Berserker"
    AltName="Berserker"
    bSpawnWithExtraAmmo=true

    VoiceType="DH_GerPlayers.DHZVoice"
    AltVoiceType="DH_GerPlayers.DHZVoice"

    RolePawns(0)=(PawnClass=Class'DH_ZombieBerserkerHeerPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_ZombieBerserkerSmockPawn',Weight=2.0)

    PrimaryWeapons(0)=(Item=Class'DHTrenchMaceItem',AssociatedAttachment=none)
    PrimaryWeapons(1)=(Item=Class'DHTrenchMaceItem_Bone',AssociatedAttachment=none)
    PrimaryWeapons(2)=(Item=Class'DHTrenchMaceItem_Grenade',AssociatedAttachment=none)

    BareHandTexture=Texture'DHEventCharactersTex.Arms.hands_zombie'
    SleeveTexture=Texture'DHEventCharactersTex.Arms.german_sleeves_zombie'
}

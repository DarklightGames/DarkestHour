//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Halloween Special 2020

class DH_ZLeader extends DHAxisRoles;

defaultproperties
{
    bCanPickupWeapons=false

    VoiceType="DH_GerPlayers.DHZVoice"
    AltVoiceType="DH_GerPlayers.DHZVoice"

    MyName="Zombie Leader"
    AltName="Zombie Leader"
    Limit=1

    bIsLeader=true
    bRequiresSL=true

    RolePawns(0)=(PawnClass=Class'DH_ZombieLeaderPawn',Weight=1.0)

    BareHandTexture=Texture'DHEventCharactersTex.hands_zombie'
    SleeveTexture=Texture'DHEventCharactersTex.h_sleeves_zombie'

    SecondaryWeapons(0)=(Item=Class'DH_P08LugerWeapon')

    PrimaryWeapons(0)=(Item=Class'DHTrenchMaceItem_Grenade',AssociatedAttachment=none)
}

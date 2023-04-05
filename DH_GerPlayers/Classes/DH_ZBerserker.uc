//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// Halloween Special 2020

class DH_ZBerserker extends DHAxisRoles;

defaultproperties
{
    bCanPickupWeapons=false;

    MyName="Berserker"
    AltName="Berserker"
    Article="a "
    PluralName="Berserkers"
    bSpawnWithExtraAmmo=true

    VoiceType="DH_GerPlayers.DHZVoice"
    AltVoiceType="DH_GerPlayers.DHZVoice"

    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_ZombieBerserkerHeerPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_GerPlayers.DH_ZombieBerserkerSmockPawn',Weight=2.0)

    PrimaryWeapons(0)=(Item=class'DH_Equipment.DHTrenchMaceItem',AssociatedAttachment=none)
    PrimaryWeapons(1)=(Item=class'DH_Equipment.DHTrenchMaceItem_Bone',AssociatedAttachment=none)
    PrimaryWeapons(2)=(Item=class'DH_Equipment.DHTrenchMaceItem_Grenade',AssociatedAttachment=none)

    BareHandTexture=Texture'DHEventCharactersTex.Arms.hands_zombie'
    SleeveTexture=Texture'DHEventCharactersTex.Arms.german_sleeves_zombie'
}

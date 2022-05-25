//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================
// Halloween Special 2020

class DH_ZBerserker extends DHAxisRoles;

defaultproperties
{
    HealthMultiplier=3.0
    bCanPickupWeapons=false;

    MyName="Berserker"
    AltName="Berserker"
    Article="a "
    PluralName="Berserkers"
    bSpawnWithExtraAmmo=true

    VoiceType="DH_GerPlayers.DHZVoice"
    AltVoiceType="DH_GerPlayers.DHZVoice"

    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_ZombiePawn',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_GerPlayers.DH_ZombieHeerPawn',Weight=2.0)
    RolePawns(2)=(PawnClass=class'DH_GerPlayers.DH_ZombieSmockHeerPawn',Weight=2.0)

    GivenItems(0)="DH_Equipment.DHShovelItem_German"

    BareHandTexture=Texture'DHEventCharactersTex.Arms.hands_zombie'
    SleeveTexture=Texture'DHEventCharactersTex.Arms.german_sleeves_zombie'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKA_SnowRiflemanLate extends DH_RKKA_SnowRifleman;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietSnowLatePawn',Weight=1.0)

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_M38Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')

    Headgear(0)=class'DH_SovietPlayers.DH_SovietHelmetSnow'
}

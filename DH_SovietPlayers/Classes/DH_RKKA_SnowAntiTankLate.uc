//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKA_SnowAntiTankLate extends DH_RKKA_SnowAntiTank;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietSnowLatePawn',Weight=1.0)
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PTRDWeapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_RPG43GrenadeWeapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItemSoviet"

    Headgear(0)=class'DH_SovietPlayers.DH_SovietHelmetSnow'
}

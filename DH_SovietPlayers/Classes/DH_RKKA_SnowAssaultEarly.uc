//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKA_SnowAssaultEarly extends DH_RKKA_SnowAssault;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPD40Weapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')

    Headgear(0)=class'DH_SovietPlayers.DH_SovietHelmetSnow'
    Headgear(1)=class'DH_SovietPlayers.DH_SovietHelmet'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
}

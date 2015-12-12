//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BritishSergeantRMCommando extends DH_RoyalMarineCommandos;

defaultproperties
{
    bIsSquadLeader=true
    MyName="Corporal"
    AltName="Corporal"
    Article="a "
    PluralName="Corporals"
    MenuImage=texture'DHBritishCharactersTex.Icons.Brit_Sg'
    Models(0)="RMCSarg1"
    Models(1)="RMCSarg2"
    Models(2)="RMCSarg3"
    bIsLeader=true
    SleeveTexture=texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo4Weapon')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_StenMkIIWeapon')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_ThompsonWeapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon')
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon')
    Grenades(2)=(Item=class'DH_Equipment.DH_RedSmokeWeapon')
    Headgear(0)=class'DH_BritishPlayers.DH_BritishRMCommandoBeret'
    PrimaryWeaponType=WT_Rifle
    bEnhancedAutomaticControl=true
    Limit=2
}

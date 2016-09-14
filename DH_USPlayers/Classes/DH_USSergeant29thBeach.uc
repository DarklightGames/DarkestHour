//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_USSergeant29thBeach extends DH_US_29th_Infantry_Beach;

defaultproperties
{
    MyName="Sergeant"
    AltName="Sergeant"
    Article="a "
    PluralName="Sergeants"
    bIsLeader=true
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_ThompsonWeapon',AssociatedAttachment=class'DH_Weapons.DH_ThompsonAmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_GreaseGunWeapon',AssociatedAttachment=class'DH_Weapons.DH_ThompsonAmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon')
    Grenades(0)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_RedSmokeWeapon')
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet29thNCOa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet29thNCOb'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=2
}

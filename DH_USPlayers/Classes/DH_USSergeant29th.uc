//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USSergeant29th extends DH_US_29th_Infantry;

defaultproperties
{
    bIsSquadLeader=true
    MyName="Sergeant"
    AltName="Sergeant"
    Article="a "
    PluralName="Sergeants"
    InfoText="The sergeant is tasked with overseeing the completion of the squad's objectives by directing his men in combat and ensuring the overall firepower is put to good use.  With the effective use of smoke and close-quarters weaponry, the sergeant's presence is an excellent force multiplier to the units under his command."
    MenuImage=texture'DHUSCharactersTex.Icons.IconSg'
    Models(0)="US_29InfSarg1"
    Models(1)="US_29InfSarg2"
    Models(2)="US_29InfSarg3"
    bIsLeader=true
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_ThompsonWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_ThompsonAmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_GreaseGunWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_ThompsonAmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
    Grenades(0)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
    Grenades(1)=(Item=class'DH_Equipment.DH_RedSmokeWeapon',Amount=1)
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet29thNCOa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet29thNCOb'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=2
}

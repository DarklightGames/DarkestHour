//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USSergeant2ndR extends DH_US_2ndRangersBattalion;


function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
    {
        return Headgear[0];
    }
    else
    {
        return Headgear[1];
    }
}

defaultproperties
{
    bIsSquadLeader=true
    MyName="Sergeant"
    AltName="Sergeant"
    Article="a "
    PluralName="Sergeants"
    InfoText="The sergeant is tasked with overseeing the completion of the squad's objectives by directing his men in combat and ensuring the overall firepower is put to good use.  With the effective use of smoke and close-quarters weaponry, the sergeant's presence is an excellent force multiplier to the units under his command."
    MenuImage=Texture'DHUSCharactersTex.Icons.IconSg'
    Models(0)="US_2RSarg1"
    Models(1)="US_2RSarg2"
    Models(2)="US_2RSarg3"
    bIsLeader=true
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_ThompsonWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_ThompsonAmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_GreaseGunWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_ThompsonAmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
    Grenades(0)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
    Grenades(1)=(Item=class'DH_Equipment.DH_RedSmokeWeapon',Amount=1)
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet2ndRNCOa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet2ndRNCOb'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=2
}

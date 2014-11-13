//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USRifleman506101st extends DH_US_506PIR;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
        return Headgear[0];
    else
        return Headgear[1];
}

defaultproperties
{
     MyName="Rifleman"
     AltName="Rifleman"
     Article="a "
     PluralName="Riflemen"
     InfoText="The rifleman is the basic soldier of the battlefield that is tasked with the important role of capturing and holding objectives, as well as the defense of key positions. Armed with the standard-issue battle rifle, the rifleman’s efficiency is determined by his ability to work as a member of a larger unit."
     MenuImage=Texture'DHUSCharactersTex.Icons.ABRifleman'
     Models(0)="US_506101AB1"
     Models(1)="US_506101AB2"
     Models(2)="US_506101AB3"
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_M1GarandWeapon',Amount=6,AssociatedAttachment=Class'DH_Weapons.DH_M1GarandAmmoPouch')
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_M1CarbineWeapon',Amount=6,AssociatedAttachment=Class'DH_Weapons.DH_M1CarbineAmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
     Grenades(0)=(Item=Class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
     Headgear(0)=Class'DH_USPlayers.DH_AmericanHelmet506101stEMa'
     Headgear(1)=Class'DH_USPlayers.DH_AmericanHelmet506101stEMb'
     PrimaryWeaponType=WT_SemiAuto
}

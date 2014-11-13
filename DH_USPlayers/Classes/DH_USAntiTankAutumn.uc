//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USAntiTankAutumn extends DH_US_Autumn_Infantry;


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
     bIsATGunner=true
     bCarriesATAmmo=false
     MyName="Anti-Tank Soldier"
     AltName="Anti-Tank Soldier"
     Article="an "
     PluralName="Anti-Tank Soldiers"
     InfoText="The anti-tank soldier is tasked with locating and destroying or disabling enemy vehicles.  Armed with close-range anti-tank weaponry, he must often get dangerously close to his target in order to assure a hit.  His weaponry can also be effective against enemy fortifications."
     MenuImage=Texture'DHUSCharactersTex.Icons.IconAT'
     Models(0)="US_AutumnInf1"
     Models(1)="US_AutumnInf2"
     Models(2)="US_AutumnInf3"
     Models(3)="US_AutumnInf4"
     Models(4)="US_AutumnInf5"
     bIsGunner=true
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_M1CarbineWeapon',Amount=6,AssociatedAttachment=Class'DH_Weapons.DH_M1CarbineAmmoPouch')
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_GreaseGunWeapon',Amount=6,AssociatedAttachment=Class'DH_Weapons.DH_ThompsonAmmoPouch')
     Grenades(0)=(Item=Class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
     GivenItems(0)="DH_ATWeapons.DH_BazookaWeapon"
     Headgear(0)=Class'DH_USPlayers.DH_AmericanHelmet1stEMa'
     Headgear(1)=Class'DH_USPlayers.DH_AmericanHelmet1stEMb'
     PrimaryWeaponType=WT_SMG
     Limit=1
}

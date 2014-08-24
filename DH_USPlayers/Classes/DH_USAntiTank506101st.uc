//=============================================================================
// DH_USAntiTank506101st.
//=============================================================================
class DH_USAntiTank506101st extends DH_US_506PIR;

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
     menuImage=Texture'DHUSCharactersTex.Icons.ABAT'
     Models(0)="US_506101AB1"
     Models(1)="US_506101AB2"
     Models(2)="US_506101AB3"
     bIsGunner=true
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_M1CarbineWeapon',Amount=6,AssociatedAttachment=Class'DH_Weapons.DH_M1CarbineAmmoPouch')
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_GreaseGunWeapon',Amount=6,AssociatedAttachment=Class'DH_Weapons.DH_ThompsonAmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
     Grenades(0)=(Item=Class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
     GivenItems(0)="DH_ATWeapons.DH_BazookaWeapon"
     Headgear(0)=Class'DH_USPlayers.DH_AmericanHelmet506101stEMa'
     Headgear(1)=Class'DH_USPlayers.DH_AmericanHelmet506101stEMb'
     PrimaryWeaponType=WT_SMG
     limit=1
}

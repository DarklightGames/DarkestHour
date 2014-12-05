//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USSquadMG506101st extends DH_US_506PIR;

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
    MyName="Squad Machine-Gunner"
    AltName="Squad Machine-Gunner"
    Article="a "
    PluralName="Squad Machine-Gunners"
    InfoText="The squad machine-gunner is tasked with the tactical employment of the light machine gun to provide direct fire support to his squad, and in many cases being its primary source of mid- and long-range firepower. Due to the light machine gun's high rate of fire, an adequate supply of ammunition is needed to maintain a constant rate of fire, provided largely by his accompanying units."
    MenuImage=Texture'DHUSCharactersTex.Icons.ABSMG'
    Models(0)="US_506101AB1"
    Models(1)="US_506101AB2"
    Models(2)="US_506101AB3"
    bIsGunner=true
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_BARWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet506101stEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet506101stEMb'
    bCarriesMGAmmo=false
    PrimaryWeaponType=WT_SMG
    Limit=2
}

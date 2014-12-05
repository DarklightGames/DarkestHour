//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USSquadMG29thBeach extends DH_US_29th_Infantry;

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
    MenuImage=Texture'DHUSCharactersTex.Icons.IconSMG'
    Models(0)="US_29Inf1b"
    Models(1)="US_29Inf2b"
    Models(2)="US_29Inf3b"
    Models(3)="US_29Inf4b"
    Models(4)="US_29Inf5b"
    bIsGunner=true
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_BARWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet29thEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet29thEMb'
    bCarriesMGAmmo=false
    PrimaryWeaponType=WT_SMG
    Limit=2
}

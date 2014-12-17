//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USSniper82nd extends DH_US_82nd_Airborne;

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
    MyName="Sniper"
    AltName="Sniper"
    Article="a "
    PluralName="Snipers"
    InfoText="The sniper is tasked with the specialized goal of eliminating key hostile units and shaking enemy morale through careful marksmanship and fieldcraft.  Through patient observation, the sniper is also capable of providing valuable reconnaissance which can have a significant impact on the outcome of the battle."
    MenuImage=texture'DHUSCharactersTex.Icons.ABSnip'
    Models(0)="US_82AB1"
    Models(1)="US_82AB2"
    Models(2)="US_82AB3"
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_SpringfieldScopedWeapon',Amount=18,AssociatedAttachment=class'DH_Weapons.DH_M1GarandAmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet82ndEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet82ndEMb'
    PrimaryWeaponType=WT_Sniper
    Limit=1
}

//=============================================================================
// DH_USSniper29th.
//=============================================================================
class DH_USSniper29thBeach extends DH_US_29th_Infantry;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
        return Headgear[0];
    else
        return Headgear[1];
}

defaultproperties
{
     MyName="Sniper"
     AltName="Sniper"
     Article="a "
     PluralName="Snipers"
     InfoText="The sniper is tasked with the specialized goal of eliminating key hostile units and shaking enemy morale through careful marksmanship and fieldcraft.  Through patient observation, the sniper is also capable of providing valuable reconnaissance which can have a significant impact on the outcome of the battle."
     menuImage=Texture'DHUSCharactersTex.Icons.IconSnip'
     Models(0)="US_29Inf1B"
     Models(1)="US_29Inf2B"
     Models(2)="US_29Inf3B"
     Models(3)="US_29Inf4B"
     Models(4)="US_29Inf5B"
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_SpringfieldScopedWeapon',Amount=18,AssociatedAttachment=Class'DH_Weapons.DH_M1GarandAmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
     Headgear(0)=Class'DH_USPlayers.DH_AmericanHelmet29thEMa'
     Headgear(1)=Class'DH_USPlayers.DH_AmericanHelmet29thEMb'
     PrimaryWeaponType=WT_Sniper
     limit=1
}

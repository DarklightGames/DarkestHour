//=============================================================================
// DH_USSniper1st.
//=============================================================================
class DH_USSniper1st extends DH_US_1st_Infantry;


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
     Models(0)="US_1Inf1"
     Models(1)="US_1Inf2"
     Models(2)="US_1Inf3"
     Models(3)="US_1Inf4"
     Models(4)="US_1Inf5"
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_SpringfieldScopedWeapon',Amount=18,AssociatedAttachment=Class'DH_Weapons.DH_M1GarandAmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
     Headgear(0)=Class'DH_USPlayers.DH_AmericanHelmet1stEMa'
     Headgear(1)=Class'DH_USPlayers.DH_AmericanHelmet1stEMb'
     PrimaryWeaponType=WT_Sniper
     limit=1
}

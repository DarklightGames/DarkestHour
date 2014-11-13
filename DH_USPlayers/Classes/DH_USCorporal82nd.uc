//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USCorporal82nd extends DH_US_82nd_Airborne;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
        return Headgear[0];
    else
        return Headgear[1];
}

defaultproperties
{
     MyName="Corporal"
     AltName="Corporal"
     Article="a "
     PluralName="Corporals"
     InfoText="The corporal is the NCO tasked to coordinate his team's movement in accordance with the squad's objective. As the direct assistant to the squad leader, he is expected to provide a comparable level of support to his men."
     MenuImage=Texture'DHUSCharactersTex.Icons.IconCorporal'
     Models(0)="US_82AB1"
     Models(1)="US_82AB2"
     Models(2)="US_82AB3"
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1GarandWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_M1GarandAmmoPouch')
     SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
     Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
     Grenades(1)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
     Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet82ndEMa'
     Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet82ndEMb'
     PrimaryWeaponType=WT_SemiAuto
     Limit=2
}

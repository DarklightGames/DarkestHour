//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USCorporal2ndR extends DH_US_2ndRangersBattalion;


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
     MyName="Corporal"
     AltName="Corporal"
     Article="a "
     PluralName="Corporals"
     InfoText="The corporal is the NCO tasked to coordinate his team's movement in accordance with the squad's objective. As the direct assistant to the squad leader, he is expected to provide a comparable level of support to his men."
     MenuImage=Texture'DHUSCharactersTex.Icons.IconCorporal'
     Models(0)="US_2R1"
     Models(1)="US_2R2"
     Models(2)="US_2R3"
     Models(3)="US_2R4"
     Models(4)="US_2R5"
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_M1GarandWeapon',Amount=6,AssociatedAttachment=Class'DH_Weapons.DH_M1GarandAmmoPouch')
     Grenades(0)=(Item=Class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
     Grenades(1)=(Item=Class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
     Headgear(0)=Class'DH_USPlayers.DH_AmericanHelmet2ndREMa'
     Headgear(1)=Class'DH_USPlayers.DH_AmericanHelmet2ndREMb'
     PrimaryWeaponType=WT_SemiAuto
     Limit=2
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USrifleman2ndR extends DH_US_2ndRangersBattalion;


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
     MenuImage=Texture'DHUSCharactersTex.Icons.IconGI'
     Models(0)="US_2R1"
     Models(1)="US_2R2"
     Models(2)="US_2R3"
     Models(3)="US_2R4"
     Models(4)="US_2R5"
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_M1GarandWeapon',Amount=6,AssociatedAttachment=Class'DH_Weapons.DH_M1GarandAmmoPouch')
     Grenades(0)=(Item=Class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
     Headgear(0)=Class'DH_USPlayers.DH_AmericanHelmet2ndREMa'
     Headgear(1)=Class'DH_USPlayers.DH_AmericanHelmet2ndREMb'
     PrimaryWeaponType=WT_SemiAuto
}

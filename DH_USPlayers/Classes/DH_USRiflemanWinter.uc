//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USRiflemanWinter extends DH_US_Winter_Infantry;


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
     Models(0)="US_WinterInf1"
     Models(1)="US_WinterInf2"
     Models(2)="US_WinterInf3"
     Models(3)="US_WinterInf4"
     Models(4)="US_WinterInf5"
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1GarandWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_M1GarandAmmoPouch')
     Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
     Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet1stEMa'
     Headgear(1)=class'DH_USPlayers.DH_AmericanHelmetWinter'
     PrimaryWeaponType=WT_SemiAuto
}

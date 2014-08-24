//=============================================================================
// DH_BritishRiflemanOx&Bucks
//=============================================================================
class DH_BritishRiflemanOx_Bucks extends DH_Ox_Bucks;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
    {
        if (FRand() < 0.5)
            return Headgear[2];
        else
            return Headgear[1];
    }
    else
    {
        return Headgear[0];
    }
}

defaultproperties
{
     MyName="Rifleman"
     AltName="Rifleman"
     Article="a "
     PluralName="Riflemen"
     InfoText="The rifleman is the basic soldier of the battlefield that is tasked with the important role of capturing and holding objectives, as well as the defense of key positions. Armed with the standard-issue battle rifle, the rifleman’s efficiency is determined by his ability to work as a member of a larger unit."
     MenuImage=Texture'DHBritishCharactersTex.Icons.Para_Rifleman'
     Models(0)="para1"
     Models(1)="para2"
     Models(2)="para3"
     Models(3)="para4"
     Models(4)="para5"
     Models(5)="para6"
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.Brit_Para_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo4Weapon',Amount=6)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     Grenades(0)=(Item=Class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
     Headgear(0)=Class'DH_BritishPlayers.DH_BritishParaHelmet1'
     Headgear(1)=Class'DH_BritishPlayers.DH_BritishParaHelmet2'
     Headgear(2)=Class'DH_BritishPlayers.DH_BritishParaHelmet1'
}

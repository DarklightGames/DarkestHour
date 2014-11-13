//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_FJFireteamLeader extends DH_FJ;

function class<ROHeadgear> GetHeadgear()
{
    local int RandNum;
    RandNum = Rand(3);

    switch (RandNum)
    {
        case 0:
             return Headgear[0];
        case 1:
             return Headgear[1];
        case 2:
             return Headgear[2];
        default:
             return Headgear[0];
    }
}

defaultproperties
{
     MyName="Fireteam Leader"
     AltName="Gefreiter"
     Article="a "
     PluralName="Fireteam Leaders"
     InfoText="The fireteam leader is the NCO tasked to coordinate his team's movement in accordance with the squad's objective. As the direct assistant to the squad leader, he is expected to provide a comparable level of support to his men."
     MenuImage=Texture'DHGermanCharactersTex.Icons.FJ_Ftl'
     Models(0)="FJ1"
     Models(1)="FJ2"
     Models(2)="FJ3"
     Models(3)="FJ4"
     Models(4)="FJ5"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_FG42Weapon',Amount=8)
     PrimaryWeapons(2)=(Item=Class'DH_Weapons.DH_G41Weapon',Amount=9,AssociatedAttachment=Class'ROInventory.ROG43AmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
     SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
     Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Headgear(0)=Class'DH_GerPlayers.DH_FJHelmet1'
     Headgear(1)=Class'DH_GerPlayers.DH_FJHelmet2'
     Headgear(2)=Class'DH_GerPlayers.DH_FJHelmetNet1'
     Limit=1
     Limit33to44=2
     LimitOver44=2
}

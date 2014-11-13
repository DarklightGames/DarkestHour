//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_12thSSFireteamLeader extends DH_12thSS;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
        return Headgear[0];
    else
        return Headgear[1];
}

defaultproperties
{
     MyName="Fireteam Leader"
     AltName="Rottenführer"
     Article="a "
     PluralName="Fireteam Leaders"
     InfoText="The fireteam leader is the NCO tasked to coordinate his team's movement in accordance with the squad's objective. As the direct assistant to the squad leader, he is expected to provide a comparable level of support to his men."
     MenuImage=Texture'DHGermanCharactersTex.Icons.WSS_Semi'
     Models(0)="12SS_1"
     Models(1)="12SS_2"
     Models(2)="12SS_3"
     Models(3)="12SS_4"
     Models(4)="12SS_5"
     Models(5)="12SS_6"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.12thSS_Sleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_G43Weapon',Amount=9,AssociatedAttachment=Class'ROInventory.ROG43AmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
     SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
     Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Headgear(0)=Class'DH_GerPlayers.DH_SSHelmetOne'
     Headgear(1)=Class'DH_GerPlayers.DH_SSHelmetTwo'
     Limit=1
     Limit33to44=2
     LimitOver44=2
}

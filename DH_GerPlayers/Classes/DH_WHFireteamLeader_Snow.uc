//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WHFireteamLeader_Snow extends DH_HeerSnow;

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
     AltName="Gefreiter"
     Article="a "
     PluralName="Fireteam Leaders"
     InfoText="The fireteam leader is the NCO tasked to coordinate his team's movement in accordance with the squad's objective. As the direct assistant to the squad leader, he is expected to provide a comparable level of support to his men."
     MenuImage=Texture'InterfaceArt_tex.SelectMenus.Gruppenfuhrer'
     Models(0)="WHS_1"
     Models(1)="WHS_2"
     Models(2)="WHS_3"
     Models(3)="WHS_4"
     Models(4)="WHS_5"
     Models(5)="WHS_6"
     SleeveTexture=Texture'Weapons1st_tex.Arms.german_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_G43Weapon',Amount=9,AssociatedAttachment=Class'ROInventory.ROG43AmmoPouch')
     Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Headgear(0)=Class'DH_GerPlayers.DH_HeerHelmetCover'
     Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetSnow'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     Limit=1
     Limit33to44=2
     LimitOver44=2
}

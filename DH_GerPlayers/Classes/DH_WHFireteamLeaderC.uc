//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WHFireteamLeaderC extends DH_HeerCamo;

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
     MenuImage=Texture'DHGermanCharactersTex.Icons.WSS_Ass'
     Models(0)="WH_C1"
     Models(1)="WH_C2"
     Models(2)="WH_C3"
     Models(3)="WH_C4"
     Models(4)="WH_C5"
     Models(5)="WH_C6"
     SleeveTexture=Texture'Weapons1st_tex.Arms.german_sleeves'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
     Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetOne'
     Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     Limit=1
     Limit33to44=2
     LimitOver44=2
}

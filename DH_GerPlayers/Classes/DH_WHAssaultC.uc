// *************************************************************************
//
//  ***   WH Assault   ***
//
// *************************************************************************

class DH_WHAssaultC extends DH_HeerCamo;

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
     MyName="Assault Trooper"
     AltName="Stoßtruppe"
     Article="an "
     PluralName="Assault Troopers"
     InfoText="The assault trooper is a specialized infantry class who is tasked with closing with the enemy and eliminating him from difficult positions such as houses and fortifications.  The assault trooper is generally better armed than most infantrymen."
     menuImage=Texture'InterfaceArt_tex.SelectMenus.Stosstruppe'
     Models(0)="WH_C1"
     Models(1)="WH_C2"
     Models(2)="WH_C3"
     Models(3)="WH_C4"
     Models(4)="WH_C5"
     Models(5)="WH_C6"
     SleeveTexture=Texture'Weapons1st_tex.Arms.german_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
     Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Headgear(0)=Class'DH_GerPlayers.DH_HeerHelmetOne'
     Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetTwo'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     limit=4
}

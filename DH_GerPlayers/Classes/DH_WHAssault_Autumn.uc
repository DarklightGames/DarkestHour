//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WHAssault_Autumn extends DH_HeerAutumn;

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
     MyName="Assault Troop"
     AltName="Stoßtruppe"
     Article="an "
     PluralName="Assault Troopers"
     InfoText="The assault trooper is a specialized infantry class who is tasked with closing with the enemy and eliminating him from difficult positions such as houses and fortifications.  The assault trooper is generally better armed than most infantrymen."
     MenuImage=Texture'InterfaceArt_tex.SelectMenus.Stosstruppe'
     Models(0)="WHAu_1"
     Models(1)="WHAu_2"
     Models(2)="WHAu_3"
     Models(3)="WHAu_4"
     Models(4)="WHAu_5"
     Models(5)="WHAu_6"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.SplinterASleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_STG44Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROSTG44AmmoPouch')
     Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Headgear(0)=Class'DH_GerPlayers.DH_HeerHelmetCover'
     Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetNoCover'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     Limit=4
}

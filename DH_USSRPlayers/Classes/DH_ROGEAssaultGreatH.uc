//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROGEAssaultGreatH extends DH_ROGE_Heer_Greatcoat;

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
     PluralName="Assault Troops"
     InfoText="The assault trooper is a specialized infantry class who is tasked with closing with the enemy and eliminating him from difficult positions such as houses and fortifications.  The assault trooper is generally better armed than most infantrymen."
     menuImage=Texture'InterfaceArt_tex.SelectMenus.Stosstruppe'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
     Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Headgear(0)=Class'DH_GerPlayers.DH_HeerHelmetThree'
     Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetTwo'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=True
     limit=4
}

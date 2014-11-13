//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WSSAssault_Autumn extends DH_WaffenSSAutumn;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
        return Headgear[0];
    else
        return Headgear[1];
}

defaultproperties
{
     MyName="Assault Trooper"
     AltName="Stoßtruppe"
     Article="an "
     PluralName="Assault Troopers"
     InfoText="The assault trooper is a specialized infantry class who is tasked with closing with the enemy and eliminating him from difficult positions such as houses and fortifications.  The assault trooper is generally better armed than most infantrymen."
     MenuImage=Texture'DHGermanCharactersTex.Icons.WSS_Ass'
     Models(0)="SSA_1"
     Models(1)="SSA_2"
     Models(2)="SSA_3"
     Models(3)="SSA_4"
     Models(4)="SSA_5"
     Models(5)="SSA_6"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_STG44Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROSTG44AmmoPouch')
     PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
     Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Headgear(0)=class'DH_GerPlayers.DH_SSHelmetCover'
     Headgear(1)=class'DH_GerPlayers.DH_SSHelmetNoCover'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     Limit=4
}

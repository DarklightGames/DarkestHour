//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_LWSquadLeader extends DH_LuftwaffeFlak;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
        return Headgear[0];
    else
        return Headgear[1];
}

defaultproperties
{
     bIsSquadLeader=true
     MyName="Squad Leader"
     AltName="Gruppenführer"
     Article="a "
     PluralName="Squad Leaders"
     InfoText="Gruppenführer||The Gruppenführer is the leader of the squad - an NCO by rank.  His job is to see to the completion of the squad's objectives by directing his men in combat and ensuring the LMG's firepower is put to good use.  Equipped for close quarters combat, the Gruppenführer is better off directing the squad's firepower at longer ranges than engaging himself.||* The Gruppenführer counts one and a half times when taking and holding objectives."
     MenuImage=Texture'InterfaceArt_tex.SelectMenus.Gruppenfuhrer'
     Models(0)="WL_1"
     Models(1)="WL_2"
     Models(2)="WL_3"
     Models(3)="WL_4"
     bIsLeader=true
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
     PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_G43Weapon',Amount=9,AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
     SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
     Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Grenades(1)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
     Grenades(2)=(Item=class'DH_Equipment.DH_OrangeSmokeWeapon',Amount=1)
     Headgear(0)=class'DH_GerPlayers.DH_LWHelmet'
     Headgear(1)=class'DH_GerPlayers.DH_LWHelmetTwo'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     Limit=2
}

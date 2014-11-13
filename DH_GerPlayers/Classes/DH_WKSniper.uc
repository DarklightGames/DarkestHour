//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WKSniper extends DH_Kriegsmarine;

defaultproperties
{
     MyName="Sniper"
     AltName="Scharfschütze"
     Article="a "
     PluralName="Snipers"
     InfoText="Scharfschütze - Difficulty: Medium||The Scharfschütze is a specialist in the area of marksmanship and camouflage.  He operated separately from the infantry platoon until 1944 - acting as a lone wolf until then so to speak.  Identifying and eliminating important enemy personnel is his job.  The Scharfschütze is effective at long range - especially when hidden, but he has little means to protect himself up close.  If spotted, it is best that he slip away quietly rather than face a direct confrontation."
     MenuImage=Texture'InterfaceArt_tex.SelectMenus.Scharf'
     Models(0)="WK_1"
     Models(1)="WK_2"
     Models(2)="WK_3"
     Models(3)="WK_4"
     SleeveTexture=Texture'Weapons1st_tex.Arms.german_sleeves'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98ScopedWeapon',Amount=18,AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
     PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_G43ScopedWeapon',Amount=6)
     SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
     SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
     Headgear(0)=class'DH_GerPlayers.DH_KriegsmarineHelmet'
     PrimaryWeaponType=WT_Sniper
     Limit=1
}

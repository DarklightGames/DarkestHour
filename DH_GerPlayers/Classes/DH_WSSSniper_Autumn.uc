//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WSSSniper_Autumn extends DH_WaffenSSAutumn;

defaultproperties
{
     MyName="Sniper"
     AltName="Scharfschütze"
     Article="a "
     PluralName="Snipers"
     InfoText="The sniper is tasked with the specialized goal of eliminating key hostile units and shaking enemy morale through careful marksmanship and fieldcraft.  Through patient observation, the sniper is also capable of providing valuable reconnaissance which can have a significant impact on the outcome of the battle."
     MenuImage=Texture'DHGermanCharactersTex.Icons.WSS_Sniper'
     Models(0)="SSA_1"
     Models(1)="SSA_2"
     Models(2)="SSA_3"
     Models(3)="SSA_4"
     Models(4)="SSA_5"
     Models(5)="SSA_6"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98ScopedWeapon',Amount=18,AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
     PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_G43ScopedWeapon',Amount=6)
     SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
     SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
     Headgear(0)=class'DH_GerPlayers.DH_SSHelmetCover'
     PrimaryWeaponType=WT_Sniper
     Limit=2
}

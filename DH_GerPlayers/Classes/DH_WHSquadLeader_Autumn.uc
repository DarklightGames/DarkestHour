//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WHSquadLeader_Autumn extends DH_HeerAutumn;

defaultproperties
{
    bIsSquadLeader=true
    MyName="Squad Leader"
    AltName="Unteroffizier"
    Article="a "
    PluralName="Squad Leaders"
    MenuImage=texture'DHGermanCharactersTex.Icons.WH_SqL'
    Models(0)="WHAu_1"
    Models(1)="WHAu_2"
    Models(2)="WHAu_3"
    Models(3)="WHAu_4"
    Models(4)="WHAu_5"
    Models(5)="WHAu_6"
    bIsLeader=true
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.SplinterASleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
    Grenades(2)=(Item=class'DH_Equipment.DH_OrangeSmokeWeapon',Amount=1)
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetCover'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetNoCover'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=2
}

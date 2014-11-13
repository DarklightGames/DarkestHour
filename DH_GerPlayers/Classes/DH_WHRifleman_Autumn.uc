//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WHRifleman_Autumn extends DH_HeerAutumn;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
        return Headgear[0];
    else
        return Headgear[1];
}

defaultproperties
{
     MyName="Rifleman"
     AltName="Schütze"
     Article="a "
     PluralName="Riflemen"
     InfoText="The rifleman is the basic soldier of the battlefield that is tasked with the important role of capturing and holding objectives, as well as the defense of key positions. Armed with the standard-issue battle rifle, the rifleman's efficiency is determined by his ability to work as a member of a larger unit."
     MenuImage=Texture'InterfaceArt_tex.SelectMenus.Schutze'
     Models(0)="WHAu_1"
     Models(1)="WHAu_2"
     Models(2)="WHAu_3"
     Models(3)="WHAu_4"
     Models(4)="WHAu_5"
     Models(5)="WHAu_6"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.SplinterASleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
     Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Headgear(0)=Class'DH_GerPlayers.DH_HeerHelmetCover'
     Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetNoCover'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WSSRifleman_Autumn extends DH_WaffenSSAutumn;

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
     MenuImage=Texture'DHGermanCharactersTex.Icons.WSS_k98'
     Models(0)="SSA_1"
     Models(1)="SSA_2"
     Models(2)="SSA_3"
     Models(3)="SSA_4"
     Models(4)="SSA_5"
     Models(5)="SSA_6"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
     Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Headgear(0)=class'DH_GerPlayers.DH_SSHelmetCover'
     Headgear(1)=class'DH_GerPlayers.DH_SSHelmetNoCover'
}

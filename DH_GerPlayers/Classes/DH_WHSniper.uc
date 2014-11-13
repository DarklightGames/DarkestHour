//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WHSniper extends DH_Heer;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
        return Headgear[0];
    else
        return Headgear[1];
}

defaultproperties
{
     MyName="Sniper"
     AltName="Scharfschütze"
     Article="a "
     PluralName="Snipers"
     InfoText="The sniper is tasked with the specialized goal of eliminating key hostile units and shaking enemy morale through careful marksmanship and fieldcraft.  Through patient observation, the sniper is also capable of providing valuable reconnaissance which can have a significant impact on the outcome of the battle."
     MenuImage=Texture'InterfaceArt_tex.SelectMenus.Scharf'
     Models(0)="WH_1"
     Models(1)="WH_2"
     Models(2)="WH_3"
     Models(3)="WH_4"
     SleeveTexture=Texture'Weapons1st_tex.Arms.german_sleeves'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98ScopedWeapon',Amount=18,AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
     SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
     SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
     Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
     Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
     PrimaryWeaponType=WT_Sniper
     Limit=2
}

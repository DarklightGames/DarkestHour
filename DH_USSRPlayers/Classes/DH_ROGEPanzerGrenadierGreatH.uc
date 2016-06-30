//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROGEPanzerGrenadierGreatH extends DH_ROGE_Heer_Greatcoat;

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
    MyName="Panzer Grenadier"
    AltName="Panzergrenadier"
    Article="an "
    PluralName="Panzer Grenadiers"
    InfoText=""
    menuImage=Texture'InterfaceArt_tex.SelectMenus.Pak-soldat'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    GivenItems(0)="DH_ATWeapons.DH_PanzerFaustWeapon"
    Headgear(0)=Class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
    PrimaryWeaponType=WT_SMG
    limit=2
    bCarriesATAmmo=false
}

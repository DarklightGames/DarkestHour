//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_StandardFireteamLeader extends DH_ROSU_RKK_Standard;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
    {
        if (FRand() < 0.5)
        {
            return Headgear[2];
        }
        else
        {
            return Headgear[1];
        }
    }
    else
    {
        return Headgear[0];
    }
}

defaultproperties
{
    MyName="Fireteam Leader"
    AltName="Komandir zvena"
    Article="a "
    PluralName="Fireteam Leaders"
    PrimaryWeaponType=WT_SemiAuto
    PrimaryWeapons(0)=(Item=class'DH_ROWeapons.DH_SVT40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')
    Grenades(0)=(Item=class'DH_ROWeapons.DH_F1GrenadeWeapon',Amount=2)
    Headgear(0)=class'DH_ROPlayers.DH_ROSovietSidecap'
    Headgear(1)=class'DH_ROPlayers.DH_ROSovietSidecap'
    Headgear(2)=class'DH_ROPlayers.DH_ROSovietSidecap'
    InfoText="The fireteam leader is the NCO tasked to coordinate his team's movement in accordance with the squad's objective. As the direct assistant to the squad leader, he is expected to provide a comparable level of support to his men."
    MenuImage=Texture'InterfaceArt_tex.SelectMenus.Strelokavto'
    limit=2
}

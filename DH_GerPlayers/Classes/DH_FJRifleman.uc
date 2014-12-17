//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_FJRifleman extends DH_FJ;

function class<ROHeadgear> GetHeadgear()
{
    local int RandNum;
    RandNum = Rand(3);

    switch (RandNum)
    {
        case 0:
             return Headgear[0];
        case 1:
             return Headgear[1];
        case 2:
             return Headgear[2];
        default:
             return Headgear[0];
    }
}

defaultproperties
{
    MyName="Rifleman"
    AltName="Schütze"
    Article="a "
    PluralName="Riflemen"
    InfoText="The rifleman is the basic soldier of the battlefield that is tasked with the important role of capturing and holding objectives, as well as the defense of key positions. Armed with the standard-issue battle rifle, the rifleman's efficiency is determined by his ability to work as a member of a larger unit."
    MenuImage=texture'DHGermanCharactersTex.Icons.FJ_k98'
    Models(0)="FJ1"
    Models(1)="FJ2"
    Models(2)="FJ3"
    Models(3)="FJ4"
    Models(4)="FJ5"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',Amount=18)
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
    Headgear(0)=class'DH_GerPlayers.DH_FJHelmetCamo1'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmetCamo2'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNet1'
}

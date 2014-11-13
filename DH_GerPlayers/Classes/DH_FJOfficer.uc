//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_FJOfficer extends DH_FJ;

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
     bIsArtilleryOfficer=true
     MyName="Artillery Officer"
     AltName="Artillerieoffizier"
     Article="a "
     PluralName="Artillery Officers"
     InfoText="The artillery officer is tasked with directing artillery fire upon the battlefield through the use of long-range observation. Coordinating his efforts with a radio operator, he is able to target locations for off-grid artillery to lay down a  barrage with devastating effect."
     MenuImage=Texture'DHGermanCharactersTex.Icons.FJ_Off'
     Models(0)="FJO1"
     Models(1)="FJO2"
     Models(2)="FJO3"
     Models(3)="FJO4"
     Models(4)="FJO5"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_G43Weapon',Amount=9,AssociatedAttachment=Class'ROInventory.ROG43AmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
     SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_GerArtyBinocularsItem"
     Headgear(0)=Class'DH_GerPlayers.DH_FJHelmetCamo1'
     Headgear(1)=Class'DH_GerPlayers.DH_FJHelmetCamo2'
     Headgear(2)=Class'DH_GerPlayers.DH_FJHelmetNet1'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     Limit=1
}

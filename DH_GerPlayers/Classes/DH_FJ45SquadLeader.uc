// *************************************************************************
//
//	***   FJ Squad Leader   ***
//
// *************************************************************************
class DH_FJ45SquadLeader extends DH_FJ_1945;

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
     bIsSquadLeader=True
     MyName="Squad Leader"
     AltName="Unteroffizier"
     Article="a "
     PluralName="Squad Leaders"
     InfoText="The squad leader is tasked with overseeing the completion of the squad's objectives by directing his men in combat and ensuring the overall firepower is put to good use.  With the effective use of smoke and close-quarters weaponry, the squad leader's presence is an excellent force multiplier to the units under his command."
     menuImage=Texture'DHGermanCharactersTex.Icons.FJ_SqL'
     Models(0)="FJ451"
     Models(1)="FJ452"
     Models(2)="FJ453"
     Models(3)="FJ454"
     Models(4)="FJ455"
     bIsLeader=True
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_STG44Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROSTG44AmmoPouch')
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
     PrimaryWeapons(2)=(Item=Class'DH_Weapons.DH_G43Weapon',Amount=9,AssociatedAttachment=Class'ROInventory.ROG43AmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
     SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
     Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Grenades(1)=(Item=Class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
     Grenades(2)=(Item=Class'DH_Equipment.DH_OrangeSmokeWeapon',Amount=1)
     Headgear(0)=Class'DH_GerPlayers.DH_FJHelmet1'
     Headgear(1)=Class'DH_GerPlayers.DH_FJHelmet2'
     Headgear(2)=Class'DH_GerPlayers.DH_FJHelmetNet1'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=True
     limit=1
     Limit33to44=2
     LimitOver44=2
}

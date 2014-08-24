// *************************************************************************
//
//  ***   DH_LWGunner   ***
//
// *************************************************************************

class DH_LWGunner extends DH_LuftwaffeFlak;

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
     MyName="Machine-Gunner"
     AltName="Maschinengewehrschütze"
     Article="a "
     PluralName="Machine-Gunners"
     InfoText="MG-Schütze||Armed with a light machine gun, the MG-Schütze provides the squad with its primary source of firepower.  The LMG can deliver insurmountable damage to the enemy, but careful use is required to avoid overheating or wasting ammunition.  Since the LMG is not a close combat weapon, the MG-Schütze also requires protection from his squad.  With intelligent use, a spotter, and sufficient ammo reserves, the MG-Schütze can keep the enemy at bay almost indefinitely.||Loadout: MG34, P38|* The MG-Schütze can bring the LMG into action more quickly than others as well as handle barrel changes; a leader spotting for him will increase his accuracy."
     menuImage=Texture'InterfaceArt_tex.SelectMenus.MG-Schutze'
     Models(0)="WL_1"
     Models(1)="WL_2"
     Models(2)="WL_3"
     Models(3)="WL_4"
     bIsGunner=true
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MG42Weapon',Amount=6)
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_MG34Weapon',Amount=6)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
     Headgear(0)=Class'DH_GerPlayers.DH_LWHelmet'
     Headgear(1)=Class'DH_GerPlayers.DH_LWHelmetTwo'
     PrimaryWeaponType=WT_LMG
     limit=3
}

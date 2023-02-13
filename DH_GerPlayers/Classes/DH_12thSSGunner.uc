//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_12thSSGunner extends DHGEMachineGunnerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_German12thSSPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.12thSS_Sleeve'
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetTwo'

    SecondaryWeapons(2)=(Item=class'DH_Weapons.DH_C96Weapon')
}

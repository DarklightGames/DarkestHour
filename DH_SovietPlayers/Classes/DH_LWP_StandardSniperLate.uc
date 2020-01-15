//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_LWP_StandardSniperLate extends DHPOLSniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicEarlyPawn',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_SovietSidecap'
	
	//to do: proper LWP uniform
	//Wojsko Polskie did use red army uniform, but they also (at least occisionally) used elements of polish uniform, and most importantly, used their own insignia (their own collartabs)
	//in the future there should at least be polish collartabs and polish army cap
	//for now, early soviet tunic resembles LWP the most, and incorrect insignia is somewhat covered by folded greatcoat

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130ScopedWeapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_SVT40Weapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_G43Weapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')
}

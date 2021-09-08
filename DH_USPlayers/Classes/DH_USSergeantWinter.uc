//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_USSergeantWinter extends DHUSSergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_USPlayers.DH_USTrenchcoatScarfPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_USPlayers.DH_USWinterScarfPawn',Weight=1.0)
    RolePawns(2)=(PawnClass=class'DH_USPlayers.DH_USTrenchcoatPawn',Weight=0.6)
    RolePawns(3)=(PawnClass=class'DH_USPlayers.DH_USWinterPawn',Weight=0.3)
    HeadgearProbabilities(0)=0.2
    Headgear(0)=class'DH_USPlayers.DH_AmericanWinterWoolHat'
    HeadgearProbabilities(1)=0.4
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmetWinter'
    HeadgearProbabilities(2)=0.4
    Headgear(2)=class'DH_USPlayers.DH_AmericanHelmet1stNCOa'
    
    HandType=Hand_Gloved
    GlovedHandTexture=Texture'DHUSCharactersTex.Gear.hands_USgloves'
    BareHandTexture=Texture'DHUSCharactersTex.Gear.hands_USgloves'
    CustomHandTexture=Texture'DHUSCharactersTex.Gear.hands_USgloves'
}

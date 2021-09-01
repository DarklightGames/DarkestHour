//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_USMortarObserverAutumn extends DHUSMortarObserverRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_USPlayers.DH_USWinterPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_USPlayers.DH_USTrenchcoatPawn',Weight=1.0)
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet1stEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet1stEMb'
    
    HandType=Hand_Gloved
    GlovedHandTexture=Texture'DHUSCharactersTex.Gear.hands_USgloves'
    BareHandTexture=Texture'DHUSCharactersTex.Gear.hands_USgloves'
    CustomHandTexture=Texture'DHUSCharactersTex.Gear.hands_USgloves'
}

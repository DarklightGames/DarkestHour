//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RKKA_Snow extends DH_Soviet_Units
      abstract;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietSnowPawn',Weight=1.0)
    SleeveTexture=texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
    DetachedArmClass=class'ROEffects.SeveredArmSovSnow'
    DetachedLegClass=class'ROEffects.SeveredLegSovSnow'
}

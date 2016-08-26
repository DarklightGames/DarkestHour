//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_Snow extends DH_ROSU_RKK
      abstract;

defaultproperties
{
    SleeveTexture=texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
    DetachedArmClass=class'ROEffects.SeveredArmSovSnow'
    DetachedLegClass=class'ROEffects.SeveredLegSovSnow'
    RolePawnClass="DH_RUPlayers.DH_RUWinterPawn"
    Models(0)="RUWinter1"
    Models(1)="RUWinter2"
    Models(2)="RUWinter3"
    Models(3)="RUWinter4"
}

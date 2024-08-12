//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHNation_Germany extends DHNation;

defaultproperties
{
    NationName="Germany"
    NativeNationName="Deutschland"
    VoicePackClass=class'DH_GerPlayers.DHGerVoice'
    RallyPointStaticMeshActive=StaticMesh'DH_Construction_stc.Backpacks.GER_backpack_established'
    RallyPointStaticMesh=StaticMesh'DH_Construction_stc.Backpacks.GER_backpack'
    InfantryResupplyStaticMesh=StaticMesh'DH_Construction_stc.Ammo.DH_Ger_ammo_box'
    PlatoonHQClass=class'DHConstruction_PlatoonHQ_Germany'
    SupplyCacheClass=class'DHConstruction_SupplyCache_Germany'
    DeployMenuFlagTexture=Material'DH_GUI_tex.DeployMenu.flag_germany'
    GrenadeCrateClass=class'DH_Weapons.DH_StielGranateSpawner'
    MapFlagIconSpriteWidget=(WidgetTexture=Texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=0,Y1=32,X2=31,Y2=63),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    DefaultSquadNames(0)="Anton"
    DefaultSquadNames(1)="Berta"
    DefaultSquadNames(2)="Caesar"
    DefaultSquadNames(3)="Dora"
    DefaultSquadNames(4)="Emil"
    DefaultSquadNames(5)="Fritz"
    DefaultSquadNames(6)="Gustav"
    DefaultSquadNames(7)="Heinrich"
    RoundStartSound=Sound'DH_SundrySounds.RoundBeginSounds.Axis_Start'
    SupplyTruckClass=class'DH_Vehicles.DH_OpelBlitzSupport'
}

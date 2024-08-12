//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHNation_Czechoslovakia extends DHNation;

defaultproperties
{
    NationName="Czechoslovakia"
    VoicePackClass=class'DH_SovietPlayers.DHCzechVoice'
    SupplyCacheClass=class'DHConstruction_SupplyCache_Czecholovakia'
    RallyPointStaticMeshActive=StaticMesh'DH_Construction_stc.Backpacks.CS_backpack_established'
    RallyPointStaticMesh=StaticMesh'DH_Construction_stc.Backpac1ks.CS_backpack'
    InfantryResupplyStaticMesh=StaticMesh'DH_Construction_stc.Ammo.DH_Soviet_ammo_box'
    PlatoonHQClass=class'DHConstruction_PlatoonHQ_Czechoslovakia'
    DeployMenuFlagTexture=Material'DH_GUI_tex.DeployMenu.flag_czechoslovakia'
    GrenadeCrateClass=class'DH_Weapons.DH_F1GrenadeSpawner'
    MapFlagIconSpriteWidget=(WidgetTexture=Texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=96,Y1=32,X2=127,Y2=63),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    DefaultSquadNames(0)="Adam"
    DefaultSquadNames(1)="Bozena"
    DefaultSquadNames(2)="Cyril"
    DefaultSquadNames(3)="David"
    DefaultSquadNames(4)="Emil"
    DefaultSquadNames(5)="Frantisek"
    DefaultSquadNames(6)="Gustav"
    DefaultSquadNames(7)="Helena"
    RoundStartSound= Sound'DH_SundrySounds.RoundBeginSounds.Soviet_Start'
    SupplyTruckClass=class'DH_Vehicles.DH_GMCTruckSupport'
}

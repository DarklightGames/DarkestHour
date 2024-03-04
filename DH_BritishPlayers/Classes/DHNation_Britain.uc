//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHNation_Britain extends DHNation;

defaultproperties
{
    NationName="Great Britain"
    VoicePackClass=class'DH_BritishPlayers.DHBritishVoice'
    SupplyCacheStaticMesh=StaticMesh'DH_Construction_stc.Supply_Cache.USA_Supply_cache_full'
    RallyPointStaticMeshActive=StaticMesh'DH_Construction_stc.Backpacks.BRIT_backpack_established'
    RallyPointStaticMesh=StaticMesh'DH_Construction_stc.Backpacks.BRIT_backpack'
    InfantryResupplyStaticMesh=StaticMesh'DH_Construction_stc.Ammo.DH_Commonwealth_ammo_box'
    PlatoonHQClass=class'DHConstruction_PlatoonHQ_Britain'
    DeployMenuFlagTexture=Material'DH_GUI_tex.DeployMenu.flag_uk'
    GrenadeCrateClass=class'DH_Weapons.DH_MillsBombSpawner'
    MapFlagIconSpriteWidget=(WidgetTexture=Texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=64,Y1=0,X2=95,Y2=31),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    DefaultSquadNames(0)="Able"
    DefaultSquadNames(1)="Baker"
    DefaultSquadNames(2)="Charlie"
    DefaultSquadNames(3)="Dog"
    DefaultSquadNames(4)="Easy"
    DefaultSquadNames(5)="Fox"
    DefaultSquadNames(6)="George"
    DefaultSquadNames(7)="How"
    RoundStartSound= Sound'DH_SundrySounds.RoundBeginSounds.Commonwealth_Start'
    SupplyTruckClass=class'DH_Vehicles.DH_GMCTruckSupport'
}

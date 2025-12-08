//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHNation_Romania extends DHNation;

defaultproperties
{
    NationName="Kingdom of Romania"
    NativeNationName="Regatul României"  
    VoicePackClass=class'DH_RomPlayers.DHRomaniaVoice'
    SupplyCacheStaticMesh=StaticMesh'DH_Construction_stc.Supply_Cache.GER_Supply_cache_full'
    PlatoonHQFlagTexture=Texture'DH_Construction_tex.Base.ROMANIA_flag_01'
    RallyPointStaticMeshActive=StaticMesh'DH_Construction_stc.Backpacks.ROM_backpack_established'
    RallyPointStaticMesh=StaticMesh'DH_Construction_stc.Backpacks.ROM_backpack'
    InfantryResupplyStaticMesh=StaticMesh'DH_Construction_stc.Ammo.DH_Ger_ammo_box'
    PlatoonHQConstructedStaticMesh=StaticMesh'DH_Construction_stc.Bases.GER_HQ_tent'
    PlatoonHQBrokenStaticMesh=StaticMesh'DH_Construction_stc.Bases.GER_HQ_tent_destroyed'
    PlatoonHQUnpackedStaticMesh=StaticMesh'DH_Construction_stc.Bases.GER_HQ_tent_unpacked'
    PlatoonHQTatteredStaticMesh=StaticMesh'DH_Construction_stc.Bases.GER_HQ_tent_light_destro'
    DeployMenuFlagTexture=Material'DH_GUI_tex.DeployMenu.flag_germany'
    GrenadeCrateClass=class'DH_Weapons.DH_StielGranateSpawner'  //strictly this is not wrong, as they were supplied with german grenades
                                                     //ideally, however, they should get their own eventually
    MapFlagIconSpriteWidget=(WidgetTexture=Texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=0,Y1=32,X2=31,Y2=63),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    DefaultSquadNames(0)="Ana"  // i am not sure if these are accurate to ww2 use, should be verified
    DefaultSquadNames(1)="Barbu"
    DefaultSquadNames(2)="Constantin"
    DefaultSquadNames(3)="Dumitru"
    DefaultSquadNames(4)="Elena"
    DefaultSquadNames(5)="Florea"
    DefaultSquadNames(6)="Gheorghe"
    DefaultSquadNames(7)="Haralambie"
    HealthFigureClass=class'DH_RomPlayers.DHHealthFigure_Romania'
    RoundStartSound= Sound'DH_SundrySounds.RoundBeginSounds.Axis_Start'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHNation_Czechoslovakia extends DHNation;

defaultproperties
{
    NationName="Czechoslovakia"
    VoicePackClass=class'DH_SovietPlayers.DHCzechVoice'
    SupplyCacheStaticMesh=StaticMesh'DH_Construction_stc.Supply_Cache.USA_Supply_cache_full'
    PlatoonHQFlagTexture=Texture'DH_Construction_tex.Base.CS_flag_01'
    RallyPointStaticMeshActive=StaticMesh'DH_Construction_stc.Backpacks.CS_backpack_established'
    RallyPointStaticMesh=StaticMesh'DH_Construction_stc.Backpac1ks.CS_backpack'
    InfantryResupplyStaticMesh=StaticMesh'DH_Construction_stc.Ammo.DH_Soviet_ammo_box'
    PlatoonHQConstructedStaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent'
    PlatoonHQBrokenStaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent_destroyed'
    PlatoonHQUnpackedStaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent_unpacked'
    PlatoonHQTatteredStaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent_light_destro'
    DeployMenuFlagTexture=Material'DH_GUI_tex.DeployMenu.flag_czechoslovakia'
    GrenadeCrateClass=class'DH_Weapons.DH_F1GrenadeSpawner'
    MapFlagIconSpriteWidget=(WidgetTexture=Texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=96,Y1=32,X2=127,Y2=63),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
    DefaultSquadNames(0)="Almaz"
    DefaultSquadNames(1)="Berezka"
    DefaultSquadNames(2)="Vostok"
    DefaultSquadNames(3)="Grach"
    DefaultSquadNames(4)="Dub"
    DefaultSquadNames(5)="Yenisey"
    DefaultSquadNames(6)="Zvezda"
    DefaultSquadNames(7)="Iskra"
    HealthFigureClass=class'DH_SovietPlayers.DHHealthFigure_USSR'
    RoundStartSound= Sound'DH_SundrySounds.RoundBeginSounds.Soviet_Start'
}
//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHNation_USSR extends DHNation;

defaultproperties
{
    NationName="Union of Soviet Socialist Republics"
    VoicePackClass=class'DH_SovietPlayers.DHSovietVoice'
    SupplyCacheStaticMesh=StaticMesh'DH_Construction_stc.Supply_Cache.USA_Supply_cache_full'
    PlatoonHQFlagTexture=Texture'DH_Construction_tex.Base.SOVIET_flag_01'
    RallyPointStaticMeshActive=StaticMesh'DH_Construction_stc.Backpacks.RUS_backpack_established'
    RallyPointStaticMesh=StaticMesh'DH_Construction_stc.Backpacks.RUS_backpack'
    InfantryResupplyStaticMesh=StaticMesh'DH_Construction_stc.Ammo.DH_Soviet_ammo_box'
    PlatoonHQConstructedStaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent'
    PlatoonHQBrokenStaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent_destroyed'
    PlatoonHQUnpackedStaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent_unpacked'
    PlatoonHQTatteredStaticMesh=StaticMesh'DH_Construction_stc.Bases.USA_HQ_tent_light_destro'
    DeployMenuFlagTexture=Material'DH_GUI_tex.DeployMenu.flag_ussr'
    GrenadeCrateClass=class'DH_Weapons.DH_F1GrenadeSpawner'
    MapFlagIconSpriteWidget=(WidgetTexture=Texture'DH_GUI_Tex.overheadmap_flags',RenderStyle=STY_Alpha,TextureCoords=(X1=32,Y1=32,X2=63,Y2=63),TextureScale=0.05,DrawPivot=DP_MiddleMiddle,ScaleMode=SM_Left,Scale=1.0,Tints[0]=(R=255,G=255,B=255,A=255),Tints[1]=(R=255,G=255,B=255,A=255))
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

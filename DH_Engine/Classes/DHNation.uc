//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHNation extends Object
    abstract;

// Name
var localized string            NationName;
var string                      NativeNationName;

var Texture                     FlagIconTexture;        // The icon used for the nation on the map.
var Texture                     TeamSelectTexture;      // TODO: set this up on the team select page!

var class<DHVoicePack>          VoicePackClass;

var class<DHConstruction>       InfantryResupplyClass;

var class<DHConstructionLoadout>    DefaultConstructionLoadoutClass;

// TODO: move these to classes as well.
// Rally Point
var StaticMesh                  RallyPointStaticMesh;
var StaticMesh                  RallyPointStaticMeshActive;

// Flags
var Material                    DeployMenuFlagTexture;
var HudBase.SpriteWidget        MapFlagIconSpriteWidget;

// Squads
var string                      DefaultSquadNames[8];

var Sound                       RoundStartSound;

// Supply
var class<DHVehicle>            SupplyTruckClass;

defaultproperties
{
}

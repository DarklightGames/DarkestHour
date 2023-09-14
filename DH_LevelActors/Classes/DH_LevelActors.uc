//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_LevelActors extends Actor
    hidecategories(Collision,Lighting,LightColor,Karma,Force,Advanced,Sound)
    placeable;

//Setup some common enums used throughout the child actors
enum ROSideIndex
{
    AXIS,
    ALLIES,
    NEUTRAL //Either side can use this vehicle
};

enum NumModifyType
{
    NMT_Add,
    NMT_Subtract,
    NMT_Set //Will set the value instead of modify it
};

enum StatusModifyType
{
    SMT_Activate,
    SMT_Deactivate,
    SMT_Toggle //Will toggle the status
};

defaultproperties
{
    Texture=Texture'DHEngine_Tex.LevelActor'
    bHidden=true
    RemoteRole=ROLE_None
}

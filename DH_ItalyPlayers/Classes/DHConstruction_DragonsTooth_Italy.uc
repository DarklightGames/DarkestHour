//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_DragonsTooth_Italy extends DHConstruction_DragonsTooth;

defaultproperties
{
    // Construction and Display
    StaticMesh=StaticMesh'DH_Construction_stc.IT_DragonTeeth_build'
    TatteredStaticMesh=StaticMesh'DH_Construction_stc.IT_DragonTeeth_dam'
    Stages(0)=(Progress=0,StaticMesh=StaticMesh'DH_Construction_stc.IT_DragonTeeth_prebuild',Sound=none,Emitter=none)

    PlacementOffset=(Z=-3)
    bShouldAlignToGround=true
    bAcceptsProjectors=true
}

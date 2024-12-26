//=============================================================================
// GrenadeMark
//=============================================================================
// A new blast texture for grenades
//=============================================================================
// Darkest Hour 
// Copyright (C) 2003 John "Ramm-Jaeger" Gibson / Adjusted by Matty
//=============================================================================


class DHGrenadeMark extends DHBlastMark;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
	DrawScale=0.5
	bGameRelevant=true
	PushBack=24
	LifeSpan=30
	FOV=1
	MaxTraceDistance=60
	bProjectBSP=true
	bProjectTerrain=true
	bProjectStaticMesh=true
	bProjectActor=false
}

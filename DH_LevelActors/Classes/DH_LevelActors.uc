// class: DH_LevelActors
// Auther: Theel
// Date: 11-07-10
// Purpose:
// Serves as the base class for most Actors within the package
// Problems/Limitations:
// Hides some catorgories, if they are needed the child actor needs to show the category itself

class DH_LevelActors extends Actor
	hidecategories(Object,Movement,Collision,Lighting,LightColor,Karma,Force,Display,Advanced,Sound)
	placeable;

//Setup some common enums used throughout the child actors
enum ROSideIndex
{
	AXIS,
	ALLIES,
	NEUTRAL	//Either side can use this vehicle
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
     bHidden=true
     RemoteRole=ROLE_none
}

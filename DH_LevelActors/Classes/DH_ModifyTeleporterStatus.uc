// class: DH_ModifyTeleporterStatus
// Auther: Theel
// Date: 10-03-10
// Purpose:
// Ability to activate, deactivate, and change destination of a teleporter based on event.
// Problems/Limitations:
// none known

class DH_ModifyTeleporterStatus extends DH_ModifyActors;

var()	array<name>			TeleportersToModify;
var		array<teleporter>	TeleReferences;
var()	string				NewURL; // if set will change the URL of the teleporter
var()	bool				UseRandomness;
var()	int 				RandomPercent; // 100 for always succeed, 0 for always fail
var()	enum	HTModify
{
	HTM_Activate,
	HTM_Deactivate,
	HTM_Toggle,
	HTM_Set
}							HowToModify; // How to modify teleporter

function PostBeginPlay()
{
	local int			i;
	local Teleporter	Tele;

	super.PostBeginPlay();

	for(i=0; i<TeleportersToModify.Length; i++)
	{
		foreach AllActors(class'Teleporter', Tele, TeleportersToModify[i])
		{
			TeleReferences.Insert(0,1); //Adds a new spot at index for the attached tele
			TeleReferences[0] = Tele; //Sets the attached tele in the reference array
			break;
		}
	}
}

event Trigger(Actor Other, Pawn EventInstigator)
{
	local int RandomNum, i;

	if(UseRandomness)
	{
		RandomNum = Rand(101);  //Gets a random # between 0 & 100
		if(RandomPercent <= RandomNum)
			return; //Leave script randomly failed
	}
	// RandomPercentToFail was not higher than randomnum
	switch(HowToModify)
	{
		case HTM_Activate: //Because SpawnCount goes up, to add reinforcements you must subtract from SpawnCount
			for(i=0;i<TeleReferences.Length;i++){
				TeleReferences[i].bEnabled = true;
			}
		break;
		case HTM_Deactivate:
			for(i=0;i<TeleReferences.Length;i++){
				TeleReferences[i].bEnabled = false;
			}
		break;
		case HTM_Toggle:
			for(i=0;i<TeleReferences.Length;i++){
				TeleReferences[i].bEnabled = !TeleReferences[i].bEnabled;
			}
		break;
		case HTM_Set:
			for(i=0;i<TeleReferences.Length;i++){
				TeleReferences[i].URL = NewURL;
			}
		break;
		default:
		break;
	}
}

defaultproperties
{
}

// class: DH_FindAndPassPawn
// Auther: Theel
// Date: 9-28-10
// Purpose:
// Can be used to capture a pawn's reference and pass it to a watch actor
// Problems/Limitations:
// Only supports proximity and factory tag.  Also it is forced to use a delay (5 seconds) before finding the pawn

class DH_FindAndPassPawn extends DH_LevelActors
	showcategories(Collision,Advanced);

enum FindType
{
	FT_ClassProximity,
	FT_TagProximity,
	FT_Factory,
};

//var	int			DelayTimeBeforeFind; //does this need to be variable?
var()	FindType				HowToFind;
var()	name					TagToFind;
var()	array<class<Pawn> >		PawnClassToFind;
var()	name					VehicleFactoryTag;
var		ROVehicleFactory		VehicleFactoryRef;
var()	name					CatchActorTag;
var		DH_CatchAndWatchPawn	CatchActorRef;

function PostBeginPlay()
{
	//can use dynamic actors?
	foreach allactors(class'DH_CatchAndWatchPawn', CatchActorRef, CatchActorTag)
		break;

	foreach allactors(class'ROVehicleFactory', VehicleFactoryRef, VehicleFactoryTag)
		break;
}

function Reset()
{
	GoToState('DelayBeforeFind');
}

auto state DelayBeforeFind
{
	function BeginState()
	{
		SetTimer(5, false);
	}
	function Timer()
	{
		switch(HowToFind)
		{
			case FT_ClassProximity:
				GoToState('FindClass');
			break;
			case FT_TagProximity:
				GoToState('FindTag');
			break;
			case FT_Factory:
				GoToState('FindFactory');
			break;
		}
	}
}

state FindClass
{
	event Touch( Actor Other )
	{
		local int 			i;

		if(Pawn(Other) == None)
			return;

		for(i=0; i<PawnClassToFind.Length; i++)
		{
			if(Other.IsA(PawnClassToFind[i].Name))
			{
       			//Other is of type to find and we need to pass it and goto passed
				CatchActorRef.PassPawnRef(Pawn(Other));
				gotostate('Passed');
			}
		}
	}
}

state FindTag
{
	event Touch( Actor Other )
	{
		if(Pawn(Other) == None)
			return;

		if(Pawn(Other).Tag == TagToFind)
		{
			//we have a matching tag this is the pawn we want!
			CatchActorRef.PassPawnRef(Pawn(Other));
			gotostate('Passed');
		}
	}
}

state FindFactory
{
	function BeginState()
	{
		if(VehicleFactoryRef.LastSpawnedVehicle != None && VehicleFactoryRef.LastSpawnedVehicle.Health >= 0)
		{
			CatchActorRef.PassPawnRef(VehicleFactoryRef.LastSpawnedVehicle);
			gotostate('Passed');
		}
	}
}

state Passed
{
}

defaultproperties
{
}

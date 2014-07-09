//-----------------------------------------------------------
// DH_BazookaAmmoMsg 
//-----------------------------------------------------------
class DH_BazookaAmmoMsg extends LocalMessage;

var(Messages) localized string RocketLoaded;


static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)

{
	switch(Switch)
	{
    		case 0:
        			return default.RocketLoaded;

    		default:
	    		return default.RocketLoaded;
	}
}

defaultproperties
{
     RocketLoaded="Rocket Loaded"
     bIsUnique=True
     bIsConsoleMessage=False
     Lifetime=2
     PosX=0.280000
     PosY=0.930000
     FontSize=-2
}

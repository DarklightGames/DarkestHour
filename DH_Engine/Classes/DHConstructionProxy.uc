//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstructionProxy extends Actor;

var DHPawn                  Pawn;
var class<DHConstruction>   ConstructionClass;

function SetConstructionClass(class<DHConstruction> ConstructionClass)
{
    self.ConstructionClass = ConstructionClass;


    // set all skins to simple color skin.
}

defaultproperties
{
    RemoteRole=ROLE_None
}

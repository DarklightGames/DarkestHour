//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHIdentifierAttachment extends DHDecoAttachment
    dependson(DHIdentifierInfo);

var() class<DHIdentifierInfo>   IdentifierInfoClass;
var private array<Material>     StaticMeshSkins;

function SetIdentiferByType(DHIdentifierInfo.EIdentifierType Type, string String)
{
    if (IdentifierInfoClass == none)
    {
        return;
    }

    if (StaticMeshSkins.Length == 0)
    {
        // Populate the original skins, then pass it through the 
        // Get the original skins from the static mesh.
        StaticMeshSkins = (new class'UStaticMesh').FindStaticMeshSkins(StaticMesh);
    }
    
    IdentifierInfoClass.static.SetIdentifierByType(self, Type, String, StaticMeshSkins);
}

defaultproperties
{
    CullDistance=0.0
}

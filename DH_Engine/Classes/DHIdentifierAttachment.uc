//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHIdentifierAttachment extends DHDecoAttachment
    dependson(DHIdentifierInfo);

var() class<DHIdentifierInfo> IdentifierInfoClass;

// This is needed in case we need to restore the original skins.
var array<Material> OriginalSkins;

function SetIdentiferByType(DHIdentifierInfo.EIdentifierType Type, string String)
{
    if (IdentifierInfoClass == none)
    {
        return;
    }
    
    IdentifierInfoClass.static.SetIdentifierByType(self, Type, String);
}

defaultproperties
{
    CullDistance=0.0
}

//==============================================================================
// Darklight Games (c) 2008-2023
//==============================================================================
// https://wiki.beyondunreal.com/Legacy:Dynamicly_Accessing_Original_Static_Mesh_Textures
//==============================================================================

class UStaticMesh extends Object;

var class sClassPlaceholder;

// This function can be used to directly transfer to the Skins array in Engine.Actor
simulated function array<Material> FindStaticMeshSkins(StaticMesh SubjectMesh)
{
    local int iPointer, i;
    local string sParseString, sTextureClass, sMaterialsPropText;
    local array<Material> SkinArray;

    // First of all obtain the string containing the list of the Materials on the Static mesh
    sMaterialsPropText = SubjectMesh.GetPropertyText("Materials");

    // This part of the function parses the string returned by GetPropertyText and returns the appropriate textures
    iPointer = InStr(sMaterialsPropText, ",Material=");

    while (iPointer != -1 && i < 256)
    {
        sParseString = Mid(sMaterialsPropText, iPointer + 10);

        // Check for a null-texture and if one is found then skip the current loop
        // NOTE: This includes the null value in the returned array, this is so it exactly mirror's the Materials array. (very important)
        if (Left(sParseString, 5) ~= "None)")
        {
            sMaterialsPropText = sParseString;
            goto 'Skip';
        }

        iPointer = InStr(sParseString, "'");
        sTextureClass = Left(sParseString, iPointer);

        // I am not certain if this is needed since my original code was used for a slightly different purpose
        SetPropertyText("sClassPlaceholder", sTextureClass);

        sParseString = Mid(sMaterialsPropText, iPointer + 1);
        iPointer = InStr(sParseString, "'");
        sParseString = Mid(sParseString, iPointer + 1);
        iPointer = InStr(sParseString, "'");

        // Cut off the parsed section of sMaterialsPropText so that it will go onto the next section during the next iteration. (otherwise infinite recursion)
        sMaterialsPropText = Mid(sParseString, iPointer + 1);
        sParseString = Left(sParseString, iPointer);

        // Create a reference to the Material used on the mesh
        SkinArray[i] = Material(DynamicLoadObject(sParseString, sClassPlaceholder));

        Skip:
        iPointer = InStr(sMaterialsPropText, ",Material=");
        i++;
    }

    // Return the completed list of skins
    return SkinArray;
}


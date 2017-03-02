class UStaticMesh extends Object;

var class sClassPlaceholder;

//==============================================================================
// https://wiki.beyondunreal.com/Legacy:Dynamicly_Accessing_Original_Static_Mesh_Textures
//==============================================================================
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

//==============================================================================
// https://wiki.beyondunreal.com/Legacy:Making_A_Static_Mesh_Translucent
//==============================================================================
// This function is used to create a new shader with an opacity channel at a certain Alpha (to create the translucency effect)
simulated function Shader CreateNewTShader()
{
    local Shader ShaderObj;
    ShaderObj = new class'Engine.Shader';
    // Creates translucency
    ShaderObj.Opacity = new class'Engine.ConstantColor';
    ConstantColor(ShaderObj.Opacity).Color.A = 128.0;
    return ShaderObj;
}

// This is the main function where most texture/shader changes are made
simulated function MakeActorTranslucent(actor A)
{
    local Array<Material> NewSkins;
    local Material TempMat;
    local int i;

    // First of all retrieve the list of existing skins
    NewSkins = FindStaticMeshSkins(A.StaticMesh);

    // Then iterate that list and try to make the skin translucent (using a ConstantColor modifier to change the Alpha)
    for (i = 0; i < NewSkins.Length; ++i)
    {
        // If the skin is already a shader this creates some difficulty, the code will 'try' to compensate but you will notice that this will not work on a lot of things
        if (Shader(NewSkins[i]) != none)
        {
            // If SelfIllumination is set then your really screwed...This code tries to compensate with FallbackMaterial's...Open to suggestions here
            if (Shader(NewSkins[i]).SelfIllumination != none)
            {
                // Look for a useable FallbackMaterial, if you can't find one then get rid of the SelfIllumination (last resort)
                if (NewSkins[i].FallbackMaterial != none && (Shader(NewSkins[i].FallbackMaterial) == none || Shader(Newskins[i].FallbackMaterial).SelfIllumination == none))
                {
                    // If the FallbackMaterial is a shader itself then attempt to use it
                    if (Shader(NewSkins[i].FallbackMaterial) != none)
                    {
                        NewSkins[i] = NewSkins[i].FallbackMaterial;
                    }
                    else
                    {
                        TempMat = NewSkins[i].FallbackMaterial;
                        NewSkins[i] = CreateNewTShader();
                        // TODO: new combiner
                        Shader(NewSkins[i]).Diffuse = TempMat;
                    }
                }
                else if (NewSkins[i].FallbackMaterial == none)
                {
                    Shader(NewSkins[i]).SelfIllumination = none;
                }
            }
            // Create translucency
            Shader(NewSkins[i]).Opacity = new class'Engine.ConstantColor';
            ConstantColor(Shader(NewSkins[i]).Opacity).Color.A = 128;
        }
        // If this is called then the translucency changes should take place perfectly
        else
        {
            TempMat = CreateNewTShader();
            Shader(TempMat).Diffuse = NewSkins[i];
            NewSkins[i] = TempMat;
        }
        // Setup the actor's Skins array
        A.Skins[i] = NewSkins[i];
    }
}

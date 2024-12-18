//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// This is a class that provides information on how to display markings on a
// vehicle, helmet or any static mesh.
//
// This is accomplished by creating a combiner material for each glyph in the
// identifier and applying it to the appropriate skin index on the static mesh.
//==============================================================================

class DHIdentifierInfo extends Object
    abstract;

// TODO: move this definition data to its own class.
enum EIdentifierType
{
    ID_UserNumber,  // User-defined decimal number.
    ID_UserLetter,  // User-defined letter.
    ID_UserString,  // User-defined string.
    ID_SquadNumber, // The squad number.
    ID_SquadName,   // The squad name.
};

enum EJustification
{
    Justify_Left,
    Justify_Center,
    Justify_Right,
};

struct Identifier
{
    var() EIdentifierType Type;
    var() EJustification Justification;
    var() class<DHGlyphSet> GlyphSetClass;
    var() array<int> SkinIndices;   // The length of this array is the maximum length of the identifier.
};

var() array<Identifier> Identifiers;

static function SetIdentifierByType(Actor AttachmentActor, EIdentifierType Type, string String)
{
    local int i, j;
    local int StartSkinIndex, SkinIndex;
    local string TrimmedString, Character;
    local array<Material> StaticMeshSkins;
    local Material GlyphMaterial, CombinerMaterial;

    // Get the original skins from the static mesh.
    // TODO: this might be expensive so we want to avoid doing this every time.
    StaticMeshSkins = (new class'UStaticMesh').FindStaticMeshSkins(AttachmentActor.StaticMesh);

    for (i = 0; i < default.Identifiers.Length; ++i)
    {
        if (default.Identifiers[i].Type != Type)
        {
            continue;
        }

        // Set the skins to the original skins.
        AttachmentActor.Skins = StaticMeshSkins;

        // Trim the string to the maximum length supported by the identifier.
        TrimmedString = Left(String, default.Identifiers[i].SkinIndices.Length);

        Log("TrimmedString" @ TrimmedString);

        // Based on the justification, figure out which skin index to start at.
        switch (default.Identifiers[i].Justification)
        {
            case Justify_Left:
                StartSkinIndex = 0;
                break;
            case Justify_Center:
                StartSkinIndex = (default.Identifiers[i].SkinIndices.Length - Len(TrimmedString)) / 2;
                break;
            case Justify_Right:
                StartSkinIndex = default.Identifiers[i].SkinIndices.Length - Len(TrimmedString);
                break;
        }

        for (j = 0; j < Len(TrimmedString); ++j)
        {
            Character = Mid(TrimmedString, j, 1);

            GlyphMaterial = default.Identifiers[i].GlyphSetClass.static.GetGlyphMaterial(Mid(TrimmedString, j, 1));

            if (GlyphMaterial == none)
            {
                continue;
            }

            SkinIndex = default.Identifiers[i].SkinIndices[StartSkinIndex + j];
            CombinerMaterial = CreateGlyphMaterial(StaticMeshSkins[SkinIndex], GlyphMaterial);
            AttachmentActor.Skins[SkinIndex] = CombinerMaterial;
        }
    }
}

static function Material CreateGlyphMaterial(Material BaseMaterial, Material GlyphMaterial)
{
    local Combiner Combiner;
    local TexCoordSource TexCoordSource;

    TexCoordSource = new class'TexCoordSource';
    TexCoordSource.TexCoordSource = TCS_Stream1;
    TexCoordSource.Material = GlyphMaterial;

    Combiner = new class'Combiner';
    Combiner.CombineOperation = CO_AlphaBlend_With_Mask;
    Combiner.AlphaOperation = AO_Use_Mask;
    Combiner.Material1 = BaseMaterial;
    Combiner.Material2 = TexCoordSource;
    Combiner.Mask = TexCoordSource;
    Combiner.SurfaceType = BaseMaterial.SurfaceType;
    Combiner.FallbackMaterial = BaseMaterial;

    return Combiner;
}

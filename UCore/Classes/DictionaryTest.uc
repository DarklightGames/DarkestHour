//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DictionaryTest extends Object;

static function Test()
{
    TestPut1();
    TestPut2();
    TestErase();
}

static function TestInt(coerce int Expected, coerce int Actual)
{
    if (Expected != Actual)
    {
        Warn("TestInt Failed! Expected:" @ Expected @ "Actual:" @ Actual);
    }
}

static function TestBool(coerce bool Expected, coerce bool Actual)
{
    if (Expected != Actual)
    {
        Warn("TestBool Failed! Expected:" @ Expected @ "Actual:" @ Actual);
    }
}

static function TestString(coerce string Expected, coerce string Actual)
{
    if (Expected != Actual)
    {
        Warn("TestString Failed! Expected: \"" $ Expected $ "\"" @ "Actual: \"" $ Actual $ "\"");
    }
}

static function TestPut1()
{
    local int i;
    local string Author;
    local array<string> Titles;
    local array<string> Authors;
    local Dictionary Books;

    Titles[Titles.Length] = "The Origin of Species";
    Titles[Titles.Length] = "Radioactive Substances";
    Titles[Titles.Length] = "The Double Helix";
    Titles[Titles.Length] = "The Realm of the Nebulae";
    Titles[Titles.Length] = "Pale Blue Dot: A Vision of the Human Future in Space";
    Titles[Titles.Length] = "The Sky Is Not The Limit: Adventures of an Urban Astrophysicist";
    Titles[Titles.Length] = "A Brief History of Time";
    Titles[Titles.Length] = "The Selfish Gene";

    Authors[Authors.Length] = "Charles Darwin";
    Authors[Authors.Length] = "Marie Curie";
    Authors[Authors.Length] = "James Watson";
    Authors[Authors.Length] = "Edwin Hubble";
    Authors[Authors.Length] = "Carl Sagan";
    Authors[Authors.Length] = "Neil deGrasse Tyson";
    Authors[Authors.Length] = "Stephen Hawking";
    Authors[Authors.Length] = "Richard Dawkins";

    TestBool(true, Titles.Length == Authors.Length);

    Books = new class'Dictionary';

    for (i = 0; i < Titles.Length; ++i)
    {
        Books.Put(Titles[i], Authors[i]);
    }

    TestBool(true, Books.GetSize() == Titles.Length);

    for (i = 0; i < Titles.Length; ++i)
    {
        TestBool(true, Books.Get(Titles[i], Author));
        TestString(Authors[i], Author);
    }

    DumpDictionary(Books);
}

static function TestPut2()
{
    local int i;
    local string Value;
    local Dictionary Albums;
    local array<string> Titles;
    local array<string> Artists;

    Titles[Titles.Length] = "Daisy";
    Titles[Titles.Length] = "Juturna";
    Titles[Titles.Length] = "Demon Days";
    Titles[Titles.Length] = "Tomorrow, In a Year";
    Titles[Titles.Length] = "Rooms of the House";
    Titles[Titles.Length] = "Overgrown";
    Titles[Titles.Length] = "The Edges of Twilight";
    Titles[Titles.Length] = "OK Computer";

    Artists[Artists.Length] = "Brand New";
    Artists[Artists.Length] = "Circa Survive";
    Artists[Artists.Length] = "Gorillaz";
    Artists[Artists.Length] = "The Knife";
    Artists[Artists.Length] = "La Dispute";
    Artists[Artists.Length] = "James Blake";
    Artists[Artists.Length] = "The Tea Party";
    Artists[Artists.Length] = "Radiohead";

    TestBool(true, Titles.Length == Artists.Length);

    Albums = new class'Dictionary';

    for (i = 0; i < Titles.Length; ++i)
    {
        Albums.Put(Titles[i], Artists[i]);
    }

    for (i = 0; i < Titles.Length; ++i)
    {
        Albums.Put(Titles[i], Caps(Artists[i]));
    }

    for (i = 0; i < Albums.GetSize(); ++i)
    {
        TestBool(true, Albums.Get(Titles[i], Value));
        TestString(Caps(Artists[i]), Value);
    }

    DumpDictionary(Albums);
}

static function TestErase()
{
    local int i, j;
    local string Value;
    local Dictionary Movies;
    local array<string> Titles;
    local array<string> Directors;

    Titles[Titles.Length] = "Blue Velvet";
    Titles[Titles.Length] = "Rosemary's Baby";
    Titles[Titles.Length] = "The Texas Chainsaw Massacre";
    Titles[Titles.Length] = "Donnie Darko";
    Titles[Titles.Length] = "Office Space";
    Titles[Titles.Length] = "Thing";
    Titles[Titles.Length] = "Hot Rod";
    Titles[Titles.Length] = "Collateral";

    Directors[Directors.Length] = "David Lynch";
    Directors[Directors.Length] = "Roman Polanski";
    Directors[Directors.Length] = "Tobe Hooper";
    Directors[Directors.Length] = "Richard Kelly";
    Directors[Directors.Length] = "Mike Judge";
    Directors[Directors.Length] = "John Carpenter";
    Directors[Directors.Length] = "Akiva Schaffer";
    Directors[Directors.Length] = "Michael Mann";

    TestBool(true, Titles.Length == Directors.Length);

    Movies = new class'Dictionary';

    for (i = 0; i < Titles.Length; ++i)
    {
        Movies.Put(Titles[i], Directors[i]);
    }

    // Go through all the keys backwards and remove them; after each
    // erasure, verify the length of the list and that the remaning keys can
    // still be gotten.

    for (i = Titles.Length - 1; i >= 0; --i)
    {
        Movies.Erase(Titles[i]);

        TestInt(i, Movies.GetSize());

        for (j = 0; j < i; ++j)
        {
            TestBool(true, Movies.Get(Titles[j], Value));
            TestString(Directors[j], Value);
        }
    }

    DumpDictionary(Movies);
}

static function DumpDictionary(Dictionary D)
{
    local int i;
    local array<string> Keys;
    local string Value;

    if (D == none)
    {
        return;
    }

    Keys = D.GetKeys();

    for (i = 0; i < Keys.Length; ++i)
    {
        D.Get(Keys[i], Value);

        Log("\"" $ Keys[i] $ "\": \"" $ Value $ "\"");
    }
}


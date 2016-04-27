//==============================================================================
// Darklight Games (c) 2008-2016
//==============================================================================

class ArrayListTest extends Object;

static function Test()
{
    TestAdd();
    TestAddAtIndex();
    TestClear();
    TestContains();
    TestGet();
    TestIndexOf();
    TestIsEmpty();
    TestLastIndexOf();
    TestRemove();
    TestRemoveRange();
}

static function TestAdd()
{
    local ArrayList_string A;

    A = new class'ArrayList_string';

    A.Add("Able");
    A.Add("Baker");
    A.Add("Charlie");
    A.Add("Dog");
    A.Add("Easy");
    A.Add("Fox");
    A.Add("George");
    A.Add("How");

    Log(class'UString'.static.Join(",", A.ToArray()));
}

static function TestAddAtIndex()
{
    local ArrayList_string A;

    A = new class'ArrayList_string';

    A.AddAtIndex(0, "Able");
    A.AddAtIndex(0, "Baker");
    A.AddAtIndex(0, "Charlie");
    A.AddAtIndex(0, "Dog");
    A.AddAtIndex(0, "Easy");
    A.AddAtIndex(0, "Fox");
    A.AddAtIndex(0, "George");
    A.AddAtIndex(0, "How");

    Log(class'UString'.static.Join(",", A.ToArray()));
}

static function TestClear()
{
    local ArrayList_string A;

    A = new class'ArrayList_string';

    A.Add("Able");
    A.Add("Baker");
    A.Add("Charlie");
    A.Add("Dog");
    A.Add("Easy");
    A.Add("Fox");
    A.Add("George");
    A.Add("How");
    A.Clear();

    Log(A.Size());
}

static function TestContains()
{
    local ArrayList_string A;

    A = new class'ArrayList_string';

    A.Add("Able");
    A.Add("Baker");
    A.Add("Charlie");
    A.Add("Dog");
    A.Add("Easy");
    A.Add("Fox");
    A.Add("George");
    A.Add("How");

    Log(A.Contains("Able"));
    Log(A.Contains("Baker"));
    Log(A.Contains("Charlie"));
    Log(A.Contains("Dog"));
    Log(A.Contains("Easy"));
    Log(A.Contains("Fox"));
    Log(A.Contains("George"));
    Log(A.Contains("How"));
    Log(A.Contains("Item"));
}

static function TestGet()
{
    local int i;
    local ArrayList_string A;

    A = new class'ArrayList_string';

    A.Add("Able");
    A.Add("Baker");
    A.Add("Charlie");
    A.Add("Dog");
    A.Add("Easy");
    A.Add("Fox");
    A.Add("George");
    A.Add("How");

    for (i = 0; i < A.Size(); ++i)
    {
        Log(A.Get(i));
    }
}

static function TestIndexOf()
{
    local int i;
    local ArrayList_string A;

    A = new class'ArrayList_string';

    A.Add("Able");
    A.Add("Baker");
    A.Add("Charlie");
    A.Add("Dog");
    A.Add("Easy");
    A.Add("Fox");
    A.Add("George");
    A.Add("How");

    for (i = 0; i < A.Size(); ++i)
    {
        Log(A.IndexOf(A.Get(i)));
    }

    Log(A.IndexOf("Item"));
}

static function TestIsEmpty()
{
    local ArrayList_string A;

    Log("TestIsEmpty");

    A = new class'ArrayList_string';

    Log(A.IsEmpty());
    A.Add("Able");
    Log(A.IsEmpty());
}

static function TestLastIndexOf()
{
    local ArrayList_string A;

    A = new class'ArrayList_string';

    A.Add("Able");
    A.Add("Baker");
    A.Add("Charlie");
    A.Add("Dog");
    A.Add("Dog");
    A.Add("Charlie");
    A.Add("Baker");
    A.Add("Able");

    Log("TestLastIndexOf");

    Log(A.LastIndexOf("Dog"));
    Log(A.LastIndexOf("Charlie"));
    Log(A.LastIndexOf("Baker"));
    Log(A.LastIndexOf("Able"));
}

static function TestRemove()
{
    local ArrayList_string A;

    A = new class'ArrayList_string';

    A.Add("Able");
    A.Add("Baker");
    A.Add("Charlie");
    A.Add("Dog");
    A.Add("Easy");
    A.Add("Fox");
    A.Add("George");
    A.Add("How");

    while (!A.IsEmpty())
    {
        Log(class'UString'.static.Join(",", A.ToArray()));

        A.Remove(0);
    }
}

static function TestRemoveRange()
{
    local ArrayList_string A;

    A = new class'ArrayList_string';

    A.Add("Able");
    A.Add("Baker");
    A.Add("Charlie");
    A.Add("Dog");
    A.Add("Easy");
    A.Add("Fox");
    A.Add("George");
    A.Add("How");

    while (!A.IsEmpty())
    {
        Log(class'UString'.static.Join(",", A.ToArray()));
        A.RemoveRange(0, A.Size() / 2);
    }
}

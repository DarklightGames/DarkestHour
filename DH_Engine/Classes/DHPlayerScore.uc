//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHPlayerScore extends Object;

const CATEGORIES_MAX = 4;

struct EventScore
{
    var class<DHScoreEvent> EventClass;
    var int                 Count;      // The amount of scoring events handled with this type
    var int                 Score;      // The amount of score accumulated from this type
};

var int                     TotalScore;
var int                     CategoryScores[CATEGORIES_MAX]; // Will be referenced by index, determined at runtime depending on what gets registered?
var array<EventScore>       EventScores;

// Event listeners for score changes.
delegate OnCategoryScoreChanged(class<DHScoreCategory> CategoryClass, int Score);
delegate OnTotalScoreChanged(int Score);

// Gets the cumulative score for the specified category.
function int GetCategoryScore(class<DHScoreCategory> CategoryClass)
{
    if (CategoryClass == none ||
        CategoryClass.default.CategoryIndex < 0 ||
        CategoryClass.default.CategoryIndex >= arraycount(CategoryScores))
    {
        return 0;
    }

    return CategoryScores[CategoryClass.default.CategoryIndex];
}

// Resets all scores to zero.
function Reset()
{
    local int i;

    TotalScore = 0;

    for (i = 0; i < arraycount(CategoryScores); ++i)
    {
        CategoryScores[i] = 0;

//        OnCategoryScoreChanged(0, Categories[i]);
    }

    EventScores.Length = 0;
}

function HandleScoreEvent(class<DHScoreEvent> EventClass)
{
    local int CategoryIndex;
    local int Value;
    local int EventScoreIndex;

    Value = EventClass.default.Value;

    // TODO: Calculate bonuses.

    TotalScore += Value;

    CategoryIndex = EventClass.default.CategoryClass.default.CategoryIndex;

    if (CategoryIndex != -1)
    {
        CategoryScores[CategoryIndex] += Value;

        OnCategoryScoreChanged(EventClass.default.CategoryClass, CategoryScores[CategoryIndex]);
    }

    EventScoreIndex = GetEventScoreIndex(EventClass);

    if (EventScoreIndex == -1)
    {
        // Event type has not been added yet, let's add it now.
        EventScores.Length += 1;
        EventScoreIndex = EventScores.Length - 1;
        EventScores[EventScoreIndex].EventClass = EventClass;
    }

    ++EventScores[EventScoreIndex].Count;
    EventScores[EventScoreIndex].Score += Value;
}

function int GetEventScoreIndex(class<DHScoreEvent> EventClass)
{
    local int i;

    for (i = 0; i < EventScores.Length; ++i)
    {
        if (EventScores[i].EventClass == EventClass)
        {
            return i;
        }
    }

    return i;
}

defaultproperties
{
}


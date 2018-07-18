//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHScoreManager extends Object;

const SCORE_CATEGORIES_MAX = 4;

struct EventScore
{
    var class<DHScoreEvent> EventClass;
    var int                 Count;      // The amount of scoring events handled with this type
    var int                 Score;      // The amount of score accumulated from this type
};

var int                     TotalScore;
var int                     CategoryScores[SCORE_CATEGORIES_MAX];
var array<EventScore>       EventScores;

var class<DHScoreCategory>  ScoreCategoryClasses[SCORE_CATEGORIES_MAX];

// Event listeners for score changes.
delegate OnCategoryScoreChanged(int CategoryIndex, int Score);
delegate OnTotalScoreChanged(int Score);

static function class<DHScoreCategory> GetCategoryByIndex(int Index)
{
    if (Index < 0 || Index >= SCORE_CATEGORIES_MAX)
    {
        return none;
    }

    return default.ScoreCategoryClasses[Index];
}

function int GetCategoryScoreByIndex(int Index)
{
    if (Index < 0 || Index >= SCORE_CATEGORIES_MAX)
    {
        return -1;
    }

    return CategoryScores[Index];
}

// Gets the cumulative score for the specified category.
function int GetCategoryScoreByClass(class<DHScoreCategory> CategoryClass)
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
        OnCategoryScoreChanged(i, CategoryScores[i]);
    }

    EventScores.Length = 0;
}

function HandleScoreEvent(DHScoreEvent ScoreEvent)
{
    local int CategoryIndex;
    local int Value;
    local int EventScoreIndex;

    Value = ScoreEvent.GetValue();

    TotalScore += Value;

    OnTotalScoreChanged(TotalScore);

    CategoryIndex = ScoreEvent.default.CategoryClass.default.CategoryIndex;

    if (CategoryIndex != -1)
    {
        CategoryScores[CategoryIndex] += Value;

        OnCategoryScoreChanged(CategoryIndex, CategoryScores[CategoryIndex]);
    }

    EventScoreIndex = GetEventScoreIndex(ScoreEvent.Class);

    if (EventScoreIndex == -1)
    {
        // Event type has not been added yet, let's add it now.
        EventScores.Length = EventScores.Length + 1;
        EventScoreIndex = EventScores.Length - 1;
        EventScores[EventScoreIndex].EventClass = ScoreEvent.Class;
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

    return -1;
}

defaultproperties
{
    ScoreCategoryClasses(0)=class'DHScoreCategory_Combat'
    ScoreCategoryClasses(1)=class'DHScoreCategory_Support'
    ScoreCategoryClasses(2)=class'DHScoreCategory_Logistics'
    ScoreCategoryClasses(3)=class'DHScoreCategory_Squad'
}


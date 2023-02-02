//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHScoreManager extends Object;

const SCORE_CATEGORIES_MAX = 2;

struct EventScore
{
    var class<DHScoreEvent> EventClass;
    var int                 Count;      // The amount of scoring events handled with this type
    var int                 Score;      // The amount of score accumulated from this type
};

struct ScoreEvent
{
    var class<DHScoreEvent>     EventClass;
    var int                     TimeSeconds;
};

var int                     TotalScore;
var int                     CategoryScores[SCORE_CATEGORIES_MAX];
var array<EventScore>       EventScores;
var array<ScoreEvent>       ScoreEvents;

var class<DHScoreCategory>  ScoreCategoryClasses[SCORE_CATEGORIES_MAX];

// NextScoreManager is the score manager to route score events to once they have been
// registered in this one. This allows passing score events to a team-specific
// score manager.
var DHScoreManager          NextScoreManager;

// When true, the normal limit-per-duration checks are skipped.
var bool                    bSkipLimits;

// Event listeners for score changes.
delegate OnCategoryScoreChanged(int CategoryIndex, int Score);
delegate OnTotalScoreChanged(int Score);

static function class<DHScoreCategory> GetCategoryClassByIndex(int Index)
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
    ScoreEvents.Length = 0;
}

// Gets the number of limited scoring events for the specified event type (based
// on the limit duration of the event class in question).
function int GetCountOfScoreEvents(class<DHScoreEvent> EventClass, GameReplicationInfo GRI)
{
    local int i;
    local int Count;

    for (i = 0; i < ScoreEvents.Length; ++i)
    {
        if (ScoreEvents[i].EventClass == EventClass &&
            GRI.ElapsedTime - ScoreEvents[i].TimeSeconds < EventClass.default.LimitDurationSeconds)
        {
            ++Count;
        }
    }

    return Count;
}

// Trims tracking of limited score events that are older than one minute.
function TrimScoreEvents(GameReplicationInfo GRI)
{
    local int i;

    for (i = ScoreEvents.Length - 1; i >= 0; --i)
    {
        if (GRI.ElapsedTime - ScoreEvents[i].TimeSeconds > ScoreEvents[i].EventClass.default.LimitDurationSeconds)
        {
            ScoreEvents.Remove(i, 1);
        }
    }
}

function HandleScoreEvent(DHScoreEvent ScoreEvent, GameReplicationInfo GRI)
{
    local int CategoryIndex;
    local int Value;
    local int EventScoreIndex;
    local int ScoreEventCount;

    if (!bSkipLimits && ScoreEvent.default.LimitPerDuration > 0)
    {
        TrimScoreEvents(GRI);
        ScoreEventCount = GetCountOfScoreEvents(ScoreEvent.Class, GRI);

        if (ScoreEventCount >= ScoreEvent.default.LimitPerDuration)
        {
            // Player has reached the limit of scoring events of this time
            // in the last minute.
            return;
        }

        ScoreEvents.Insert(0, 1);
        ScoreEvents[0].EventClass = ScoreEvent.Class;
        ScoreEvents[0].TimeSeconds = GRI.ElapsedTime;
    }

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

    if (NextScoreManager != none)
    {
        NextScoreManager.HandleScoreEvent(ScoreEvent, GRI);
    }
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

function JSONObject Serialize()
{
    local int i;
    local JSONObject Root, EventScoreObject, CategoryScoreObject;
    local JSONArray EventScoresArray, CategoryScoresArray;

    CategoryScoresArray = class'JSONArray'.static.Create();

    for (i = 0; i < arraycount(CategoryScores); ++i)
    {
        CategoryScoreObject = new class'JSONObject';
        CategoryScoreObject.PutString("type", GetCategoryClassByIndex(i));
        CategoryScoreObject.PutInteger("score", CategoryScores[i]);
        CategoryScoresArray.Add(CategoryScoreObject);
    }

    EventScoresArray = class'JSONArray'.static.Create();

    for (i = 0; i < EventScores.Length; ++i)
    {
        EventScoreObject = new class'JSONObject';
        EventScoreObject.PutString("type", string(EventScores[i].EventClass));
        EventScoreObject.PutInteger("count", EventScores[i].Count);
        EventScoreObject.PutInteger("score", EventScores[i].Score);
        EventScoresArray.Add(EventScoreObject);
    }

    Root = new class'JSONObject';
    Root.Put("total", class'JSONNumber'.static.ICreate(TotalScore));
    Root.Put("categories", CategoryScoresArray);
    Root.Put("events", EventScoresArray);

    return Root;
}

defaultproperties
{
    ScoreCategoryClasses(0)=class'DHScoreCategory_Combat'
    ScoreCategoryClasses(1)=class'DHScoreCategory_Support'
}

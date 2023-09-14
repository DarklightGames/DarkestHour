//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMainMenuGame extends CinematicGame;

const DESIRED_MIN_FPS =                 60.0;                   // If average FPS is below this, it won't do any limiter calculations
const DESIRED_MAX_FPS =                 144.0;                  // If average FPS is above this, it'll keep doing more and more limiter iterations

const LIMITER_ITERATIONS =              1000;                   // Base number of iterations the limiter will do, it increases dynamically with IterationMultiplier
const LIMITER_STRENGTH =                10;                     // How many Sqrt() calculations are done per iteration (effects how quickly it'll lower the FPS to desired max)

const CLIENTFRAMERATE_UPDATETIME =      0.25;                   // How often to calculate the average fps

var     float           ClientAverageFrameRate;
var     float           ClientFrameRateConsolidated;            // Keeps track of tick rates over time, used to calculate average
var     int             ClientFrameRateCount;                   // Keeps track of how many frames are between ClientFrameRateConsolidated

var     int             IterationMultiplier;

event Tick(float DeltaTime)
{
    local int i, j, x;

    ClientFrameRateConsolidated += DeltaTime;

    // If enough time has passed, calculate Average Frame Rate
    if (ClientFrameRateConsolidated > CLIENTFRAMERATE_UPDATETIME)
    {
        ClientAverageFrameRate = ClientFrameRateCount / ClientFrameRateConsolidated;
        ClientFrameRateCount = 0;
        ClientFrameRateConsolidated -= CLIENTFRAMERATE_UPDATETIME;

        if (ClientAverageFrameRate > DESIRED_MAX_FPS)
        {
            ++IterationMultiplier;
        }
        else if (ClientAverageFrameRate < DESIRED_MIN_FPS)
        {
            --IterationMultiplier;
        }
    }
    else
    {
        ++ClientFrameRateCount;
    }

    // The limiter
    if (ClientAverageFrameRate > DESIRED_MIN_FPS)
    {
        for (i = 0; i < (LIMITER_ITERATIONS * IterationMultiplier); ++i)
        {
            for (j = 0; j < LIMITER_STRENGTH; ++j)
            {
                x = Sqrt(Rand(10000));
            }
        }
    }
}

defaultproperties
{
    PlayerControllerClassName="DH_Engine.DHCinematicPlayer"
}

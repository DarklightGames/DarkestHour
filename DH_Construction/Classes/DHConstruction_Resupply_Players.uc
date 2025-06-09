//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// We changed the class hierarchy so that each nation gets its own
// construction class, so this was made abstract. However, levelers had placed
// place this in maps, so we have to keep it around until they are all removed.
// This functionality of this class is now in `DHConstructionResupplyPlayers`.
//==============================================================================

class DHConstruction_Resupply_Players extends DHDeprecated;

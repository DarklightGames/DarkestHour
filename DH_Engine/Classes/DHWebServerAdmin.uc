//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHWebServerAdmin extends UTServerAdmin
    config;

// Override to add ServerName argument so we can put the serve rname on the header page
function QueryHeaderPage(WebRequest Request, WebResponse Response)
{
    local int i;
    local string Menu, GroupPage, Dis, CurPageTitle;

    Response.Subst("ServerName", Class'GameReplicationInfo'.default.ServerName);
    Response.Subst("AdminName", CurAdmin.UserName);
    Response.Subst("HeaderColSpan", "2");

    if (QueryHandlers.Length > 0)
    {
        GroupPage = Request.GetVariable("Group", QueryHandlers[0].DefaultPage);

        // We build a multi-column table for each QueryHandler
        for (i = 0; i < QueryHandlers.Length; ++i)
        {
            if (QueryHandlers[i].DefaultPage == GroupPage)
            {
                CurPageTitle = QueryHandlers[i].Title;
            }

            Dis = "";

            if (QueryHandlers[i].NeededPrivs != "" && !CanPerform(QueryHandlers[i].NeededPrivs))
            {
                Dis = "d";
            }

            Response.Subst("MenuLink", RootFrame $ "?Group=" $ QueryHandlers[i].DefaultPage);
            Response.Subst("MenuTitle", QueryHandlers[i].Title);

            Menu $= WebInclude(HeaderPage $ "_item" $ Dis);
        }

        Response.Subst("Location", CurPageTitle);
        Response.Subst("HeaderMenu", Menu);
    }

    if (CanPerform("Xs"))
    {
        Response.Subst("HeaderColSpan", "3");
        Response.Subst("SkinSelect", Select("WebSkin", GenerateSkinSelect()));
        Response.Subst("WebSkinSelect", WebInclude(SkinSelectInclude));
    }

    // Set URIs
    ShowPage(Response, HeaderPage);
}

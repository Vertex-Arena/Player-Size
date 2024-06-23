#pragma newdecls required
#pragma semicolon 1

#include <sourcemod>

#define SCALE_SMALL 75
#define SCALE_NORMAL 100
#define SCALE_LARGE 125

public Plugin myinfo =
{
    name = "[IOS] PlayerSize",
    author = "inactivo",
    description = "Allows administrators to change their character size.",
    version = "1.1",
    url = "http://dsc.gg/vertexar"
};

public void OnPluginStart()
{
    RegAdminCmd("sm_playersize", Command_PlayerSize, ADMFLAG_GENERIC, "Change your character size");
    RegAdminCmd("sm_size", Command_PlayerSize, ADMFLAG_GENERIC, "Change your character size");
    LoadTranslations("playersize.phrases");
}

public Action Command_PlayerSize(int client, int args)
{
    if (!client)
    {
        ReplyToCommand(client, "[SM] This command cannot be used from console.");
        return Plugin_Handled;
    }

    Menu menu = new Menu(Handle_PlayerSizeMenu);
    menu.SetTitle("%t", "PickYourSize");

    char small[16];
    Format(small, sizeof(small), "%t", "Small");
    char smallInfo[8];
    IntToString(SCALE_SMALL, smallInfo, sizeof(smallInfo));
    menu.AddItem(smallInfo, small);

    char normalInfo[4];
    IntToString(SCALE_NORMAL, normalInfo, sizeof(normalInfo));
    menu.AddItem(normalInfo, "Normal");

    char large[16];
    Format(large, sizeof(large), "%t", "Large");
    char largeInfo[4];
    IntToString(SCALE_LARGE, largeInfo, sizeof(largeInfo));
    menu.AddItem(largeInfo, large);

    menu.Display(client, 20);
    return Plugin_Handled;
}

public int Handle_PlayerSizeMenu(Menu menu, MenuAction action, int param1, int param2)
{
    if (action == MenuAction_Select)
    {
        char option[4];
        menu.GetItem(param2, option, sizeof(option));
        int scale = StringToInt(option);
        
        char size[16];
        switch (scale)
        {
            case SCALE_SMALL: Format(size, sizeof(size), "%T", "Small", param1);
            case SCALE_NORMAL: size = "Normal";
            case SCALE_LARGE: Format(size, sizeof(size), "%T", "Large", param1);
        }

        ServerCommand("mp_player_model_scale %d %d", GetClientUserId(param1), scale);
        PrintToChat(param1, "[SM] \x04%t", "YourSizeChanged", size, scale);
    }
    return 0;
}
#include maps\mp\zombies\_zm_powerup_zombie_blood;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zm_tomb_main_quest;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zm_tomb_dig;

main()
{
    extmapcheck = GetDvar("CUSTOM_MAP");
    switch( extmapcheck )
    {
        case "0":
            xmapcheck = 1;
            break;
        case "1":
            xmapcheck = 1;
            break;
        case "2":
            xmapcheck = 1;
            break;
        case "3":
            xmapcheck = 1;
            break;
        case "4":
            xmapcheck = 1;
            break;
        case "5":
            xmapcheck = 1;
            break;
        default:
            break;
    }
    if(xmapcheck)
    return;
	replacefunc(maps\mp\zm_tomb_dig::dig_spots_init, ::dig_spots_init);
	replacefunc(maps\mp\zm_tomb_dig::generate_shovel_unitrigger, ::generate_shovel_unitrigger);
}

generate_shovel_unitrigger( e_shovel ) //checked changed to match cerberus output
{
	return;
}

dig_spots_init()
{
	return;
}
�GSC
     T  �  H  �  �  "  �  �  V  @ =       =   C:/Users/astey/Documents/Black Ops 2 - GSC Studio/GSC Fast Compiler/Custom Maps 1/remix/src/scripts/zm - compiled/zm_tomb/bsm_tomb_main.gsc main extmapcheck xmapcheck CUSTOM_MAP 0 1 2 3 4 5  zm_treasure_chest_init maps/mp/zm_tomb_classic replacefunc init custom_map is_true maps/mp/zombies/_zm_weap_one_inch_punch one_inch_punch_melee_attack oneinchpunchgivefunc turn_on_power disable_doors_trenches add_staff_to_box override_zombie_count tomb_special_weapon_magicbox_check special_weapon_magicbox_check useBossZombies getdvarintdefault activate_zone_nml flag_set initial_blackscreen_passed flag_wait crazyplace openchamber trenches deactivatetank zone _k1 _a1 capture_zones_init_done zone_capture zones n_current_progress maps/mp/zm_tomb_capture_zones handle_generator_capture script_noteworthy setclientfield state_ zone_capture_in_progress end_game between_round_over round_number staff_air_zm zombie_weapons is_in_box limited_weapons staff_lightning_zm staff_fire_zm staff_water_zm zm_doors i targetname zombie_door getentarray origin weapon raygun2_included ray_gun_zm raygun_mark2_zm has_weapon_or_upgrade randomint beacon_zm beacon_ready shared_ammo_weapon any_crystal_picked_up trig t trig_tank_station_call disable_trigger speed_change_round increase_zombie_speed check_count intermission start_of_round waittill_any zombie_move_speed zombies get_round_enemy_array get_closest_valid_player closestplayer sprint set_zombie_run_cycle common_scripts/utility maps/mp/_utility maps/mp/zombies/_zm_utility maps/mp/zombies/_zm_weapons maps/mp/zm_tomb_utility maps/mp/zm_tomb_gamemodes maps/mp/zm_tomb_fx maps/mp/zm_tomb_ffotd maps/mp/zm_tomb_tank maps/mp/zm_tomb_quest_fire maps/mp/zm_tomb_teleporter maps/mp/zm_tomb_giant_robot maps/mp/zombies/_zm maps/mp/animscripts/zm_death maps/mp/zm_tomb_amb maps/mp/zombies/_zm_ai_mechz maps/mp/zombies/_zm_ai_quadrotor maps/mp/zombies/_load maps/mp/gametypes_zm/_spawning maps/mp/zm_tomb_vo maps/mp/zombies/_zm_perk_divetonuke maps/mp/zombies/_zm_perks maps/mp/zombies/_zm_perk_electric_cherry maps/mp/zombies/_zm_weap_staff_fire maps/mp/zombies/_zm_weap_staff_water maps/mp/zombies/_zm_weap_staff_lightning maps/mp/zombies/_zm_weap_staff_air maps/mp/zm_tomb maps/mp/zm_tomb_achievement maps/mp/zm_tomb_distance_tracking maps/mp/zombies/_zm_magicbox_tomb maps/mp/zombies/_zm_spawner maps/mp/zm_tomb_challenges maps/mp/zombies/_zm_perk_random maps/mp/_sticky_grenade maps/mp/zombies/_zm_weap_beacon maps/mp/zombies/_zm_weap_claymore maps/mp/zombies/_zm_weap_riotshield_tomb maps/mp/zombies/_zm_weap_staff_revive maps/mp/zombies/_zm_weap_cymbal_monkey maps/mp/zm_tomb_ambient_scripts maps/mp/zm_tomb_dig maps/mp/zm_tomb_main_quest maps/mp/zm_tomb_ee_main maps/mp/zm_tomb_ee_side maps/mp/zombies/_zm_zonemgr maps/mp/zm_tomb_chamber maps/mp/_visionset_mgr maps/mp/zombies/_zm_audio character/c_usa_dempsey_dlc4 character/c_rus_nikolai_dlc4 character/c_ger_richtofen_dlc4 character/c_jap_takeo_dlc4 maps/mp/zombies/_zm_powerup_zombie_blood maps/mp/zombies/_zm_devgui maps/mp/zombies/_zm_score maps/mp/zombies/_zm_challenges maps/mp/zombies/_zm_laststand   �  �  	  %  A  Y  s  �  �  �    �  �      4  H  e  �  �  �  �  �    R  5  Y  ~  �  �  �  �  	  :	  V	  q	  �	  �	  �	  �	  
  :
  a
  �
  �
  �
  �
  �
  �
    +  E  b    �  �  �  �    6          
   h'(Y   8   ' (?l ' (?d ' (?\ ' (?T ' (?L ' (?D ? @ Z         ����   ����   ����   ����   ����   ����    ���� ;   -              .       6       &-   
   F.        ;         !  (-2     6-2     6-2     6-4        6      !  (-
   .       ;  -
  .       6-
   .     6    _=	    
   F; -2        6    _=	    
   F; -2        6             -
  .       6    7   ' ( p'(_; V  '(d7!  (-0     6-ddQ7    0        6-
   7   N0       6 q'(?��+-
   .       6       &
  W; � 
   U%    
F;t 
      7!   (
  !  (
      7!   (
  !  (
      7!   (
  !  (
      7!   (
  !  (?  ? p�          -
  .     6-
   
   .     '(' ( SH;>  7       7�  E  ��F;             @� 7!   (' A? ��           _=    ; L  
   F; -
  0        ;   
   F;$ -
  0      ;  -d.      !K;  
   F;    _=    ;  ?  
   F;2 -
  0      >  -
  0      >  -
  0      ;   
   F;2 -
  0      >  -
  0      >  -
  0      ;   
   F;2 -
  0      >  -
  0      >  -
  0      ;   
   F;2 -
  0      >  -
  0      >  -
  0      ;      7    _; -     7    0      ;         &
  W; $ 
   U%    K; -
  .     6? ? ��                -
  
   .     '(' ( p'(_;   '(-0        6 q'(?��        &
  W"  -2        6-
   
   
   0        6    _=	    
   F;    J; !  (?��             _=	    
   G;  ;r -.      '(' ( SH;" - 7   .      7!   (' A? ��-.        '(' ( SH; -
   0      6' A? ��+?��      &     L  �          :      �  �      d  �         �      t  �       �      T  �      �  �        #      �  �   � �   �  �   �  .�  �  J�    zR    ��   &  ��   .  ��   6  ��   ?  ��   I  G�  \  k�  l  T  >  ��  z  �  
  ��   �  ��   �  1  
  \�    8  <�    f  ��  �  �      %  A  Q  a  }  �  �  �  �  �    ��  �   �   �  #�   �  a�  �  ��   %  _  ��  F  ��  �  � N  � P  �  T  �  �    �  �  �  �  �  �  �  �  �  �  ?	  �  �  �  �  �  �      �"  R  8 Z  Y j  t x    � �  �    � �  ��  ��  Z  ��  \  � �  ��  ��     J  4  k .  r R  � f    �  � r  *  �z  2  �  � �  �    6  z  �  ��  �  �  �  �  �  ��  �  �  �  ��  �  �  �  � �  �  "  ^  �  �  � �  �    N  r  �   �  �  �  >  �  �    #    %   `  0   H8  d  D  Ov  Vz  �  g �  �  r �  �  � �  ��  �  ��    � <  �V  �X  � d  �  9 �  E �  R �  n�  �  �T  � z  
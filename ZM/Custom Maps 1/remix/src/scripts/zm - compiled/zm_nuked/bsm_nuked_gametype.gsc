�GSC
     ~	  �  �	  �  �  �  �  �  �  @ V  '        C:/Users/astey/Documents/Black Ops 2 - GSC Studio/GSC Fast Compiler/Custom Maps 1/remix/src/scripts/zm - compiled/zm_nuked/bsm_nuked_gametype.gsc main extmapcheck xmapcheck CUSTOM_MAP 0 1 2 3 4 5  game_objects_allowed maps/mp/gametypes_zm/_zm_gametype replacefunc onspawnplayer get_player_spawns_for_gametype init_spawnpoints_for_custom_survival_maps init mode location allowed entities i isallowed isvalidlocation getentarray house hunters_cabin script_gameobjectname maps/mp/gametypes_zm/_gameobjects entity_is_allowed location_is_allowed is_classic spawnflags classname trigger_multiple connectpaths delete script_vector origin moveto movedone disconnectpaths predictedspawn spawnpoint match_string spawnpoints spawn_in_spectate ZSURVIVAL:onSpawnPlayer pixbeginevent usingobj is_zombie custom_spawnplayer player_initialized begin_spawning flag maps/mp/zombies/_zm check_for_valid_spawn_near_team scr_zm_map_start_location default default_start_location scr_zm_ui_gametype _ custom_map maze mazespawnpoints targetname initial_spawn_points getstructarray getfreespawnpoint zsurvival angles spawn getentitynumber entity_num onplayerspawned player_revive_monitor freezecontrols spectator_respawn score maps/mp/gametypes_zm/_globallogic_score getpersstat participation pers score_total old_score zombification_time enabletext maps/mp/zombies/_zm_blockers rebuild_barrier_reward_reset host_ended_game freeze_player_controls enableweapons game_mode_spawn_player_logic spawnspectator delay_thread pixendevent player random_chance side_selection j m spawns_randomized array_randomize randomint set_game_var get_game_var switchedsides team allies script_int arrayremovevalue playernum _team1_num _team2_num en_num player_spawns structs tokens token _k1 _a1 custom_spawns player_respawn_point script_string   strtok maps/mp/_utility maps/mp/gametypes_zm/_hud_util common_scripts/utility maps/mp/zombies/_zm_utility maps/mp/gametypes_zm/_callbacksetup maps/mp/gametypes_zm/_weapons maps/mp/gametypes_zm/_globallogic_defaults maps/mp/gametypes_zm/_hud_message maps/mp/gametypes_zm/_globallogic_ui maps/mp/zombies/_zm_laststand maps/mp/zombies/_zm_audio maps/mp/zombies/_zm_audio_announcer maps/mp/gametypes_zm/_hud maps/mp/zombies/_zm_stats maps/mp/gametypes_zm/_spawning maps/mp/zombies/_zm_pers_upgrades_functions maps/mp/zombies/_zm_game_module maps/mp/zombies/_zm_spawner �  P  a  �  �  �  �      �  �     B  g  �  �  �  �  �  l  	  B	  b	            
   h'(Y   8   ' (?l ' (?d ' (?\ ' (?T ' (?L ' (?D ? @ Z         ����   ����   ����   ����   ����   ����    ���� ;   -              .       6-            .       6-            .       6-.     6       &                     '(-.       '(
  h'(
   F; 
   '('(SH;t7    _;_-.     '(-.        ' (9>   9=	 -.      9;d 7    _= 7    F;/ 7    _= 7    
   G; -0       6-0        6'A? G�7    _;b -	��L=7    7    N0     6
  U%7   _= 7    F; -0     6'A? ��7    _= 7    F;/ 7    _= 7    
   G; -0       6'A? ��        &                     _< '(-
  .     6"   !   (    _=    _=    ; 
 -   1 6 -
  .       ;  -.       '(_< � 
   '(    '(
  F> 
   F=    _;    '(    
   NN'('(    _=	    
   F;( '(   SH;     S'('A?��?  -
  
   .       '(-.        '(-
   7   7   0      6-0        !  (-4        6-4        6-0      6!   (-
   0        !  (
   !  (   !  (    !  (!  (!  (!   (-4      6    _=    9; -0      6-0        6    _;' -    / ' ( ; -    	   ��L=0      6-.     6                     _< 
   _<G 
   (-.     '(-d.     '(2I;  -
  .     6? -
  .     6-
   .     '(-
   .       ;  F; '(? F; '(_=  7   _;4'(_= SH;  F;� 7   
   G= 7    _= 7    F; -.     6'(?G 7   
   F= 7    _= 7    F; -.       6'(? 'A?� 7   
   F= 7    _= 7    F; -.     6'(?G 7   
   G= 7    _= 7    F; -.       6'(? 'A?��7   _<a 7   
   F;* -
  .     7!  (-7   N
  .       6?) -
  .       7!  (-7   N
  .       6'(SH;T 7    _<& ' ( SH;    7!   (' A? ��?  7    7   F; 'A?��     
                    
   '	(    '(
  F> 
   F=    _;    '(    
   NN'	('(-
   
   .       '('(SH;x 7    _;X -
  7    .       '('(p'(_;( '(	F; S'(q'(? ��'A?��S'('A?�' (    �	  �       �
  �      �
       �  u      �  H     �  `     �  V    t
    |
  < �
  �
  �
  H  �
  H  �
  V  �
  V  �
  u  �
  �  �
  7 2  I C  ]  ]  �  �  �  �  �  � �  �  .  4 �  � �  ��   Q �  �  ` �  � �  �  �  ��  �  ��  �  �   �   �l  ]  � y  �  �  ��  �   �    �  Z �  j   t   .  �    � :  H  �  �  � �    ^  �  I $  � �	  � �	  �  �	  �
  �  6
  �  >
  �  F
  �  N
    V
   ^
  ��
  ��
  �  �  ��
  ��
  ��
  �  �  �  ��
  ��
  �   � 
  �$  hp  ~       D  R  s�  �  b  p  } �  t  ��  �  ��  �  �   ��  ��  ��  �  ��  �  
�   �  B�  K�  U�  �  h�  �  J  { �     6  �  �  �$  �  � ,  �  �>  F  �  �  �N  �   R  �  b  j   n  !|  �  1 �  �  < �  r �  |�  ��  �  �   �&  6  @  % ,  30  8:  DD  NP  aX  �h  p  ��  �   �  '�  5�  D�  F�  H �  �  5   ,  8  � F  �|  �  �  .  p  �  � �  �  2  t  �  ��  �  �    @  N  �  �  ��  �  �      p  � �  �  � �    �6  T  j  ��  ��  �  �  �  �  �  $ �  9  "  G   
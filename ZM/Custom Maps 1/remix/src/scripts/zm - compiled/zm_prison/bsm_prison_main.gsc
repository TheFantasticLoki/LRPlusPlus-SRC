�GSC
     �  QC    iC  -:  5;  aP  aP     @ 8 z       C:/Users/astey/Documents/Black Ops 2 - GSC Studio/GSC Fast Compiler/Custom Maps 1/remix/src/scripts/zm - compiled/zm_prison/bsm_prison_main.gsc main extmapcheck xmapcheck CUSTOM_MAP 0 1 2 3 4 5  give_afterlife maps/mp/zm_alcatraz_classic replacefunc init_brutus maps/mp/zombies/_zm_ai_brutus init door_think maps/mp/zombies/_zm_blockers include_craftables maps/mp/zm_alcatraz_craftables map custom_map rooftop custom_electric_chair_player_thread electric_chair_player_thread_custom_func bridge_reset track_quest_status_thread_custom_func docks acid_bench onplayerconnect onplayerconnected map_setup cost kill_door_think zombie_cost sethintlowpriority script_noteworthy local_power_on is_true _door_open door_opened power_cost sethintstring local_doors_stay_open waittill_door_can_close door_block ZOMBIE_NEED_LOCAL_POWER power_on ZOMBIE_NEED_POWER flag_wait default_buy_door set_hint_string door_buy door_delay _default_door_custom_logic alcatraz_afterlife_doors local_electric_door electric_door electric_buyable_door delay_door door_can_close flag craftable_name riotshield_dolly riotshield_door riotshield_clamp riotshield packasplat_case packasplat_fuse packasplat_blood packasplat plane_cloth plane_fueltanks plane_engine plane_steering plane_rigging plane refuelable_plane_gas1 refuelable_plane_gas2 refuelable_plane_gas3 refuelable_plane_gas4 refuelable_plane_gas5 refuelable_plane prison_open_craftablestub_update_prompt open_table zombie_include_craftables custom_craftablestub_update_prompt alcatraz_shield_zm build_zs piece_riotshield_dolly ondrop_common onpickup_common t6_wpn_zmb_shield_dlc2_dolly dolly generate_zombie_craftable_piece piece_riotshield_door t6_wpn_zmb_shield_dlc2_door door piece_riotshield_clamp t6_wpn_zmb_shield_dlc2_shackles clamp spawnstruct name add_craftable_piece onbuyweapon_riotshield onbuyweapon riotshieldcraftable triggerthink include_craftable build_bsm piece_packasplat_case p6_zm_al_packasplat_suitcase case piece_packasplat_fuse p6_zm_al_packasplat_engine fuse piece_packasplat_blood p6_zm_al_packasplat_iv blood packasplatcraftable p6_zm_al_key quest_key1 include_key_craftable tag_origin oncrafted_plane ondrop_plane onpickup_plane p6_zm_al_clothes_pile_lrg cloth tag_feul_tanks veh_t6_dlc_zombie_part_fuel fueltanks veh_t6_dlc_zombie_part_engine engine tag_control_mechanism veh_t6_dlc_zombie_part_control steering veh_t6_dlc_zombie_part_rigging rigging is_shared client_field_state sidequest_sheets pickup_alias sidequest_oxygen sidequest_engine sidequest_valves sidequest_rigging planecraftable prison_plane_update_prompt oncrafted_fuel ondrop_fuel onpickup_fuel accessories_gas_canister_1 fuel1 fuel2 fuel3 fuel4 fuel5 planefuelable s_struct m_shockbox t_bump amount attacker shockbox_anim fxanim_props fxanim_zom_al_shock_box_on_anim on fxanim_zom_al_shock_box_off_anim off afterlife_door ZM_PRISON_AFTERLIFE_DOOR cellblock origin targetname target getstruct getent health setcandamage useanimtree trigger_radius spawn angles HINT_NOICON setcursorhint ZM_PRISON_AFTERLIFE_INTERACT damage isplayer getcurrentweapon lightning_hands_zm afterlife_interact_dist distance2d delete zmb_powerpanel_activate playsound box_activated _effect playfxontag p6_zm_al_shock_box_on setmodel setanim script_string wires_shower_door wires_admin_door getentarray array_delete player_opened_afterlife_door disable_afterlife_boxes script zm_prison auto_upgrade_tower disable_gondola disable_doors_docks showers disable_doors_showers disable_doors_cellblock player connected maps/mp/zombies/_zm_game_module turn_power_on_and_open_doors flag_set zombie_power_on setclientfield sleight_on wait_network_frame doubletap_on juggernog_on electric_cherry_on deadshot_on divetonuke_on additionalprimaryweapon_on Pack_A_Punch_on afterlife_doors_close bench col col2 acidgatmodel trigger weap end_game souldistance script_model p6_zm_work_bench souls collision_clip_64x64x64 p6_anim_zm_al_packasplat acid_gat_trigger This Machine Needs Power watchzombies soulsAreDone Hold ^3&&1^7 to convert Blundergat into Acidgat usebuttonpressed blundergat_zm blundergat_upgraded_zm takeweapon Converting... Hold ^3&&1^7 for Acidgat distance blundersplat_zm giveweapon switchtoweapon blundersplat_upgraded_zm zombies i all axis getaispeciesarray soulchest watchme start closest newbench death sendsoul end fxorg fx powerup_on moveto useBossZombies getdvarintdefault int helmet_off actor registerclientfield brutus_lock_down brutus_setup_complete brutus_zombie_spawner brutus_spawners brutus_prespawn add_spawn_function array_thread is_enabled script_forcespawn brutus_location getstructarray brutus_spawn_positions setup_interaction_matrix sndbrutusistalking brutus_health brutus_health_increase brutus_round_count brutus_last_spawn_round brutus_count brutus_max_count brutus_damage_percent brutus_helmet_shots brutus_team_points_for_death brutus_player_points_for_death brutus_points_for_helmet brutus_alarm_chance brutus_min_alarm_chance brutus_alarm_chance_increment brutus_max_alarm_chance brutus_min_round_fq brutus_max_round_fq brutus_reset_dist_sq brutus_aggro_dist_sq brutus_aggro_earlyout brutus_blocker_pieces_req brutus_zombie_per_round brutus_players_in_zone_spawn_point_cap brutus_teargas_duration player_teargas_duration brutus_teargas_radius num_pulls_since_brutus_spawn brutus_min_pulls_between_box_spawns brutus_explosive_damage_for_helmet_pop brutus_explosive_damage_increase brutus_failed_paths_to_teleport brutus_do_prologue brutus_min_spawn_delay brutus_max_spawn_delay brutus_respawn_after_despawn brutus_in_grief ui_gametype zgrief brutus_shotgun_damage_mod brutus_custom_goalradius brutus_spawning_logic get_brutus_interest_points check_perk_machine_valid custom_perk_validation check_craftable_table_valid custom_craftable_validation check_plane_valid custom_plane_validation m_linkpoint chair_number n_effects_duration e_home_telepoint e_corpse_location using custom electric chair thread logprint death_or_disconnect home_telepoint_ corpse_starting_point_ disableweapons enableinvulnerability stand setstance playerlinktodelta setplayerangles zmb_electric_chair_2d playsoundtoplayer chair_electrocution quest do_player_general_vox ghost ignoreme dontspeak isspeaking setclientfieldtoplayer character_name J_Head vox_plr_3_arlington_electrocution_0 playsoundontag vox_plr_1_sal_electrocution_0 vox_plr_2_billy_electrocution_0 vox_plr_0_finn_electrocution_0 Arlington Sal Billy Finn zone_golden_gate_bridge zones is_spawning_allowed unlink setorigin enableweapons rumble_electric_chair disableinvulnerability show t_plane_fly using bridge reset thread characters_in_nml plane_trip_to_nml_successful flag_clear bridge_empty start_of_round prep_for_new_quest waittill_crafted fly fuel transfer_plane_trigger plane_fly_trigger trigger_on tower_disabled enableTowerUpgrade enabletowerupgrade zombie_vars trap_activated tower_trap_upgraded t_call_triggers call_triggers gondola_powered_on_roof gondola_call_trigger zm_doors zombie_door a_afterlife_triggers _a87 _k87 struct afterlife_trigger unitrigger_stub maps/mp/_utility common_scripts/utility maps/mp/zombies/_zm_utility maps/mp/zm_alcatraz_utility maps/mp/zombies/_zm_craftables maps/mp/zombies/_zm_afterlife maps/mp/gametypes_zm/_zm_gametype maps/mp/zm_prison_achievement maps/mp/zm_prison_spoon maps/mp/zm_prison_sq_bg maps/mp/zm_alcatraz_sq maps/mp/zm_prison maps/mp/zm_alcatraz_traps maps/mp/zm_alcatraz_travel maps/mp/zombies/_zm_magicbox maps/mp/zombies/_zm_powerups maps/mp/zm_prison_sq_final maps/mp/zm_prison_sq_fc maps/mp/zm_prison_sq_wth t    �  �  �       �  F  ;  Y  �  {  �  �  �  �  �    '  D  a  |  �             
   h'(Y   8   ' (?l ' (?d ' (?\ ' (?T ' (?L ' (?D ? @ Z         ����   ����   ����   ����   ����   ����    ���� ;   -              .       6-            .       6-            .       6-            .       6            
   F;      ' ( _=   
   F;      !  (      !  ( _=   
   F;' -      ?C        �;D `�E  RC 2     6 _=   
   G;# -4       6-4        6-4        6         
   W �' (    _;    ' (-0      6;N   Y �  -    .     <  
   U%-   .       < + - 0     6    _< !   (    �N!   (-
   0      6-   .     ;   +-0     6-0        6-   .     ;  - 0     6-   0        6+? 5�-    .     <  
   U%-   .       < + - 0     6    _< !   (    �N!   (-
   0      6-   .     ;   +-0     6-0        6-   .     ;  - 0     6-   0        6+? y�-
  .       6- 
   0     6-0        <  ? I�? t -0     <  ? 5�-0     6?X    _; -0     6?D -0     <  ? �? 0 Z          ���   ����   h���   ����    ����- 0       6-
   .     <  ?  ? ��                                                         
      7!   (
  '(-
   
                 @ 
   
   .       '(-
   
               0
  
   .       '(-
   
                
   
   .       '(-.       '(7!   (-0     6-0     6-0     6      7!  (    7!  (-.     6
  '(-
   
               $0
   
   .       '(-
   
               $ 
   
   .       '(-
   
                
   
   .       '(-.       '(7!   (-0     6-0     6-0     6      7!  (-.     6-
   
   .     6
  '(-
                    0
   
   .       '(-
                     
   
   .       '
(-
                    > 
   
   .       '	(-
                     
   
   .       '(-
                     
   
   .       '(7!   (
7!   (	7!   (7!   (7!   (7"   
7"  	7"  7"  7"  
   7!  (
  
7!  (
  	7!  (
  7!  (
  7!  (-.       '(7!   (-0     6-	0     6-
0     6-0     6-0     6      7!  (    7!  (-.     6
  '(-                     
   
   .       '(-                     
   
   .       '(-                     
   
   .       '(-	                     
   
   .       '(-
                     
   
   .       '(7!   (7!   (7!   (7!   (7!   (7"   7"  7"  7"  7"  -.      ' ( 7!   (- 0     6- 0     6- 0     6- 0     6- 0     6       7!  (    7!  (- .     6                 	   ��L=+    _<       
   !  (     
   !  (   _=	    
   F;&-  0        6    _=	    
   F>    _=	    
   F;#      �E �F �DG; -0        6-
      .     '(_<   -
   7   .     '(�7!  (-0     6-0     6-@7    
   .     '(7    7   cPN7   bPN7    aPN7!  (_;  -
  0     6-   0       6;

   U$$ %- .      =  - 0        
   F;�    _;� -7     7   .        H;� -0        6-
   0       6-
   
      .      6-
   0       6-
      0      67    
   F> 7   
   F= 7   _; --
   7   .       .       6-0       6X
    V? ? ��; " -0       <  	   ��L=+?��?  ? ��             ' (-2       6    
   F=  _=  
   F; -2        6-2     6-2     6?i  _=  
   F; -2      6?M    
   F=  _=  
   F; -2      6?%    
   F=  _=  
   F;	 -2      6         
   U$ %-.     6+-
  .       6-
   0      6X
   V-.      6X
   V-.      6X
   V-.      6X
   V-.      6X
   V-.      6X
   V-.      6X
   V-.      6X
   V-.      6         
   U$ %- 4       6?��        
                    
   W �!  (-
   .       '(-
   0     67!   (7!  (	_=  	
   F;o -   �=D ��E  rC
   .       '(-
   0     67!   (-     ?D ��E  rC
   .       '(-
   0     67!   (-           4BN
  .       '(-
   0     67!   (-F#           BN
  .       '(
  7!  (7!   (-
   0     6-
   0       6-2       6
  U%+-
  0       6
  U$%-0      ; -0        ' ( 
  F>  
   F;�  
   F; -
  0     6?  
   F; -
  0       6-
   0       6+-
  0     6-0       =  -7    7   .     AH;Z  
   F;$ -
  0     6-
   0       6?< ? ,  
   F;" -
  0       6-
   0       6? 	   ���=+?q�	   ���=+-
   0       6?��              
   W; P -
  
   .       '(' ( SH;$  7    _< - 4     6' A? ��	   ��L=+?��                
   W!  (
  U%_<                   4BN'(_<      '(' (-7   .       H; -7    .       '(' ( _9>   7   _9;   7!   A- 4     67    K; X
  V                _;                  4BN'(_9>  _9;   -
   .       '(-
   0     6-
   
      .      ' (-0     6+- 0        6-0       6       &            _=	    
   G= -
  .     9;B -
   (#
   
   .     6-
    (#
   
   .       6-
   .     6 -
  
   .     !  (    SF;  -               .       6' (     SH; &     7!   (     7!   (' A? ��-
  
   .       !  (-4        6!  (�!  (�!  (!  (!  (!  (!   (	  ���=!  (!   (�!  (�!   (�!   (d!   (d!   (
!   (�!   (!   (!   (     !  ( @!  (!   (!   (!   (x!   (!   (!   (@!   (!  (!   (�!  (X!  (!   (!   (
!   (<!   (!   (!  (
  h
  F; !  (	  �?!  (0!   (-
    (#
   
   .       6-
    (#
   
   .       6-4        6    < / -4       6      !  (      !  (      !  (                 -
  .       6
  W-
  
   N.      '(-
   
   N.        ' (-0      6-0        6-
   0        6-
   0        6-7   0      6-
  0        6-d
  
   0      6-0        6!   (!   (-
   0      6O+    Y   T   -
  
   0      6?d -
  
   0      6?P -
  
   0      6?< -
  
   0      6?( Z         ����   ����   ����   ����+
     7!   (
     7!   (-0      6-
   0        6F; -  f�E3UF  �D0      6?� F; -  f
E �F  �D0      6?� F; -  f&%Ef�F  �D0      6?i F; -  �)E3�F  �D0      6?E F; -   HEf�F  �D0      6?! F; -  ��E��F  �D0      6-0        6-
  0        6	    �?+-0        6-0        6!  (!  (         -
  .       6;�    SF; +?��   SI; +?��-
  .     ;  -
  .       6X
   V
   U%-.       6-
   .     6-
   
   .     6-
   
   .     ' (- 0     6+? i�        &
  W
   W-
   .     !  (    
   !  (   <  X
  V;  
   U%+X
  V? ��              +X
   V-
  
   .     '(p'(_;  ' (^  7!  ( ? ��          -
  
   .     '(' ( SH;0  7       �B ��E ��CF; ^  7!   (' A? ��            -
  
   .     '(' ( SH;0  7      `�D �F @�DF; ^  7!   (' A? ��            -
  
   .     '(' ( SH;h  7      �E F ��DF>  7      �E 0F ��DF>  7       � �F ��DF; ^  7!   (' A? ��                -
  
   .     '('(p'(_;  ' (^  7   7!  (q'(?��       �         d      �  i      L"  �      �(  �      X+  �      ,  k      �,  {      �,  `     �/  �     ,0  �     �0       �1        �1  :      d4  �     <7  '      �7  t      H8  �      �8  �      �8  �      L9  �      �9  K    �    �  . �  �  �     :  �  dF  �  i  �  it  �  �  �  ��  �  �  :  '  E  ` �  k  �  {  �  �  �  � �  �       f   �   �   �   "!  J!  � .   �   �   Z!   Y   �   !  g!  )  *  F.  x.  �.  /  �/  :  v   2!  R     ;!  � |!  � �!  �  �!  �!  �!  �  �!  �  �!  � $"  U 2"  v7  �  x"  P  �"  �"  #  �#  �#  "$  ^  �"  �"  #  �#  �#  ($  � �"  �"  4#  �#  $  @$  %  @#  L$  P&  5(  6 Z#  f#  r#  f$  r$  ~$  j&  v&  �&  �&  �&  N(  Z(  f(  r(  ~(  J  y#  m  �#  � �#  �$  �&  �(  L  �$  x �$  �  �$  �$  +%  c%  �%  �  �$  �$  0%  h%  �%  �  �$   %  8%  p%  �%  �
 �$  %  P%  �%  �%  �&  0'  h'  �'  �'  $
  �&  3
  �&  �(  N
  �&  	'  A'  y'  �'  ]
  �&  '  H'  �'  �'  i
  �&  '  P'  �'  �'  �
  �(  �t S)  +  � f)  �4  �4  � �)  �7  � �)  � �)  � �)   .  � *  T.  " -*  +  ;*  �.  g b*  r  s*  w1  �1  � �*  � �*  Y1  � �*  6-  �-  �-  �-  B1  � �*   �*  2  b8  �8  �8  Z9  ! +  �t  0+  K  d+  t  �+  �  �+  �  �+  �  �+  �  �+  	,  �  &,  / 4,  �1  H E,  b  U,  e,  u,  �,  �,  �,  �,  �,  �  �,  � $-  t-  �-  �-  01  � `.    �.  /  ; �.  �.  m */  �0  �0  � F/  t/  � T/  �/  � �/  � 
0   �0  . j1  D �1  �7  k �1  �1  �3  4  �  &2  �  ,2  � 82  ) �2  �9  O  �2  .F  4  DF  04  _  94  �  E4  �  Q4  c t4  D7  �  �4  �  �4  � �4  6  � �4  � �4   5  @ 5  V  '5  z I5  �6  � m5  �5  �5  �5  �  6  � 16  U6  y6  �6  �6  �6  �  �6  �  7  �  7  ( �7  O  �7  b �7  |F �7  �  �7  �
       �(  '  �(  �   �   �    �  j    �  �1  �  r  �  z  �  �  �  �    �  �  Z+  �,  �	  $  )  )  ()  0)  ^+  �1  �1  � 4  4)  ,  �B  4N  Z \  �+  Z-  ��  � �  ��  �  ��  �(  �(  �   �    �   �   �   H!  8   B   H   P   �   �   !  !   V   !  $d    !  ] �   u�   u �   z!  2,  ~ d!  � �!  ��!   �!   "  % 
"  ; "  F 0"  ZN"  iP"  zR"  �T"  �V"  �X"  �Z"  �\"  �^"  �`"  �b"  �d"  f"  h"  (j"  .l"  Dn"  Zp"  pr"  �t"  �v"  � �"  ��"  ��"  �&  �(   �"  0 �"  �"  
#  9 �"  n �"  � �"  � �"  � �"  � �"  � #  � ,#   0#  1R#  ^$  b&  F(  a�#  ��#  �$  �&  �(  � �#  � �#  �#  $  � �#  � �#  � �#  � �#  �  $   $   $  / 8$  F <$  ` �$  m �$  ( �$  � �$  (%  �%  �*  >1  L1  �4  � �$  � �$  � �$  � %  	 %  	 H%  8	 L%  ?	 `%  U	 �%  t	 �%  }	 �%  �	 �%  �	
�%  �%  �%  �%  �%  �'  �'  �'  (  (  �	
&  &  &  &  &  (   (  &(  ,(  2(  �	 &  �	$&  .&  8&  B&  L&  �	 (&  �	 2&  
 <&  
 F&  � �&  �7  w
 �&  ('  `'  �'  �'  �
 �&  �
 ,'  �
 d'  �
 �'  �
 �'  �
�(  �
�(  �
�(  �
�(  �
�(  �
�(  �(  �(  �*  $ �(  �*  H �(  L �(  [ )  t  )  �+  ~<)  �)  �)  �)  Z*  `*  �,  "/  (/  R0  �0  �0  �0  1  �8  �8  �8  9  :9  x9  �9  �9  �9  :  �
 `)  z)  �4  �4  �7  \8  �8  �8  T9  �9  �d)  �)  ��)  � �)  .  �
�)  �)  �)  �,  D-  �-  �-  .  <.  �4  � �)  P.  � *    *  < F*  ON*  j*  y �*  � �*  ��*  V1  � �*  ��*  �*  �*  �*  � �*   �*  � �*  2  z2  . +  cp+  �+  �+  j t+  �+  �+  � �+  �,  �,  
-  � ,  �,  8 B,  W P,  u `,  � p,  � �,  � �,  � �,  � �,  � �,  � -  �/  .0  -  -  -  -  N8  !-  & -  �7  /-  r0  < "-  r-  �-  �-  .1  I 2-  ZL-  �0  �0  ` �-  �-  x �-  � ,.  �2.  � B.  � j.  �/  80  �0  � t.  �/   �.   �.  �.  �.  :/  $ �.  �.  �.  h/  F �.  T /  v B/  P/  � p/  �/  ��/  ��/  �1  �8  �8  P9  � �/  � �/  ��/  @0  �00  �0  �20  �40   D0  �0  �0   �0  # R1  5 �1  V �1  �1  �3   4  Z �1  �3  e �1  �1  �3  4   �1  
4  � �1  � 2  �2  2  62  J2  X2  h2  �^2  �5  n2   ~2  8�2  h�2  {�2  ��2  ��2  ��2  ��2  ��2  ��2  ��2  �2  0�2  O�2  h�2  |3  �
3  �3  �3  �"3  �.3  63  >3  2F3  LN3  dV3  �^3  �f3  �n3  �t3  �|3  �3  9�3  Z�3  z�3  ��3  ��3  ��3  ��3  �3  (4  � �3  � �3  ��3  �3  xB4  �N4  �Z4  �f4  �h4  
j4  l4  .n4  @ r4  l ~4  � �4  � �4  � �4  6  � 5  & 5  : 5  \65  ,7  e>5  27  o F5  �Z5  � f5  z5  �5  �5  � j5  � ~5  � �5   �5  7 �5  A �5  E �5  K �5  P �5  �5  h�5  �5  n�5  � �6  �>7  � B7  �T7  d7   t7  �7  3 �7  @ �7  s �7  w �7  � �7  � �7  "8  � �7  8  �8  8  8  �8  � .8    88  J8  $L8  2 V8  J `8  _�8  �8  N9  h �8  �8  X9  t�9  ��9  ��9  ��9  � �9  �:  
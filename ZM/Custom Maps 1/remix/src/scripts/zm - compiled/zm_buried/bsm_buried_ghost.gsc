�GSC
     �  �  �  �  �  2  �  �  �  @ w  H     
   C:/Users/astey/Documents/Black Ops 2 - GSC Studio/GSC Fast Compiler/Custom Maps 1/remix/src/scripts/zm - compiled/zm_buried/bsm_buried_ghost.gsc main zeGamemode survival  ghost_round_think maps/mp/zombies/_zm_ai_ghost replacefunc init_ghost_spawners _a131 _k131 spawner script_noteworthy ghost_zombie_spawner getentarray ghost_spawners prespawn add_spawn_function array_thread targetname female_ghost female_ghost_spawner spot death intermission maps/mp/zombies/_zm_ai_ghost_ffotd prespawn_start origin startinglocation ghost_zombie animname ghost audio_type has_legs no_gib ignore_enemy_count ignore_equipment ignore_claymore force_killable_timer noplayermeleeblood paralyzer_callback paralyzer_hit_callback paralyzer_slowtime paralyzer_score_time_ms ignore_slowgun_anim_rates ghost_reset_anim reset_anim ghost_springpad_fling custom_springpad_fling bookcase_entering_callback ignore_subwoofer ignore_headchopper ignore_spring_pad recalc_zombie_array setphysparams cant_melee spawn_point angles forceteleport run set_zombie_run_cycle zm_move_run setanimstatefromasd ghost_damage_func actor_damage_func ghost_death_func deathfunction ghost_health maxhealth health zombie_init_done allowpain ignore_nuke normal animmode face enemy orientmode none bloodimpact disableaimassist forcemovementscriptstate maps/mp/zombies/_zm_spawner zombie_setup_attack_properties is_spawned_in_ghost_zone pathenemyfightdist zombie_complete_emerging_into_playable_area setfreecameralockonallowed ghost_custom_think_logic ghost_bad_path_failsafe bad_path_failsafe ghost_think attack_time ignore_inert subwoofer_burst_func subwoofer_fling_func subwoofer_knockdown_func prespawn_end qrate player get_current_ghost_count zombie_total ghost_round_last_ghost_origin last_ghost_down stoploopsound zmb_ai_ghost_death playsound ghost_impact_fx setclientfield ghost_fx prepare_to_die extra_custom_death_logic anim_rate getclientfield zm_death getanimlengthfromasd wait_ghost_ghost death_anim maps/mp/animscripts/zm_shared donotetracks zombie_ghost_count favoriteenemy ghost_count attacker is_player_valid give_player_rewards owner buried_ghost_killed maps/mp/zombies/_zm_stats increment_client_stat increment_player_stat delete old_spawn_func old_wait_func ghost_round flag_init round_number randomintrange next_ghost_round round_spawn_func round_wait_func between_round_over music_round_override ghost_round_start ghost_round_spawning ghost_round_wait sndghostroundmus sndghostroundmus_end zombie_ghost_round_states is_started flag ghost_round_stop max players valid_players ghost_ai ghost_round_ending ghost_intermission get_players ghost_round_aftermath increase_ghost_health array_randomize find_ghost_spawn spawn_zombie is_ghost find_target point zombie_spawn_locations randomint zone_name maps/mp/zombies/_zm_zonemgr is_player_in_zone script_string find_flesh ent script_origin spawn sndroundwait sndGhostRoundEnd mus_ghost_round_start mus_ghost_round_loop playloopsound stingerDone mus_ghost_round_over playsoundwithnotify restart_round flag_set ghost_round_starting flag_clear power_up_origin full_ammo maps/mp/zombies/_zm_powerups specific_powerup_drop maps/mp/_utility common_scripts/utility maps/mp/zombies/_zm_utility G    �  �  �  �   T  z  �  �        &
  h
  G;  -            .       6-            .       6             -
  
   .       !  (    SF; -              .       6    '(p'(_; ( ' ( 7   
   F;  !  (q'(?��         
   W
   W-0     6    !  (
  !  (
  !  (!   (!   (!   (!   (!  (!  (!   (    !  (!  (g!  ("        !  (      !  (      !  (!   (!   (!   (-.     6-H0       6!   (    _;3    ' ( 7    _<	 ^* 7!  (- 7    7   0        6-
   0        6-
   0        6      !  (      !  (    !  (    !  (!   (X
   V!   (!   (-
   0      6-
   0        6-
   0        6-0        6!  (-0      6    _=    ;  !   (-0        6-0       6    !  (    _;	 -   1 6      !  (-4        6!  (!   (    !  (      !  (      !  (-0        6           -.        F=     F;     !  (X
   V-0       6-
   0        6-
   0      6-
   0      6-4        6    _;	 -   5 6-
   0      '(-
   0      6--
   0      4      6-
   .     6    _=    ; 1 !  B    _;#    7   _=
    7   I; 	    7!  B' (-   .       ;  -    .     6    ' (?9    _= -    7   .     ;  -    7   .     6    7   ' ( _; ! -
    0       6-
    0       6-0        6        -
  .     6    -.        N!   (    '(    ' (;� 
   U%       F;r !  (    '(    ' (-.       6      !  (      !  (-2     6-2     6    7!  (    -.        N!   (?9 -
  .     ; +     7!  (-.       6!   ( !   (!  (?9�                
   W
   W   ;   !   (+-.      SP'(-4      6!   (-.     6;�    J;  ? � -.      '(-.     '(-.       '(_<  ? ��-    7      .     ' ( _; < -
   0     6 7!   ( 7!   ( 7!   (!   B!   A? ? [�+?U�            ; H -    SO.        ' (- 7    0     9>  7   
   G; ? ��?   ?��          
   W-^*
  .       ' (!   (- 4     6
   W-
    0     6+-
   0       6       &
  U%X
   V-0     6-
   
   0        6
  U%-0      6!  (     &
  W+-
   .     ;  +    ;  	      ?+?��        &-
   .     6X
   V        &-
   .     6         
   U%X
   V   ' (- 
   4      6+!   (   7!  (     �  �       0  &      �  �      0  �      �  �       �  �	      �  �
     L  �	      �  �	      �  �	      (  }	      D  
      X  k
  � �   �  � �      �       &�     &�     u�  @  ��   [  ��   `  ��  l  !�  �  ��   #  J�   >  f�   I  ��   U  ��   z  ��  �  $�  �  6�  �  W�  �  �  k�   �  ��     ��  E  �  S  �  c  *�   o  pT  �  �T  �  ��  �  �  �  E�   �  j�   �  �     ��     ��    ��   7  �  d  �  ;�  s  �  U�  �  �  �  m�   �  ��  �  ��  �  ��  �  � �  I�  H  ~  Y�  Z  �  �� �  �� �  ��   �  �  ��  �  	�  �  �  }	�   L  �	�   U  �	�   a  �	�   n  �	�   v   
�  �  �  
�   �  _
�     Q  k
�   %  �
�   6  �
�  ^  �
�  l  �
�  �  �
�    '   d�  \  �	�   r  ��  �  ��  �  �  .  "�  J  dG y  �  �  �  �  :2  @4  F6  N :  ` >  �J  P  j  x  ��  �  � �  ��  �  �  ��  � �  � �  �  0�  �  �  R  7�  �  H �  U�  ^ �  d�  o�  x�    �  �  �  �   �*  0  6  0<  [F  |R  �^  �f  �n  �v  �  �  �  �  �  �  �  �  2 �  K �  }�  �
  �    �  �  �&  � ,  �4  �<  � B   P   `  ;|  ��  �       ��  �  �  3�  Q�  ]�  j    �  �2  �4  �  �H  2  D  �  �V  l  
 \  ^  ( p  E �  d �  �  |�  �  � �  � �  �  � �    �  &    *  8  4"  .  <  @F  X  d  n  x  �  �  m|  �  �  s �  �  ��  ��  � �  �  �  ,  H  	�  *  �  #	  .  �  4	  >  ^  �  E	  F  j  �  U	 "  h	8  �  �	�  �  �  �	�  �  �  
�  
�  "
�  0
�  9
 �  R  �  f  �  L
    �  �
�  �
�  �
�  �
       9,  G 0  RN  V Z  jl  �  w z  �  � �  � �  � �  �  � �  � �   8  -Z  = v  
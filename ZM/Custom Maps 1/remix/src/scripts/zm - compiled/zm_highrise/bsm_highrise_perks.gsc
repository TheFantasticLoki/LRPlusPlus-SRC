�GSC
     �  �  +  �    I  �)  �)  �  @ �          C:/Users/astey/Documents/Black Ops 2 - GSC Studio/GSC Fast Compiler/Custom Maps 1/remix/src/scripts/zm - compiled/zm_highrise/bsm_highrise_perks.gsc main extmapcheck xmapcheck CUSTOM_MAP 0 1 2 3 4 5  perk_machine_spawn_init maps/mp/zombies/_zm_perks replacefunc set_perk_clientfield perk state custom_map resetperkhud perk_additional_primary_weapon setclientfieldtoplayer perk_dead_shot perk_dive_to_nuke perk_double_tap perk_juggernaut perk_marathon perk_quick_revive perk_sleight_of_hand perk_tombstone perk_chugabud _custom_perks clientfield_set specialty_additionalprimaryweapon specialty_deadshot specialty_flakjacket specialty_rof specialty_armorvest specialty_longersprint specialty_quickrevive specialty_fastreload specialty_scavenger specialty_finalstand extra_perk_spawns specialty_weapupgrade array building1topperkarray spawnstruct building1topperks origin angles zombie_vending_quickrevive model script_noteworthy zombie_vending_jugg zombie_vending_doubletap2 zombie_vending_sleight zombie_vending_nuke_on_lo zombie_vending_three_gun p6_anim_zm_buildable_pap_on redroomperkarray redroomperks match_string location pos structs usedefaultlocation i tokens k _k1 _a1 _k2 _a2 use_trigger perk_machine bump_trigger collision flag_pos perk_machine_flag scr_zm_map_start_location default default_start_location scr_zm_ui_gametype _perks_ override_perk_targetname targetname getstructarray zm_perk_machine zclassic_perks_rooftop zclassic_perks_tomb zstandard_perks_nuked disablebsmmagic is_true building1top redroom script_string   strtok delete zm_collision_perks1 precachemodel trigger_radius_use spawn zombie_vending triggerignoreteam givepoints script_model setmodel is_locked _no_vending_machine_bump_trigs trigger_radius script_activated zmb_perks_bump_bottle script_sound audio_bump_trigger thread_bump_trigger disconnectpaths clip bump script zm_highrise machine blocker_model script_int turn_on_notify mus_perks_revive_jingle revive_perk mus_perks_revive_sting script_label vending_revive target mus_perks_speed_jingle speedcola_perk mus_perks_speed_sting vending_sleight mus_perks_stamin_jingle marathon_perk mus_perks_stamin_sting vending_marathon mus_perks_jugganog_jingle jugg_perk mus_perks_jugganog_sting longjinglewait vending_jugg mus_perks_tombstone_jingle tombstone_perk mus_perks_tombstone_sting vending_tombstone mus_perks_doubletap_jingle tap_perk mus_perks_doubletap_sting vending_doubletap mus_perks_whoswho_jingle mus_perks_whoswho_sting vending_chugabud mus_perks_mulekick_jingle mus_perks_mulekick_sting vending_additionalprimaryweapon vending_packapunch mus_perks_packa_jingle mus_perks_packa_sting getstruct pack_flag perks_rattle mus_perks_deadshot_jingle deadshot_perk mus_perks_deadshot_sting vending_deadshot deadshot_vending vending_deadshot_model perk_machine_set_kvps specialty_quickrevive_upgrade specialty_fastreload_upgrade specialty_longersprint_upgrade specialty_armorvest_upgrade specialty_scavenger_upgrade specialty_rof_upgrade specialty_finalstand_upgrade specialty_additionalprimaryweapon_upgrade specialty_deadshot_upgrade change_collected players get_players distance getstance prone score maps/mp/zombies/_zm_magicbox common_scripts/utility maps/mp/_utility maps/mp/zombies/_zm_utility maps/mp/zombies/_zm_weapons maps/mp/zombies/_zm_laststand maps/mp/zombies/_zm_power maps/mp/zombies/_zm_pers_upgrades_functions maps/mp/zombies/_zm_audio maps/mp/_demo maps/mp/zombies/_zm_stats maps/mp/zombies/_zm_score maps/mp/_visionset_mgr maps/mp/zombies/_zm �  �  �  �  �    "  <  h  �  �  �  �     �           
   h'(Y   8   ' (?l ' (?d ' (?\ ' (?T ' (?L ' (?D ? @ Z         ����   ����   ����   ����   ����   ����    ���� ;   -              .       6              
   G; !  ( Y   �   - 
  0        6?@- 
  0        6?,- 
  0        6?- 
  0        6?- 
  0        6?� - 
  0        6?� - 
  0        6?� - 
  0        6?� - 
  0        6?� - 
  0        6?�    _=     7    _; -    7    16Z      ����   ���   ���    ���   ,���   8���   D���   P���	   \���
   h���    t���        &-
   
   
   
   
   
   
   .     !  (-.     
   !  (  `�D  �D �SE
      7!   (   �  4C    
      7!   (
  
      7!   (
  
      7!   (-.       
   !  ( 
��D��)ER�>E
      7!   (      �C    
      7!   (
  
      7!   (
  
      7!   (-.       
   !  ( ��E��E>E
      7!   (      �C    
      7!   (
  
      7!   (
  
      7!   (-.       
   !  ( q��D3c�DIE
      7!   (      C    
      7!   (
  
      7!   (
  
      7!   (-.       
   !  ( \��DbE�4IE
      7!   (      4B    
      7!   (
  
      7!   (
  
      7!   (-.       
   !  ( �2�D��ETE
      7!   (      �B    
      7!   (
  
      7!   (
  
      7!   (-.       
   !  ( �j�D
/�DTE
      7!   (      �B    
      7!   (
  
      7!   (
  
      7!   (-
   .       !  (-.     
   !  (  �:E ��D ��D
      7!   (      �CffFA
      7!   (
  
      7!   (
  
      7!   (                                           -.      6
  '(    '(
  F> 
   F=    _;    '(    
   NN'('(    _; -
     .     '(? -
  
   .     '(
  F> 
   F> 
   F; '('(SH;� -    .       > 	    
   F>	    
   F;             @�7!   (7   _;� -
  7    .     '('(SH;Z F; H -    
   F.        =  7    
   F; -0       6? S'('A?��?  _= ;  S'('A?�   _=	    
   F;:    '(p'	(	_; " 	'
(
   S'(	q'	(? ��? J    _=	    
   F;6    '(p'(_; " '
(
   S'(q'(? ��_9>  SF;  -
   .     6'(SH;�7    '
(
_=  7    _;�-F(7                 �AN
  .       '(
  7!  (
7!   (-0     6-4       6-7    
   .       '(7   7!  (-7    0       67!  (    _=    ;  '(? O -@#7    
   .     '(7!   (
  7!  (
  7!  (

  G; -4      6-7    
   .     '(7   7!  (-   
   F.      <  -
  0     6-0       6
  7!  (7!   (7!   (-   .       = 	    
   F;             @�7!  (7!   (7   _; 7    7!  (7   _; 7    7!  (7   _; 7    7!  (
Y  �  
   7!  (
  7!  (
  7!  (
  7!  (
  7!  (
  7!  (_;  
   7!  (?*
   7!  (
  7!  (
  7!  (
  7!  (
  7!  (
  7!  (_;  
   7!  (?�
   7!  (
  7!  (
  7!  (
  7!  (
  7!  (
  7!  (_;  
   7!  (?�
   7!  (
  7!  (
  7!  (7!   (
  7!  (
  7!  (
  7!  (_;  
   7!  (?*
   7!  (
  7!  (
  7!  (
  7!  (
  7!  (
  7!  (_;  
   7!  (?�
   7!  (
  7!  (
  7!  (
  7!  (
  7!  (
  7!  (_;  
   7!  (?�
   7!  (
  7!  (
  7!  (
  7!  (
  7!  (
  7!  (_;  
   7!  (?4
   7!  (
  7!  (
  7!  (
  7!  (
  7!  (
  7!  (_;  
   7!  (?�
   7!  (
  7!  (
  7!  (7!   (
  7!  (-
   7    .       '(_; G -7    
   .     ' (7     7!  (-7    0     6
   7!  (
  7!  (_;  
   7!  (?2
   7!  (
  7!  (
  7!  (
  7!  (
  7!  (
  7!  (_;  
   7!  (?� 
   _=  
   7    _; -
    7    /6?� Z         ���   ���   ^���   V���   ����   ����   ����   ����	   .���
   &���   p���   h���   ����   ����   ����   ����   6���   ����   ����     ���'A?3�            '(; � -.        '(' ( SH;V -     7    .       <H= - 0       
   F;  7    dN 7!  ('(' A?��_= ;  ? 
 	 ���=+?p�     0  �       �  F     d  <               p  �    �     �  : �  �
   #  7  K  _  s  �  �  �  �  d �  �  �  �  l  �  L  �  ,  �  d �  <  I  � �  �   �      L  A R  H  �  c �  � �  �  �    �    � 0  �  � X      K  �  � �  _     �
 �  \  �  h �  q  �  � 2  � 4  �  8  �  �  �    �  �  �  �   �   �   �  [�  2  `�  f	�      x  �  �  4  <  �  q�  ~   �    � 4  � H  � \  � p   �   �  * �  9 �  G�  �  �  �  �  �  U�  �  e	   l  �  �  �        6  �   N  �   p  V  n  �  �  �  �  �	   x  v  �  �  �  �  �    �	 &  |      :  L  Z  ^  �  � .  �  �	 6  �  �  �  �  �  �  �  �  �	 >  t  �  �    ,  :  >  �   F    ' N  &  N h  6  N  j  |  �  �  �  �  �  �  �  
    �  �  F  j�  �  �$�  �  �  �  �  
  "  >  P  b  z  �  �  �  �  �      0  B  Z  r  �  �  �  �  �  �    "  :  R  n  �  �    ��  (  �    x  �  X  �  4  �  *  �  �  x  �  �  �  ��  D  �  $  �    t  �  B  H  �  �  �  �  � �  ��  V  �  6  �    �    �  T  �  ��  h  �  H  �  (  �    �  �    0  � H  � �   (  $ �  >   W x  �  s�  H  ��  �  �       f  �"  �$  �&  �(  �*  �,  v  �.  �0  �4  �6  �8  �:  �<  �>  �@  B  D  F   R  l  ,Z  F b  Nt  |  e�  x �  ��  �  � �  �  �  � �  � �  � �  � �  �  J   
  �  )   |  @  1>  P  �    4  L  j  �  �  �  �  �    4  L  j  �  �  �  �  �    *  B  `  |  ,  D  b  ~  ? F  O �    q �  � �  ��  �  "  t  �  "  t  �    j  �    l  � .  �  �  �f  �l  t  � �  �   �  +�  �  B  �  �  B  �  �  8  �  :  8 �  o *  o:  tD  yZ  � ^  ��  ��  �  �  ��  �  �  ��  �  �  � �  � �    .  � �  �
  V  �  �  V  �  �  L  �  N         `  �    `  �    V  �  �    X   <  1 F  d  �  @ P  V Z  n  f �  ~ �  �  �  � �  � �  �  � �  � �    .  � �  �  �   	     	 <  (	 F  d  �  7	 P  Q	 Z  n  c	 �  ~		 �  �  �  �    $  <  Z  v  �	 �  �	 �  �  �	 �  �	 �  �	 �    �	 2  
 F  (
 P  d  H
 �  �  [
 �  r
 �  �
 
    �
 &  �
 4  �
 >  �
 H  �
 R  �
 \  x   f  #�  �  9 �  W �  t �  � �  �   �   � .  � >  ( V  Cr  Tt  { �  ��  �  
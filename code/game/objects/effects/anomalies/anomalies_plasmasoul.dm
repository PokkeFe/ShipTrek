/obj/effect/anomaly/plasmasoul
	name = "plasma soul"
	icon_state = "plasmasoul"
	desc = "A mysterious anomaly, it slowly emits plasma into the area around it."
	density = TRUE
	aSignal = /obj/item/assembly/signaler/anomaly/plasmasoul
	effectrange = 3
	pulse_delay = 6 SECONDS
	var/reagent_amount = 5

/obj/effect/anomaly/plasmasoul/anomalyEffect()
	..()

	if(!COOLDOWN_FINISHED(src, pulse_cooldown))
		return

	COOLDOWN_START(src, pulse_cooldown, pulse_delay)
	for(var/mob/living/Mob in range(effectrange,src))
		if(iscarbon(Mob))
			var/mob/living/carbon/carbon = Mob
			carbon.reagents?.add_reagent(/datum/reagent/toxin/plasma, reagent_amount)
			to_chat(Mob, span_warning("Your blood feels thick.."))
			playsound(Mob, 'sound/effects/bubbles.ogg', 50)


	if(!COOLDOWN_FINISHED(src, pulse_secondary_cooldown))
		return

	COOLDOWN_START(src, pulse_secondary_cooldown, pulse_delay*3)
	var/turf/open/tile = get_turf(src)
	if(istype(tile))
		tile.atmos_spawn_air("o2=250;plasma=750;TEMP=1000")

/obj/effect/anomaly/plasmasoul/Bumped(atom/movable/AM)
	var/turf/open/spot = locate(rand(src.x-effectrange, src.x+effectrange), rand(src.y-effectrange, src.y+effectrange), src.z)
	if(istype(spot))
		spot.atmos_spawn_air("o2=50;plasma=300;TEMP=500")

/obj/effect/anomaly/plasmasoul/detonate()
	for(var/mob/living/Mob in range(effectrange*2,src))
		if(iscarbon(Mob))
			var/mob/living/carbon/carbon = Mob
			if(carbon.run_armor_check(attack_flag = "bio") <= 40)
				carbon.reagents?.add_reagent(/datum/reagent/toxin/plasma, reagent_amount*3)
	var/turf/open/tile = get_turf(src)
	if(istype(tile))
		tile.atmos_spawn_air("o2=600;plasma=3000;TEMP=2000")
	. = ..()

/obj/effect/anomaly/plasmasoul/planetary
	immortal = TRUE
	immobile = TRUE

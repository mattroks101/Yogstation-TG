#define CLUWNEDOWN 50

/obj/item/clothing/mask/yogs/cluwne
	name = "clown wig and mask"
	desc = "A true prankster's facial attire. A clown is incomplete without his wig and mask."
	flags_cover = MASKCOVERSEYES
	icon_state = "cluwne"
	item_state = "cluwne"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	flags_1 = MASKINTERNALS
	item_flags = ABSTRACT | NODROP | DROPDEL
	flags_inv = HIDEEARS|HIDEEYES
	var/voicechange = TRUE
	var/last_sound = 0
	var/delay = 15

/obj/item/clothing/mask/yogs/cluwne/proc/play_laugh1()
	if(world.time - delay > last_sound)
		playsound (src, 'yogstation/sound/voice/cluwnelaugh1.ogg', 30, 1)
		last_sound = world.time

/obj/item/clothing/mask/yogs/cluwne/proc/play_laugh2()
	if(world.time - delay > last_sound)
		playsound (src, 'yogstation/sound/voice/cluwnelaugh2.ogg', 30, 1)
		last_sound = world.time

/obj/item/clothing/mask/yogs/cluwne/proc/play_laugh3()
	if(world.time - delay > last_sound)
		playsound (src, 'yogstation/sound/voice/cluwnelaugh3.ogg', 30, 1)
		last_sound = world.time

/obj/item/clothing/mask/yogs/cluwne/equipped(mob/user, slot) //when you put it on
	var/mob/living/carbon/C = user
	if((C.wear_mask == src) && (voicechange))
		play_laugh1()
	return ..()

/obj/item/clothing/mask/yogs/cluwne/speechModification(message) //whenever you speak
	if(voicechange)
		if(prob(5)) //the brain isnt fully gone yet...
			message = pick("HELP ME!!","PLEASE KILL ME!!","I WANT TO DIE!!", "END MY SUFFERING", "I CANT TAKE THIS ANYMORE!!" ,"SOMEBODY STOP ME!!")
			play_laugh2()
		if(prob(3))
			message = pick("HOOOOINKKKKKKK!!", "HOINK HOINK HOINK HOINK!!","HOINK HOINK!!","HOOOOOOIIINKKKK!!") //but most of the time they cant speak,
			play_laugh3()
		else
			message = pick("HEEEENKKKKKK!!", "HONK HONK HONK HONK!!","HONK HONK!!","HOOOOOONKKKK!!") //More sounds,
			play_laugh1()
	return message

/obj/item/clothing/mask/yogs/cluwne/equipped(mob/user, slot)
	if(!ishuman(user))
		return
	if(slot == SLOT_WEAR_MASK)
		var/mob/living/carbon/human/H = user
		H.dna.add_mutation(CLUWNEMUT)
	return

/obj/item/clothing/mask/yogs/cluwne/happy_cluwne
	name = "Happy Cluwne Mask"
	desc = "The mask of a poor cluwne that has been scrubbed of its curse by the Nanotrasen supernatural machinations division. Guaranteed to be %99 curse free and %99.9 not haunted. "
	flags_1 = MASKINTERNALS
	alternate_screams = list('yogstation/sound/voice/cluwnelaugh1.ogg','yogstation/sound/voice/cluwnelaugh2.ogg','yogstation/sound/voice/cluwnelaugh3.ogg')
	var/can_cluwne = TRUE
	item_flags = ABSTRACT

/obj/item/clothing/mask/yogs/cluwne/happy_cluwne/attack_self(mob/user)
	voicechange = !voicechange
	to_chat(user, "<span class='notice'>You turn the voice box [voicechange ? "on" : "off"]!</span>")
	if(voicechange)
		play_laugh1()

/obj/item/clothing/mask/yogs/cluwne/happy_cluwne/equipped(mob/user, slot)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(slot == SLOT_WEAR_MASK)
		if(prob(1) && can_cluwne) // Its %99 curse free!
			log_admin("[key_name(H)] was made into a cluwne by [src]")
			message_admins("[key_name(H)] got cluwned by [src]")
			to_chat(H, "<span class='userdanger'>The masks straps suddenly tighten to your face and your thoughts are erased by a horrible green light!</span>")
			H.dropItemToGround(src)
			H.cluwneify()
			qdel(src)
		else if(prob(0.1) && can_cluwne) //And %99.9 free form being haunted by vengeful jester-like entites.
			var/turf/T = get_turf(src)
			var/mob/living/simple_animal/hostile/floor_cluwne/S = new(T)
			S.Acquire_Victim(user)
			log_admin("[key_name(user)] summoned a floor cluwne using the [src]")
			message_admins("[key_name(user)] summoned a floor cluwne using the [src]")
			to_chat(H, "<span class='warning'>The mask suddenly slips off your face and... slides under the floor?</span>")
			to_chat(H, "<i>...dneirf uoy ot gnoleb ton seod tahT</i>")
			qdel(src)
		else if(can_cluwne)
			can_cluwne = FALSE
			addtimer(CALLBACK(src, .proc/re_cluwne), CLUWNEDOWN)

/obj/item/clothing/mask/yogs/cluwne/happy_cluwne/proc/re_cluwne()
	if(!can_cluwne)
		can_cluwne = TRUE

#undef CLUWNEDOWN